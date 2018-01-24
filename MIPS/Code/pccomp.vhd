library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;

entity pc is 
port( 
  	clock : in  std_logic;
	reset : in std_logic;
	value : in std_logic_vector(31 downto 0);
	lower : out std_logic_vector(4 downto 0);
	pc_value : out std_logic_vector(31 downto 0));
end pc;
	  
architecture pc_arch of pc is
	begin
	process (clock, reset, value)
		begin
		     	if (reset = '1') then 
			    	lower <= "00000";
				pc_value <= X"00000000";
		     	elsif (rising_edge(clock)) then
			     	lower <= value(4 downto 0);
				pc_value <= value;
		      	end if;
	end process;
end pc_arch;
