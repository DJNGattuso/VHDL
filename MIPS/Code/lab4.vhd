library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;

entity datapath is 
port( 
  	clk, rst: in std_logic;
	rs_out : out std_logic_vector(3 downto 0);
	rt_out : out std_logic_vector(3 downto 0);
	pc_out : out std_logic_vector(3 downto 0);
	zero, overflow : out std_logic);
end datapath;
	  
  
architecture data_arch of datapath is
	----------------------------defining the components------------------------------
	component icache_comp is
		port
		(
			address : in std_logic_vector(4 downto 0);
			instruction : out std_logic_vector(31 downto 0));
	end component;

	component instmux_comp is
		port
		(
			control : in std_logic;
			regD : in std_logic_vector(4 downto 0);
			regT : in std_logic_vector(4 downto 0);
			reg : out std_logic_vector(4 downto 0));
	end component;
	  
	component reg_comp is 
		port
		( 	din   : in std_logic_vector(31 downto 0);      
			reset : in std_logic;
			clk   : in std_logic;
			writing : in std_logic;
			read_a : in std_logic_vector(4 downto 0);
			read_b : in std_logic_vector(4 downto 0);
			write_address : in std_logic_vector(4 downto 0);
			out_a  : out std_logic_vector(31 downto 0);
			out_b  : out std_logic_vector(31 downto 0));
	end component;
	
	component signex_comp is
		port
		( 	func : in std_logic_vector(1 downto 0);
			immediate : in std_logic_vector(15 downto 0);
			signExtended : out std_logic_vector(31 downto 0)); 
	end component;

	component regmux_comp is
		port
		( 	control : in std_logic;
			reg : in std_logic_vector(31 downto 0);
			immediate : in std_logic_vector(31 downto 0);
			value : out std_logic_vector(31 downto 0));
	end component;

	component alu_comp is 
		port
		( 	x : in std_logic_vector(31 downto 0);
			y : in std_logic_vector(31 downto 0); -- two input operands
			add_sub : in std_logic; -- 0 = add , 1 = sub
			logic_func : in std_logic_vector(1 downto 0 );-- 00 = AND, 01 = OR , 10 = XOR , 11 = NOR
			func : in std_logic_vector(1 downto 0 ) ; -- 00 = lui, 01 = setless , 10 = arith , 11 = logic
			output : out std_logic_vector(31 downto 0) ;
			overflow : out std_logic ;
			zero : out std_logic);
	end component;

	component dcache_comp is
		port
		(
			clock : in std_logic;
			reset : in std_logic;
  			registerData : in std_logic_vector(31 downto 0);
			write : in std_logic;
			muxsel : in std_logic;
			ld_st : in std_logic_vector(31 downto 0);
			Dout: out std_logic_vector(31 downto 0));
	end component;

	component nxt_comp is 
		port
		(
			rt : in std_logic_vector(31 downto 0);
			rs : in std_logic_vector(31 downto 0); 
     			pc     : in std_logic_vector(31 downto 0);
     			target_address : in std_logic_vector(25 downto 0);
     			branch_type    : in std_logic_vector(1 downto 0);
     			pc_sel	: in std_logic_vector(1 downto 0);
     			next_pc	: out std_logic_vector(31 downto 0));
	end component;

	component pc_comp is 
		port( 
		  	clock : in  std_logic;
			reset : in std_logic;
			value : in std_logic_vector(31 downto 0);
			lower : out std_logic_vector(4 downto 0);
			pc_value : out std_logic_vector(31 downto 0));
	end component;

	--------------------------defining the entities------------------------------------
	for instruction : icache_comp use entity work.icache(icache_arch);
	for write : instmux_comp use entity work.instmux(inst_arch);
	for registr : reg_comp use entity work.regfile(arch_regfile);
	for se : signex_comp use entity work.signextend(se_arch);
	for check : regmux_comp use entity work.regmux(rm_arch);
	for a_l_u : alu_comp use entity work.alu(arch_alu);
	for data : dcache_comp use entity work.dcache(dcache_arch);
	for nextpc : nxt_comp use entity work.next_address(arch_addressing);
	for pcpass : pc_comp use entity work.pc(pc_arch);
	  
	------------------------------------------defining the signals-------------------------------------
	------general signal-----
	signal pc_in : std_logic_vector(31 downto 0);
	signal pc_nxt : std_logic_vector(31 downto 0);
	signal lower_pc : std_logic_vector(4 downto 0);

	-----signals for instruction----
	signal the_instruction : std_logic_vector(31 downto 0);
	signal reg_one, reg_two : std_logic_vector(31 downto 0);
	signal write_reg : std_logic_vector(4 downto 0);

	-----signals from sign extend-----
	signal immediate_se : std_logic_vector(31 downto 0);

	----signal for regValue-----
	signal reg_value : std_logic_vector(31 downto 0);

	-------signals from alu-------
	signal alu_out : std_logic_vector(31 downto 0);
	signal alu_over, alu_zero : std_logic;

	--dcache signal
	signal data_out : std_logic_vector(31 downto 0);

	--control signals
	signal branch_type, pc_sel, logic, the_func : std_logic_vector(1 downto 0);
	signal reg_write,alu_src, addsub, data_write, reg_in_src, reg_dst : std_logic;

	----------------------------------------------------------------------------------------------------
	begin

		pcpass : pc_comp port map(clk, rst, pc_nxt, lower_pc, pc_in);

		--------next pc------------
		nextpc : nxt_comp port map(reg_one, reg_two, pc_in, the_instruction(25 downto 0), branch_type, pc_sel, pc_nxt);
	 
		-----------send pc address to icache and get the instruction components
		instruction : icache_comp port map(lower_pc, the_instruction);


		--------get the address to write into
		write : instmux_comp port map(reg_dst, the_instruction(15 downto 11), the_instruction(20 downto 16), write_reg);

		----------control
		process(the_instruction)

			begin
			--lui
			if(the_instruction(31 downto 26) = "001111") then
				reg_write <= '1'; 
				reg_dst <=  '0'; 
				reg_in_src <=  '1'; 
				alu_src <=  '1'; 
				addsub <=  '0'; 
				data_write <= '0';  
				logic <=  "00";
				the_func <= "00";
				branch_type <= "00";  
				pc_sel <= "00"; 
			--addi
			elsif(the_instruction(31 downto 26)  = "001000") then
				reg_write <= '1'; 
				reg_dst <=  '0'; 
				reg_in_src <=  '0'; 
				alu_src <=  '1'; 
				addsub <=  '0'; 
				data_write <= '0';  
				logic <=  "00";
				the_func <= "10";
				branch_type <= "00";  
				pc_sel <= "00"; 
			--slti
			elsif(the_instruction(31 downto 26)  = "001010") then
				reg_write <= '1'; 
				reg_dst <=  '0'; 
				reg_in_src <=  '0'; 
				alu_src <=  '1'; 
				addsub <=  '0'; 
				data_write <= '0';  
				logic <=  "00";
				the_func <= "01";
				branch_type <= "00";  
				pc_sel <= "00"; 
			--andi
			elsif(the_instruction(31 downto 26)  = "001100") then
				reg_write <= '1'; 
				reg_dst <=  '0'; 
				reg_in_src <=  '0'; 
				alu_src <=  '1'; 
				addsub <=  '0'; 
				data_write <= '0';  
				logic <=  "00";
				the_func <= "11";
				branch_type <= "00";  
				pc_sel <= "00"; 
			--ori
			elsif(the_instruction(31 downto 26)  = "001101") then
				reg_write <= '1'; 
				reg_dst <=  '0'; 
				reg_in_src <=  '0'; 
				alu_src <=  '1'; 
				addsub <=  '0'; 
				data_write <= '0';  
				logic <=  "01";
				the_func <= "11";
				branch_type <= "00";  
				pc_sel <= "00"; 
			--xori
			elsif(the_instruction(31 downto 26)  = "001101") then
				reg_write <= '1'; 
				reg_dst <=  '0'; 
				reg_in_src <=  '0'; 
				alu_src <=  '1'; 
				addsub <=  '0'; 
				data_write <= '0';  
				logic <=  "10";
				the_func <= "11";
				branch_type <= "00";  
				pc_sel <= "00"; 
			--lw
			elsif(the_instruction(31 downto 26)  = "100011") then
				reg_write <= '1'; 
				reg_dst <=  '0'; 
				reg_in_src <=  '1'; 
				alu_src <=  '1'; 
				addsub <=  '0'; 
				data_write <= '0';  
				logic <=  "10";
				the_func <= "10";
				branch_type <= "00";  
				pc_sel <= "00"; 
			--sw
			elsif(the_instruction(31 downto 26)  = "101011") then
				reg_write <= '0'; 
				reg_dst <=  '0'; 
				reg_in_src <=  '1'; 
				alu_src <=  '1'; 
				addsub <=  '0'; 
				data_write <= '1';  
				logic <=  "00";
				the_func <= "10";
				branch_type <= "00";  
				pc_sel <= "00"; 
			--nor
			elsif(the_instruction(31 downto 26)  = "100111") then
				reg_write <= '1'; 	
				reg_dst <=  '1'; 	
				reg_in_src <=  '0'; 	
				alu_src <=  '0'; 	
				addsub <=  '0'; 
				data_write <= '0';  
				logic <=  "11";
				the_func <= "11";
				branch_type <= "00";  
				pc_sel <= "00"; 
			--jump
			elsif(the_instruction(31 downto 26)  = "000010") then
				reg_write <= '0';
				reg_dst <=  '0';
				reg_in_src <=  '0'; 
				alu_src <=  '0'; 
				addsub <=  '0'; 
				data_write <= '0';  
				logic <=  "00";
				the_func <= "00";
				branch_type <= "00";  
				pc_sel <= "01"; 
			--bltz
			elsif(the_instruction(31 downto 26)  = "000001") then
				reg_write <= '0'; 
				reg_dst <=  '0'; 
				reg_in_src <=  '0'; 
				alu_src <=  '0'; 
				addsub <=  '0'; 
				data_write <= '0';  
				logic <=  "00";
				the_func <= "00";
				branch_type <= "11";  
				pc_sel <= "00"; 
			--beq
			elsif(the_instruction(31 downto 26)  = "000100") then
				reg_write <= '0';
				reg_dst <=  '0';
				reg_in_src <=  '0'; 
				alu_src <=  '0'; 
				addsub <=  '0'; 
				data_write <= '0';  
				logic <=  "00";
				the_func <= "00";
				branch_type <= "01";  
				pc_sel <= "00"; 
			--bne
			elsif(the_instruction(31 downto 26)  = "000101") then
				reg_write <= '0'; 
				reg_dst <=  '0'; 
				reg_in_src <=  '0'; 
				alu_src <=  '0'; 
				addsub <=  '0'; 
				data_write <= '0';  
				logic <=  "00";
				the_func <= "00";
				branch_type <= "10";  
				pc_sel <= "00"; 

			elsif(the_instruction(31 downto 26)  = "000000")  then 
				--add
				if(the_instruction(5 downto 0)  = "100000") then
					reg_write <= '1'; 
					reg_dst <=  '1'; 
					reg_in_src <=  '0'; 
					alu_src <=  '0'; 
					addsub <=  '0'; 
					data_write <= '0'; 
					logic <= "00";
					the_func <= "10";
					branch_type <= "00";
					pc_sel <= "00";
				--sub
				elsif(the_instruction(5 downto 0) = "100010") then
					reg_write <= '1'; 
					reg_dst <=  '1'; 
					reg_in_src <=  '0'; 
					alu_src <=  '0'; 
					addsub <=  '1'; 
					data_write <= '0'; 
					logic <= "00";
					the_func <= "10";
					branch_type <= "00";
					pc_sel <= "00"; 
				--slt
				elsif(the_instruction(5 downto 0) = "101010") then
					reg_write <= '1'; 
					reg_dst <=  '1'; 
					reg_in_src <=  '0'; 
					alu_src <=  '0'; 
					addsub <=  '0'; 
					data_write <= '0'; 
					logic <= "00";
					the_func <= "01";
					branch_type <= "00";
					pc_sel <= "00"; 
				--and
				elsif(the_instruction(5 downto 0) = "100100") then
					reg_write <= '1'; 
					reg_dst <=  '1'; 
					reg_in_src <=  '0'; 
					alu_src <=  '0'; 
					addsub <=  '1'; 
					data_write <= '0'; 
					logic <= "00";
					the_func <= "11";
					branch_type <= "00";
					pc_sel <= "00"; 
				--or
				elsif(the_instruction(5 downto 0) = "100101") then
					reg_write <= '1'; 
					reg_dst <=  '1'; 
					reg_in_src <=  '0'; 
					alu_src <=  '0'; 
					addsub <=  '0'; 
					data_write <= '0'; 
					logic <= "01";
					the_func <= "11";
					branch_type <= "00";
					pc_sel <= "00"; 
				--xor
				elsif(the_instruction(5 downto 0) = "100110") then
					reg_write <= '1'; 
					reg_dst <=  '1'; 
					reg_in_src <=  '0'; 
					alu_src <=  '0'; 
					addsub <=  '0'; 
					data_write <= '0'; 
					logic <= "10";
					the_func <= "11";
					branch_type <= "00";
					pc_sel <= "00"; 
				--jump register
				else
					reg_write <= '0'; 
					reg_dst <=  '0'; 
					reg_in_src <=  '0'; 
					alu_src <=  '0'; 
					addsub <=  '0'; 
					data_write <= '0'; 
					logic <= "00";
					the_func <= "00";
					branch_type <= "00";
					pc_sel <= "10"; 
				end if;
			end if;
		end process;

		----------get the read values from the register
		registr : reg_comp port map(data_out,rst,clk,reg_write,the_instruction(20 downto 16), the_instruction(25 downto 21), write_reg,reg_one, reg_two);

		------------Sign Extend
		se : signex_comp port map(the_func, the_instruction(15 downto 0), immediate_se);

		-----------determine if we use immediate or register
		check : regmux_comp port map(alu_src, reg_two, immediate_se, reg_value);

		-----------alu
		a_l_u : alu_comp port map(reg_one, reg_value, addsub, logic, the_func, alu_out, alu_over, alu_zero);
		
		------------dcache
		data : dcache_comp port map(clk, rst, alu_out, data_write, reg_in_src, reg_one, data_out);

	rs_out <= reg_two(3 downto 0);
	rt_out <= reg_one(3 downto 0);
	pc_out <= lower_pc(3 downto 0);
	zero <= alu_zero;
	overflow <= alu_over;
		
end data_arch;
