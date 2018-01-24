library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;

entity dcache is 
port( 
	clock : in std_logic;
	reset : in std_logic;
  	registerData : in std_logic_vector(31 downto 0);
	write : in std_logic;
	muxsel : in std_logic;
	ld_st : in std_logic_vector(31 downto 0);
	Dout: out std_logic_vector(31 downto 0));
end dcache;
	  
  
architecture dcache_arch of dcache is
	------signals for data cache-----
	signal D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11, D12, D13, D14, D15, D16, D17, 
			D18, D19, D20, D21, D22, D23, D24, D25, D26, D27, D28, D29, D30, D31: std_logic_vector(31 downto 0);

	begin	
	process(registerData, write, ld_st, clock, reset, muxsel)
		begin
			if (reset = '1') then
					D0 <= (others => '0');
					D1 <= (others => '0');
					D2 <= (others => '0');
					D3 <= (others => '0');
					D4 <= (others => '0');
					D5 <= (others => '0');
					D6 <= (others => '0');
					D7 <= (others => '0');
					D8 <= (others => '0');
					D9 <= (others => '0');
					D10 <= (others => '0');
					D11 <= (others => '0');
					D12 <= (others => '0');
					D13 <= (others => '0');
					D14 <= (others => '0');
					D15 <= (others => '0');
					D16 <= (others => '0');
					D17 <= (others => '0');
					D18 <= (others => '0');
					D19 <= (others => '0');
					D20 <= (others => '0');
					D21 <= (others => '0');
					D22 <= (others => '0');
					D23 <= (others => '0');
					D24 <= (others => '0');
					D25 <= (others => '0');
					D26 <= (others => '0');
					D27 <= (others => '0');
					D28 <= (others => '0');
					D29 <= (others => '0');
					D30 <= (others => '0');
					D31 <= (others => '0');
			
			
			elsif (rising_edge(clock)) then
				if (write = '1') then
					case registerData(4 downto 0) is
						when "00000" => D0 <= ld_st; 
						when "00001" => D1 <= ld_st; 
						when "00010" => D2 <= ld_st; 
						when "00011" => D3 <= ld_st; 
						when "00100" => D4 <= ld_st; 
						when "00101" => D5 <= ld_st;
						when "00110" => D6 <= ld_st;
						when "00111" => D7 <= ld_st; 
						when "01000" => D8 <= ld_st; 
						when "01001" => D9 <= ld_st;
						when "01010" => D10 <= ld_st; 
						when "01011" => D11 <= ld_st; 
						when "01100" => D12 <= ld_st; 
						when "01101" => D13 <= ld_st;
						when "01110" => D14 <= ld_st; 
						when "01111" => D15 <= ld_st; 
						when "10000" => D16 <= ld_st;
						when "10001" => D17 <= ld_st;
						when "10010" => D18 <= ld_st; 
						when "10011" => D19 <= ld_st; 
						when "10100" => D20 <= ld_st; 
						when "10101" => D21 <= ld_st; 
						when "10110" => D22 <= ld_st; 
						when "10111" => D23 <= ld_st; 
						when "11000" => D24 <= ld_st; 
						when "11001" => D25 <= ld_st; 
						when "11010" => D26 <= ld_st;
						when "11011" => D27 <= ld_st; 
						when "11100" => D28 <= ld_st; 
						when "11101" => D29 <= ld_st;
						when "11110" => D30 <= ld_st;
						when others => D31 <= ld_st;
					end case;
				end if;
			end if;

			if (muxsel = '0') then Dout <= registerData;
			else
				case registerData(4 downto 0) is
					when "00000" => DOut <= D0;
					when "00001" => DOut <= D1; 
					when "00010" => DOut <= D2; 
					when "00011" => DOut <= D3; 
					when "00100" => DOut <= D4; 
					when "00101" => DOut <= D5; 
					when "00110" => DOut <= D6; 
					when "00111" => DOut <= D7; 
					when "01000" => DOut <= D8; 
					when "01001" => DOut <= D9; 
					when "01010" => DOut <= D10; 
					when "01011" => DOut <= D11; 
					when "01100" => DOut <= D12; 
					when "01101" => DOut <= D13; 
					when "01110" => DOut <= D14; 
					when "01111" => DOut <= D15; 
					when "10000" => DOut <= D16; 
					when "10001" => DOut <= D17; 
					when "10010" => DOut <= D18; 
					when "10011" => DOut <= D19; 
					when "10100" => DOut <= D20; 
					when "10101" => DOut <= D21; 
					when "10110" => DOut <= D22; 
					when "10111" => DOut <= D23; 
					when "11000" => DOut <= D24; 
					when "11001" => DOut <= D25; 
					when "11010" => DOut <= D26; 
					when "11011" => DOut <= D27; 
					when "11100" => DOut <= D28; 
					when "11101" => DOut <= D29; 
					when "11110" => DOut <= D30; 
					when others => DOut <= D31; 
				end case;		
			end if;
	end process;
end dcache_arch;
