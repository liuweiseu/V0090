//UDP-based service routine for the PANOSETI Quadrant Board
////////////////////////////Gold Firmware///////////////////////////////////////////////
//#define GOLD_COPY
//To permit printing some debug messages
//#define VERBOSE

//In hw13, added a pin to select one of two IP addresses on J3, abandoned UART
//#define READ_IP_ADDR_FROM_J3

//prevent setting the PH readout to a longer value than we've allocated storage for
#define MAX_STOP_CHANNEL 69

//Define this to make it impossible to set this remotely
#define ADCCLKPHASE 5

//We have 24b counter values but only 16b allocated for them.  So set this from 0 to 8 to scale the raw value by a power of two
#define IM_TRUNC_FACTOR 0
//Define this when using the hardware v08 or above; takes into account interface change for
//  the extra adc_clk_phase bit
#define HW_GTV08
//DEfine this when remapping the PH data
#define PH_REMAP

#define SUB_BL
#include <stdio.h>

#include "xparameters.h"
#include "xgpio.h"
#include "netif/xadapter.h"

#include "platform.h"
#include "platform_config.h"
#if defined (__arm__) || defined(__aarch64__)
#include "xil_printf.h"
#endif

#include "lwip/udp.h"
#include "lwipopts.h"
#include "xil_cache.h"
#include "xspi.h"
#include "xspi_l.h"
#include "xllfifo.h"
#include "xsysmon.h"
#include "xwdttb.h"
//#include "ip_addr.h"
#include "xintc.h"
//This is set to 0 in lwipopts.h, but system doesn't see it
#define LWIP_DHCP 0
#if LWIP_DHCP==1
#include "lwip/dhcp.h"
#endif

#include "gpio_spi_sel.h"
#include "flash.h"
/////////////////////////// HARDWARE INSTANCES  ////////////////////////////////////////
//The SPI interface
XSpi Spi; /* The instance of the SPI device */
XSpi_Config *ConfigPtr;	/* Pointer to Configuration data */
#define TMP125_SPI_MASK 0x01	//Temp sensor
#define DAQADC_SPI_MASK 0x02	//The LTC2170
#define HKADC_SPI_MASK 0x04		//The LTC2496
#define HV_DAC_SPI_MASK 0x08	//The AD5686
#define VCO1_DAC_SPI_MASK 0x10	//For WR TCVCXO
#define VCO2_DAC_SPI_MASK 0x20  //For WR VCXO

//The PulseHeight mode FIFO
XLlFifo PH_Fifo;
//The Image mode FIFO
XLlFifo IM_Fifo;
//A pointer to one or the other
//XLlFifo Current_Fifo;

//There is dual-channel GPIO; chan 1 is output, 2 is input
XGpio Gpio;
#define GPIO_ADD XPAR_GPIO_BASEADDR
#define GPIO_OUT_CHAN 1
#define GPIO_IN_CHAN 2

XGpio Gpio_mech;

//The XADC Stuff
#define SYSMON_DEVICE_ID 	XPAR_SYSMON_0_DEVICE_ID
static XSysMon SysMonInst;

//The science payload size
#define SCI_BUF_SIZE 528

//Command packets will be sent to this port,
// and command echo responses will be sent from this port
#define UDP_CMD_PORT 60000
//Science packets will be sent to this port
#define UDP_SCI_PORT 60001
//Send housekeeping to this port
#define UDP_HK_PORT 60002

//The MAROC_Slow_Control hardware module can be accessed through this address
#define MAROC_SC XPAR_MAROC_SLOW_CONTROL_0_S00_AXI_BASEADDR
/*
 * The interface to the slow control module
wire [31:0] par_data_in = slv_reg0;
wire SC_reset = slv_reg2[0];
wire maroc_reset = slv_reg2[1];
wire wr_par_data = slv_reg2[2];
wire rd_par_data = slv_reg2[3];
wire [3:0] chan_enable = slv_reg2[7:4];
wire SC_go = slv_reg2[8];
and slv_reg1 is the par_data_out (readback from the MAROCs)
*/
//WR SPI INTERRUPT
#define WR_INTERRUPT_INTR 5
//The MAROC_data_capture hardware module can be accessed through this address
#define MAROC_DC XPAR_MAROC_DC_0_S00_AXI_BASEADDR
#define ACQ_MODE_PH 0x01
#define ACQ_MODE_IM 0x02
#define ADC_LATENCY_SKIP_VAL 10
 /* The interface to the maroc_dc module
wire [2:0] adc_clk_phase_sel =  slave_reg8[13:11];
wire [1:0] mode_enable = slave_reg8[10:9]; //00 for none, 01 for PH, 10 for IM, 11 for both
wire [264:0] trigger_mask = {slave_reg8[8:0],
                            slave_reg7,
                            slave_reg6,
                            slave_reg5,
                            slave_reg4,
                            slave_reg3,
                            slave_reg2,
                            slave_reg1,
                            slave_reg0};
wire [7:0] frame_interval = slave_reg9[7:0];
wire [7:0] hold1_delay = slave_reg9[15:8];
wire [7:0] hold2_delay = slave_reg9[23:16];
wire [7:0] ph_stop_chan = slave_reg9[30:24];
wire counter_reset = slave_reg9[31];
*/

void XSpi_Abort(XSpi *InstancePtr);

/* defined by each RAW mode application */
void tcp_fasttmr(void);
void tcp_slowtmr(void);

/* missing declaration in lwIP */
void lwip_init();

#if LWIP_DHCP==1
extern volatile int dhcp_timoutcntr;
err_t dhcp_start(struct netif *netif);
#endif

extern volatile int TcpFastTmrFlag;
extern volatile int TcpSlowTmrFlag;
extern volatile int interrupt_counter;

static struct netif server_netif;
struct netif *echo_netif;
int recvd_pkt_number = 0;
struct pbuf * recvd_pkt;
static 	struct pbuf *hk_pbuf;

//Function Prototypes
void print_ip(char *msg, struct ip4_addr *ip);
void print_ip_settings(struct ip4_addr *ip, struct ip4_addr *mask, struct ip4_addr *gw);
//Called when a packet received by GbEMAC
void recv_callback(void *arg, struct udp_pcb *tpcb, struct pbuf *p, struct ip4_addr *addr, u16_t port);

//Write the 829-bit serial setup data to the MAROC chip(s).  Read back the data and fill the out_ptr array
//Bits 3:0 of chip_mask indicate which chip(s) to write- a 1 in each position writes that chip
//All chips are written in parallel, so must supply data for all four even if some are masked
// (that data will be unused for the masked chips)
//Data read back will be put in a u32 array and needs to be de-interleaved at a higher level
void Set_MAROC_registers(u8 chip_mask, u32* chip0,u32* chip1,u32* chip2,u32* chip3, u32* out_ptr);

//Set the high voltage- takes a pointer to four 16-bit values
void Set_HV(u16* data_ptr);

//Update the GPIO that controls the stim, hv_enable, etc
void UpdateGPIO(void);

//Set one of the DACs that control the White Rabbit VCOs
void Set_WRDAC(u8 which_dac, u16 value);

//Set the parameters associated with data acquisition modes.
//parameters, all u16:
/*	acq_mode
 * 	acq_int
 * 	hold1 delay
 * 	hold2 delay
 * 	adc clock phase
 * 	monitor channel
 */
void Set_Acquisition(u16* dataptr);

//Reset the system
void ResetSys(u16 reset_mask);

//Set stepper motor
void SetStepper(s16 steps);

//Set channel Mask- a 1 in any bit position masks that channel
void SetChannelMask(u8* data_ptr);

//Read the HK ADC, and values from temp sensor, etc.  Put results in u16 array.  If SPI is busy, return -1
int GetHouseKeeping(void);
void GetTMP125(void);

void SetupLTC2170(void);

//Send the housekeeping data
void SendHouseKeeping(void);

//Initialize the ph_baseline array
int PH_BL_Init(u16 * ph_baseline_array);

void InitXADC(void);

//Wait some number of interrupt ticks, about 160ms/tick
void waitabit(u8 val);

#ifdef PH_REMAP
void InitRemap(u16* array);
#endif

//This gets called when the WR interrupt is asserted, to indicate that MB can use the SPI bus
void WR_int_callback();

//The udp pcb for sending and receiving command and housekeeping
struct udp_pcb *cmd_pcb;
//The udp pcb for sending science
struct udp_pcb *sci_pcb;
//The udp pcb for sending housekeeping
struct udp_pcb *hk_pcb;

//Increment this each time a science packet is sent
u16 packet_number = 0;

//Increment in timer interrupt
u32 elapsed_time = 0;
u8 hk_timer = 0;

//keep track of these when the acquisition parameters are set
u8 acq_mode = 0;
u16 stop_channel = 65;
u8 stim_level = 0;
u8 stim_rate = 0;
u8 stim_on = 0;
u8 hv_rstb = 0;
// spi_sel = 0 is for WR control, = 1 for MB control
u8 spi_sel = 0;
// Set to 1 to arm the WR interrupt logic
u8 wr_int_arm = 0;
u8 SPI_flag;
u8 ET_clk_reset = 0;

u8 shutter_power = 0;
u8 shutter_open = 0;
u8 focus_limits_on = 0;
u8 fan_speed = 0;

