library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;


entity datapath_disc is
	generic
	(
	Size		: NATURAL	:= 8
	);
	
	port(
			clk,res	: in std_logic;
			
		    ula_control	: in std_logic;
			
			disc_wr_en_in : in STD_LOGIC;
			
			reg_control : in std_logic_vector(2 downto 0); -- O 1 bit carrega o endereço atual e o bit 0 carrega o endereço anterior quando forem 1.
														   -- o bit 2 é o controle do seletor do reg_bank. Quando 1, a saída é o endereço anterior do disc.
			
			sel_control : in std_logic_vector(1 downto 0);
			
			rand_control : in std_logic;
			
			after_duo : in std_logic;
			
			end_of_disciple : out std_logic;
			
			disc_wr_en : out std_logic;
			
			disc_addr :out std_logic_vector(Size-3 downto 0);
					
			disc_addr_prev :out std_logic_vector(Size-3 downto 0);
			
			disc_address_2_mem :out std_logic_vector(Size-3 downto 0);
			
			disc_data :out std_logic_vector(Size-1 downto 0)
			
			);
end datapath_disc;

architecture arc of datapath_disc is
	
	component alu_1 is 
	generic 
	(
	WIDTH		: NATURAL	:= 8
	);

	port(
	one_op		     : in STD_LOGIC_VECTOR(WIDTH-1 downto 0); -- uma constante (00000001).
	rb_op			     : in STD_LOGIC_VECTOR(WIDTH-1 downto 0); -- operandos Rb_op são oriundos de Reg Bank (saídas de REG_GURU ou REG_INIT).
	alu_ctrl         : in STD_LOGIC;                          -- controle a saida da ula: 
	alu_result		  : out STD_LOGIC_VECTOR(WIDTH-1 downto 0) -- resultado_soma(proxima posicao do GURU) ou posicao atual do GURU
	);
	end component;
	
	component code_gen_1 is
    generic(
	SIZE : Natural := 8
	);
    port(
        sel_control     : in STD_LOGIC_VECTOR(1 downto 0);
       
		
		q : out STD_LOGIC_VECTOR(SIZE-1 downto 0)
    );
	end component;
	
	component mux is
    generic(
	SIZE : Natural := 6
	);
    port(
         rand_control     : in STD_LOGIC;
        q_rand,q_alu       : in STD_LOGIC_VECTOR(SIZE -1 downto 0);
		
		q : out STD_LOGIC_VECTOR(SIZE-1 downto 0)
    );
	end component;
	
	component reg_bank_disc is 
	generic
	(
	WIDTH		: NATURAL	:= 8
	);

	port
	(
	clk			    : in STD_LOGIC;
	res			    : in STD_LOGIC;
	ng_2_RB         : in STD_LOGIC_VECTOR(WIDTH-1 downto 0);
	load_DISC	    : in STD_LOGIC;
	load_PRE_DISC  : in STD_LOGIC;
	out_sel		    : in STD_LOGIC;
	disc_addr       : out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
	disc_prev_addr  : out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
	rb_out		    : out STD_LOGIC_VECTOR(WIDTH-1 downto 0)
	);
	end component;
	
	component rand_num_1 is
    generic(
    SIZE: NATURAL := 8
    );
    port(
        clk, res: in STD_LOGIC;
        q       : out STD_LOGIC_VECTOR(SIZE -1 downto 0)
    );
	end component;
	
	signal 		end_of_disciple_s : std_logic;
			
	signal		disc_wr_en_s : std_logic;
			
	signal		disc_addr_s :  std_logic_vector(Size-3 downto 0);
					
	signal		disc_addr_prev_s: std_logic_vector(Size-3 downto 0);
			
	signal		disc_address_2_mem_s :std_logic_vector(Size-3 downto 0);
			
	signal		disc_data_s :	std_logic_vector(Size-1 downto 0);
	
	signal		alu_result_s: std_logic_vector(Size-3 downto 0);
	
	signal		rand_data_s: std_logic_vector(Size-3 downto 0);
	
	signal		q_out_mux_s: std_logic_vector(Size-3 downto 0);
	
	signal		q_data_s : std_logic_vector(Size-1 downto 0);
	
	signal 		rb_out_s : std_logic_vector(Size-3 downto 0);
	
	begin
	
	alu1: alu_1 	generic map(
						width => 6
							)
				port map(
						one_op => "111000",	-- Constante de -8 em complemento de 2
						rb_op  => disc_addr_s,
						alu_ctrl => ula_control,
						alu_result => alu_result_s
						);
						
	num_gen1: rand_num_1 generic map(
						Size => 6
							)
						port map(
						clk => clk,
						res => res,
						q => rand_data_s
						);
						
	mux1: 	mux generic map(
						Size => 6
						)
				port map(
					rand_control => rand_control,
					q_rand => rand_data_s,
					q_alu => alu_result_s,
					q	=>	q_out_mux_s);
	
	code_gen1 : code_gen_1 generic map(
						Size => Size
						)
						
						port map(
						sel_control => sel_control,
						q => disc_data_s
						);
						
	RB:	reg_bank_disc generic map(
						width => size-2
						)
						port map(
						clk => clk,
						res=>res,
						ng_2_RB=>q_out_mux_s,
						load_DISC => reg_control(1),
						load_PRE_DISC => reg_control(0),
						out_sel => reg_control(2),
						disc_addr => disc_addr_s,
						disc_prev_addr => disc_addr_prev_s,
						rb_out => rb_out_s
						);
						
	end_of_disciple_s <= '1' when (disc_addr_prev_s = "000100" or disc_addr_prev_s = "000101" or disc_addr_prev_s = "000110" or disc_addr_prev_s = "000111" or after_duo ='1')
							 else '0';
	
	end_of_disciple <= end_of_disciple_s;
	
	disc_wr_en <= disc_wr_en_in;
	
	disc_addr <= disc_addr_s;
	
	disc_addr_prev <= disc_addr_prev_s;
	
	disc_address_2_mem <= rb_out_s;
	
	disc_data <= disc_data_s;
	
end arc;