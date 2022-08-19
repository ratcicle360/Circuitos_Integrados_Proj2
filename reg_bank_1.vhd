library IEEE;
use IEEE.std_logic_1164.all;



entity reg_bank_disc is 
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
end reg_bank_disc;


architecture arch of reg_bank_disc is

--***********************************
--*	TYPE DECLARATIONS				*
--***********************************

--***********************************
--*	COMPONENT DECLARATIONS			*
--***********************************

component reg_1
	generic
	(
	WIDTH	: natural  := 8
	);
	
   port
   (
   clk  : in  STD_LOGIC;
   clr  : in  STD_LOGIC;
   load : in  STD_LOGIC;
   d    : in  STD_LOGIC_VECTOR(WIDTH-1 downto 0);
   q	  : out STD_LOGIC_VECTOR(WIDTH-1 downto 0)
   );
end component;


--***********************************
--*	INTERNAL SIGNAL DECLARATIONS	*
--***********************************

signal DISC_out_s			: STD_LOGIC_VECTOR(WIDTH-1 downto 0);
signal PRE_DISC_out_s	: STD_LOGIC_VECTOR(WIDTH-1 downto 0);


begin

	--*******************************
	--*	COMPONENT INSTANTIATIONS	*
	--*******************************
	
	

	
	reg_DISC:	reg_1		generic map
						(
						WIDTH	=> WIDTH
						)
						
						port map
						(
									clk	   => clk , 
		                     clr      => res,
		                     load     => load_DISC, 
									d        => ng_2_RB,
									q        => DISC_out_s
						);
	
	
	
	reg_PRE_DISC:	reg_1		generic map
						(
						WIDTH	=> WIDTH
						)
						
						port map
						(
									clk	   => clk , 
		                     clr      => res,
		                     load     => load_PRE_DISC, 
									d        => DISC_out_s,
									q        => PRE_DISC_out_s
						);
	



						
	--*******************************
	--*	SIGNAL ASSIGNMENTS			*
	--*******************************
	
	rb_out			   <= 	
									DISC_out_s			when (out_sel = '0') else 	-- quando o seletor for 1, pega a posicação anterior do disc
									PRE_DISC_out_s 	when (out_sel = '1' ) else
									(others => 'X');
			
	disc_addr 	      <=    DISC_out_s;
	disc_prev_addr 	<=    PRE_DISC_out_s;

end arch;
