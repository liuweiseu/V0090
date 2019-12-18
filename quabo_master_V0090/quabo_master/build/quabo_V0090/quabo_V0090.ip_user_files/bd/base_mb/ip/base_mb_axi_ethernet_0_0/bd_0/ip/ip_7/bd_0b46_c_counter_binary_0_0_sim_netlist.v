// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3_AR71948 (lin64) Build 2405991 Thu Dec  6 23:36:41 MST 2018
// Date        : Mon Oct 14 16:53:37 2019
// Host        : Wei-Berkeley running 64-bit Ubuntu 18.04.3 LTS
// Command     : write_verilog -force -mode funcsim
//               /media/wei/DATA/LW/Project/Vivado_Project/quabo3_V006.xpr/quabo3_Viv20183/quabo3_Viv20183.srcs/sources_1/bd/base_mb/ip/base_mb_axi_ethernet_0_0/bd_0/ip/ip_7/bd_0b46_c_counter_binary_0_0_sim_netlist.v
// Design      : bd_0b46_c_counter_binary_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7k160tffg676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "bd_0b46_c_counter_binary_0_0,c_counter_binary_v12_0_12,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "c_counter_binary_v12_0_12,Vivado 2018.3" *) 
(* NotValidForBitStream *)
module bd_0b46_c_counter_binary_0_0
   (CLK,
    SCLR,
    THRESH0,
    Q);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME clk_intf, ASSOCIATED_BUSIF q_intf:thresh0_intf:l_intf:load_intf:up_intf:sinit_intf:sset_intf, ASSOCIATED_RESET SCLR, ASSOCIATED_CLKEN CE, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN base_mb_clk_wiz_1_0_clk_out1, INSERT_VIP 0" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:reset:1.0 sclr_intf RST" *) (* x_interface_parameter = "XIL_INTERFACENAME sclr_intf, POLARITY ACTIVE_HIGH, INSERT_VIP 0" *) input SCLR;
  (* x_interface_info = "xilinx.com:signal:data:1.0 thresh0_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME thresh0_intf, LAYERED_METADATA undef" *) output THRESH0;
  (* x_interface_info = "xilinx.com:signal:data:1.0 q_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME q_intf, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value data} bitwidth {attribs {resolve_type generated dependency bitwidth format long minimum {} maximum {}} value 24} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} integer {signed {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value false}}}} DATA_WIDTH 24}" *) output [23:0]Q;

  wire CLK;
  wire [23:0]Q;
  wire SCLR;
  wire THRESH0;

  (* C_AINIT_VAL = "0" *) 
  (* C_CE_OVERRIDES_SYNC = "0" *) 
  (* C_FB_LATENCY = "0" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_SCLR = "1" *) 
  (* C_HAS_SINIT = "0" *) 
  (* C_HAS_SSET = "0" *) 
  (* C_IMPLEMENTATION = "0" *) 
  (* C_SCLR_OVERRIDES_SSET = "1" *) 
  (* C_SINIT_VAL = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_WIDTH = "24" *) 
  (* C_XDEVICEFAMILY = "kintex7" *) 
  (* c_count_by = "1" *) 
  (* c_count_mode = "0" *) 
  (* c_count_to = "1100000000000000000000" *) 
  (* c_has_load = "0" *) 
  (* c_has_thresh0 = "1" *) 
  (* c_latency = "1" *) 
  (* c_load_low = "0" *) 
  (* c_restrict_count = "1" *) 
  (* c_thresh0_value = "1100000000000000000000" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  bd_0b46_c_counter_binary_0_0_c_counter_binary_v12_0_12 U0
       (.CE(1'b1),
        .CLK(CLK),
        .L({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .LOAD(1'b0),
        .Q(Q),
        .SCLR(SCLR),
        .SINIT(1'b0),
        .SSET(1'b0),
        .THRESH0(THRESH0),
        .UP(1'b1));
endmodule

(* C_AINIT_VAL = "0" *) (* C_CE_OVERRIDES_SYNC = "0" *) (* C_COUNT_BY = "1" *) 
(* C_COUNT_MODE = "0" *) (* C_COUNT_TO = "1100000000000000000000" *) (* C_FB_LATENCY = "0" *) 
(* C_HAS_CE = "0" *) (* C_HAS_LOAD = "0" *) (* C_HAS_SCLR = "1" *) 
(* C_HAS_SINIT = "0" *) (* C_HAS_SSET = "0" *) (* C_HAS_THRESH0 = "1" *) 
(* C_IMPLEMENTATION = "0" *) (* C_LATENCY = "1" *) (* C_LOAD_LOW = "0" *) 
(* C_RESTRICT_COUNT = "1" *) (* C_SCLR_OVERRIDES_SSET = "1" *) (* C_SINIT_VAL = "0" *) 
(* C_THRESH0_VALUE = "1100000000000000000000" *) (* C_VERBOSITY = "0" *) (* C_WIDTH = "24" *) 
(* C_XDEVICEFAMILY = "kintex7" *) (* ORIG_REF_NAME = "c_counter_binary_v12_0_12" *) (* downgradeipidentifiedwarnings = "yes" *) 
module bd_0b46_c_counter_binary_0_0_c_counter_binary_v12_0_12
   (CLK,
    CE,
    SCLR,
    SSET,
    SINIT,
    UP,
    LOAD,
    L,
    THRESH0,
    Q);
  input CLK;
  input CE;
  input SCLR;
  input SSET;
  input SINIT;
  input UP;
  input LOAD;
  input [23:0]L;
  output THRESH0;
  output [23:0]Q;

  wire CLK;
  wire [23:0]Q;
  wire SCLR;
  wire THRESH0;

  (* C_AINIT_VAL = "0" *) 
  (* C_CE_OVERRIDES_SYNC = "0" *) 
  (* C_FB_LATENCY = "0" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_SCLR = "1" *) 
  (* C_HAS_SINIT = "0" *) 
  (* C_HAS_SSET = "0" *) 
  (* C_IMPLEMENTATION = "0" *) 
  (* C_SCLR_OVERRIDES_SSET = "1" *) 
  (* C_SINIT_VAL = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_WIDTH = "24" *) 
  (* C_XDEVICEFAMILY = "kintex7" *) 
  (* c_count_by = "1" *) 
  (* c_count_mode = "0" *) 
  (* c_count_to = "1100000000000000000000" *) 
  (* c_has_load = "0" *) 
  (* c_has_thresh0 = "1" *) 
  (* c_latency = "1" *) 
  (* c_load_low = "0" *) 
  (* c_restrict_count = "1" *) 
  (* c_thresh0_value = "1100000000000000000000" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  bd_0b46_c_counter_binary_0_0_c_counter_binary_v12_0_12_viv i_synth
       (.CE(1'b0),
        .CLK(CLK),
        .L({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .LOAD(1'b0),
        .Q(Q),
        .SCLR(SCLR),
        .SINIT(1'b0),
        .SSET(1'b0),
        .THRESH0(THRESH0),
        .UP(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2015"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
INaBf8vh5mCmDzf2yp77pxZAxQdyEQiT/vG2dEgvrFjseUnGc6ldwH4JvdnpZSpdf/ihioPyMNjl
u6ooyzv5TA==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
S5XIZZtuFR/MZffuhwdnvE3H9oRWM4uXoaGZTa/Dyk62O+Wa0v41pjmZELCiR7uodZPFQfykZ6K9
2ZDMu8dB3afQRMs5lnd/53M1b9ke+MNEeZ/wzjUcsJghubnEAwzdWeW/0tlqST1WD9B/KCxYqwH5
Gj6IZTTFHAXcaVhnCT8=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
CM6IcdzP0PbD6yMSqylmi4JE2qpmxiNeI+prjGwJiD8e3Xsynu3PbGKJAOpOxtR1hT/3mpBcx1Rz
Fkz0QBh4wtE8fiziv1i+xi8T6cqC8ClamjrpZ//sn6dh7NvwSYik14MlwVuei4DZoZJZF63aoPUn
RXkQ13wtK+MkYKBcPVSZMFZmaCU6jMMBYclXzvRG1JqqZoa7mWFTeFZePUTXG7Wo12QaZ8GUi0AV
UIshoN25yn5e2Xr3FyuEtm5AvsZb+iLsgLeHBtKBnsVaHQphicgqwgwv6MQQF6ZNBgU/aACfibDS
3+n/mMMm8k1cj2bW6VCi7a+c8LmCf81NlJuLww==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
ehl0CusS7+JNGq6HfhyaBMy68nccIdIGqixoEztEZfkCpXuUYsdqw6G9MIJdWdu0Ck2acV7K6IVg
rzb8/bNaDDVWp48kupToegTkOdwDkCejEqppido4BkJ+iEkjPniz+aJHlOlOwmauETy2hCMuuC57
oWDprzGWlsqbCjqzKrXmPYm6fNdcOa2DiOYstQaMFNbPU2ccrbLJAiYMHNDqtPNqWxKBsD67kiGf
2eOneDOmdmy7YkNsL+cx8MJc3BVUsYBrpAEsGyFMkmX8a8nYz8R/wlFQFGQAd/t5XrfxFNI58mj1
AHXbcAMhGKVq9YdKeU/vSXY/NwMqp12xJ1nUaw==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2017_05", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
h/qRAwiPuqY/Zg/QWqbaYm8xWTi9SshYuPzyL0UME9ZDDF+C2CyGAugh9HzMdD0kZmT94TKmBgLR
dKP28nlE8VCCU5rvbjKxfn/wNtNKHCvZ1hns8CF7+pGuelhxGvXNmYKFw5co8+4grYFaDXeoZZR6
S5sjvhqtSVD3+qq4vYWRjT2Y/yes7L9dRsLq2D3iZ4xjgVHuIbOQLT/EUKW+9iYudT9Uy6YTwB+5
mSb0QK3YfZdGwZyXB4S3mdF9vNQHdW/rnACq3yngF+lprNkh3ooQKdGqtxtz8KSQxNZOAFE+koOw
h00o7AKpvDAp3uNguLvnNJH3rugOhh95b8Jatw==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
TsA04vIYHDZne2CBj5bWCBFH4MtNoFDCn/3DNEi0BwutuUf+X+lD9kAO3kl352WHjQbF79Ssm+PT
fCYpODgWdxSVbzaHFpITxCQ4HcIJhUeW5PC5tw09Tand68D6eg84qRguH+llbb5jdGJkJeTCf+Mx
pupkkLiDvNyTYWe+nqw=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
rx9hgQkvaJJTJJcTjGFW1DrrWiT+xanrcMvFn0Z3KRXlZvf+SE7IQgGCiP7ZDA6T5z1Zv5nzS4h5
cVi+CvwC9UMZRWmLDAjzASJ2nx1g9BjbYe2vHAUmyurIiR6LSigTeM/9TlMv+fFwJbqwuH6FJ3/z
Vl4tIMk4NrqkMn/riOG87SjhesepM6kcQOBgDGzLTG14z3qeZG8OPzxgApfyubmX4qdD1oTgGm2u
Q4mQfFxEye6Jqkn4Rzjhifs/ieNYomHlK7R2/72QJj5j0WyYBIhvO+09izz299Z54ZP2ZXaRMfDT
lU4lQNqQU14PX9Yk9p7sy2PnK4vTwwF0CFIgSQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
M9l0glTXD+5Cas69xCfvJ/OfR1IH2BkKw9bRa/nLTBC57JrVuS1/mXVr3pYKfUFn5r9bD9ECXiIM
Z8ny2Nyd2sm5ur5c9rJ8ZmZI2ea5A0rBycV2Jw7bp037cp6FT8Xt2GPblbCn/X5j/7JqWZq7oK54
ili2drCsPcaALF3whN4gIjN5fCnTZxH95CDPCBOE8ddigesYmYz7XPJacIf4WMhqWJEeYnSaiOuT
NYtFDkLLvd/8f4ClzlVsvruVGbiTfkMSy7atGweTUEZn0E3oqmrv+QwVDo32IBrW6+dvZn2dW9ag
tTg4r/WHjY7tAp1nVrjIUqfBp9GBWnjvtayzgg==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Bi1GItXdyPCyYdxcz5Dqb0Om0KqjeLcBukfwaA500drH9R530CTqYWjZalPo1RGpXEDRSSAQUe22
3DZyBFy62qPyxOzGF9c/Qg0l2jPLP+4Cet+N1DJm7zew5AwhlTpKYpF6z0v0Pj2VGw6YINdZV/Cs
FLky8omz9LnlkZ8R0/j+2rTYw74d7IIBuXj8sunmv5JB37g9GMqYlrVMQagIpmaYGNTqqUmii/Yn
FCX+9dM95RKUfsviAxipYPwWx4qLvKOFj2UwjSFexkkCMu4wx253ih1zcqTiUIGbXFiCoD2ST5s3
q6Rbol925cD3w+rEr8AlSNtpOcRVQC8J22gyFQ==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 12624)
`pragma protect data_block
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
j7soFnG7YPN+5fclfrJV9lPtnJQP3gPuhFfB
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
