library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity alu is 
port(	x, y : in std_logic_vector(31 downto 0); -- two input operands
	add_sub : in std_logic; -- 0 = add , 1 = sub
	logic_func : in std_logic_vector(1 downto 0 );-- 00 = AND, 01 = OR , 10 = XOR , 11 = NOR
	func : in std_logic_vector(1 downto 0 ) ; -- 00 = lui, 01 = setless , 10 = arith , 11 = logic
	output : out std_logic_vector(31 downto 0) ;
	overflow : out std_logic ;
	zero : out std_logic);
end alu;

architecture arch_alu of alu is
	--component alu_comp is
	--	port 
	--	( xP, yP : in std_logic_vector(31 downto 0); 
	--	add_subP : in std_logic;
	--	logic_funcP : in std_logic_vector(1 downto 0 );
	--	funcP : in std_logic_vector(1 downto 0 ); 
	--	outputP : out std_logic_vector(31 downto 0);
	--	overflowP : out std_logic;
	--	zeroP : out std_logic);
	--	)
	--end component;

	signal addsub_result : std_logic_vector(31 downto 0); --store the result of the add or sub
	signal logic_result : std_logic_vector(31 downto 0); --store the result of the logic 
	signal x_MSB, y_MSB, result_MSB : std_logic; --store the MSB to calculate overflow		

	begin
		--Port map assignments
	--	x <= xP;
	--	y <= yP;
	--	add_sub <= add_subP;
	--	logic_func <= logic_funcP;
	--	func <= funcP;
	--	outputP <= output;
	--	overflowP <= overflow;
	--	zeroP <= zero;

		--process for the add_sub component
		process(x, y, add_sub)
			begin
				if (add_sub = '0') then --addition
					addsub_result <= x + y;
				else --subtraction
					addsub_result <= x - y;
				end if;
		end process;


		--process for the logic_func component
		process(x, y, logic_func)
			begin
				if (logic_func = "00") then --AND
					logic_result <= x AND y;
				elsif (logic_func ="01") then -- OR
					logic_result <= x OR y;
				elsif (logic_func = "10") then --XOR
					logic_result <= x XOR y;
				else --NOR
					logic_result <= x NOR y;
				end if;
		end process;

		--process for the mux
		process(y, result_MSB, addsub_result, logic_result, func)
			begin
				if (func = "00") then --output y 
					output <= y;
				elsif (func = "01") then --lst
					output <= "0000000000000000000000000000000" & result_MSB;
				elsif (func = "10") then --add/sub output
					output <= addsub_result;
				else --output logic result
					output <= logic_result;
				end if;
		end process;

		--process for zero and to calculate the MSB
		process(x, y, add_sub, addsub_result) 
			begin
				
				if (addsub_result = "00000000000000000000000000000000") then 
					zero <= '1';
				else
					zero <= '0';
				end if;

				x_MSB <= x(31); --get the MSB of x
				y_MSB <= y(31); --get the MSB of y
				result_MSB <= addsub_result(31); --get MSB of add/sub result

		end process; --sub first and result must be same, add first and second
	
		--process to calculate the overflow
		process(x_MSB, y_MSB, add_sub, result_MSB)
			begin	
				if (add_sub = '0') then --addition
					if (x_MSB = '1' and y_MSB = '1') then --two negative
						if (result_MSB = '1') then --result negative
							overflow <= '0';
						else --result positive
							overflow <= '1';
						end if;
					elsif (x_MSB = '0' and y_MSB = '0') then --two positives
						if (result_MSB = '1') then --result negative
							overflow <= '1';
						else --result positive
							overflow <= '0';
						end if;
					else
						overflow <= '0';
					end if;
				else --subtraction
					if (x_MSB = '1' and y_MSB = '0') then --negative-positve
						if (result_MSB = '1') then --result negative
							overflow <= '0';
						else --result positive
							overflow <= '1';
						end if;
					elsif (x_MSB = '0' and y_MSB = '1') then --positive-negative
						if (result_MSB = '1') then --result negative
							overflow <= '1';
						else --result positive
							overflow <= '0';
						end if;
					else
						overflow <= '0';
					end if;
				end if;
		end process;
end arch_alu;
