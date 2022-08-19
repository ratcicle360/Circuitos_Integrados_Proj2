library ieee;
use ieee.std_logic_1164.all;


entity ffd is
  port (
    clock, d, reset: in STD_LOGIC;
    q: out STD_LOGIC
  );
end entity;

architecture processor of ffd is
begin
  sequencial: process(clock, reset)
  begin
    if reset='1' then
      q <= '1';
    elsif clock'event and clock = '1' then
      q <= d;
    end if;
  end process;
end architecture;