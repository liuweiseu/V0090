
o
Command: %s
53*	vivadotcl2>
*route_design -directive NoTimingRelaxation2default:defaultZ4-113h px� 
�
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2"
Implementation2default:default2
xc7k160t2default:defaultZ17-347h px� 
�
0Got license for feature '%s' and/or device '%s'
310*common2"
Implementation2default:default2
xc7k160t2default:defaultZ17-349h px� 
P
Running DRC with %s threads
24*drc2
82default:defaultZ23-27h px� 
V
DRC finished with %s
79*	vivadotcl2
0 Errors2default:defaultZ4-198h px� 
e
BPlease refer to the DRC report (report_drc) for more information.
80*	vivadotclZ4-199h px� 
p
,Running DRC as a precondition to command %s
22*	vivadotcl2 
route_design2default:defaultZ4-22h px� 
P
Running DRC with %s threads
24*drc2
82default:defaultZ23-27h px� 
�
�Clock Placer Checks: Poor placement for routing between an IO pin and BUFG. 
Resolution: Poor placement of an IO pin and a BUFG has resulted in the router using a non-dedicated path between the two.  There are several things that could trigger this DRC, each of which can cause unpredictable clock insertion delays that result in poor timing.  This DRC could be caused by any of the following: (a) a clock port was placed on a pin that is not a CCIO-pin (b)the BUFG has not been placed in the same half of the device or SLR as the CCIO-pin (c) a single ended clock has been placed on the N-Side of a differential pair CCIO-pin.
 This is normally an ERROR but the CLOCK_DEDICATED_ROUTE constraint is set to FALSE allowing your design to continue. The use of this override is highly discouraged as it may lead to very poor timing results. It is recommended that this error condition be corrected in the design.

	%s (IBUFDS.O) is locked to %s
	%s (BUFG.I) is provisionally placed by clockplacer on %s
%s*DRC2�
 "t
.base_mb_i/in_buf_ds_adcbitclk/inst/IBUFDS_inst	.base_mb_i/in_buf_ds_adcbitclk/inst/IBUFDS_inst2default:default2default:default2@
 "*
	IOB_X1Y10
	IOB_X1Y102default:default2default:default2�
 "v
/base_mb_i/maroc_dc_0/inst/USR_LOGIC/BUFG_bitclk	/base_mb_i/maroc_dc_0/inst/USR_LOGIC/BUFG_bitclk2default:default2default:default2J
 "4
BUFGCTRL_X0Y22
BUFGCTRL_X0Y222default:default2default:default2;
 #DRC|Implementation|Placement|Clocks2default:default8ZPLCK-12h px� 
�

�Clock Placer Checks: Sub-optimal placement for a clock-capable IO pin and BUFH pair. 
Resolution: A dedicated routing path between the two can be used if: (a) The clock-capable IO (CCIO) is placed on a CCIO capable site (b) The BUFH is placed in the same clock region row as the CCIO pin. Both the above conditions must be met at the same time, else it may lead to longer and less predictable clock insertion delays.
 This is normally an ERROR but the CLOCK_DEDICATED_ROUTE constraint is set to FALSE allowing your design to continue. The use of this override is highly discouraged as it may lead to very poor timing results. It is recommended that this error condition be corrected in the design.

	%s (IBUFDS.O) is locked to %s
	%s (BUFH.I) is provisionally placed by clockplacer on %s
%s*DRC2�
 "t
.base_mb_i/in_buf_ds_adcbitclk/inst/IBUFDS_inst	.base_mb_i/in_buf_ds_adcbitclk/inst/IBUFDS_inst2default:default2default:default2@
 "*
	IOB_X1Y10
	IOB_X1Y102default:default2default:default2�
 "v
/base_mb_i/maroc_dc_0/inst/USR_LOGIC/BUFH_bitclk	/base_mb_i/maroc_dc_0/inst/USR_LOGIC/BUFH_bitclk2default:default2default:default2D
 ".
BUFHCE_X1Y0
BUFHCE_X1Y02default:default2default:default2;
 #DRC|Implementation|Placement|Clocks2default:default8ZPLCK-55h px� 
�
�Placement Constraints Check for IO constraints: Invalid constraint on register %s. It has the property IOB=TRUE, but it is not driving or driven by any IO element.%s*DRC2�
 "�
�base_mb_i/axi_quad_spi_0/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/LOGIC_FOR_MD_0_GEN.SPI_MODULE_I/RATIO_NOT_EQUAL_4_GENERATE.SCK_O_NQ_4_NO_STARTUP_USED.SCK_O_NE_4_FDRE_INST	�base_mb_i/axi_quad_spi_0/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/LOGIC_FOR_MD_0_GEN.SPI_MODULE_I/RATIO_NOT_EQUAL_4_GENERATE.SCK_O_NQ_4_NO_STARTUP_USED.SCK_O_NE_4_FDRE_INST2default:default2default:default28
  DRC|Implementation|Placement|IOs2default:default8ZPLIO-6h px� 
�
�Placement Constraints Check for IO constraints: Invalid constraint on register %s. It has the property IOB=TRUE, but it is not driving or driven by any IO element.%s*DRC2�
 "�
�base_mb_i/axi_quad_spi_1/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/LOGIC_FOR_MD_0_GEN.SPI_MODULE_I/RATIO_NOT_EQUAL_4_GENERATE.SCK_O_NQ_4_NO_STARTUP_USED.SCK_O_NE_4_FDRE_INST	�base_mb_i/axi_quad_spi_1/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/LOGIC_FOR_MD_0_GEN.SPI_MODULE_I/RATIO_NOT_EQUAL_4_GENERATE.SCK_O_NQ_4_NO_STARTUP_USED.SCK_O_NE_4_FDRE_INST2default:default2default:default28
  DRC|Implementation|Placement|IOs2default:default8ZPLIO-6h px� 
b
DRC finished with %s
79*	vivadotcl2(
0 Errors, 4 Warnings2default:defaultZ4-198h px� 
e
BPlease refer to the DRC report (report_drc) for more information.
80*	vivadotclZ4-199h px� 
V

Starting %s Task
103*constraints2
Routing2default:defaultZ18-103h px� 
i
Using Router directive '%s'.
20*	routeflow2&
NoTimingRelaxation2default:defaultZ35-270h px� 
}
BMultithreading enabled for route_design using a maximum of %s CPUs17*	routeflow2
82default:defaultZ35-254h px� 
p

Phase %s%s
101*constraints2
1 2default:default2#
Build RT Design2default:defaultZ18-101h px� 
C
.Phase 1 Build RT Design | Checksum: 1ab92d837
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:22 ; elapsed = 00:00:12 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6955 ; free virtual = 285962default:defaulth px� 
v

Phase %s%s
101*constraints2
2 2default:default2)
Router Initialization2default:defaultZ18-101h px� 
o

Phase %s%s
101*constraints2
2.1 2default:default2 
Create Timer2default:defaultZ18-101h px� 
B
-Phase 2.1 Create Timer | Checksum: 1ab92d837
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:22 ; elapsed = 00:00:13 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6960 ; free virtual = 286012default:defaulth px� 
{

Phase %s%s
101*constraints2
2.2 2default:default2,
Fix Topology Constraints2default:defaultZ18-101h px� 
N
9Phase 2.2 Fix Topology Constraints | Checksum: 1ab92d837
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:23 ; elapsed = 00:00:13 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6921 ; free virtual = 285622default:defaulth px� 
t

Phase %s%s
101*constraints2
2.3 2default:default2%
Pre Route Cleanup2default:defaultZ18-101h px� 
G
2Phase 2.3 Pre Route Cleanup | Checksum: 1ab92d837
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:23 ; elapsed = 00:00:13 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6921 ; free virtual = 285622default:defaulth px� 
p

Phase %s%s
101*constraints2
2.4 2default:default2!
Update Timing2default:defaultZ18-101h px� 
C
.Phase 2.4 Update Timing | Checksum: 1ec92e81d
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:50 ; elapsed = 00:00:25 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6890 ; free virtual = 285312default:defaulth px� 
�
Intermediate Timing Summary %s164*route2L
8| WNS=-2.312 | TNS=-2.441 | WHS=-2.811 | THS=-3094.230|
2default:defaultZ35-416h px� 
}

Phase %s%s
101*constraints2
2.5 2default:default2.
Update Timing for Bus Skew2default:defaultZ18-101h px� 
r

