module ETH_CORE_CTRL #(
    parameter eth = 1
)(
    input clk,
    input rst,
    
	input [31:0]s_axis_txd_tdata,
	input [3:0] s_axis_txd_tkeep,
	input s_axis_txd_tlast,
	input s_axis_txd_tvalid,
	output s_axis_txd_tready,
	
	output  [31:0]m_axis_txd_tdata,
	output  [3:0] m_axis_txd_tkeep,
	output  m_axis_txd_tlast,
	output  reg m_axis_txd_tvalid,
	input m_axis_txd_tready,
	
	input m_axis_txc_tready,
	output reg m_axis_txc_tvalid,
	output reg m_axis_txc_tlast,
	output [31:0]m_axis_txc_tdata,
	output [3:0]m_axis_txc_tkeep
);


wire rst_inv;
assign rst_inv              =   ~rst;

wire [36:0] fifo_din;
wire [36:0] fifo_din_tmp;
//assign s_axis_txd_tdata     =   fifo_din_tmp[31:0];
//assign s_axis_txd_tkeep     =   fifo_din_tmp[35:32];
//assign s_axis_txd_tlast     =   fifo_din_tmp[36:36];
//assign s_axis_txd_tvalid    =   fifo_din_tmp[37:37];
assign fifo_din_tmp = {s_axis_txd_tlast, s_axis_txd_tkeep, s_axis_txd_tdata};
reg [36:0] fifo_din_reg;
always @(posedge clk)
    begin
        if(rst_inv)
            fifo_din_reg <= 0;
        else
            fifo_din_reg <= fifo_din_tmp;
    end

generate
    //if(eth == 0)
    //    assign fifo_din     =   fifo_din_reg;
    //else
        assign fifo_din     =   fifo_din_tmp;
endgenerate

wire [36:0] fifo_dout;
assign m_axis_txd_tdata     =   fifo_dout[31:0];
assign m_axis_txd_tkeep     =   fifo_dout[35:32];
assign m_axis_txd_tlast     =   fifo_dout[36:36];
//assign m_axis_txd_tvalid    =   fifo_dout[37:37];
wire fifo_empty;
wire fifo_full;
assign s_axis_txd_tready    =   ~fifo_full;

assign m_axis_txc_tdata     =   32'hFFFFFFFF;
assign m_axis_txc_tkeep     =   4'b1111;
fifo_generator_0 eth_ctrl
   (.din(fifo_din),
    .dout(fifo_dout),
    .empty(fifo_empty),
    .full(fifo_full),
    .rd_clk(clk),
    .rd_en(m_axis_txd_tready),
    .rst(rst_inv),
    .wr_clk(clk),
    .wr_en(s_axis_txd_tvalid));

reg s_axis_txd_tvalid_reg;
always @(posedge clk)
    begin
        if(rst_inv)
            s_axis_txd_tvalid_reg   <=  1'b0;
        else
            s_axis_txd_tvalid_reg   <=  s_axis_txd_tvalid;
    end

reg s_axis_txd_tlast_reg;
always @(posedge clk)
    begin
        if(rst_inv)
            s_axis_txd_tlast_reg    <=  1'b0;
        else
            s_axis_txd_tlast_reg    <=  s_axis_txd_tlast;
    end
 always @(posedge clk)
    begin
        if(rst_inv)
            m_axis_txd_tvalid <= 1'b0;
        //else if(s_axis_txd_tvalid == 1'b1)
        else if(m_axis_txc_tvalid == 1)
            m_axis_txd_tvalid <= 1'b1;
        else if(m_axis_txd_tlast == 1'b1)
            m_axis_txd_tvalid <= 1'b0;
        else
            m_axis_txd_tvalid <= m_axis_txd_tvalid;
    end
 
 reg [3:0]cnt;
 always @(posedge clk)
    begin
        if(rst_inv)
            cnt <=  4'b0;
        else if(m_axis_txc_tvalid == 1)
            cnt <= cnt + 1;
        else
            cnt <= 4'b0;    
    end  
      
 always @(posedge clk)
    begin
        if(rst_inv)
            m_axis_txc_tvalid <= 1'b0;
        //else if((s_axis_txd_tvalid_reg == 1'b0)&& (s_axis_txd_tvalid == 1'b1) && (s_axis_txd_tready == 0))
        else if((s_axis_txd_tlast_reg == 0) && (s_axis_txd_tlast == 1))
            m_axis_txc_tvalid <= 1'b1;     
        else if(cnt == 10)  //get this value from debug
            m_axis_txc_tvalid <= 1'b0;
    end

always @(posedge clk)
    begin
        if(rst_inv)
            m_axis_txc_tlast <= 1'b0;
        else if(cnt == 9) //get this value from debug
            m_axis_txc_tlast <= 1'b1;
        else
            m_axis_txc_tlast <= 1'b0;
    end 

endmodule