u8 flash_rate = 0;
u8 flash_level = 0;
u8 flash_width = 0;
//Send this out in the first housekeeping packet then set to 0, to flag any reboots
char first_hk_pkt = 0xaa;
//We'll read the board location on powerup and over-write this value
u16 board_location = 0x1234;

//We'll read the HK ADC every timer interrupt, if the SPI isn't busy.  This is because
//  the ADC is so slow (~150ms/conversion).  We'll put the values here, and keep a pointer
// to the next channel to be converted
u8 hkadc_channel = 0;
u16 hkadc_array [16] = {0};
u16 tmp125_val = 0;
//If this is zero, only send an HK packet in response to the HK command.
// Else, send one every approx hk_interval seconds
u8 hk_interval = 1;

//We'll subtract off a fixed baseline from the PH data.  Reserve 64 * 4 u16 values
// (it'd probably be OK to just use a single value for each ADC channel- 4 values total.  If RAM becomes a problem, and we need that 512B back, could reconsider)
u16 ph_baseline_array[256];

//Save the HV values so we can restore them after a BL_Init
u16 HV_settings [4] = {0,0,0,0};

u8 SPI_chan_mask;
u8 SPI_TxBuf[3];
u8 SPI_RxBuf[3];
u8 SPI_flag;
u8 SPI_bytes_to_send = 0;

#if defined (__arm__) && !defined (ARMR5)
#if XPAR_GIGE_PCS_PMA_SGMII_CORE_PRESENT == 1 || XPAR_GIGE_PCS_PMA_1000BASEX_CORE_PRESENT == 1
int ProgramSi5324(void);
int ProgramSfpPhy(void);
#endif
#endif