Phase %s%s
101*constraints2
2.5.1 2default:default2!
Update Timing2default:defaultZ18-101h px� 
E
0Phase 2.5.1 Update Timing | Checksum: 1a5348381
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:01:09 ; elapsed = 00:00:29 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6873 ; free virtual = 285152default:defaulth px� 
�
Intermediate Timing Summary %s164*route2J
6| WNS=-2.312 | TNS=-2.440 | WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px� 
P
;Phase 2.5 Update Timing for Bus Skew | Checksum: 166228111
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:01:09 ; elapsed = 00:00:29 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6872 ; free virtual = 285142default:defaulth px� 
I
4Phase 2 Router Initialization | Checksum: 1a55eed9e
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:01:09 ; elapsed = 00:00:29 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6872 ; free virtual = 285142default:defaulth px� 
p

Phase %s%s
101*constraints2
3 2default:default2#
Initial Routing2default:defaultZ18-101h px� 
C
.Phase 3 Initial Routing | Checksum: 146b0b6c6
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:01:31 ; elapsed = 00:00:35 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6849 ; free virtual = 284902default:defaulth px� 
s

Phase %s%s
101*constraints2
4 2default:default2&
Rip-up And Reroute2default:defaultZ18-101h px� 
u

Phase %s%s
101*constraints2
4.1 2default:default2&
Global Iteration 02default:defaultZ18-101h px� 
�
Intermediate Timing Summary %s164*route2J
6| WNS=-2.311 | TNS=-2.485 | WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px� 
G
2Phase 4.1 Global Iteration 0 | Checksum: e781bf74
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:02:30 ; elapsed = 00:00:59 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6852 ; free virtual = 284942default:defaulth px� 
u

Phase %s%s
101*constraints2
4.2 2default:default2&
Global Iteration 12default:defaultZ18-101h px� 
�
Intermediate Timing Summary %s164*route2J
6| WNS=-2.311 | TNS=-2.545 | WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px� 
H
3Phase 4.2 Global Iteration 1 | Checksum: 1c8daeb94
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:02:33 ; elapsed = 00:01:02 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6856 ; free virtual = 284982default:defaulth px� 
F
1Phase 4 Rip-up And Reroute | Checksum: 1c8daeb94
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:02:33 ; elapsed = 00:01:02 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6856 ; free virtual = 284982default:defaulth px� 
|

Phase %s%s
101*constraints2
5 2default:default2/
Delay and Skew Optimization2default:defaultZ18-101h px� 
p

Phase %s%s
101*constraints2
5.1 2default:default2!
Delay CleanUp2default:defaultZ18-101h px� 
r

Phase %s%s
101*constraints2
5.1.1 2default:default2!
Update Timing2default:defaultZ18-101h px� 
E
0Phase 5.1.1 Update Timing | Checksum: 19f62983f
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:02:37 ; elapsed = 00:01:03 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6857 ; free virtual = 284982default:defaulth px� 
�
Intermediate Timing Summary %s164*route2J
6| WNS=-2.311 | TNS=-2.545 | WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px� 
C
.Phase 5.1 Delay CleanUp | Checksum: 158307f9f
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:02:37 ; elapsed = 00:01:03 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6856 ; free virtual = 284972default:defaulth px� 
z

Phase %s%s
101*constraints2
5.2 2default:default2+
Clock Skew Optimization2default:defaultZ18-101h px� 
M
8Phase 5.2 Clock Skew Optimization | Checksum: 158307f9f
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:02:38 ; elapsed = 00:01:03 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6846 ; free virtual = 284872default:defaulth px� 
O
:Phase 5 Delay and Skew Optimization | Checksum: 158307f9f
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:02:38 ; elapsed = 00:01:04 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6846 ; free virtual = 284872default:defaulth px� 
n

Phase %s%s
101*constraints2
6 2default:default2!
Post Hold Fix2default:defaultZ18-101h px� 
p

Phase %s%s
101*constraints2
6.1 2default:default2!
Hold Fix Iter2default:defaultZ18-101h px� 
r

Phase %s%s
101*constraints2
6.1.1 2default:default2!
Update Timing2default:defaultZ18-101h px� 
E
0Phase 6.1.1 Update Timing | Checksum: 16843875d
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:02:42 ; elapsed = 00:01:05 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6847 ; free virtual = 284882default:defaulth px� 
�
Intermediate Timing Summary %s164*route2K
7| WNS=-2.311 | TNS=-2.545 | WHS=-2.247 | THS=-315.291|
2default:defaultZ35-416h px� 
C
.Phase 6.1 Hold Fix Iter | Checksum: 1e38c7cbb
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:02:54 ; elapsed = 00:01:10 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6811 ; free virtual = 284532default:defaulth px� 
A
,Phase 6 Post Hold Fix | Checksum: 16d57b961
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:02:54 ; elapsed = 00:01:10 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6814 ; free virtual = 284562default:defaulth px� 
t

