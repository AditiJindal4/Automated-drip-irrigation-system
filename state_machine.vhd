LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity state_machine is port(

	clk_input, reset, sm_clken, blink_sig, ns_request, ew_request		: in std_logic;
	ns_green, ns_amber, ns_red, ew_green, ew_amber, ew_red				: out std_logic;
	ns_crossing, ew_crossing														: out std_logic;
	ns_clear, ew_clear																: out std_logic;
	bin_state																			: out std_logic_vector(3 downto 0)
	
);
end entity;

architecture circuit of state_machine is
	
	type state_names is(s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11, s12, s13, s14, s15);
	
	signal current_state, next_state		: state_names;
	
	begin
	
	-- register process
	
	process (clk_input)
	
	begin 
	
	if (rising_edge(clk_input)) then
			if (reset = '1') then
				current_state <= s0;
			elsif (reset = '0' AND sm_clken = '1') then
				current_state <= next_state;
			end if;
		end if;
		
	end process;
	
	--transition process
	
	process (current_state)
	
	begin
		
		case (current_state) is
		
			when s0 =>
				if (ew_request = '1' AND ns_request = '0') then 
					next_state <= s6;
				else 
					next_state <= s1;
				end if;
				
			when s1 =>
				if (ew_request = '1' AND ns_request = '0') then
					next_state <= s6;
				else 
					next_state <= s2;
				end if;
				
			when s2 =>
				next_state <= s3;
			
			when s3 =>
				next_state <= s4;	
			
			when s4 =>
				next_state <= s5;
				
			when s5 =>
				next_state <= s6;
				
			when s6 =>
				next_state <= s7;
				
			when s7 =>
				next_state <= s8;
				
			when s8 =>
				if (ew_request = '0' AND ns_request = '1') then
					next_state <= s14;
				else
					next_state <= s9;
				end if;
				
			when s9 =>
				if (ew_request = '0' AND ns_request = '1') then
					next_state <= s14;
				else
					next_state <= s10;
				end if;
				
			when s10 =>
				next_state <= s11;
				
			when s11 => 
				next_state <= s12;
		
			when s12 =>
				next_state <= s13;
			
			when s13 =>
				next_state <= s14;
				
			when s14 =>
				next_state <= s15;
				
			when s15 =>
				next_state <= s0;
				
		end case;
		
	end process;
	
	-- decoder process
	
	process (current_state)
	
	begin
	
		case (current_state) is
			
			when s0 | s1 =>
				
				ns_clear <= '0';
				ns_green <= blink_sig;
				ns_amber <= '0';
				ns_red <= '0';
				ns_crossing <= '0';
				
				
				ew_clear <= '0';
				ew_green <= '0';
				ew_amber <= '0';
				ew_red <= '1';
				ew_crossing <= '0';
				
				
			when s2 | s3 | s4 | s5 =>
				
				ns_clear <= '0';
				ns_green <= '1';
				ns_amber <= '0';
				ns_red <= '0';
				ns_crossing <= '1';
			
				ew_clear <= '0';
				ew_green <= '0';
				ew_amber <= '0';
				ew_red <= '1';
				ew_crossing <= '0';
				
				
			when s6 =>
				
				ns_clear <= '1';
				ns_green <= '0';
				ns_amber <= '1';
				ns_red <= '0';
				ns_crossing <= '0';
				
				ew_clear <= '0';
				ew_green <= '0';
				ew_amber <= '0';
				ew_red <= '1';
				ew_crossing <= '0';
				
			when s7 =>
		
				ns_clear <= '0';
				ns_green <= '0';
				ns_amber <= '1';
				ns_red <= '0';
				ns_crossing <= '0';
				
				ew_clear <= '0';
				ew_green <= '0';
				ew_amber <= '0';
				ew_red <= '1';
				ew_crossing <= '0';
				
			when s8 | s9 =>
			
				ns_clear <= '0';
				ns_green <= '0';
				ns_amber <= '0';
				ns_red <= '1';
				ns_crossing <= '0';
				
				ew_clear <= '0';
				ew_green <= blink_sig;
				ew_amber <= '0';
				ew_red <= '0';
				ew_crossing <= '0';
				
			when s10 | s11 | s12 | s13 =>
			
				ns_clear <= '0';
				ns_green <= '0';
				ns_amber <= '0';
				ns_red <= '1';
				ns_crossing <= '0';
				
				ew_clear <= '0';
				ew_green <= '1';
				ew_amber <= '0';
				ew_red <= '0';
				ew_crossing <= '1';
				
				
			when s14 =>
				
				ns_clear <= '0';
				ns_green <= '0';
				ns_amber <= '0';
				ns_red <= '1';
				ns_crossing <= '0';
				
				ew_clear <= '1';
				ew_green <= '0';
				ew_amber <= '1';
				ew_red <= '0';
				ew_crossing <= '0';
				
				
			when s15 =>
			
				ns_clear <= '0';
				ns_green <= '0';
				ns_amber <= '0';
				ns_red <= '1';
				ns_crossing <= '0';
				
				ew_clear <= '0';
				ew_green <= '0';
				ew_amber <= '1';
				ew_red <= '0';
				ew_crossing <= '0';
				
		end case;
			
		case (current_state) is
		
			when s0 =>
				bin_state <= "0000";
				
			when s1 =>
				bin_state <= "0001";
				
			when s2 =>
				bin_state <= "0010";
				
			when s3 =>
				bin_state <= "0011";
			
			when s4 =>
				bin_state <= "0100";
				
			when s5 =>
				bin_state <= "0101";
				
			when s6 =>
				bin_state <= "0110";
				
			when s7 =>
				bin_state <= "0111";
				
			when s8 =>
				bin_state <= "1000";
				
			when s9 =>
				bin_state <= "1001";
				
			when s10 =>
				bin_state <= "1010";
				
			when s11 =>
				bin_state <= "1011";
				
			when s12 =>
				bin_state <= "1100";
				
			when s13 =>
				bin_state <= "1101";
				
			when s14 =>
				bin_state <= "1110";
				
			when s15 =>
				bin_state <= "1111";
				
			end case;
	end process;
end architecture;
				
				
				