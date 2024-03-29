Library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity full_adder is
	port
	(
	a_in, b_in, c_in		:	in STD_LOGIC;
	z_out, c_out		:	out STD_LOGIC
	);
	
end full_adder;



architecture dataflow of full_adder is

signal aux_xor, aux_and_1, aux_and_2, aux_and_3	: STD_LOGIC;

begin

	z_out <= aux_xor xor c_in AFTER 4 ns;
     aux_xor <= a_in xor b_in AFTER 4 ns;
     aux_and_1 <= a_in and b_in AFTER 3 ns; 
     aux_and_2 <= a_in and c_in AFTER 3 ns; 
	c_out <= aux_and_1 or aux_and_2 or aux_and_3 AFTER 5 ns; 
	aux_and_3 <= b_in and c_in AFTER 3 ns; 
	
end dataflow;