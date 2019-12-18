--! @file eb_framer.vhd
--! @brief Produces EB content from WB operations
--!        
--!
--! Copyright (C) 2013-2014 GSI Helmholtz Centre for Heavy Ion Research GmbH 
--!
--! Muxes adress / data lines and inserts meta data generated by eb_record_gen
--!
--! @author Mathias Kreider <m.kreider@gsi.de>
--!
--------------------------------------------------------------------------------
--! This library is free software; you can redistribute it and/or
--! modify it under the terms of the GNU Lesser General Public
--! License as published by the Free Software Foundation; either
--! version 3 of the License, or (at your option) any later version.
--!
--! This library is distributed in the hope that it will be useful,
--! but WITHOUT ANY WARRANTY; without even the implied warranty of
--! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
--! Lesser General Public License for more details.
--!  
--! You should have received a copy of the GNU Lesser General Public
--! License along with this library. If not, see <http://www.gnu.org/licenses/>.
---------------------------------------------------------------------------------

--! Standard library
library IEEE;
--! Standard packages   
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.wishbone_pkg.all;
use work.genram_pkg.all;
use work.eb_hdr_pkg.all;
use work.etherbone_pkg.all;
use work.eb_internals_pkg.all;

entity eb_framer is
  port(
    clk_i           : in   std_logic;            -- WB Clock
    rst_n_i         : in   std_logic;            -- async reset

    slave_i         : in   t_wishbone_slave_in;  -- WB op. -> not WB compliant, but the record format is convenient
    slave_o         : out  t_wishbone_slave_out;  -- flow control    
    master_o        : out  t_wishbone_master_out;
    master_i        : in   t_wishbone_master_in; 
    
    byte_cnt_o      : out  std_logic_vector(15 downto 0);
    ovf_o           : out  std_logic;
       
    tx_send_now_i   : in   std_logic;
    tx_flush_o      : out  std_logic; 
    max_ops_i       : in   unsigned(15 downto 0);
    length_i        : in   unsigned(15 downto 0); 
    cfg_rec_hdr_i   : in   t_rec_hdr -- EB cfg information, eg read from cfg space etc
);   
end eb_framer;

architecture rtl of eb_framer is

--signals
signal ctrl_fifo_q      : std_logic_vector(0 downto 0);
signal ctrl_fifo_d      : std_logic_vector(0 downto 0);
signal ctrl_fifo_empty  : std_logic;

signal s_slave_stall  : std_logic;
signal s_tx_send_now, r_tx_send_now : std_logic; 
signal send_now       : std_logic; -- queued version

signal tx_stb         : std_logic;
signal r_pop_req, 
       r_pop_cmd      : std_logic;
signal r_abort        : std_logic;
signal s_space_sufficient : std_logic;  
signal s_rec_byte_cnt,
       r_rec_byte_cnt,
       s_word_cnt : unsigned(15 downto 0);

signal op_fifo_q      : std_logic_vector(31 downto 0);
signal op_fifo_d      : std_logic_vector(31 downto 0);
signal op_fifo_push   : std_logic;
signal op_fifo_pop    : std_logic;
signal op_fifo_full   : std_logic;
signal op_fifo_empty  : std_logic;

signal dat            : t_wishbone_data;
signal adr            : t_wishbone_address;
signal we             : std_logic;
signal stb            : std_logic;
signal cyc            : std_logic;

signal r_ack,
       r_err,
       r_ovf          : std_logic;
       

signal tx_cyc         : std_logic;
signal r_rec_ack      : std_logic;
signal s_recgen_slave_stall,
       s_recgen_slave_ack        : std_logic;
signal adr_wr         : t_wishbone_address;
signal adr_rd         : t_wishbone_address;
signal rec_hdr        : t_rec_hdr;
signal rec_valid      : std_logic;
signal r_first_rec    : std_logic;
signal r_eb_hdr       : t_eb_hdr;

