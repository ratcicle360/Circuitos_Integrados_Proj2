Library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity rc_adder_2 is
	generic
	(
	WIDTH	: natural := 8
	);
	port
	(
	a_i, b_i		:	in STD_LOGIC_VECTOR (WIDTH-1 downto 0);
	z_out		:	out STD_LOGIC_VECTOR (WIDTH-1 downto 0);
	c_i			:	in STD_LOGIC;
	c_o			:	out STD_LOGIC
	);
	
end rc_adder_2;


architecture structural of rc_adder_2 is


	COMPONENT full_adder 
		port ( a_in, b_in, c_in		:	in STD_LOGIC;
				z_out, c_out		:	out STD_LOGIC);
	END COMPONENT;
	
  
  
signal carry	: STD_LOGIC_VECTOR (WIDTH-1 downto 0);  -- auxiliary signal carry(x) means carry_out of stage x

begin

-- seguir template 


-- FOR generate para todos os WIDTH bits
	g1: for i in width-1 downto 0 generate
		
--      IF generate para caso LSB
		lsb: if i= 0 generate
			ult_bit: full_adder port map(a_in=>a_i(i),b_in=>b_i(i),c_in => c_i,
											c_out => carry(i),z_out=>z_out(i));
			end generate lsb;
--		fechar IF 
		msb: if i>0 generate
			
			outros_bits: full_adder port map(a_in=>a_i(i),b_in=>b_i(i),c_in => carry(i-1),
											c_out => carry(i),z_out=>z_out(i));

--      IF generate para caso MSB
		end generate msb;
	end generate g1;
	
	c_o <= carry(width-1);
--		fechar IF 




--		IF generate para demais casos


--		fechar IF 
		


-- fechar FOR



end structural;