u16 DeviceId;
int Status;
int main()
{
	xil_printf("***************************************\n\r");
	xil_printf("********Boot from Addr:0x010100********\n\r");
	//xil_printf("*************Gold Frimware*************\n\r");
	xil_printf("***************************************\n\r");
 	volatile int delay;
 	//initialize baseline array to zero.  We'll fill it when commanded, after setting up the MAROCs
 	for (delay = 0; delay < 256; delay++)ph_baseline_array[delay] = 0;

	  // Initialize the SPI driver so that it is  ready to use.
	 ConfigPtr = XSpi_LookupConfig(XPAR_SPI_0_DEVICE_ID);
	 	 if (ConfigPtr == NULL) return XST_DEVICE_NOT_FOUND;
	 Status = XSpi_CfgInitialize(&Spi, ConfigPtr,ConfigPtr->BaseAddress);
	 	 if (Status != XST_SUCCESS) return XST_FAILURE;
	 	XSpi_Reset(&Spi);
	 	 // Start the SPI driver so that the device is enabled.
	 	XSpi_Start(&Spi);
	 	 //Disable Global interrupt to use polled mode operation
	 	XSpi_IntrGlobalDisable(&Spi);

	 	//Set up the LTC2170 in 1-lane, 12-bit mode
	 	//SetupLTC2170();

	 	//Set up the XADC
	 	InitXADC();
	 	//Set up the GPIO
		 Status = XGpio_Initialize(&Gpio, XPAR_GPIO_DEVICE_ID);
		 if (Status != XST_SUCCESS)  return XST_FAILURE;
		 /* Set the direction for all signals of first channel to be outputs, other to be inputs */
		 XGpio_SetDataDirection(&Gpio, GPIO_OUT_CHAN, 0x0);
		 XGpio_SetDataDirection(&Gpio, GPIO_IN_CHAN, 0xffffffff);
		 //Set HVRSTb low, so HV disabled, stim off, stim_level= 0

		 //Set up the GPIO for the mechanical stuff
		 Status = XGpio_Initialize(&Gpio_mech, XPAR_AXI_GPIO_MECH_DEVICE_ID);
		 if (Status != XST_SUCCESS)  return XST_FAILURE;
		 /* Set the direction for all signals of first channel to be outputs, other to be inputs */
		 XGpio_SetDataDirection(&Gpio_mech, GPIO_OUT_CHAN, 0x0);
		 XGpio_SetDataDirection(&Gpio_mech, GPIO_IN_CHAN, 0xffffffff);
		 //Set all outputs low
		 XGpio_DiscreteWrite(&Gpio_mech, GPIO_OUT_CHAN, 0);

		 XGpio_DiscreteWrite(&Gpio, GPIO_OUT_CHAN, 0x0);
		 //Set HVRSTb low, so HV disabled, stim on, stim_level= 50%
		 stim_on = 1;
		 stim_level = 0x80;
		 //default is wr control
		 spi_sel = 0;
		 //disable wr interrupt
		 wr_int_arm = 0;
		 UpdateGPIO();
		 //Set the HVs to 0.  Need to do this to make the VREF input of the AD5686 behave properly
		 //Set_HV(HV_settings);

		 //The PulseHeight mode FIFO
		 XLlFifo_Config *Config;
		 /* Initialize the Device Configuration Interface driver */
		 Config = XLlFfio_LookupConfig(XPAR_AXI_FIFO_MM_S_PH_DEVICE_ID);
		 if (!Config) {
			xil_printf("No config found for %d\r\n", XPAR_AXI_FIFO_MM_S_PH_DEVICE_ID);
			return XST_FAILURE;
		 }
		Status = XLlFifo_CfgInitialize(&PH_Fifo, Config, Config->BaseAddress);
		if (Status != XST_SUCCESS) {
			xil_printf("Initialization failed\n\r");
			return Status;
		}
#ifdef PH_REMAP
		//Need to define a map array.
		u16 remap_array [256];
		InitRemap(remap_array);
		//for (Status = 0; Status<256; Status++) remap_array[Status] = Status;
#endif
		 //The Image mode FIFO
		 /* Initialize the Device Configuration Interface driver */
		 Config = XLlFfio_LookupConfig(XPAR_AXI_FIFO_MM_S_IM_DEVICE_ID);
		 if (!Config) {
			xil_printf("No config found for %d\r\n", XPAR_AXI_FIFO_MM_S_IM_DEVICE_ID);
			return XST_FAILURE;
		 }
		Status = XLlFifo_CfgInitialize(&IM_Fifo, Config, Config->BaseAddress);
		if (Status != XST_SUCCESS) {
			xil_printf("Initialization failed\n\r");
			return Status;
		}
	struct ip4_addr ipaddr, netmask, gw;
	struct ip4_addr host_ipaddr;

	xil_printf("PANOSETI Quadrant board UDP\n\r");

	echo_netif = &server_netif;
#if defined (__arm__) && !defined (ARMR5)
#if XPAR_GIGE_PCS_PMA_SGMII_CORE_PRESENT == 1 || XPAR_GIGE_PCS_PMA_1000BASEX_CORE_PRESENT == 1
	ProgramSi5324();
	ProgramSfpPhy();
#endif
#endif

	init_platform();
	/* the mac address of the board. this should be unique per board */
	unsigned char flash_uid[8];
	gpio_sel_mb();
	flash_read_uid(flash_uid);
	gpio_sel_wr();
	//unsigned char mac_ethernet_address[] ={ 0x00, 0x0a, 0x35, 0x00, 0x01, 0x02 };
	unsigned char mac_ethernet_address[6] ={flash_uid[0],flash_uid[1],flash_uid[2],flash_uid[3],flash_uid[4],flash_uid[5]};
	xil_printf("mac_address = %x %x %x %x %x %x\r\n",mac_ethernet_address[0],mac_ethernet_address[1],mac_ethernet_address[2],
			                                         mac_ethernet_address[3],mac_ethernet_address[4],mac_ethernet_address[5]);
#if LWIP_DHCP==1
    ipaddr.addr = 0;
	gw.addr = 0;
	netmask.addr = 0;
#else
	/* initialize IP addresses to be used */
	IP4_ADDR(&ipaddr,  192, 168,   1, 10);
	IP4_ADDR(&netmask, 255, 255, 0xfc,  0);
	IP4_ADDR(&gw,      192, 168,   1,  1);
	IP4_ADDR(&host_ipaddr,      192, 168,   1,  100);
#endif	
#ifdef READ_IP_ADDR_FROM_J3
	u32 switch_val = (XGpio_DiscreteRead(&Gpio, GPIO_IN_CHAN) & 0x01);
	if (switch_val)
		{
			board_location = 0x1235;
			IP4_ADDR(&ipaddr,  192, 168,   1, 11);
			mac_ethernet_address[5] = 0x02;
		}
	else
		{
			IP4_ADDR(&ipaddr,  192, 168,   1, 10);
			board_location = 0x1234;
			mac_ethernet_address [5] = 0x01;
		}
#else
	board_location = (XGpio_DiscreteRead(&Gpio, GPIO_IN_CHAN) & 0x3ff);
	IP4_ADDR(&ipaddr, 192, 168, board_location>>8, board_location & 0xff);
#endif
	//print_app_header();

	lwip_init();
  	/* Add network interface to the netif_list, and set it as default */
	if (!xemac_add(echo_netif, &ipaddr, &netmask,
						&gw, mac_ethernet_address,
						PLATFORM_EMAC_BASEADDR)) {
		xil_printf("Error adding N/W interface\n\r");
		return -1;
	}
	netif_set_default(echo_netif);
	/* Register WR SPI access Interrupt handler */
	XIntc_RegisterHandler(XPAR_INTC_0_BASEADDR,
				WR_INTERRUPT_INTR,
				(XInterruptHandler)WR_int_callback,
				0);
	/* now enable interrupts */
	platform_enable_interrupts();

	/* specify that the network if is up */
	netif_set_up(echo_netif);

#if (LWIP_DHCP==1)
	/* Create a new DHCP client for this interface.
	 * Note: you must call dhcp_fine_tmr() and dhcp_coarse_tmr() at
	 * the predefined regular intervals after starting the client.
	 */
	dhcp_start(echo_netif);
	dhcp_timoutcntr = 24;

	while(((echo_netif->ip_addr.addr) == 0) && (dhcp_timoutcntr > 0))
		xemacif_input(echo_netif);

	if (dhcp_timoutcntr <= 0) {
		if ((echo_netif->ip_addr.addr) == 0) {
			xil_printf("DHCP Timeout\r\n");
			xil_printf("Configuring default IP of 192.168.1.10\r\n");
			IP4_ADDR(&(echo_netif->ip_addr),  192, 168,   1, 10);
			IP4_ADDR(&(echo_netif->netmask), 255, 255, 255,  0);
			IP4_ADDR(&(echo_netif->gw),      192, 168,   1,  1);
		}
	}

	ipaddr.addr = echo_netif->ip_addr.addr;
	gw.addr = echo_netif->gw.addr;
	netmask.addr = echo_netif->netmask.addr;
#endif

	print_ip_settings(&ipaddr, &netmask, &gw);

	err_t err;

	/* create a udp socket for the command data */
	cmd_pcb = udp_new();
	if (!cmd_pcb) {
		xil_printf("Error creating PCB. Out of Memory\r\n");
		return -1;
	}
	/* bind to local address- we'll receive commands on this one */
	if ((err = udp_bind(cmd_pcb, &ipaddr, UDP_CMD_PORT)) != ERR_OK) {
		xil_printf("error on udp_bind: %x\n\r", err);
	}
	/* connect to PC command/housekeeping port*/
	err = udp_connect(cmd_pcb, &host_ipaddr, UDP_CMD_PORT);
	if (err != ERR_OK)
		xil_printf("error on udp_connect: %x\n\r", err);

	//register the receive data callback
	udp_recv(cmd_pcb, recv_callback, NULL);

	/* create a udp socket for the science data */
	sci_pcb = udp_new();
	if (!sci_pcb) {
		xil_printf("Error creating PCB. Out of Memory\r\n");
		return -1;
	}

	/* connect to PC science port */
	err = udp_connect(sci_pcb, &host_ipaddr, UDP_SCI_PORT);
	if (err != ERR_OK)
		xil_printf("error on udp_connect: %x\n\r", err);

	/* create a udp socket for the housekeeping data */
	hk_pcb = udp_new();
	if (!hk_pcb) {
		xil_printf("Error creating PCB. Out of Memory\r\n");
		return -1;
	}

	/* connect to PC housekeeping port */
	err = udp_connect(hk_pcb, &host_ipaddr, UDP_HK_PORT);
	if (err != ERR_OK)
		xil_printf("error on udp_connect: %x\n\r", err);

	//Set the HVs to 0.  Need to do this to make the VREF input of the AD5686 behave properly
	Set_HV(HV_settings);
	//Set up the LTC2170 in 1-lane, 12-bit mode
	SetupLTC2170();

	//Pulse the ET_clk_reset line
	ET_clk_reset = 1;
	UpdateGPIO();
	for (delay = 0; delay < 1000; delay++);
	ET_clk_reset = 0;
	UpdateGPIO();

	/* receive and process packets */
	while (1)
	{
			xemacif_input(echo_netif);
			if (TcpFastTmrFlag)
				{
					//This gets called about every 250ms
					TcpFastTmrFlag = 0;
					elapsed_time++;
					if (elapsed_time & 0x01)  //convert every other time
					{
						u16 val = GetHouseKeeping();
						//Since we read the data from channel n-1 when we write address n, must compensate here
						s8 array_addr = hkadc_channel - 1;
						if (array_addr == -1) array_addr = 15;
						if (val != -1) hkadc_array[array_addr] = val;
						hkadc_channel++;
						if (hkadc_channel == 16) hkadc_channel = 0;
						GetTMP125();
					}
					if ((elapsed_time & 0xf) == 0) //every sixteen ticks, about every 4 sec
					{
						hk_timer++;
						if ((hk_interval != 0) && (hk_timer == hk_interval))
						{
							hk_timer = 0;
							SendHouseKeeping();
						}
					}
				}
			//Check the PH_FIFO if in PH mode and a packet has come in

			if (((acq_mode & 0xf) == ACQ_MODE_PH) && (XLlFifo_iRxOccupancy(&PH_Fifo)))
			{
				//Check the fifo occupancy.  There should be 4*stop_channel words in the FIFO,
				// since each word contains two samples, there are 4 chips, and we get 2 samples per channel
				static u32 ReceiveLength;
				int i;
				u32 RxWord0, RxWord1;
				//GetLen returns num bytes; convert to num u32s
				ReceiveLength = (XLlFifo_iRxGetLen(&PH_Fifo))/4;
				//in PH_MODE, we get the elapsed time, in IM we don't. So one extra word in PH mode
				u32 expected_length =(stop_channel<<2) + 1;
				if ((ReceiveLength>0) && (ReceiveLength != expected_length))
					{
						//Wrong packet length, need to read them out and dump them
						xil_printf("Received %d words, SB %d\n", ReceiveLength, expected_length);
						for ( i=0; i < ReceiveLength; i++)
							RxWord0 = XLlFifo_RxGetWord(&PH_Fifo);
					}
				if (ReceiveLength == expected_length)
				{
					struct pbuf *sci_pbuf;
					sci_pbuf = pbuf_alloc(PBUF_TRANSPORT, SCI_BUF_SIZE, PBUF_RAM);
					if (!sci_pbuf) {
						xil_printf("error allocating pbuf to send\r\n");
						return -1;
					}
					char * sci_payload_ptr = sci_pbuf->payload;
					*(sci_payload_ptr) = acq_mode;
					*(sci_payload_ptr+1) = 0x0;
					*(u16*)(sci_payload_ptr+2) = packet_number++;
					*(u16*)(sci_payload_ptr+4) = board_location;
					*(u16*)(sci_payload_ptr+14) = (u16)ReceiveLength;
					//We'll use this to look up the baseline value, for subtraction
					u16 bl_array_index = 0;
					s16 temp0;
					s16 temp1;
					//as the values come in we'll remap them; use this index into the remap array
					u16 remap_index = 0;
					//There are two u32s per time sample; so ReceiveLength/2 is the number of samples
				for ( i=0; i < (ReceiveLength/2); i++)
				{
					//RxWord0 = 0;
					//RxWord1 = 0;
					//Read two u32s for each sample
					RxWord1 = XLlFifo_RxGetWord(&PH_Fifo);
					RxWord0 = XLlFifo_RxGetWord(&PH_Fifo);
					RxWord1 &= 0x0fff0fff;
					RxWord0 &= 0x0fff0fff;
					//We will skip a number of words at the beginning of the record,
					//  due to the ADC latency

					if (i>=ADC_LATENCY_SKIP_VAL)
					{
						//We will only send every other value, since there are two per channel
						//If ADC_LATENCY_SKIP_VAL is even, we send the even ones, etc
						if ((i - ADC_LATENCY_SKIP_VAL) & 0x01)
						{
#ifdef SUB_BL
							//Turn off BL subtract by setting bit 4 of acq_mode (so acq_mode = 0x11)
							if ((acq_mode & 0x10) == 0)
							{
							temp0 = (RxWord0 & 0xfff) - ph_baseline_array[bl_array_index++];
							if (temp0 < 0) temp0 = 0;
							temp1 = (RxWord0 >> 16) - ph_baseline_array[bl_array_index++];
							if (temp1 < 0) temp1 = 0;
							RxWord0 = temp1<<16 | temp0;

							temp0 = (RxWord1 & 0xfff) - ph_baseline_array[bl_array_index++];
							if (temp0 < 0) temp0 = 0;
							temp1 = (RxWord1 >> 16) - ph_baseline_array[bl_array_index++];
							if (temp1 < 0) temp1 = 0;
							RxWord1 = temp1<<16 | temp0;
							}
#endif

#ifndef PH_REMAP

								memcpy(sci_payload_ptr + 16 + 4*((i - ADC_LATENCY_SKIP_VAL) & 0xffe), (u8*)&RxWord0,4);
								memcpy(sci_payload_ptr + 20 + 4*((i - ADC_LATENCY_SKIP_VAL) & 0xffe), (u8*)&RxWord1,4);
							}
#else

							//Each sample point has 4 12b values, 8 bytes.  We'll load them up with 8 single-byte transfers
							*(sci_payload_ptr + 16 + 2*(remap_array[remap_index])) = RxWord0;
							*(sci_payload_ptr + 17 + 2*(remap_array[remap_index++])) = RxWord0>>8;
							*(sci_payload_ptr + 16 + 2*(remap_array[remap_index])) = RxWord0>>16;
							*(sci_payload_ptr + 17 + 2*(remap_array[remap_index++])) = RxWord0>>24;
							*(sci_payload_ptr + 16 + 2*(remap_array[remap_index])) = RxWord1;
							*(sci_payload_ptr + 17 + 2*(remap_array[remap_index++])) = RxWord1>>8;
							*(sci_payload_ptr + 16 + 2*(remap_array[remap_index])) = RxWord1>>16;
							*(sci_payload_ptr + 17 + 2*(remap_array[remap_index++])) = RxWord1>>24;
						}

#endif
						}
					}
				//Last one is ET
				RxWord0 = XLlFifo_RxGetWord(&PH_Fifo);
				memcpy(sci_payload_ptr + 10, (u8*)&RxWord0,4);
				err_t err = udp_send(sci_pcb, sci_pbuf);
				if (err != ERR_OK) {
					xil_printf("Error on command udp_send: %d\r\n", err);
					pbuf_free(sci_pbuf);
					return -2;
				}
				pbuf_free(sci_pbuf);

			}
			}
			else if ((acq_mode & 0xf) == ACQ_MODE_IM)
				{
					if (XLlFifo_iRxOccupancy(&IM_Fifo))
					{
					//Check the fifo occupancy.  There should be 256 words in the FIFO,
					static u32 ReceiveLength;
					int i;
					u32 RxWord0;
					//GetLen returns num bytes; convert to num u32s
					ReceiveLength = (XLlFifo_iRxGetLen(&IM_Fifo))/4;
					if ((ReceiveLength>0) && (ReceiveLength != 256)) {
					//Wrong packet length, need to read them out and dump them
					xil_printf("Received %d words, SB 256\n", ReceiveLength);
						for ( i=0; i < ReceiveLength; i++)
							RxWord0 = XLlFifo_RxGetWord(&IM_Fifo);
						}
					if (ReceiveLength == 256)
					{
						struct pbuf *sci_pbuf;
						sci_pbuf = pbuf_alloc(PBUF_TRANSPORT, SCI_BUF_SIZE, PBUF_RAM);
						if (!sci_pbuf) {
							xil_printf("error allocating pbuf to send\r\n");
							return -1;
						}
						char * sci_payload_ptr = sci_pbuf->payload;
						*(sci_payload_ptr) = acq_mode;
						*(sci_payload_ptr+1) = 0x0;
						*(u16*)(sci_payload_ptr+2) = packet_number++;
						*(u16*)(sci_payload_ptr+4) = board_location;
						*(u16*)(sci_payload_ptr+14) = (u16)ReceiveLength;
						//There's one 24b value, padded to 32b, per channel
						//Seems like there's an extra word... dump it
						//RxWord0 = XLlFifo_RxGetWord(&IM_Fifo);
					for ( i=0; i < ReceiveLength; i++)
					{
						RxWord0 = 0;
						RxWord0 = XLlFifo_RxGetWord(&IM_Fifo);
						//Each 32b word holds a 24b value.  But we only have 16b allocated
						u16 trig_value = RxWord0>>IM_TRUNC_FACTOR;
						memcpy(sci_payload_ptr + 16 + 2*i, (u8*)(&trig_value),2);
						}


						err_t err = udp_send(sci_pcb, sci_pbuf);
						if (err != ERR_OK) {
							xil_printf("Error on command udp_send: %d\r\n", err);
							pbuf_free(sci_pbuf);
							return -2;
							}
						pbuf_free(sci_pbuf);

				}

			}
		}
	}

	/* never reached */
	cleanup_platform();

	return 0;
}