-- FSMs
type t_mux_state is (s_INIT, s_IDLE, s_EB, s_REC, s_WA, s_RA, s_WRITE, s_READ, s_REC_ACK, s_SEND, s_PAD, s_ERROR);
signal r_mux_state    : t_mux_state;
signal r_cnt_ops     : unsigned(8 downto 0);
signal r_cnt_pad      : unsigned(16 downto 0);
signal r_byte_cnt : unsigned(15 downto 0);

signal s_recgen_slave_i  : t_wishbone_slave_in;

function or_all(slv_in : std_logic_vector)
return std_logic is
variable I : natural;
variable ret : std_logic;
begin
  ret := '0';
  for I in 0 to slv_in'left loop
   ret := ret or slv_in(I);
  end loop;    
  return ret;
end function or_all;

function f_parse_rec(x : std_logic_vector) return t_rec_hdr is
    variable o : t_rec_hdr;
  begin
    o.bca_cfg  := x(31);
    o.rca_cfg  := x(30);
    o.rd_fifo  := x(29);
    o.res1     := x(28);
    o.drop_cyc := x(27);
    o.wca_cfg  := x(26);
    o.wr_fifo  := x(25);
    o.res2     := x(24);
    o.sel      := x(23 downto 16);
    o.wr_cnt   := unsigned(x(15 downto 8));
    o.rd_cnt   := unsigned(x( 7 downto 0));
    return o;
  end function;

function to_unsigned(b_in : std_logic; bits : natural)
return unsigned is
variable ret : std_logic_vector(bits-1 downto 0) := (others=> '0');
begin
  ret(0) := b_in;
  return unsigned(ret);
end function to_unsigned;

begin
------------------------------------------------------------------------------
-- IO assignments
------------------------------------------------------------------------------
  cyc <= slave_i.cyc;
  stb <= slave_i.stb;
  we  <= slave_i.we;
  adr <= slave_i.adr;
  dat <= slave_i.dat;

  s_slave_stall   <= (s_recgen_slave_stall or op_fifo_full) and not r_ovf;
  slave_o.stall   <= s_slave_stall;
  slave_o.dat     <= (others => '0');
  s_tx_send_now   <= (tx_send_now_i and not s_slave_stall) or r_tx_send_now; 

  s_recgen_slave_i.cyc  <= cyc and not s_tx_send_now;
  s_recgen_slave_i.stb  <= stb;
  s_recgen_slave_i.we   <= we;
  s_recgen_slave_i.sel  <= slave_i.sel;
  s_recgen_slave_i.adr  <= adr;
  s_recgen_slave_i.dat  <= dat;
   
  s_space_sufficient <= '1' when r_byte_cnt + s_rec_byte_cnt <= length_i
                   else '0';
  
  
  r_rec_byte_cnt <= s_word_cnt(13 downto 0) & "00";

  s_word_cnt <=  (1 + to_unsigned(or_all(std_logic_vector(rec_hdr.rd_cnt)), 16)
                  + to_unsigned(or_all(std_logic_vector(rec_hdr.wr_cnt)), 16) 
                  + rec_hdr.rd_cnt  
                  + rec_hdr.wr_cnt);
  
  
  byte_cnt_o   <= std_logic_vector(r_byte_cnt);
  ovf_o        <= r_ovf;
  slave_o.ack  <= r_ack;
  slave_o.err  <= r_err;
  
  acks : process (clk_i, rst_n_i) is

  begin
    if( rst_n_i = '0') then
      r_ovf <= '0';
      r_ack <= '0';
      r_err <= '0';
    elsif rising_edge(clk_i) then 
      r_ack <= s_recgen_slave_ack and s_space_sufficient;
      r_err <= s_recgen_slave_ack and not s_space_sufficient;
      r_ovf <= r_ovf or (s_recgen_slave_ack and not s_space_sufficient); 
    end if;  
  end process; 
