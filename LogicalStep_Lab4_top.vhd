-- Aditi Jindal, Brandon Kong, Group 15

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LogicalStep_Lab4_top IS
   PORT
	(
		clkin_50		: in	std_logic;							-- The 50 MHz FPGA Clockinput
		rst_n			: in	std_logic;							-- The RESET input (ACTIVE LOW)
		pb_n			: in	std_logic_vector(3 downto 0); -- The push-button inputs (ACTIVE LOW)
		sw   			: in  std_logic_vector(7 downto 0); -- The switch inputs
		leds			: out std_logic_vector(7 downto 0);	-- for displaying the the lab4 project details
	-------------------------------------------------------------
	-- you can add temporary output ports here if you need to debug your design 
	-- or to add internal signals for your simulations
	-------------------------------------------------------------
	
   seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;							-- seg7 digi selectors
	seg7_char2  : out	std_logic							-- seg7 digi selectors
	);
END LogicalStep_Lab4_top;

ARCHITECTURE SimpleCircuit OF LogicalStep_Lab4_top IS
   component segment7_mux port (
          clk        : in  std_logic := '0';
			 DIN2 		: in  std_logic_vector(6 downto 0);	--bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DIN1 		: in  std_logic_vector(6 downto 0); --bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DOUT			: out	std_logic_vector(6 downto 0);
			 DIG2			: out	std_logic;
			 DIG1			: out	std_logic
   );
   end component;

   component clock_generator port (
			sim_mode			: in boolean;
			reset				: in std_logic;
         clkin      		: in  std_logic;
			sm_clken			: out	std_logic;
			blink		  		: out std_logic
  );
   end component;

    component pb_filters port (
			clkin				: in std_logic;
			rst_n				: in std_logic;
			rst_n_filtered	    : out std_logic;
			pb_n				: in  std_logic_vector (3 downto 0);
			pb_n_filtered	    : out	std_logic_vector(3 downto 0)							 
 );
   end component;

	component pb_inverters port (
			rst_n				: in  std_logic;
			rst				    : out	std_logic;							 
			pb_n_filtered	    : in  std_logic_vector (3 downto 0);
			pb					: out	std_logic_vector(3 downto 0)							 
  );
   end component;
	
	component synchronizer port(
			clk					: in std_logic;
			reset					: in std_logic;
			din					: in std_logic;
			dout					: out std_logic
	);
   end component; 
 
	component holding_register port (
			clk					: in std_logic;
			reset					: in std_logic;
			register_clr		: in std_logic;
			din					: in std_logic;
			dout					: out std_logic
	);
  end component;		

	component state_machine port (
			clk_input		: in std_logic;
			reset				: in std_logic;
			sm_clken			: in std_logic;
			blink_sig		: in std_logic;
			
			ns_request		: in std_logic;
			ew_request		: in std_logic;
			
			ns_green			: out std_logic;
			ns_amber		   : out std_logic;
			ns_red  			: out std_logic;
			ew_green			: out std_logic;
			ew_amber			: out std_logic;
			ew_red  			: out std_logic;
			
			ns_crossing		: out std_logic;
			ew_crossing 	: out std_logic;
			
			ns_clear 		: out std_logic;
			ew_clear			: out std_logic;	
			
			bin_state		: out std_logic_vector(3 downto 0)
	);
	end component;
	
			
----------------------------------------------------------------------------------------------------
	CONSTANT	sim_mode																	: boolean := FALSE;  -- set to FALSE for LogicalStep board downloads																						-- set to TRUE for SIMULATIONS
	SIGNAL rst, rst_n_filtered, synch_rst			  							: std_logic;
	SIGNAL sm_clken, blink_sig														: std_logic; 
	SIGNAL pb_n_filtered, pb														: std_logic_vector(3 downto 0); 
	SIGNAL ew_sync_out, ns_sync_out												: std_logic; 
	SIGNAL ew_hldr_out,	ns_hldr_out  									      : std_logic; 
	SIGNAL ew_clear, ns_clear														: std_logic; 
	SIGNAL ew_crossing, ns_crossing												: std_logic; 
	SIGNAL ew_green, ew_amber, ew_red, ns_green, ns_amber, ns_red 		: std_logic; 
	SIGNAL ew_lights, ns_lights													: std_logic_vector(6 downto 0);
	
BEGIN
----------------------------------------------------------------------------------------------------
INST0: pb_filters		port map (clkin_50, rst_n, rst_n_filtered, pb_n, pb_n_filtered);
INST1: pb_inverters		port map (rst_n_filtered, rst, pb_n_filtered, pb);
INST2: synchronizer     port map (clkin_50,synch_rst, rst, synch_rst);	-- the synchronizer is also reset by synch_rst.
INST3: clock_generator 	port map (sim_mode, synch_rst, clkin_50, sm_clken, blink_sig);


INST4: synchronizer		port map (clkin_50, synch_rst, pb(1), ew_sync_out);
INST5: holding_register	port map (clkin_50, synch_rst, ew_clear, ew_sync_out, ew_hldr_out);
leds(3) <= ew_hldr_out;
INST6: synchronizer		port map (clkin_50, synch_rst, pb(0), ns_sync_out);
INST7: holding_register	port map(clkin_50, synch_rst, ns_clear, ns_sync_out, ns_hldr_out);
leds(1) <= ns_hldr_out;

INST8: state_machine		port map(clkin_50, synch_rst, sm_clken, blink_sig, ns_hldr_out, ew_hldr_out, ns_green, ns_amber, ns_red, ew_green, ew_amber, ew_red, ns_crossing, ew_crossing, ns_clear, ew_clear, leds(7 downto 4));

leds(0) <= ns_crossing;
leds(2) <= ew_crossing;

ns_lights(6 downto 0) <= ns_amber & "00" & ns_green & "00" & ns_red;
ew_lights(6 downto 0) <= ew_amber & "00" & ew_green & "00" & ew_red;

INST9: segment7_mux		port map(clkin_50, ns_lights, ew_lights, seg7_data, seg7_char2, seg7_char1);


END SimpleCircuit;