void
recv_callback(void *arg, struct udp_pcb *tpcb,
                               struct pbuf *p, struct ip4_addr *addr, u16_t port)
{
		xil_printf("Got one, packet number %d\n\r", recvd_pkt_number);
		//MicroBlaze is Little-Endian
		recvd_pkt_number++;
		//A byte pointer to the payload
		u8 * bptr;
		bptr = (u8 *) (p->payload);
		//Number of bytes in the payload
		u16 cmd_len = (u16)(p->len);
		//Copy the payload to a new array to guarantee that it starts on a u8, u16, u32 boundary
		u32* newptr;
		newptr = (u32*)malloc((size_t) cmd_len);
		memcpy(newptr, bptr, cmd_len);
		//Reserve an array to store the data read back from the MAROCs
		u32 readback[104];

		//The first byte determines what kind of command
		u8 byte0 = *(bptr);
		if ((byte0 & 0x7f) == 0x01)   //Load Marocs
		{
			//Recast the byte pointer to a u32 pointer for each of the chip data.  Set mask to 1111 to write all chips
			//Set_MAROC_registers(0x0f, (u32*)(bptr+4), (u32*)(bptr+132), (u32*)(bptr+260), (u32*)(bptr+388), readback);
			Set_MAROC_registers(0x0f, newptr+1, newptr+33, newptr+65, newptr+97, readback);
#ifdef VERBOSE
		int i;
		for (i = 0; i<104; i++) xil_printf("%x\n",readback[i]);
#endif
		}

		if ((byte0 & 0x7f) == 0x02)   //Set HVs
		{
			Set_HV((u16*)(bptr+2));
		}
		if ((byte0 & 0x7f) == 0x03)   //Set Acquisition mode and interval
		{
			Set_Acquisition((u16*)(bptr+2));
		}
		if ((byte0 & 0x7f) == 0x04)   //System resets
		{
			//not using argument at this point
			ResetSys( *(u16*)(bptr+2));
		}
		if ((byte0 & 0x7f) == 0x05)   //
		{
			//SetStepper( (u16*)(bptr+2));
			SetStepper((s16)*((u16*)(bptr+4)));
			shutter_power = (*(bptr+6) & 0x01);
			shutter_open = ((*(bptr+6) & 0x02) == 0x02);
			focus_limits_on = ((*(bptr+6) & 0x04) == 0x04);
			fan_speed = (*(bptr+8) & 0x0f);
			//OK to write the GPIO again even if the stepper is in motion
			XGpio_DiscreteWrite(&Gpio_mech, GPIO_OUT_CHAN, (focus_limits_on <<23) | (shutter_power<<22) | (shutter_open<<21) | (fan_speed<<17));
		}
		if ((byte0 & 0x7f) == 0x06)   //Channel Mask
		{
			SetChannelMask(bptr+4);
		}
		if (byte0 == 0x07)   //BL adjust
		{
			Status = PH_BL_Init(ph_baseline_array);
			if (Status != 0) xil_printf("BaseLine Cal Failed\n");
		}

		if ((byte0 & 0x80) == 0x80)  //Echo the packet
		{
			//struct pbuf *hk_pbuf;
			hk_pbuf = pbuf_alloc(PBUF_TRANSPORT, cmd_len, PBUF_RAM);
			if (!hk_pbuf) {
				xil_printf("error allocating pbuf to send\r\n");
				return;
			}
			else if ((byte0 & 0x7f) == 0x01)
			{
				//The Set Marocs command; we want to send back the data read from the chips
				//The 32b words come back interleaved ASIC0[0], ASIC1[0], ASIC2[0], ASIC3[0], ASIC0[0], ...
				//We will de-interleave them so they match the data sent out
				//First, copy the first 4B of the command
				char * hk_payload_ptr = hk_pbuf->payload;
				memcpy(hk_payload_ptr, (char*)bptr, 4);
				//Then, copy one word from each ASIC to its proper place
				int i;
				for (i = 0; i < 26; i++)
					{
					memcpy(hk_payload_ptr + 4 + 4*i, readback+4*i,4);
					memcpy(hk_payload_ptr + 132 + 4*i, readback+4*i+1,4);
					memcpy(hk_payload_ptr + 260 + 4*i, readback+4*i+2,4);
					memcpy(hk_payload_ptr + 388 + 4*i, readback+4*i+3,4);
					}

			}
			else
			{
				//Copy the command payload
				char * hk_payload_ptr = hk_pbuf->payload;
				memcpy(hk_payload_ptr, (char*)bptr, cmd_len);
			}
			err_t err = udp_send(cmd_pcb, hk_pbuf);
			if (err != ERR_OK) {
				xil_printf("Error on command udp_send: %d\r\n", err);
				pbuf_free(hk_pbuf);
				return;
			}
			pbuf_free(hk_pbuf);
		}

		if (byte0 == 0x20)  //Get housekeeping data
		{
			hk_interval = *(bptr+1);
			hk_timer = 0;
			SendHouseKeeping();
		}
		free(newptr);
		pbuf_free(p);
		return;
}
void
print_ip(char *msg, struct ip4_addr *ip)
{
	print(msg);
	xil_printf("%d.%d.%d.%d\n\r", ip4_addr1(ip), ip4_addr2(ip),
			ip4_addr3(ip), ip4_addr4(ip));
}
void
print_ip_settings(struct ip4_addr *ip, struct ip4_addr *mask, struct ip4_addr *gw)
{

	print_ip("Board IP: ", ip);
	print_ip("Netmask : ", mask);
	print_ip("Gateway : ", gw);
}