--------------------
 
  rgen: eb_record_gen 
  PORT MAP (
         
      clk_i           => clk_i,
      rst_n_i         => rst_n_i,

      slave_i         => s_recgen_slave_i,
      slave_stall_o   => s_recgen_slave_stall,
      slave_ack_o     => s_recgen_slave_ack,
      
      rec_ack_i       => r_rec_ack,
      
      rec_valid_o     => rec_valid,
      rec_hdr_o       => rec_hdr,
      rec_adr_rd_o    => adr_rd, 
      rec_adr_wr_o    => adr_wr,
      byte_cnt_o      => s_rec_byte_cnt, --s_rec_word_cnt,
      cfg_rec_hdr_i   => cfg_rec_hdr_i); 
 
------------------------------------------------------------------------------
-- fifos
------------------------------------------------------------------------------
  
    op_fifo : generic_sync_fifo
    generic map(
      g_data_width             => 32,
      g_size                   => 256,
      g_show_ahead             => true,
      g_with_empty             => true,
      g_with_full              => true,
      g_with_almost_full       => false)
    port map (
      clk_i   => clk_i,
      rst_n_i => rst_n_i,
      full_o  => op_fifo_full,
      we_i    => op_fifo_push,
      d_i     => op_fifo_d,
      empty_o => op_fifo_empty,
      rd_i    => op_fifo_pop,
      q_o     => op_fifo_q,
      count_o => open);  
  
  
  ctrl_fifo : generic_sync_fifo
    generic map(
      g_data_width             => 1,
      g_size                   => 256,
      g_show_ahead             => true,
      g_with_empty             => true,
      g_with_full              => true,
      g_with_almost_full       => false)
    port map (
      clk_i   => clk_i,
      rst_n_i => rst_n_i,
      full_o  => open,
      we_i    => op_fifo_push,
      d_i     => ctrl_fifo_d,
      empty_o => ctrl_fifo_empty,
      rd_i    => op_fifo_pop,
      q_o     => ctrl_fifo_q,
      count_o => open); 
      
       
  op_fifo_pop     <= ((r_pop_req and (tx_stb and not master_i.stall)) or r_pop_cmd) and not op_fifo_empty;
  op_fifo_push    <= (cyc and stb and not s_slave_stall) or s_tx_send_now;
  op_fifo_d       <= dat when we = '1'
                else adr;
              
  ctrl_fifo_d(0)  <= s_tx_send_now;
  send_now        <= ctrl_fifo_q(0) when ctrl_fifo_empty = '0'
              else '0';
  
  master_o.cyc <= tx_cyc;
  master_o.stb <= tx_stb;
  master_o.we  <= '0';
  master_o.sel <= (others => '1');
  master_o.adr <= (others => '0');