Phase %s%s
101*constraints2
7 2default:default2'
Timing Verification2default:defaultZ18-101h px� 
p

Phase %s%s
101*constraints2
7.1 2default:default2!
Update Timing2default:defaultZ18-101h px� 
C
.Phase 7.1 Update Timing | Checksum: 1af328ce4
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:03:01 ; elapsed = 00:01:12 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6819 ; free virtual = 284602default:defaulth px� 
�
Intermediate Timing Summary %s164*route2J
6| WNS=-2.311 | TNS=-2.545 | WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px� 
G
2Phase 7 Timing Verification | Checksum: 1af328ce4
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:03:02 ; elapsed = 00:01:12 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6819 ; free virtual = 284602default:defaulth px� 
o

Phase %s%s
101*constraints2
8 2default:default2"
Route finalize2default:defaultZ18-101h px� 
B
-Phase 8 Route finalize | Checksum: 1af328ce4
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:03:03 ; elapsed = 00:01:13 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6816 ; free virtual = 284582default:defaulth px� 
v

Phase %s%s
101*constraints2
9 2default:default2)
Verifying routed nets2default:defaultZ18-101h px� 
I
4Phase 9 Verifying routed nets | Checksum: 1af328ce4
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:03:03 ; elapsed = 00:01:13 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6816 ; free virtual = 284572default:defaulth px� 
s

Phase %s%s
101*constraints2
10 2default:default2%
Depositing Routes2default:defaultZ18-101h px� 
�
,Router swapped GT pin %s to physical pin %s
200*route2�
�base_mb_i/wrc_board_quabo_Light_0/U0/cmp_xwrc_board_quabo/cmp_xwrc_platform/gen_phy_kintex7.cmp_gtx/U_GTX_INST/gtxe2_i/GTREFCLK0�base_mb_i/wrc_board_quabo_Light_0/U0/cmp_xwrc_board_quabo/cmp_xwrc_platform/gen_phy_kintex7.cmp_gtx/U_GTX_INST/gtxe2_i/GTREFCLK02default:default2P
GTXE2_CHANNEL_X0Y4/GTREFCLK1GTXE2_CHANNEL_X0Y4/GTREFCLK12default:default8Z35-467h px� 
F
1Phase 10 Depositing Routes | Checksum: 1d087659c
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:03:05 ; elapsed = 00:01:15 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6814 ; free virtual = 284552default:defaulth px� 
w

Phase %s%s
101*constraints2
11 2default:default2)
Incr Placement Change2default:defaultZ18-101h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2.
Netlist sorting complete. 2default:default2
00:00:00.012default:default2
00:00:00.012default:default2
3725.2812default:default2
0.0002default:default2
68522default:default2
284942default:defaultZ17-722h px� 
�
hPost Placement Timing Summary WNS=%s. For the most accurate timing information please run report_timing.610*place2
-2.3072default:defaultZ30-746h px� 
A
,Ending IncrPlace Task | Checksum: 1269b4e37
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:26 ; elapsed = 00:00:14 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6883 ; free virtual = 285252default:defaulth px� 
J
5Phase 11 Incr Placement Change | Checksum: 1d087659c
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:03:32 ; elapsed = 00:01:30 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6888 ; free virtual = 285292default:defaulth px� 
q

Phase %s%s
101*constraints2
12 2default:default2#
Build RT Design2default:defaultZ18-101h px� 
C
.Phase 12 Build RT Design | Checksum: ddbfc4d7
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:03:41 ; elapsed = 00:01:38 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6848 ; free virtual = 284902default:defaulth px� 
w

Phase %s%s
101*constraints2
13 2default:default2)
Router Initialization2default:defaultZ18-101h px� 
p

Phase %s%s
101*constraints2
13.1 2default:default2 
Create Timer2default:defaultZ18-101h px� 
B
-Phase 13.1 Create Timer | Checksum: 867aaa5e
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:03:42 ; elapsed = 00:01:40 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6828 ; free virtual = 284702default:defaulth px� 
|

