-- 32 x 32 register file
-- two read ports, one write port with write enable

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity regfile  is
port( 	din   : in std_logic_vector(31 downto 0);      
	reset : in std_logic;
	clk   : in std_logic;
	writing : in std_logic;
	read_a : in std_logic_vector(4 downto 0);
	read_b : in std_logic_vector(4 downto 0);
	write_address : in std_logic_vector(4 downto 0);
	out_a  : out std_logic_vector(31 downto 0);
	out_b  : out std_logic_vector(31 downto 0));
end regfile ;

architecture arch_regfile of regfile is
	--Defining 32 registers of 32 bits
	signal R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15, R16, R17, 
			R18, R19, R20, R21, R22, R23, R24, R25, R26, R27, R28, R29, R30, R31: std_logic_vector(31 downto 0);
	
	begin 
	
		-- synchronous operations
		process (clk, reset)
			begin
				--make all register 0 if reset is 1
				if (reset = '1') then
					R0 <= (others => '0');
					R1 <= (others => '0');
					R2 <= (others => '0');
					R3 <= (others => '0');
					R4 <= (others => '0');
					R5 <= (others => '0');
					R6 <= (others => '0');
					R7 <= (others => '0');
					R8 <= (others => '0');
					R9 <= (others => '0');
					R10 <= (others => '0');
					R11 <= (others => '0');
					R12 <= (others => '0');
					R13 <= (others => '0');
					R14 <= (others => '0');
					R15 <= (others => '0');
					R16 <= (others => '0');
					R17 <= (others => '0');
					R18 <= (others => '0');
					R19 <= (others => '0');
					R20 <= (others => '0');
					R21 <= (others => '0');
					R22 <= (others => '0');
					R23 <= (others => '0');
					R24 <= (others => '0');
					R25 <= (others => '0');
					R26 <= (others => '0');
					R27 <= (others => '0');
					R28 <= (others => '0');
					R29 <= (others => '0');
					R30 <= (others => '0');
					R31 <= (others => '0');
			
				-- all situations that occur during a rising edge
				elsif (rising_edge(clk)) then
					-- case to write to the registers 
					if (writing = '1') then
						case write_address is
							when "00000" => R0 <= din;
							when "00001" => R1 <= din;
							when "00010" => R2 <= din;
							when "00011" => R3 <= din;
							when "00100" => R4 <= din;
							when "00101" => R5 <= din;
							when "00110" => R6 <= din;
							when "00111" => R7 <= din;
							when "01000" => R8 <= din;
							when "01001" => R9 <= din;
							when "01010" => R10 <= din;
							when "01011" => R11 <= din;
							when "01100" => R12 <= din;
							when "01101" => R13 <= din;
							when "01110" => R14 <= din;
							when "01111" => R15 <= din;
							when "10000" => R16 <= din;
							when "10001" => R17 <= din;
							when "10010" => R18 <= din;
							when "10011" => R19 <= din;
							when "10100" => R20 <= din;
							when "10101" => R21 <= din;
							when "10110" => R22 <= din;
							when "10111" => R23 <= din;
							when "11000" => R24 <= din;
							when "11001" => R25 <= din;
							when "11010" => R26 <= din;
							when "11011" => R27 <= din;
							when "11100" => R28 <= din;
							when "11101" => R29 <= din;
							when "11110" => R30 <= din;
							when others => R31 <= din;
						end case;
					end if;
				end if;
		end process;

		-- asynchronous operations
		-- for out_a
		with read_a select
			out_a <= R0 when "00000",
					R1 when "00001",
					R2 when "00010",
					R3 when "00011",
					R4 when "00100",
					R5 when "00101",
					R6 when "00110",
					R7 when "00111",
					R8 when "01000",
					R9 when "01001",
					R10 when "01010",
					R11 when "01011",
					R12 when "01100",
					R13 when "01101",
					R14 when "01110",
					R15 when "01111",
					R16 when "10000",
					R17 when "10001",
					R18 when "10010",
					R19 when "10011",
					R20 when "10100",
					R21 when "10101",
					R22 when "10110",
					R23 when "10111",
					R24 when "11000",
					R25 when "11001",
					R26 when "11010",
					R27 when "11011",
					R28 when "11100",
					R29 when "11101",
					R30 when "11110",
					R31 when others; 
					
		-- for out_b
		with read_b select
			out_b <= R0 when "00000",
					R1 when "00001",
					R2 when "00010",
					R3 when "00011",
					R4 when "00100",
					R5 when "00101",
					R6 when "00110",
					R7 when "00111",
					R8 when "01000",
					R9 when "01001",
					R10 when "01010",
					R11 when "01011",
					R12 when "01100",
					R13 when "01101",
					R14 when "01110",
					R15 when "01111",
					R16 when "10000",
					R17 when "10001",
					R18 when "10010",
					R19 when "10011",
					R20 when "10100",
					R21 when "10101",
					R22 when "10110",
					R23 when "10111",
					R24 when "11000",
					R25 when "11001",
					R26 when "11010",
					R27 when "11011",
					R28 when "11100",
					R29 when "11101",
					R30 when "11110",
					R31 when others; 
end arch_regfile;
