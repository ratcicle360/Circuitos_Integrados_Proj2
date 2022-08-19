library ieee;
use ieee.std_logic_1164.all;

entity disciple_circuit is 
		generic
		(
		WIDTH				   : NATURAL	:= 8
		);
		port
		(
		clock					: in  STD_LOGIC;						
		reset					: in  STD_LOGIC;						
	    cnt_disc_rdy		: in  STD_LOGIC;						--from counter
	    start_step     	: in STD_LOGIC;					
		go_disc           : in  STD_LOGIC;	

		duo_formed        : in  STD_LOGIC;
		guru_right_behind  : in  STD_LOGIC;
	
		end_of_disciple		:  out  STD_LOGIC;
		disc_wr_en 		 	: out STD_LOGIC;
		disc_data       	: out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
	    disc_address_to_mem       	: out STD_LOGIC_VECTOR(WIDTH-3 downto 0);
		disc_address       	: out STD_LOGIC_VECTOR(WIDTH-3 downto 0);
		disc_address_prev  	: out STD_LOGIC_VECTOR(WIDTH-3 downto 0)
		);
	end  entity;
	
architecture arc of disciple_circuit is
	
	component datapath_disc is
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
			
			after_duo : in std_logic;
			
			rand_control : in std_logic;
			
			end_of_disciple : out std_logic;
			
			disc_wr_en : out std_logic;
			
			disc_addr :out std_logic_vector(Size-3 downto 0);
					
			disc_addr_prev :out std_logic_vector(Size-3 downto 0);
			
			disc_address_2_mem :out std_logic_vector(Size-3 downto 0);
			
			disc_data :out std_logic_vector(Size-1 downto 0)
			
			);
	end component;
	
	component Disciple_Control IS
	PORT ( 	rst			: IN STD_LOGIC;
			clk 		: IN STD_LOGIC;
			
			star_step 	: IN STD_LOGIC;
			
			cnt_disc_rdy	: IN STD_LOGIC;
			
			go_disc :IN STD_LOGIC;
			
			duo_formed: IN STD_LOGIC;
			
			guru_right_behind: IN std_logic;
			
			after_duo: out std_logic;
			
			end_of_disc : in std_logic;
				
			ula_control	: OUT std_logic;
			
			disc_wr_en : OUT STD_LOGIC;
			
			reg_control : out std_logic_vector(2 downto 0);
			
			sel_control : out std_logic_vector(1 downto 0);
			
			rand_control : out std_logic);

	END component;
	
	signal ula_control_s: std_logic;
	signal disc_wr_en_s: std_logic;
	signal disc_wr_en_s1: std_logic;
	signal reg_control_s: std_logic_vector(2 downto 0);
	signal sel_control_S: std_logic_vector(1 downto 0);
	signal rand_control_s: std_logic;
	signal end_of_disciple_s: std_logic;
	signal disc_addr_s: std_logic_vector(width -3 downto 0);
	signal disc_addr_prev_s : std_logic_vector(width-3 downto 0);
	signal disc_address_2_mem_s: std_logic_vector(width-3 downto 0);
	signal disc_data_s	: std_logic_vector(width-1 downto 0);
	signal after_duo_s: std_logic;
	begin
	
	DD: datapath_disc generic map (
						Size => Width
						)
						
						port map (
						clk => clock,
						res => reset,
						after_duo => after_duo_s,
						ula_control => ula_control_s,
						disc_wr_en_in => disc_wr_en_s,
						reg_control => reg_control_s,
						sel_control =>  sel_control_S,
						rand_control => rand_control_s,
						end_of_disciple=>end_of_disciple_s,
						disc_wr_en => disc_wr_en_s1,
						disc_addr => disc_addr_s,
						disc_addr_prev => disc_addr_prev_s,
						disc_address_2_mem=>disc_address_2_mem_s,
						disc_data => disc_data_s
						);
						
	DC: Disciple_Control port map
						(clk=> clock,
						rst => reset,
						star_step => start_step,
						cnt_disc_rdy=>cnt_disc_rdy,
						go_disc => go_disc,
						duo_formed => duo_formed,
						after_duo => after_duo_s,
						guru_right_behind => guru_right_behind,
						end_of_disc => end_of_disciple_s,
						ula_control => ula_control_s,
						disc_wr_en => disc_wr_en_s,
						reg_control => reg_control_s,
						sel_control => sel_control_S,
						rand_control=>rand_control_s
						);
	
	end_of_disciple <= end_of_disciple_s;
	disc_wr_en <= disc_wr_en_s1;
	disc_address<= disc_addr_s;
	disc_address_prev <= disc_addr_prev_s;
	disc_address_to_mem <= disc_address_2_mem_s;
	disc_data <= disc_data_s;
	
end arc;
						
						
						
						
	
	