//Write the 829-bit serial setup data to the MAROC chip(s).  Read back the data and fill the out_ptr array
//Bits 3:0 of chip_mask indicate which chip(s) to write- a 1 in each position writes that chip
//All chips are written in parallel, so must supply data for all four even if some are masked
// (that data will be unused for the masked chips)
//Data read back will be put in a u32 array and needs to be de-interleaved at a higher level
void Set_MAROC_registers(u8 chip_mask, u32* chip0, u32* chip1, u32* chip2, u32* chip3, u32* out_ptr)
{
	/*
	 * The interface to the IP block:
	wire [31:0] par_data_in = slv_reg0;
	wire SC_reset = slv_reg2[0];
	wire maroc_reset = slv_reg2[1];
	wire wr_par_data = slv_reg2[2];
	wire rd_par_data = slv_reg2[3];
	wire [3:0] chan_enable = slv_reg2[7:4];
	wire SC_go = slv_reg2[8];
	and slv_reg1 is the par_data_out
	 *
	 */
#define MAROC_SC_GO_PW 10
#define MAROC_SC_WAIT_TIL_DONE 1000000
	volatile u32 delay;
	//Reset the logic
	u32 val2write;
	Xil_Out32(MAROC_SC + 8, 0x01);
	Xil_Out32(MAROC_SC + 8, 0x0);
	//We need to interleave the data on a u32 basis: chip0, chip1, chip2, chip3, chip0, ..., 104 u32s for each
	int ii;
	for (ii = 0; ii < 104; ii++)
	{
		val2write = *chip0;
		Xil_Out32(MAROC_SC, *chip0++);
		//Pulse the wr_par_data line
		Xil_Out32(MAROC_SC + 8, 0x04);
		Xil_Out32(MAROC_SC + 8, 0x0);
		Xil_Out32(MAROC_SC, *chip1++);
		Xil_Out32(MAROC_SC + 8, 0x04);
		Xil_Out32(MAROC_SC + 8, 0x0);
		Xil_Out32(MAROC_SC, *chip2++);
		Xil_Out32(MAROC_SC + 8, 0x04);
		Xil_Out32(MAROC_SC + 8, 0x0);
		Xil_Out32(MAROC_SC, *chip3++);
		Xil_Out32(MAROC_SC + 8, 0x04);
		Xil_Out32(MAROC_SC + 8, 0x0);
	}
	//Now the data should be all loaded up; pulse the Reset_SC to the MAROCs bit
	/*
	val2write = (chip_mask<<4) | 0x02;
	Xil_Out32(MAROC_SC + 8, val2write);
	for (delay = 0; delay < MAROC_SC_GO_PW; delay++);
	val2write = chip_mask<< 4;
	Xil_Out32(MAROC_SC + 8, val2write);
	*/
	//And pulse the GO bit
	Xil_Out32(MAROC_SC + 8, (chip_mask<< 4) | 0x100);
	for (delay = 0; delay < MAROC_SC_GO_PW; delay++);
	Xil_Out32(MAROC_SC + 8, (chip_mask<< 4));
	//Now wait here til done, so we don't clobber the bitstream with another write or something
	for (delay = 0; delay < MAROC_SC_WAIT_TIL_DONE; delay++);
	//Now read back that data that came out of the MAROCs, should be in the FIFO
	//The first four words are junk
	for (ii = 0; ii < 108; ii++)
	{
		//pulse the rd_par_data line
		Xil_Out32(MAROC_SC + 8, 0x08);
		Xil_Out32(MAROC_SC + 8, 0x0);
		//Store the data
		if (ii>=4) *out_ptr++ = Xil_In32(MAROC_SC + 4);
	}

	return;
}

//Set the high voltage- takes a pointer to four 16-bit values
void Set_HV(u16* data_ptr)
{
	//Enable HV
	hv_rstb = 1;
	UpdateGPIO();
	//The AD5686 DAC takes a 24b input word {C[3:0], A[3:0], D[15:0]}:
	//C = 4'b0011 for "write DAC and update output
	//A = one-hot address, = 1, 2, 4, 8
	//D = data
	XSpi_Abort(&Spi);
	//Data stable on falling edge for AD5686
	XSpi_SetOptions(&Spi, XSP_MASTER_OPTION | XSP_MANUAL_SSELECT_OPTION | XSP_CLK_ACTIVE_LOW_OPTION);
	//u8 SendBuf[3];
	u8 ii;
	//volatile u32 delay;
	u16 value;
	for (ii = 0; ii < 4; ii++)
	{
		value = *(data_ptr + ii);
		HV_settings[ii] = value;

		SPI_chan_mask = HV_DAC_SPI_MASK;
		//Data to write to the device
		SPI_TxBuf[0] = 0x30 | (1<<ii);
		SPI_TxBuf[1] = (u8)(value >> 8);
		SPI_TxBuf[2] = value & 0xff;
		SPI_bytes_to_send = 3;
		//This will be cleared in the interrupt routine
		SPI_flag = 1;
		//This arms the interrupt logic
		wr_int_arm = 1;
		spi_sel = 0;
		UpdateGPIO();
		//wait for it to be cleared
		while (SPI_flag);

		/*SendBuf[0] = 0x30 | (1<<ii);
		SendBuf[1] = (u8)(value >> 8);
		SendBuf[2] = value & 0xff;

		XSpi_SetSlaveSelect(&Spi, HV_DAC_SPI_MASK);
		XSpi_Transfer(&Spi, SendBuf, NULL, 3);
		XSpi_SetSlaveSelect(&Spi, 0xff);
		//TODO- figure out how to check when Spi is ready rather than just waiting
		for (delay = 0; delay < 300; delay++);
		*/
	}


}

//Set the acquisition mode, stim parameters, etc
/*The maroc_dc interface:
wire inhibit_PH_write = slave_reg8[16];
wire sw_trig = slave_reg8[15];
wire [3:0] adc_clk_phase_sel =  slave_reg8[14:11];
wire [1:0] acqmode = slave_reg8[10:9]; //00 for none, 01 for PH, 10 for IM
wire [264:0] trigger_mask = {slave_reg8[8:0],
                            slave_reg7,
                            slave_reg6,
                            slave_reg5,
                            slave_reg4,
                            slave_reg3,
                            slave_reg2,
                            slave_reg1,
                            slave_reg0};
wire [7:0] frame_interval = slave_reg9[7:0];
wire [7:0] hold1_delay = slave_reg9[15:8];
wire [7:0] hold2_delay = slave_reg9[23:16];
wire [7:0] ph_stop_chan = slave_reg9[30:24];
wire counter_reset = slave_reg9[31];
 */
void Set_Acquisition(u16* dataptr)
{
	volatile u32 delay;
	//Get the value of slv_reg8- we need to preserve the mask bits
	u32 regval = Xil_In32(MAROC_DC + 32) & 0x1ff;

	acq_mode = *dataptr++ & 0xff;
	u8 acq_int = *dataptr++ & 0xff;
	u8 hold1 = *dataptr++ & 0xf;
	u8 hold2 = *dataptr++ & 0xf;
#ifdef HW_GTV08
	u8 adcclkph = *dataptr++ & 0xf;
#else
	u8 adcclkph = *dataptr++ & 0x7;
#endif
#ifdef ADCCLKPHASE
	adcclkph = ADCCLKPHASE;
#endif
	stop_channel = *dataptr++ & 0xff;
	if (stop_channel>MAX_STOP_CHANNEL)stop_channel = MAX_STOP_CHANNEL;
	stim_on = *dataptr++ & 0xff;
	stim_level = *dataptr++ & 0xff;
	stim_rate = *dataptr++ & 0x7;

	dataptr++;
	flash_rate = *dataptr++ & 0x7;
	flash_level = *dataptr++ & 0x1f;
	flash_width = *dataptr++ & 0xf;

	UpdateGPIO();
	regval = acq_int | (hold1<<8) | (hold2<<16) | (stop_channel<<24);
	Xil_Out32(MAROC_DC + 36, regval);
#ifdef HW_GTV08
	//regval = regval | ((acq_mode & 0x3)<<9) | (adcclkph<<11) | ((acq_mode & 0x80)<<9);
	regval = ((acq_mode & 0x3)<<9) | (adcclkph<<11) | ((acq_mode & 0x80)<<9);
#else
	regval = regval | ((acq_mode & 0x3)<<9) | (adcclkph<<11) | ((acq_mode & 0x80)<<8);
#endif
	//Set acq_mode to zero
	Xil_Out32(MAROC_DC + 32, regval & 0xfffff9ff);
	//Wait for any acquisition to end
	for (delay = 0; delay < 1000; delay++);
	//Reset the FIFO
	if (acq_mode == ACQ_MODE_PH)XLlFifo_RxReset(&PH_Fifo);
	else XLlFifo_RxReset(&IM_Fifo);
	//Wait for reset to complete
	for (delay = 0; delay < 1000; delay++);
	//Set acq_mode
	Xil_Out32(MAROC_DC + 32, regval);
	//Pulse the sw_trig if acquisition is disabled
	if (acq_mode == 0)
	{
		regval = Xil_In32(MAROC_DC + 32);
		regval |=0x8000;
		Xil_Out32(MAROC_DC + 32, regval);
		regval &= ~0x8000;
		Xil_Out32(MAROC_DC + 32, regval);
	}
}

