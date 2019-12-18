// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3_AR71948 (lin64) Build 2405991 Thu Dec  6 23:36:41 MST 2018
// Date        : Mon Oct 14 16:53:34 2019
// Host        : Wei-Berkeley running 64-bit Ubuntu 18.04.3 LTS
// Command     : write_verilog -force -mode funcsim
//               /media/wei/DATA/LW/Project/Vivado_Project/quabo3_V006.xpr/quabo3_Viv20183/quabo3_Viv20183.srcs/sources_1/bd/base_mb/ip/base_mb_axi_ethernet_0_0/bd_0/ip/ip_6/bd_0b46_c_shift_ram_0_0_sim_netlist.v
// Design      : bd_0b46_c_shift_ram_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7k160tffg676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "bd_0b46_c_shift_ram_0_0,c_shift_ram_v12_0_12,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "c_shift_ram_v12_0_12,Vivado 2018.3" *) 
(* NotValidForBitStream *)
module bd_0b46_c_shift_ram_0_0
   (D,
    CLK,
    CE,
    SCLR,
    Q);
  (* x_interface_info = "xilinx.com:signal:data:1.0 d_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME d_intf, LAYERED_METADATA undef" *) input [0:0]D;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME clk_intf, ASSOCIATED_BUSIF q_intf:sinit_intf:sset_intf:d_intf:a_intf, ASSOCIATED_RESET SCLR, ASSOCIATED_CLKEN CE, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN base_mb_clk_wiz_1_0_clk_out1, INSERT_VIP 0" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:clockenable:1.0 ce_intf CE" *) (* x_interface_parameter = "XIL_INTERFACENAME ce_intf, POLARITY ACTIVE_LOW" *) input CE;
  (* x_interface_info = "xilinx.com:signal:reset:1.0 sclr_intf RST" *) (* x_interface_parameter = "XIL_INTERFACENAME sclr_intf, POLARITY ACTIVE_HIGH, INSERT_VIP 0" *) input SCLR;
  (* x_interface_info = "xilinx.com:signal:data:1.0 q_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME q_intf, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value data} bitwidth {attribs {resolve_type generated dependency data_bitwidth format long minimum {} maximum {}} value 1} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}} DATA_WIDTH 1}" *) output [0:0]Q;

  wire CE;
  wire CLK;
  wire [0:0]D;
  wire [0:0]Q;
  wire SCLR;

  (* C_AINIT_VAL = "0" *) 
  (* C_HAS_CE = "1" *) 
  (* C_HAS_SCLR = "1" *) 
  (* C_HAS_SINIT = "0" *) 
  (* C_HAS_SSET = "0" *) 
  (* C_SINIT_VAL = "0" *) 
  (* C_SYNC_ENABLE = "0" *) 
  (* C_SYNC_PRIORITY = "1" *) 
  (* C_WIDTH = "1" *) 
  (* c_addr_width = "4" *) 
  (* c_default_data = "0" *) 
  (* c_depth = "1" *) 
  (* c_elaboration_dir = "./" *) 
  (* c_has_a = "0" *) 
  (* c_mem_init_file = "no_coe_file_loaded" *) 
  (* c_opt_goal = "0" *) 
  (* c_parser_type = "0" *) 
  (* c_read_mif = "0" *) 
  (* c_reg_last_bit = "1" *) 
  (* c_shift_type = "0" *) 
  (* c_verbosity = "0" *) 
  (* c_xdevicefamily = "kintex7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  bd_0b46_c_shift_ram_0_0_c_shift_ram_v12_0_12 U0
       (.A({1'b0,1'b0,1'b0,1'b0}),
        .CE(CE),
        .CLK(CLK),
        .D(D),
        .Q(Q),
        .SCLR(SCLR),
        .SINIT(1'b0),
        .SSET(1'b0));
endmodule

(* C_ADDR_WIDTH = "4" *) (* C_AINIT_VAL = "0" *) (* C_DEFAULT_DATA = "0" *) 
(* C_DEPTH = "1" *) (* C_ELABORATION_DIR = "./" *) (* C_HAS_A = "0" *) 
(* C_HAS_CE = "1" *) (* C_HAS_SCLR = "1" *) (* C_HAS_SINIT = "0" *) 
(* C_HAS_SSET = "0" *) (* C_MEM_INIT_FILE = "no_coe_file_loaded" *) (* C_OPT_GOAL = "0" *) 
(* C_PARSER_TYPE = "0" *) (* C_READ_MIF = "0" *) (* C_REG_LAST_BIT = "1" *) 
(* C_SHIFT_TYPE = "0" *) (* C_SINIT_VAL = "0" *) (* C_SYNC_ENABLE = "0" *) 
(* C_SYNC_PRIORITY = "1" *) (* C_VERBOSITY = "0" *) (* C_WIDTH = "1" *) 
(* C_XDEVICEFAMILY = "kintex7" *) (* ORIG_REF_NAME = "c_shift_ram_v12_0_12" *) (* downgradeipidentifiedwarnings = "yes" *) 
module bd_0b46_c_shift_ram_0_0_c_shift_ram_v12_0_12
   (A,
    D,
    CLK,
    CE,
    SCLR,
    SSET,
    SINIT,
    Q);
  input [3:0]A;
  input [0:0]D;
  input CLK;
  input CE;
  input SCLR;
  input SSET;
  input SINIT;
  output [0:0]Q;

  wire CE;
  wire CLK;
  wire [0:0]D;
  wire [0:0]Q;
  wire SCLR;

  (* C_AINIT_VAL = "0" *) 
  (* C_HAS_CE = "1" *) 
  (* C_HAS_SCLR = "1" *) 
  (* C_HAS_SINIT = "0" *) 
  (* C_HAS_SSET = "0" *) 
  (* C_SINIT_VAL = "0" *) 
  (* C_SYNC_ENABLE = "0" *) 
  (* C_SYNC_PRIORITY = "1" *) 
  (* C_WIDTH = "1" *) 
  (* c_addr_width = "4" *) 
  (* c_default_data = "0" *) 
  (* c_depth = "1" *) 
  (* c_elaboration_dir = "./" *) 
  (* c_has_a = "0" *) 
  (* c_mem_init_file = "no_coe_file_loaded" *) 
  (* c_opt_goal = "0" *) 
  (* c_parser_type = "0" *) 
  (* c_read_mif = "0" *) 
  (* c_reg_last_bit = "1" *) 
  (* c_shift_type = "0" *) 
  (* c_verbosity = "0" *) 
  (* c_xdevicefamily = "kintex7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  bd_0b46_c_shift_ram_0_0_c_shift_ram_v12_0_12_viv i_synth
       (.A({1'b0,1'b0,1'b0,1'b0}),
        .CE(CE),
        .CLK(CLK),
        .D(D),
        .Q(Q),
        .SCLR(SCLR),
        .SINIT(1'b0),
        .SSET(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2015"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
PkyhyBb59EPgq8kANKUgNUvJSxwVgcYTKLlfXroHeM6zPnPHm+ATuJPY2OmCojZnDY2A6SHiMUmx
ylnsx6jVAA==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
XgKClVpS+h3z22aTgNZepCZW5Yffl4m6nNLRjY88G0b6Og6dF7wA3of30X3Vr2BKX5GVSe+jeu6a
q3D7Qa0T3sEnO1qnWdbom/P31G6nS7/pQCPaLh+suxznQX2imRfhfTkmY1B9wExxZtZBbss2GPfs
EFGX8a+efiUiZLAKaSE=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
LYMHL9qwz9VPPAbHAyLFK1YM6t0YBJUbhdak6y3IQta7KscLfLakFo9QXv7rXKj3R5WEjx6Vg+9K
QUgoa/uCYy+n2t004DDpVeDamNuGIrJU3WXV9mo6tEi21Rm+kIG+CFgVuqLY9JSjwI3dhmEqYYtS
wC2GIO6hKaV0keq1ldvsRFBu71kLY+jczboTe6EddpUktWp3UM/RqnrSfHPMlZWhHp1k3YC0SDq9
gvcPn9DB3vIjXgn+xRbyzZOt/j+s8RfjF446i2RalkF5p/den9o/OMG5jmv4rZKHj9S1V3Z2UuL1
c2fxe26sNIvZ7tpz8RHVWRMloPfcPVakam2zhg==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
BACIRg239ZSAZHpsLobWk7IZyWSAM1rsaZq5LesIgnba07iijhvT5s8WIOIIgHZs1XEDKelSnU1J
+5cyEbU9WgPZsja6FQEw6J0GuN3L/1QyrvmNIJKsNXINx7R+xaY/n0uby2eFsFE9luplvdOyrCEw
eK82BghXwPdasTT1ZUgKiycyGYtNsp5ZaPIWXI9ezN9oHowcWp7Mn6v2jrdDl4lzJuoHgqRtkZvG
7GqevJFheGfXkRPuQGkNK2Pk6XN9woSB1a9C+FUsQBM5MlIE7zrBQAjONIQj/nd82Hlp1H4PRxBW
1mmFP7PskMeNR2hH5xwkvg4Q3IfYBlw8gdzneg==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2017_05", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
vUWbACu3JL9XeVH21XChN1bLnACIM0U/dLRQNf2LGaDFNW9CL0o3SY9pOtV226o71+9Eal6i7P4l
ht62RU2AHTweJsgWkXtQBI0/jHIw4/gxbBebNbqZM6m3qjEE5blPsuzJ1njoX2JWCJElO3p9FfRu
uHpC+4hYoccdFayGku3vk1gwz9lLJ4FcYG9mi1vLIY+tzs0o83THQ8dLrg50Rr/r2n0Xf4hxWe4U
tJ6iUOYBQUYjeOwNQOOxfjv5PKfLIgGA2WC8sJb2GFe9MkTDoMAo40nBLK0Y8+klDIJTyx079Bx0
wdRg2JxUF3+TGlXW98+2/iWy94H1CPEVRm18FQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
VX8rVAT0l4oniSvb1X0sblwaqcWh2XE0oCAZbC0SVv8fCy8dLmmtqBzFq3w2V/7nyMmJzWKNP/yV
0GW7ICEfrGaBejU3VpwaHA69xE56Y/8NSHGlZOhr390/5/UqELcFOknZEPJXMLpeKjUn2ijACn/u
O0myDIvGFiUyRGWWYKM=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
dlKAt52rb1rebbUvCxUw/pmWR03F+be3vApC1VuekYTvk7BFt7xopdHrqsvoU8rgaCBc2wuCudx5
nUcu7bKEyHKFc6bcbp6J84c2uG0ZckyqBn/OHRMbmq4Vbar8C3ERI2YmcbL0Q0fBLzMosVarF9eM
+c6VfE9hA5lx9qpwFJhgk5v/yx6kjgu+kEnG+xsdWrpKrj8LIxxh6gkrPOn+jQtKQSX3o7q35Rcv
W3vWLRYdH+pHsfJqCdT0wL4oBTLa7ozdsufX9l6UDgT4ECxLf7R1TtNj7XA1jaaefThL0F1AUCjF
5WuhMqBOotpDZUmvB91yVtbXLMm0r85tK9b/iA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
P32sC+oKYYK2lZxLIBZag40VsCf/LPiFqFHd3VRnzanyttmib/wc/Y7FhiypY3fbNjugDBuQwMDG
/Ayk5M9vxVe2dPfFBuyxfuB4E4LSnS1OpTTOrC3uiVfSV0OBFsTueL/t4aRSYeRUBegT77SJeE//
UzhS+8TqAbCTIcLtF8BSnuSYkPXan6+Zj0QPblv3FqYGK1Be9dujkha+uvljqzVn3bTJcdSTftX1
YXxqEa14Dx/0eOvdUjh8IQM5La5Mb1nljC6I5vYsnRDbn9QjpkKAnTgrOH18BHKuc38OAD5nDgfP
k2LgQJhBFGFAmv5O76A+Rhy6F4t4MuKxtJhWTA==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
vIjvGVbQ7qInaIv5t21dpvZY0A5cH1ELVwVuyotid/R9A/tKsGdNkWyjXqf71+FQ9yOSnGRTavVB
Wp4KoCnLpIGBRzR/bfmnHSFTVXMDpWBmkCaDnCBBss+q6tydJyh0prPnlON9NYtE61NDmeMaA9jl
vE84O65FKNnRLW8urXyKZQ6ZrxgZOlgGyWjAPaBhXSJAID4ibQcSQGGRZi5ovXc1E2siDd7UM/HG
ProeFmuZK+BEV0s/EgIMLriVg8T86JVJ9H6fpB6yvMlLP3vrcHmYydZFv6m6lBZfhIUJMsOTbdaC
uLRm+wBUPQYMekQHJN3VGvOayiJcXm8m4CAs0g==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 4640)
`pragma protect data_block
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
mjBAc1ulfGh057+DJjvJGT4fQwfETnQ=
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