Phase %s%s
101*constraints2
13.2 2default:default2,
Fix Topology Constraints2default:defaultZ18-101h px� 
N
9Phase 13.2 Fix Topology Constraints | Checksum: 867aaa5e
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:03:43 ; elapsed = 00:01:40 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6791 ; free virtual = 284332default:defaulth px� 
u

Phase %s%s
101*constraints2
13.3 2default:default2%
Pre Route Cleanup2default:defaultZ18-101h px� 
G
2Phase 13.3 Pre Route Cleanup | Checksum: f57f53d7
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:03:43 ; elapsed = 00:01:41 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6791 ; free virtual = 284332default:defaulth px� 
q

Phase %s%s
101*constraints2
13.4 2default:default2!
Update Timing2default:defaultZ18-101h px� 
D
/Phase 13.4 Update Timing | Checksum: 15672371a
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:04:09 ; elapsed = 00:01:48 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6737 ; free virtual = 283792default:defaulth px� 
�
Intermediate Timing Summary %s164*route2L
8| WNS=-2.312 | TNS=-2.467 | WHS=-2.812 | THS=-3088.591|
2default:defaultZ35-416h px� 
~

Phase %s%s
101*constraints2
13.5 2default:default2.
Update Timing for Bus Skew2default:defaultZ18-101h px� 
s

Phase %s%s
101*constraints2
13.5.1 2default:default2!
Update Timing2default:defaultZ18-101h px� 
F
1Phase 13.5.1 Update Timing | Checksum: 18e709a99
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:04:28 ; elapsed = 00:01:52 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6706 ; free virtual = 283482default:defaulth px� 
�
Intermediate Timing Summary %s164*route2J
6| WNS=-2.312 | TNS=-2.464 | WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px� 
Q
<Phase 13.5 Update Timing for Bus Skew | Checksum: 21b8ef76d
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:04:28 ; elapsed = 00:01:52 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6703 ; free virtual = 283452default:defaulth px� 
J
5Phase 13 Router Initialization | Checksum: 1bbc2ef3f
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:04:28 ; elapsed = 00:01:53 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6706 ; free virtual = 283482default:defaulth px� 
q

Phase %s%s
101*constraints2
14 2default:default2#
Initial Routing2default:defaultZ18-101h px� 
D
/Phase 14 Initial Routing | Checksum: 1954f30ce
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:04:29 ; elapsed = 00:01:53 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6699 ; free virtual = 283412default:defaulth px� 
t

Phase %s%s
101*constraints2
15 2default:default2&
Rip-up And Reroute2default:defaultZ18-101h px� 
v

Phase %s%s
101*constraints2
15.1 2default:default2&
Global Iteration 02default:defaultZ18-101h px� 
�
Intermediate Timing Summary %s164*route2J
6| WNS=-2.311 | TNS=-2.467 | WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px� 
H
3Phase 15.1 Global Iteration 0 | Checksum: 73bef0e2
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:04:44 ; elapsed = 00:02:02 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6703 ; free virtual = 283452default:defaulth px� 
v

Phase %s%s
101*constraints2
15.2 2default:default2&
Global Iteration 12default:defaultZ18-101h px� 
�
Intermediate Timing Summary %s164*route2J
6| WNS=-2.311 | TNS=-2.467 | WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px� 
I
4Phase 15.2 Global Iteration 1 | Checksum: 17524ee15
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:04:48 ; elapsed = 00:02:06 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6695 ; free virtual = 283372default:defaulth px� 
G
2Phase 15 Rip-up And Reroute | Checksum: 17524ee15
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:04:48 ; elapsed = 00:02:06 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6695 ; free virtual = 283372default:defaulth px� 
}

Phase %s%s
101*constraints2
16 2default:default2/
Delay and Skew Optimization2default:defaultZ18-101h px� 
q

Phase %s%s
101*constraints2
16.1 2default:default2!
Delay CleanUp2default:defaultZ18-101h px� 
s