//Reset the system
void ResetSys(u16 reset_mask)
{
	volatile u32 delay;
	//Pulse the MAROC_SC reset- first read reg2
	u32 regval = Xil_In32(MAROC_SC + 8);
	//Assert the maroc_SC_RST line
	Xil_Out32(MAROC_SC + 8, regval | 0x02);
	//Wait a bit- don't know maroc min pw
	for (delay = 0; delay < 100; delay++);
	//De-assert the maroc_SC line and assert the maroc_slow_control module reset
	Xil_Out32(MAROC_SC + 8, (regval & 0xfffffffd) | 0x01);
	//Restore previous value
	Xil_Out32(MAROC_SC + 8, regval);
	//Pulse the MAROC_DC reset- first read reg9
	regval = Xil_In32(MAROC_DC + 36);
	//Assert the maroc_DC module reset
	Xil_Out32(MAROC_DC + 36, regval | 0x80000000);
	//Restore previous value
	Xil_Out32(MAROC_DC + 36, regval);
}

//Set stepper motor
void SetStepper(s16 steps)
{
	if (steps == 0) return;
	//Write the step value to the LS 16 bits
	XGpio_DiscreteWrite(&Gpio_mech, GPIO_OUT_CHAN,  (focus_limits_on <<23) | steps);
	//Then pulse bit 16
	XGpio_DiscreteWrite(&Gpio_mech, GPIO_OUT_CHAN,  (focus_limits_on <<23) | steps | 0x10000);
	XGpio_DiscreteWrite(&Gpio_mech, GPIO_OUT_CHAN,  (focus_limits_on <<23) | steps);
}

//Set channel Mask- a 1 in any bit position masks that channel
void SetChannelMask(u8* data_ptr)
{
	int i;
	u32 val;
	for (i = 0; i<8;i++)
		{
			memcpy(&val, data_ptr,4);
			Xil_Out32(MAROC_DC + (i<<2),val);
			data_ptr+=4;
		}
	u32 regval = Xil_In32(MAROC_DC + 32);
	Xil_Out32(MAROC_DC + 32, (regval & 0xfffffe00) | ((*data_ptr) & 0x1ff));
}

//Read the HK ADC, and values from temp sensor, etc.  Put results in u16 array
int GetHouseKeeping(void)
{
	//Check the status of the SPI interface, return if it's in the process of transmitting
	if ((XSpi_ReadReg(&Spi, XSP_SR_OFFSET) & XSP_SR_TX_EMPTY_MASK) != 0) return -1;
	//Get the data from the Housekeeping ADC, LTC2496
	XSpi_Abort(&Spi);
	(void) XSpi_GetStatusReg(&Spi);
	//Data stable on rising edge for LTC2496
	XSpi_SetOptions(&Spi, XSP_MASTER_OPTION | XSP_MANUAL_SSELECT_OPTION);

	SPI_chan_mask = HKADC_SPI_MASK;
	//Need to rotate addr right, and put LSbit in MSbit due to funny mapping of ADC
	u8 adc_addr = ((hkadc_channel & 0x01)<<3) | (hkadc_channel>>1);
	//Data to write to the device
	SPI_TxBuf[0] = 0xb0 | adc_addr;
	SPI_TxBuf[1] = 0;
	SPI_TxBuf[2] = 0;
	SPI_bytes_to_send = 3;
	//This will be cleared in the interrupt routine
	SPI_flag = 1;
	//This arms the interrupt logic
	wr_int_arm = 1;
	//wr
	spi_sel = 0;
	UpdateGPIO();
	//wait for it to be cleared
	while (SPI_flag);
	//Check for out of range:
	if ((SPI_RxBuf[0] & 0x30) == 0x30) return 0xffff;
	if ((SPI_RxBuf[0] & 0x20) == 0) return 0;
	//Return a 16-bit result
	return ((SPI_RxBuf[0] & 0xf)<<12) + (SPI_RxBuf[1]<<4) + (SPI_RxBuf[2]>>4);

	/*
	u8 SendBuf[3] = {0,0,0};
	u8 RxBuf[3] = {2,2,2};
	volatile u32 delay;
	//Need to rotate addr right, and put LSbit in MSbit due to funny mapping of ADC
	u8 adc_addr = ((hkadc_channel & 0x01)<<3) | (hkadc_channel>>1);
	//Set bits 7:5 = 101, bit 4 = 1 (for single-ended)
	SendBuf[0] = 0xb0 | adc_addr;
	XSpi_SetSlaveSelect(&Spi, HKADC_SPI_MASK);
	Status = XSpi_Transfer(&Spi, SendBuf, RxBuf, 3);
	//TODO- figure out how to check when Spi is ready rather than just waiting
	for (delay = 0; delay < 30000; delay++);
	XSpi_SetSlaveSelect(&Spi, 0xff);
	//Check for out of range:
	if ((RxBuf[0] & 0x30) == 0x30) return 0xffff;
	if ((RxBuf[0] & 0x20) == 0) return 0;
	//Return a 16-bit result
	return ((RxBuf[0] & 0xf)<<12) + (RxBuf[1]<<4) + (RxBuf[2]>>4);
	*/
}

//Update the GPIO that controls the stim, hv_enable, etc
void UpdateGPIO(void)
{
	XGpio_DiscreteWrite(&Gpio, GPIO_OUT_CHAN, ((ET_clk_reset<<28) | (flash_width<<24) | (flash_level<<19) | (flash_rate<<16) |
			(wr_int_arm<<15)|(spi_sel<<14)|(stim_rate<<10) | (stim_level<<2) | (stim_on<<1) | hv_rstb ));
}

void GetTMP125(void)
{
	//Data stable on rising edge for LTC2496
	XSpi_SetOptions(&Spi, XSP_MASTER_OPTION | XSP_MANUAL_SSELECT_OPTION);

	SPI_chan_mask = TMP125_SPI_MASK;
	//Data to write to the device
	SPI_TxBuf[0] = 0;
	SPI_TxBuf[1] = 0;
	SPI_bytes_to_send = 2;
	//This will be cleared in the interrupt routine
	SPI_flag = 1;
	//This arms the interrupt logic
	wr_int_arm = 1;
	spi_sel = 0;
	UpdateGPIO();
	//wait for it to be cleared
	while (SPI_flag);
	tmp125_val = (SPI_RxBuf[1]>>5) + (SPI_RxBuf[0]<<3);

	/*
	u8 SendBuf[2] = {0,0};
	u8 RxBuf[2] = {0,0};
	volatile u32 delay;
	XSpi_SetSlaveSelect(&Spi, TMP125_SPI_MASK);
	Status = XSpi_Transfer(&Spi, SendBuf, RxBuf, 2);
	//TODO- figure out how to check when Spi is ready rather than just waiting
	for (delay = 0; delay < 30000; delay++);
	XSpi_SetSlaveSelect(&Spi, 0xff);
	tmp125_val = (RxBuf[1]>>5) + (RxBuf[0]<<3);
	return;
	*/
}

//Send the housekeeping data
void SendHouseKeeping(void)
{
#ifdef GOLD_COPY
	return;
#endif
//Allocate a pbuf
//struct pbuf *hk_pbuf;
hk_pbuf = pbuf_alloc(PBUF_TRANSPORT, 64, PBUF_RAM);
if (!hk_pbuf) {
	xil_printf("error allocating pbuf to send\r\n");
	return;
}
else
{
	//A pointer to the pbuf's payload
	char * hk_payload_ptr = hk_pbuf->payload;
	//Put the proper response code in the first two bytes
	*hk_payload_ptr++ = 0x20;
	*hk_payload_ptr++ = first_hk_pkt;
	first_hk_pkt = 0;
	*hk_payload_ptr++ = board_location & 0xff;
	*hk_payload_ptr++ = board_location>>8;
	//Copy the data from the ADC array
	memcpy(hk_payload_ptr, (char*)hkadc_array, 32);
	memcpy(hk_payload_ptr+32, &tmp125_val, 2);
	u16 value = XSysMon_GetAdcData(&SysMonInst, XSM_CH_TEMP);
	memcpy(hk_payload_ptr+34, &value,2);
	value = XSysMon_GetAdcData(&SysMonInst, XSM_CH_VCCINT);
	memcpy(hk_payload_ptr+36, &value,2);
	value = XSysMon_GetAdcData(&SysMonInst, XSM_CH_VCCAUX);
	memcpy(hk_payload_ptr+38, &value,2);
}
err_t err = udp_send(hk_pcb, hk_pbuf);
if (err != ERR_OK) {
	xil_printf("Error on command udp_send: %d\r\n", err);
	pbuf_free(hk_pbuf);
	return;
}
pbuf_free(hk_pbuf);
return;
}

//Set one of the DACs that control the White Rabbit VCOs
//which_dac = 0 for DAC1 (the main WR TCVCXO), 1 for DAC2 (the other one)
void Set_WRDAC(u8 which_dac, u16 value)
{
	XSpi_Abort(&Spi);
	//Data stable on falling edge for AD5662
	XSpi_SetOptions(&Spi, XSP_MASTER_OPTION | XSP_MANUAL_SSELECT_OPTION | XSP_CLK_ACTIVE_LOW_OPTION);
	u8 SendBuf[3];
	volatile u32 delay;
	SendBuf[0] = 0;
	SendBuf[1] = (u8)(value>>8);
	SendBuf[2] = (u8)(value & 0xff);
	XSpi_SetSlaveSelect(&Spi, which_dac ? VCO2_DAC_SPI_MASK: VCO1_DAC_SPI_MASK);
	XSpi_Transfer(&Spi, SendBuf, NULL, 3);
	XSpi_SetSlaveSelect(&Spi, 0xff);
		//TODO- figure out how to check when Spi is ready rather than just waiting
	for (delay = 0; delay < 300; delay++);

}

