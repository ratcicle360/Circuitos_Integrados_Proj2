library ieee;
use ieee.std_logic_1164.all;

entity code_gen_1 is
    generic(
	SIZE : Natural := 8
	);
    port(
        sel_control     : in STD_LOGIC_VECTOR(1 downto 0);
       
		
		q : out STD_LOGIC_VECTOR(SIZE-1 downto 0)
    );
end code_gen_1;

architecture arq of code_gen_1 is

begin 

	process (sel_control)
	begin
		if(sel_control = "01") then
			q <= "00000100"; --Codigo de  Discipulo
		elsif(sel_control ="00") then
			q <= "00000001"; --Codigo de Blank
		elsif(sel_control = "11") then
			q <= "00001000"; --Codigo de Duo
		else
			q <= "00000000";
		end if;
	end process;
end arq;