Phase %s%s
101*constraints2
16.1.1 2default:default2!
Update Timing2default:defaultZ18-101h px� 
F
1Phase 16.1.1 Update Timing | Checksum: 1bc3a55f8
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:04:52 ; elapsed = 00:02:07 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6695 ; free virtual = 283372default:defaulth px� 
�
Intermediate Timing Summary %s164*route2J
6| WNS=-2.311 | TNS=-2.467 | WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px� 
D
/Phase 16.1 Delay CleanUp | Checksum: 1c10f8afb
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:04:53 ; elapsed = 00:02:07 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6694 ; free virtual = 283362default:defaulth px� 
{

Phase %s%s
101*constraints2
16.2 2default:default2+
Clock Skew Optimization2default:defaultZ18-101h px� 
N
9Phase 16.2 Clock Skew Optimization | Checksum: 1c10f8afb
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:04:53 ; elapsed = 00:02:07 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6694 ; free virtual = 283362default:defaulth px� 
P
;Phase 16 Delay and Skew Optimization | Checksum: 1c10f8afb
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:04:53 ; elapsed = 00:02:07 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6694 ; free virtual = 283362default:defaulth px� 
o

Phase %s%s
101*constraints2
17 2default:default2!
Post Hold Fix2default:defaultZ18-101h px� 
q

Phase %s%s
101*constraints2
17.1 2default:default2!
Hold Fix Iter2default:defaultZ18-101h px� 
s

Phase %s%s
101*constraints2
17.1.1 2default:default2!
Update Timing2default:defaultZ18-101h px� 
F
1Phase 17.1.1 Update Timing | Checksum: 18dee0770
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:04:58 ; elapsed = 00:02:09 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6706 ; free virtual = 283482default:defaulth px� 
�
Intermediate Timing Summary %s164*route2J
6| WNS=-2.311 | TNS=-2.467 | WHS=0.042  | THS=0.000  |
2default:defaultZ35-416h px� 
D
/Phase 17.1 Hold Fix Iter | Checksum: 25aacd5cd
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:04:58 ; elapsed = 00:02:09 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6706 ; free virtual = 283482default:defaulth px� 
B
-Phase 17 Post Hold Fix | Checksum: 25aacd5cd
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:04:58 ; elapsed = 00:02:09 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6706 ; free virtual = 283482default:defaulth px� 
u

Phase %s%s
101*constraints2
18 2default:default2'
Timing Verification2default:defaultZ18-101h px� 
q

Phase %s%s
101*constraints2
18.1 2default:default2!
Update Timing2default:defaultZ18-101h px� 
D
/Phase 18.1 Update Timing | Checksum: 1a13ecfda
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:05:05 ; elapsed = 00:02:11 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6707 ; free virtual = 283492default:defaulth px� 
�
Intermediate Timing Summary %s164*route2J
6| WNS=-2.311 | TNS=-2.467 | WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px� 
H
3Phase 18 Timing Verification | Checksum: 1a13ecfda
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:05:06 ; elapsed = 00:02:11 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6707 ; free virtual = 283492default:defaulth px� 
n

Phase %s%s
101*constraints2
19 2default:default2 
Reset Design2default:defaultZ18-101h px� 
b
&%s nets already restored were skipped.120*route2
552532default:defaultZ35-307h px� 
A
,Phase 19 Reset Design | Checksum: 1bc624a49
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:05:15 ; elapsed = 00:02:13 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6825 ; free virtual = 284672default:defaulth px� 
t

Phase %s%s
101*constraints2
20 2default:default2&
Post Router Timing2default:defaultZ18-101h px� 
�
�Timer settings changed to match sign-off timing analysis. Setup and Hold analysis on slow, fast Corners with nearest common node skew is enabled.
62*routeZ35-62h px� 
�
Post Routing Timing Summary %s
20*route2J
6| WNS=-2.307 | TNS=-2.532 | WHS=0.046  | THS=0.000  |
2default:defaultZ35-20h px� 
�
dThe design did not meet timing requirements. Please run report_timing_summary for detailed reports.
39*routeZ35-39h px� 
�
�TNS is the sum of the worst slack violation on every endpoint in the design. Review the paths with the biggest WNS violations in the timing reports and modify your constraints or your design to improve both WNS and TNS.
96*routeZ35-253h px� 
G
2Phase 20 Post Router Timing | Checksum: 1ac7d62b4
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:05:37 ; elapsed = 00:02:17 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6812 ; free virtual = 284542default:defaulth px� 
@
Router Completed Successfully
2*	routeflowZ35-16h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:05:37 ; elapsed = 00:02:17 . Memory (MB): peak = 3725.281 ; gain = 0.000 ; free physical = 6970 ; free virtual = 286122default:defaulth px� 
Z
Releasing license: %s
83*common2"
Implementation2default:defaultZ17-83h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
3442default:default2
1002default:default2
32default:default2
02default:defaultZ4-41h px� 
^
%s completed successfully
29*	vivadotcl2 
route_design2default:defaultZ4-42h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2"
route_design: 2default:default2
00:05:432default:default2
00:02:202default:default2
3725.2812default:default2
0.0002default:default2
69702default:default2
286122default:defaultZ17-722h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2.
Netlist sorting complete. 2default:default2
00:00:00.012default:default2
00:00:00.012default:default2
3725.2812default:default2
0.0002default:default2
69702default:default2
286122default:defaultZ17-722h px� 
H
&Writing timing data to binary archive.266*timingZ38-480h px� 
D
Writing placer database...
1603*designutilsZ20-1893h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2.
Netlist sorting complete. 2default:default2
00:00:00.032default:default2
00:00:00.012default:default2
3725.2812default:default2
0.0002default:default2
68972default:default2
285922default:defaultZ17-722h px� 
=
Writing XDEF routing.
211*designutilsZ20-211h px� 
J
#Writing XDEF routing logical nets.
209*designutilsZ20-209h px� 
J
#Writing XDEF routing special nets.
210*designutilsZ20-210h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2)
Write XDEF Complete: 2default:default2
00:00:082default:default2
00:00:042default:default2
3725.2812default:default2
0.0002default:default2
67112default:default2
285792default:defaultZ17-722h px� 
�
 The %s '%s' has been generated.
