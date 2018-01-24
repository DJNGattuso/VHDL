library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;

entity regmux is 
port( 
  	control : in std_logic;
	reg, immediate : in std_logic_vector(31 downto 0);
	value : out std_logic_vector(31 downto 0));
end regmux;
	  
  
architecture rm_arch of regmux is
	begin
	  	process(control, reg, immediate)
	    		begin
		      		if (control = '0') then 
		        		value <= reg;
		     		else 
			       		value <= immediate;
				end if;
		end process;
end rm_arch;