void SetupLTC2170(void)
{
	//Need to send the following values to the chip after power up
	//We'll recast these as u8s, so put the data in the MSB, the address in the LSB
	//The u8 cast will send the address out first, as it should be
	u16 regvals [5] = {0x8000, 	//software reset
				   0x001,			//power up
				   0x602,			//1-lane, 12-bit
				   0x003,			//testpattern off
				   0x004};		//testpattern off
	XSpi_Abort(&Spi);
	//Data stable on rising edge LTC2170
	XSpi_SetOptions(&Spi, XSP_MASTER_OPTION | XSP_MANUAL_SSELECT_OPTION);

	int i;
	for (i=0; i<5; i++)
	{
		SPI_chan_mask = DAQADC_SPI_MASK;
		//Data to write to the device
		SPI_TxBuf[0] = regvals[i] & 0xff;
		SPI_TxBuf[1] = regvals[i] >>8;
		SPI_bytes_to_send = 2;
		//This will be cleared in the interrupt routine
		SPI_flag = 1;
		//This arms the interrupt logic
		wr_int_arm = 1;
		spi_sel = 0;
		UpdateGPIO();
		//wait for it to be cleared
		while (SPI_flag);
		/*
		XSpi_SetSlaveSelect(&Spi, DAQADC_SPI_MASK);
		XSpi_Transfer(&Spi, (u8*)(regvals+i), NULL, 2);
		XSpi_SetSlaveSelect(&Spi, 0xff);
		*/
	}
}

//Initialize the ph_baseline array
int PH_BL_Init(u16 * ph_baseline_array)
{
	volatile int delay;
	u16 ReceiveLength;
	u16 i;
	u32 RxWord0;
	u32 RxWord1;
	//We need to turn off the stim generator. Store old value so we can restore
	//Also turn off the HV by asserting hv_rstb
	u8 old_stim_on = stim_on;
	hv_rstb=0;
	stim_on = 0;
	UpdateGPIO();
	//Wait for HV to decay
	waitabit(6);
	//We want to set the acq_mode temporarily to PH, then pulse the sw_trig bit
	//It would be good to mask all triggers before doing this (other than sw_trig)- should put a "mask_all" bit in hardware
	//Get the value of slv_reg8 & 9- we need to preserve the mask bits
	u32 reg8val = Xil_In32(MAROC_DC + 32);
	u32 reg9val = Xil_In32(MAROC_DC + 36);
	//Initialize the bl_array to zero; we'll add up a bunch and get an average
	for (i=0;i<256;i++) ph_baseline_array[i] = 0;

	//Iterate 9 times and throw away the first one (because it was
	//  hanging around in the CC FIFO) to get an average of 8
	u8 loopcount;
	for (loopcount = 0; loopcount < 9; loopcount++)
	{
	Xil_Out32(MAROC_DC + 32, (reg8val & 0xfffff9ff) | 0x200); //set acq_mode to 01
	//Set stop channel to max
	Xil_Out32(MAROC_DC + 36, (reg9val & 0x80ffffff) | (MAX_STOP_CHANNEL<<24));
	//Clear the PH_Fifo and wait for it to be empty
	//XLlFifo_RxReset(&PH_Fifo);
	while (!XLlFifo_IsRxEmpty(&PH_Fifo))XLlFifo_RxReset(&PH_Fifo);
	//Pulse the sw_trig
	Xil_Out32(MAROC_DC + 32, (reg8val & 0xfffff9ff) | 0x8200);
	Xil_Out32(MAROC_DC + 32, (reg8val & 0xffff79ff) | 0x200);
	//Wait for FIFO to fill
	for (delay = 0; delay < 10000; delay++);
	//We'll average 8 baselines
	//GetLen returns num bytes; convert to num u32s
	ReceiveLength = (XLlFifo_iRxGetLen(&PH_Fifo))/4;
	if (ReceiveLength == 0)
		{
			xil_printf("no data returned in BL routine");
			return -1;
		}
	u32 expected_length =(MAX_STOP_CHANNEL<<2) + 1;
	if ((ReceiveLength>0) && (ReceiveLength != expected_length))
		{
			//Wrong packet length, need to read them out and dump them
			xil_printf("Received %d words in BL routine, SB %d\n", ReceiveLength, expected_length);
			for (i=0; i< ReceiveLength; i++)
				RxWord0 = XLlFifo_RxGetWord(&PH_Fifo);
			return -1;
		}

	u16 bl_array_index=0;
	//There are two u32s per time sample; so ReceiveLength/2 is the number of samples
	for (i=0; i < (ReceiveLength/2); i++)
		{
			//Read two u32s for each sample
			RxWord1 = XLlFifo_RxGetWord(&PH_Fifo) & 0x0fff0fff;
			RxWord0 = XLlFifo_RxGetWord(&PH_Fifo) & 0x0fff0fff;
			//We will skip a number of words at the beginning of the record,
			//  due to the ADC latency
	//Set this so that the values sent out don't go to 0
	#define RESIDUAL_BL 10
			if ((i>=ADC_LATENCY_SKIP_VAL) && (loopcount > 0))
			//We will only send every other value, since there are two per channel
			//If ADC_LATENCY_SKIP_VAL is even, we send the even ones, etc
			if ((i - ADC_LATENCY_SKIP_VAL) & 0x01)
			{
				ph_baseline_array[bl_array_index++] += (RxWord0 & 0xfff) - RESIDUAL_BL;
				ph_baseline_array[bl_array_index++] += (RxWord0>>16)  - RESIDUAL_BL;
				ph_baseline_array[bl_array_index++] += (RxWord1 & 0xfff) - RESIDUAL_BL;
				ph_baseline_array[bl_array_index++] += (RxWord1>>16)  - RESIDUAL_BL;
			}
			//Protect against a too-long ReceiveLength writing data outside the array
			if (bl_array_index>255)break;
		}
	//read and ignore one more (Elapsed Time)
	RxWord1 = XLlFifo_RxGetWord(&PH_Fifo);
	}

	for (i = 0; i<256; i++) ph_baseline_array[i] = ph_baseline_array[i]>>3;
#ifdef VERBOSE
	for (i = 0; i<64; i++)
	{
		for (delay = 0; delay < 4; delay++)
			xil_printf("%d ",ph_baseline_array[4*i+delay]);
		xil_printf("\n");
	}
#endif
	//Restore previous values
	Xil_Out32(MAROC_DC + 32, (reg8val));
	Xil_Out32(MAROC_DC + 36, (reg9val));
	stim_on = old_stim_on;
	//hv_rstb = 1;
	//UpdateGPIO();
	Set_HV(HV_settings);

	//Clear the PH_Fifo and wait for it to be empty
	//XLlFifo_RxReset(&PH_Fifo);
	while (!XLlFifo_IsRxEmpty(&PH_Fifo))XLlFifo_RxReset(&PH_Fifo);


	//Now send back the bl_array data
	hk_pbuf = pbuf_alloc(PBUF_TRANSPORT, 516, PBUF_RAM);
	if (!hk_pbuf) {
		xil_printf("error allocating pbuf to send\r\n");
		return -1;
	}
	{

		//Copy the command payload
		char * hk_payload_ptr = hk_pbuf->payload;
		*hk_payload_ptr = 0x07;
		memcpy(hk_payload_ptr+4, (char*)ph_baseline_array, 512);
	}
	err_t err = udp_send(cmd_pcb, hk_pbuf);
	if (err != ERR_OK) {
		xil_printf("Error on command udp_send: %d\r\n", err);
		pbuf_free(hk_pbuf);
		return -1;
	}
	pbuf_free(hk_pbuf);



	return 0;
}