------------------------------------------------------------------------------
-- Output Mux
------------------------------------------------------------------------------
  r_eb_hdr  <= c_eb_init;
  
  OMux : with r_mux_state select
  master_o.dat <= op_fifo_q(31 downto 0)  when s_WRITE | s_READ,
               f_format_rec(rec_hdr)   when s_REC,
               adr_wr                  when s_WA,
               adr_rd                  when s_RA, 
               f_format_eb(r_eb_hdr)   when s_EB,
               (others => '0')         when others;
               
           

  p_eb_mux : process (clk_i) is
  variable v_state         : t_mux_state;
  begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        r_mux_state     <= s_IDLE;
        tx_cyc          <= '0';
        r_first_rec     <= '1';
        r_tx_send_now   <= '0';
        r_byte_cnt      <= (others => '0');
        r_abort         <= '0';
      else   
        v_state         := r_mux_state;                    
        tx_stb          <= '0';
        r_rec_ack       <= '0';
        tx_flush_o      <= '0';
        r_pop_req       <= '0'; -- all states that can pop the opfifo
        r_pop_cmd       <= '0';
                
        r_tx_send_now <= (r_tx_send_now or tx_send_now_i) and s_slave_stall;
        
        
        
        case r_mux_state is
          when s_INIT   =>  v_state           := s_IDLE;
          when s_IDLE   =>  if(send_now = '1' and r_ovf = '0') then
                                v_state       := s_SEND;
                            elsif(rec_valid = '1') then
                              
                              --analyse rechdr op count for suffcient packet space
                              if(r_first_rec = '1') then
                                   tx_cyc            <= '1';
                                   tx_flush_o        <= '1';
                                   r_first_rec       <= '0';
                                   v_state           := s_EB;
                                 else
                                   v_state       := s_REC;
                                 end if;
                              
                            end if;
                            
          when s_EB     =>  if(master_i.stall = '0') then
                              r_byte_cnt      <= r_byte_cnt +4;
                              v_state    := s_REC; -- output EB hdr
                            end if;
                            
          when s_REC    =>  if(master_i.stall = '0') then -- output record hdr
                              if(rec_hdr.wr_cnt + rec_hdr.rd_cnt /= 0) then 
                                if(rec_hdr.wr_cnt /= 0) then
                                  v_state    := s_WA;
                                else
                                  v_state    := s_RA;
                                end if;
                              else
                                v_state    := s_REC_ACK;
                              end if;
                            end if;
          
          when s_WA     =>  if(master_i.stall = '0') then
                              r_cnt_ops    <= '0' & rec_hdr.wr_cnt -2; -- output write base address
                              v_state    := s_WRITE;
                            end if;               
          
          when s_WRITE  =>  if(master_i.stall = '0') then
                              r_cnt_ops <= r_cnt_ops-1;
                                
                              if(r_cnt_ops(r_cnt_ops'left) = '1') then -- output write values
                                if(rec_hdr.rd_cnt /= 0) then
                                  v_state := s_RA;
                                else
                                  v_state := s_REC_ACK;
                                end if;
                              end if;
                            end if;
          
          when s_RA     =>  if(master_i.stall = '0') then
                              r_cnt_ops    <= '0' & rec_hdr.rd_cnt -2; -- output readback address
                              v_state    := s_READ;
                            end if;  
          
          when s_READ   =>  if(master_i.stall = '0') then
                              r_cnt_ops <= r_cnt_ops-1;
                              
                              if(r_cnt_ops(r_cnt_ops'left) = '1') then -- output read addresses
                                v_state := s_REC_ACK;
                              end if;
                            end if;
          
          when s_REC_ACK   =>  r_byte_cnt <= r_byte_cnt + r_rec_byte_cnt;
                               if(send_now = '1' and r_ovf = '0') then    
                                 v_state       := s_SEND;
                               else
                                 v_state       := s_IDLE;
                               end if; 
                               
          when s_SEND   =>   r_byte_cnt      <= (others => '0');
                             v_state         := s_IDLE;
                            
          when s_PAD    =>  if(master_i.stall = '0') then
                                if(r_cnt_pad(r_cnt_pad'left) = '1') then -- output padding
                                  tx_cyc        <= '0';
                                  v_state       := s_IDLE;
                                end if;
                                r_cnt_pad <= r_cnt_pad-4;
                            end if;
         
          when others   =>  v_state := s_IDLE;
        end case;
      
        
        -- flags on state transition
        if(v_state = s_EB     or
           v_state = s_REC    or
           v_state = s_WA     or
           v_state = s_WRITE  or
           v_state = s_RA     or
           v_state = s_READ   ) then
         tx_stb   <= '1';
        end if;
        
        if(v_state = s_WRITE or
           v_state = s_READ) then
         r_pop_req <= '1'; 
        end if;   
        
        if(v_state = s_ERROR or
           v_state = s_SEND) then
          r_pop_cmd   <= '1';
        end if;
        
        if(v_state = s_REC_ACK) then
          r_rec_ack <= '1';
        end if;
        
        if(v_state = s_SEND) then
          r_first_rec   <= '1';
          tx_cyc        <= '0'; 
        end if;
        
        if(v_state = s_ERROR) then
           r_abort         <= '1';
        else
           r_abort         <= '0';
        end if;
        
                                            
        
        r_mux_state <= v_state;
      end if;
    end if;
  end process;

end architecture;





