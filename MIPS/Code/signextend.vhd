library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;

entity signextend is 
port( 
  	func : in std_logic_vector(1 downto 0);
	immediate : in std_logic_vector(15 downto 0);
	signExtended : out std_logic_vector(31 downto 0)); 
end signextend;
	  
  
architecture se_arch of signextend is
	begin

	--process Sign Extend
	process(func, immediate)
		begin
			if (func = "00") then signExtended <= immediate & "0000000000000000";
			elsif (func = "11") then signExtended <= "0000000000000000" & immediate;
			else signExtended <= immediate(15) & immediate(15) & immediate(15) & immediate(15) 							& immediate(15) & immediate(15) & immediate(15) & immediate(15) & immediate(15) 						& immediate(15) & immediate(15) & immediate(15) & immediate(15) & immediate(15) 						& immediate(15) & immediate(15) & immediate; 
			end if;
	end process;
end se_arch;