#ifdef PH_REMAP
void InitRemap(u16* remap_array)
{
	//There is no doubt a more code-compact way to do this- this approach takes 4088B to set the 256 2B values required
	remap_array[0]=24;
	remap_array[1]=96;
	remap_array[2]=240;
	remap_array[3]=255;
	remap_array[4]=8;
	remap_array[5]=112;
	remap_array[6]=241;
	remap_array[7]=254;
	remap_array[8]=9;
	remap_array[9]=113;
	remap_array[10]=225;
	remap_array[11]=238;
	remap_array[12]=25;
	remap_array[13]=97;
	remap_array[14]=224;
	remap_array[15]=239;
	remap_array[16]=26;
	remap_array[17]=98;
	remap_array[18]=208;
	remap_array[19]=223;
	remap_array[20]=10;
	remap_array[21]=114;
	remap_array[22]=209;
	remap_array[23]=222;
	remap_array[24]=11;
	remap_array[25]=115;
	remap_array[26]=193;
	remap_array[27]=206;
	remap_array[28]=27;
	remap_array[29]=99;
	remap_array[30]=192;
	remap_array[31]=207;
	remap_array[32]=28;
	remap_array[33]=100;
	remap_array[34]=176;
	remap_array[35]=191;
	remap_array[36]=12;
	remap_array[37]=116;
	remap_array[38]=177;
	remap_array[39]=190;
	remap_array[40]=13;
	remap_array[41]=117;
	remap_array[42]=161;
	remap_array[43]=174;
	remap_array[44]=29;
	remap_array[45]=101;
	remap_array[46]=160;
	remap_array[47]=175;
	remap_array[48]=30;
	remap_array[49]=102;
	remap_array[50]=144;
	remap_array[51]=159;
	remap_array[52]=14;
	remap_array[53]=118;
	remap_array[54]=145;
	remap_array[55]=158;
	remap_array[56]=15;
	remap_array[57]=119;
	remap_array[58]=129;
	remap_array[59]=142;
	remap_array[60]=31;
	remap_array[61]=103;
	remap_array[62]=128;
	remap_array[63]=143;
	remap_array[64]=40;
	remap_array[65]=80;
	remap_array[66]=243;
	remap_array[67]=252;
	remap_array[68]=56;
	remap_array[69]=64;
	remap_array[70]=242;
	remap_array[71]=253;
	remap_array[72]=57;
	remap_array[73]=65;
	remap_array[74]=226;
	remap_array[75]=237;
	remap_array[76]=41;
	remap_array[77]=81;
	remap_array[78]=227;
	remap_array[79]=236;
	remap_array[80]=42;
	remap_array[81]=82;
	remap_array[82]=211;
	remap_array[83]=220;
	remap_array[84]=58;
	remap_array[85]=66;
	remap_array[86]=210;
	remap_array[87]=221;
	remap_array[88]=59;
	remap_array[89]=67;
	remap_array[90]=194;
	remap_array[91]=205;
	remap_array[92]=43;
	remap_array[93]=83;
	remap_array[94]=195;
	remap_array[95]=204;
	remap_array[96]=44;
	remap_array[97]=84;
	remap_array[98]=179;
	remap_array[99]=188;
	remap_array[100]=60;
	remap_array[101]=68;
	remap_array[102]=178;
	remap_array[103]=189;
	remap_array[104]=61;
	remap_array[105]=69;
	remap_array[106]=162;
	remap_array[107]=173;
	remap_array[108]=45;
	remap_array[109]=85;
	remap_array[110]=163;
	remap_array[111]=172;
	remap_array[112]=46;
	remap_array[113]=86;
	remap_array[114]=147;
	remap_array[115]=156;
	remap_array[116]=62;
	remap_array[117]=70;
	remap_array[118]=146;
	remap_array[119]=157;
	remap_array[120]=63;
	remap_array[121]=71;
	remap_array[122]=130;
	remap_array[123]=141;
	remap_array[124]=47;
	remap_array[125]=87;
	remap_array[126]=131;
	remap_array[127]=140;
	remap_array[128]=88;
	remap_array[129]=32;
	remap_array[130]=244;
	remap_array[131]=251;
	remap_array[132]=72;
	remap_array[133]=48;
	remap_array[134]=245;
	remap_array[135]=250;
	remap_array[136]=73;
	remap_array[137]=49;
	remap_array[138]=229;
	remap_array[139]=234;
	remap_array[140]=89;
	remap_array[141]=33;
	remap_array[142]=228;
	remap_array[143]=235;
	remap_array[144]=90;
	remap_array[145]=34;
	remap_array[146]=212;
	remap_array[147]=219;
	remap_array[148]=74;
	remap_array[149]=50;
	remap_array[150]=213;
	remap_array[151]=218;
	remap_array[152]=75;
	remap_array[153]=51;
	remap_array[154]=197;
	remap_array[155]=202;
	remap_array[156]=91;
	remap_array[157]=35;
	remap_array[158]=196;
	remap_array[159]=203;
	remap_array[160]=92;
	remap_array[161]=36;
	remap_array[162]=180;
	remap_array[163]=187;
	remap_array[164]=76;
	remap_array[165]=52;
	remap_array[166]=181;
	remap_array[167]=186;
	remap_array[168]=77;
	remap_array[169]=53;
	remap_array[170]=165;
	remap_array[171]=170;
	remap_array[172]=93;
	remap_array[173]=37;
	remap_array[174]=164;
	remap_array[175]=171;
	remap_array[176]=94;
	remap_array[177]=38;
	remap_array[178]=148;
	remap_array[179]=155;
	remap_array[180]=78;
	remap_array[181]=54;
	remap_array[182]=149;
	remap_array[183]=154;
	remap_array[184]=79;
	remap_array[185]=55;
	remap_array[186]=133;
	remap_array[187]=138;
	remap_array[188]=95;
	remap_array[189]=39;
	remap_array[190]=132;
	remap_array[191]=139;
	remap_array[192]=104;
	remap_array[193]=16;
	remap_array[194]=247;
	remap_array[195]=248;
	remap_array[196]=120;
	remap_array[197]=0;
	remap_array[198]=246;
	remap_array[199]=249;
	remap_array[200]=121;
	remap_array[201]=1;
	remap_array[202]=230;
	remap_array[203]=233;
	remap_array[204]=105;
	remap_array[205]=17;
	remap_array[206]=231;
	remap_array[207]=232;
	remap_array[208]=106;
	remap_array[209]=18;
	remap_array[210]=215;
	remap_array[211]=216;
	remap_array[212]=122;
	remap_array[213]=2;
	remap_array[214]=214;
	remap_array[215]=217;
	remap_array[216]=123;
	remap_array[217]=3;
	remap_array[218]=198;
	remap_array[219]=201;
	remap_array[220]=107;
	remap_array[221]=19;
	remap_array[222]=199;
	remap_array[223]=200;
	remap_array[224]=108;
	remap_array[225]=20;
	remap_array[226]=183;
	remap_array[227]=184;
	remap_array[228]=124;
	remap_array[229]=4;
	remap_array[230]=182;
	remap_array[231]=185;
	remap_array[232]=125;
	remap_array[233]=5;
	remap_array[234]=166;
	remap_array[235]=169;
	remap_array[236]=109;
	remap_array[237]=21;
	remap_array[238]=167;
	remap_array[239]=168;
	remap_array[240]=110;
	remap_array[241]=22;
	remap_array[242]=151;
	remap_array[243]=152;
	remap_array[244]=126;
	remap_array[245]=6;
	remap_array[246]=150;
	remap_array[247]=153;
	remap_array[248]=127;
	remap_array[249]=7;
	remap_array[250]=134;
	remap_array[251]=137;
	remap_array[252]=111;
	remap_array[253]=23;
	remap_array[254]=135;
	remap_array[255]=136;

}
#endif

void InitXADC(void)
{
	//Initialize the XADC
		XSysMon_Config *SysMonConfigPtr;
		SysMonConfigPtr = XSysMon_LookupConfig(SYSMON_DEVICE_ID);
		if (SysMonConfigPtr == NULL) {
			return;
		}
		XSysMon_CfgInitialize(&SysMonInst, SysMonConfigPtr,
		SysMonConfigPtr->BaseAddress);
		XSysMon_SetSequencerMode(&SysMonInst, XSM_SEQ_MODE_SAFE);
		XSysMon_SetSeqChEnables(&SysMonInst, XSM_SEQ_CH_TEMP |
							XSM_SEQ_CH_VCCAUX |
							XSM_SEQ_CH_VCCINT);
		XSysMon_SetAdcClkDivisor(&SysMonInst, 32);
		XSysMon_SetSequencerMode(&SysMonInst, XSM_SEQ_MODE_CONTINPASS);
/*		volatile int delay;
		while(1)
		{
		u16 value = XSysMon_GetAdcData(&SysMonInst, XSM_CH_TEMP);
		xil_printf("Temp %d ", value);
		value = XSysMon_GetAdcData(&SysMonInst, XSM_CH_VCCAUX);
		xil_printf("Temp %d ", value);
		value = XSysMon_GetAdcData(&SysMonInst, XSM_CH_VCCINT);
		xil_printf("Temp %d \n", value);
		for (delay=0;delay<1000000;delay++);
		}
*/


}

/*
	//Test the two WR DACs
	while (1)
	{
	u16 dacval;
	for (dacval=0;dacval<60000;dacval+=1000)
		Set_WRDAC(1, dacval);
	for (delay = 0; delay < 1000000; delay++);
	for (dacval=0;dacval<60000;dacval+=1000)
		Set_WRDAC(0, dacval);
	for (delay = 0; delay < 1000000; delay++);
	}
*/
void waitabit(u8 val)
{
	u8 time_now;
	u8 i;
	for (i=0;i<val;i++)
	{
		time_now = interrupt_counter & 0xff;
		while(time_now == (interrupt_counter & 0xff));
	}
	return;
}

void WR_int_callback()
{
	//Set the SPI MUX to grab control
	spi_sel = 1;
	UpdateGPIO();
	//volatile u32 delay;
	XSpi_SetSlaveSelect(&Spi, SPI_chan_mask);
	Status = XSpi_Transfer(&Spi, SPI_TxBuf, SPI_RxBuf, SPI_bytes_to_send);
	while ((XSpi_ReadReg(&Spi, XSP_SR_OFFSET) & XSP_SR_TX_EMPTY_MASK) != 0);
	//for (delay = 0; delay < 30000; delay++);
	XSpi_SetSlaveSelect(&Spi, 0xff);
	spi_sel = 0;
	wr_int_arm = 0;
	UpdateGPIO();
	SPI_flag = 0;
}