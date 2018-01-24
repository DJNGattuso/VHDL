library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;

entity next_address is
port(	
	rt, rs : in std_logic_vector(31 downto 0); -- two register inputs
     pc     : in std_logic_vector(31 downto 0);
     target_address : in std_logic_vector(25 downto 0);
     branch_type    : in std_logic_vector(1 downto 0);
     pc_sel	: in std_logic_vector(1 downto 0);
     next_pc	: out std_logic_vector(31 downto 0));
end next_address ;

architecture arch_addressing of next_address is
	signal branch_address, branch_out: std_logic_vector(15 downto 0);
	signal branch_se, jump_out, jump : std_logic_vector(31 downto 0);

	begin
		branch_address <= target_address(15 downto 0);
		jump_out <= "000000" & target_address;
		
		--branch process
		--need to make the branch out extend to 32 bits
		process (branch_type, rs, rt, branch_address)
			begin
				if (branch_type = "00") then --no branch
					branch_out <= (others => '0');
				elsif (branch_type ="01") then --beq
					if (rs /= rt) then
						branch_out <= branch_address;
					else 
						branch_out <= (others => '0');
					end if;
				elsif (branch_type = "10") then --bne
					if (rs = rt) then
						branch_out <= branch_address;
					else
						branch_out <= (others => '0');
					end if;

				else --bltz
					if (rs < "000000000000000000000000000000000000000000") then
						branch_out <= branch_address;
					else
						branch_out <= (others => '0');
					end if;
				end if;
		end process;

		--branch sign extend
		process (branch_out)
			begin
				if (branch_out(15) = '0') then
					branch_se <= "0000000000000000" & branch_out;
				else
					branch_se <= "1111111111111111" & branch_out;
				end if;
		end process;

		--calculate next branch address
		process (branch_se, pc)
			begin
				jump <= branch_se + pc + '1';
		end process;

		--jump process
		process (pc_sel, rs, jump, jump_out)
			begin
				if (pc_sel = "00") then --no jump
					next_pc <= jump;
				elsif (pc_sel = "01") then --jump
					next_pc <= jump_out;
				elsif (pc_sel = "10") then --jump reg
				  	next_pc <= rs;
				else
					next_pc <= jump;
				end if;
		end process;
end arch_addressing;
