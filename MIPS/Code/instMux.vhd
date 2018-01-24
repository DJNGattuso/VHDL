library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;

entity instMux is 
port( 
  	control : in std_logic;
	regD, regT : in std_logic_vector(4 downto 0);
	reg : out std_logic_vector(4 downto 0));
end instMux;
	  
  
architecture inst_arch of instMux is
	begin
	process (control, regT, regD)
		begin
		     	if (control = '0') then 
			    	reg <= regT;
		     	else 
			     	reg <= regD;
		      	end if;
	end process;
end inst_arch;