621*common2

checkpoint2default:default2�
�/media/wei/DATA/LW/Project/Vivado_Project/Panoseti/V0090/quabo_master_V0090/quabo_master/build/quabo_V0090/quabo_V0090.runs/impl_1/base_mb_wrapper_routed.dcp2default:defaultZ17-1381h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2&
write_checkpoint: 2default:default2
00:00:212default:default2
00:00:172default:default2
3725.2812default:default2
0.0002default:default2
67662default:default2
285922default:defaultZ17-722h px� 
�
%s4*runtcl2�
�Executing : report_drc -file base_mb_wrapper_drc_routed.rpt -pb base_mb_wrapper_drc_routed.pb -rpx base_mb_wrapper_drc_routed.rpx
2default:defaulth px� 
�
Command: %s
53*	vivadotcl2�
ureport_drc -file base_mb_wrapper_drc_routed.rpt -pb base_mb_wrapper_drc_routed.pb -rpx base_mb_wrapper_drc_routed.rpx2default:defaultZ4-113h px� 
>
IP Catalog is up to date.1232*coregenZ19-1839h px� 
P
Running DRC with %s threads
24*drc2
82default:defaultZ23-27h px� 
�
#The results of DRC are in file %s.
168*coretcl2�
�/media/wei/DATA/LW/Project/Vivado_Project/Panoseti/V0090/quabo_master_V0090/quabo_master/build/quabo_V0090/quabo_V0090.runs/impl_1/base_mb_wrapper_drc_routed.rpt�/media/wei/DATA/LW/Project/Vivado_Project/Panoseti/V0090/quabo_master_V0090/quabo_master/build/quabo_V0090/quabo_V0090.runs/impl_1/base_mb_wrapper_drc_routed.rpt2default:default8Z2-168h px� 
\
%s completed successfully
29*	vivadotcl2

