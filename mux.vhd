library ieee;
use ieee.std_logic_1164.all;

entity mux is
    generic(
	SIZE : Natural := 6
	);
    port(
         rand_control     : in STD_LOGIC;
        q_rand,q_alu       : in STD_LOGIC_VECTOR(SIZE -1 downto 0);
		
		q : out STD_LOGIC_VECTOR(SIZE-1 downto 0)
    );
end mux;

architecture arq of mux is

begin
    
	process (rand_control,q_rand,q_alu)
	begin
		if(rand_control = '0') then
			q <= q_alu;
		else
			q <= q_rand;
		end if;
	end process;
end arq;