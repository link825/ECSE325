library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;

entity g42_FIR_tb is
end g42_FIR_tb;

architecture testbench of g42_FIR_tb is



	component g42_FIR is 
		port ( 	
			x		: in std_logic_vector(15 downto 0); --input signal
			clk		: in std_logic;  -- clock
			rst		: in std_logic;  -- asynchronous active-high reset
			y 		: out std_logic_vector(16 downto 0) -- output signal
		);
	end component g42_FIR;

	file file_IN 		: text;
	file file_RESULTS 	: text;
	
	constant clk_PERIOD : time := 60 ns;
	
	signal x_in		: std_logic_vector(15 downto 0);
	signal clk_in		: std_logic;
	signal rst_in		: std_logic;
	signal y_out		: std_logic_vector(16 downto 0);

begin
		g42_FIR_test : g42_FIR
		port map (
			x 	=> x_in,
			clk 	=> clk_in,
			rst 	=> rst_in,
			y 		=> y_out
		);
	
--CLOCK GENERATION
	clk_gen : process 
		 begin 
			  clk_in <= '1';
			  wait for clk_PERIOD / 2; 
			  clk_in <= '0';
			  wait for clk_PERIOD / 2; 
	end process clk_gen;
				

	feeding_instr : process is 
		variable v_lline1 : line;
		variable v_lline2 : line; 
		variable v_Oline  : line; 
		variable v_x_in   : std_logic_vector(15 downto 0);
	 
	begin

		rst_in <= '1';
		wait until rising_edge(clk_in);
		wait until rising_edge(clk_in);
		rst_in <= '0';

		file_open(file_IN, "C:\Users\sli196.CAMPUS\ECSE325\scripts\lab3\lab3-In-fixedOutput.txt", read_mode);
		file_open(file_RESULTS, "C:\Users\sli196.CAMPUS\ECSE325\scripts\lab3\lab3-out.txt", write_mode);
		
		while not endfile (file_IN) loop
			readline(file_IN, v_lline1);	
			read(v_lline1, v_x_in);
			x_in <= v_x_in;
			write(v_Oline, y_out);
			writeline(file_RESULTS, v_Oline);
			wait until rising_edge(clk_in);
		 end loop;
		 wait until rising_edge(clk_in);
		 wait until rising_edge(clk_in);
	 	 wait;
	end process feeding_instr;
end testbench;