report_drc2default:defaultZ4-42h px� 
�
%s4*runtcl2�
�Executing : report_methodology -file base_mb_wrapper_methodology_drc_routed.rpt -pb base_mb_wrapper_methodology_drc_routed.pb -rpx base_mb_wrapper_methodology_drc_routed.rpx
2default:defaulth px� 
�
Command: %s
53*	vivadotcl2�
�report_methodology -file base_mb_wrapper_methodology_drc_routed.rpt -pb base_mb_wrapper_methodology_drc_routed.pb -rpx base_mb_wrapper_methodology_drc_routed.rpx2default:defaultZ4-113h px� 
E
%Done setting XDC timing constraints.
35*timingZ38-35h px� 
Y
$Running Methodology with %s threads
74*drc2
82default:defaultZ23-133h px� 
�
2The results of Report Methodology are in file %s.
450*coretcl2�
�/media/wei/DATA/LW/Project/Vivado_Project/Panoseti/V0090/quabo_master_V0090/quabo_master/build/quabo_V0090/quabo_V0090.runs/impl_1/base_mb_wrapper_methodology_drc_routed.rpt�/media/wei/DATA/LW/Project/Vivado_Project/Panoseti/V0090/quabo_master_V0090/quabo_master/build/quabo_V0090/quabo_V0090.runs/impl_1/base_mb_wrapper_methodology_drc_routed.rpt2default:default8Z2-1520h px� 
d
%s completed successfully
29*	vivadotcl2&
report_methodology2default:defaultZ4-42h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2(
report_methodology: 2default:default2
00:00:502default:default2
00:00:112default:default2
3725.2812default:default2
0.0002default:default2
64902default:default2
283162default:defaultZ17-722h px� 
�
%s4*runtcl2�
�Executing : report_power -file base_mb_wrapper_power_routed.rpt -pb base_mb_wrapper_power_summary_routed.pb -rpx base_mb_wrapper_power_routed.rpx
2default:defaulth px� 
�
Command: %s
53*	vivadotcl2�
�report_power -file base_mb_wrapper_power_routed.rpt -pb base_mb_wrapper_power_summary_routed.pb -rpx base_mb_wrapper_power_routed.rpx2default:defaultZ4-113h px� 
�
$Power model is not available for %s
23*power2Q
STARTUPE2_inst	+base_mb_i/SPI_STARTUP_0/inst/STARTUPE2_inst2default:default8Z33-23h px� 
E
%Done setting XDC timing constraints.
35*timingZ38-35h px� 
K
,Running Vector-less Activity Propagation...
51*powerZ33-51h px� 
P
3
Finished Running Vector-less Activity Propagation
1*powerZ33-1h px� 
�
�Detected over-assertion of set/reset/preset/clear net with high fanouts, power estimation might not be accurate. Please run Tool - Power Constraint Wizard to set proper switching activities for control signals.282*powerZ33-332h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
3572default:default2
1012default:default2
32default:default2
02default:defaultZ4-41h px� 
^
%s completed successfully
29*	vivadotcl2 
report_power2default:defaultZ4-42h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2"
report_power: 2default:default2
00:00:242default:default2
00:00:092default:default2
3725.2812default:default2
0.0002default:default2
64312default:default2
282852default:defaultZ17-722h px� 
�
%s4*runtcl2
kExecuting : report_route_status -file base_mb_wrapper_route_status.rpt -pb base_mb_wrapper_route_status.pb
2default:defaulth px� 
�
%s4*runtcl2�
�Executing : report_timing_summary -max_paths 10 -file base_mb_wrapper_timing_summary_routed.rpt -pb base_mb_wrapper_timing_summary_routed.pb -rpx base_mb_wrapper_timing_summary_routed.rpx -warn_on_violation 
2default:defaulth px� 
r
UpdateTimingParams:%s.
91*timing29
% Speed grade: -1, Delay Type: min_max2default:defaultZ38-91h px� 
|
CMultithreading enabled for timing update using a maximum of %s CPUs155*timing2
82default:defaultZ38-191h px� 
�
rThe design failed to meet the timing requirements. Please see the %s report for details on the timing violations.
188*timing2"
timing summary2default:defaultZ38-282h px� 
�
}There are set_bus_skew constraint(s) in this design. Please run report_bus_skew to ensure that bus skew requirements are met.223*timingZ38-436h px� 
�
%s4*runtcl2l
XExecuting : report_incremental_reuse -file base_mb_wrapper_incremental_reuse_routed.rpt
2default:defaulth px� 
g
BIncremental flow is disabled. No incremental reuse Info to report.423*	vivadotclZ4-1062h px� 
�
%s4*runtcl2l
XExecuting : report_clock_utilization -file base_mb_wrapper_clock_utilization_routed.rpt
2default:defaulth px� 
�
%s4*runtcl2�
�Executing : report_bus_skew -warn_on_violation -file base_mb_wrapper_bus_skew_routed.rpt -pb base_mb_wrapper_bus_skew_routed.pb -rpx base_mb_wrapper_bus_skew_routed.rpx
2default:defaulth px� 
r
UpdateTimingParams:%s.
91*timing29
% Speed grade: -1, Delay Type: min_max2default:defaultZ38-91h px� 
|
CMultithreading enabled for timing update using a maximum of %s CPUs155*timing2
82default:defaultZ38-191h px� 


End Record