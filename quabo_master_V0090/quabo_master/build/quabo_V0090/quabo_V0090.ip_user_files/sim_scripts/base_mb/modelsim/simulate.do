onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L xil_defaultlib -L xpm -L microblaze_v11_0_0 -L axi_lite_ipif_v3_0_4 -L mdm_v3_2_15 -L lib_cdc_v1_0_2 -L proc_sys_reset_v5_0_13 -L lib_pkg_v1_0_2 -L lib_srl_fifo_v1_0_2 -L axi_uartlite_v2_0_22 -L lmb_v10_v3_0_9 -L lmb_bram_if_cntlr_v4_0_15 -L blk_mem_gen_v8_4_2 -L fifo_generator_v13_2_3 -L lib_bmg_v1_0_11 -L axi_ethernet_buffer_v2_0_19 -L xbip_utils_v3_0_9 -L xbip_pipe_v3_0_5 -L xbip_bram18k_v3_0_5 -L mult_gen_v12_0_14 -L tri_mode_ethernet_mac_v9_0_13 -L gig_ethernet_pcs_pma_v16_1_5 -L xlconstant_v1_1_5 -L c_reg_fd_v12_0_5 -L c_mux_bit_v12_0_5 -L c_shift_ram_v12_0_12 -L xbip_dsp48_wrapper_v3_0_4 -L xbip_dsp48_addsub_v3_0_5 -L xbip_addsub_v3_0_5 -L c_addsub_v12_0_12 -L c_gate_bit_v12_0_5 -L xbip_counter_v3_0_5 -L c_counter_binary_v12_0_12 -L util_vector_logic_v2_0_1 -L lib_fifo_v1_0_12 -L axi_fifo_mm_s_v4_2_0 -L axi_intc_v4_1_12 -L axi_timer_v2_0_20 -L interrupt_control_v3_1_4 -L axi_iic_v2_0_21 -L xlconcat_v2_1_1 -L dist_mem_gen_v8_0_12 -L axi_quad_spi_v3_2_17 -L axi_gpio_v2_0_20 -L xlslice_v1_0_1 -L axi_timebase_wdt_v3_0_10 -L generic_baseblocks_v2_1_0 -L axi_infrastructure_v1_1_0 -L axi_register_slice_v2_1_18 -L axi_data_fifo_v2_1_17 -L axi_crossbar_v2_1_19 -L axi_hwicap_v3_0_22 -L axis_infrastructure_v1_1_0 -L axis_register_slice_v1_1_18 -L axis_switch_v1_1_18 -L unisims_ver -L unimacro_ver -L secureip -lib xil_defaultlib xil_defaultlib.base_mb xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {base_mb.udo}

run -all

quit -force
