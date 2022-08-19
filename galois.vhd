library ieee;
use ieee.std_logic_1164.all;

entity galois is
    generic(
    SIZE : NATURAL := 12;
    a: NATURAL:=3; -- Coeficientes do polinomio
    b: NATURAL:=7
    );

    port(
    res, clk : in  STD_LOGIC;
    q        : out STD_LOGIC_vector(SIZE-1 downto 0)
    );


end galois;

architecture arch of galois is
    signal q_s : STD_LOGIC_VECTOR(SIZE-1 downto 0);
    signal a_s :STD_LOGIC;
    signal b_s: STD_LOGIC;
    
    component ffd is
        port(
            clock,d, reset : in STD_LOGIC;
            q              : out STD_LOGIC
        );
    end component;
begin
    a_s <= (q_s(SIZE-1) XOR q_s(a-1) );
    b_s <= (q_s(SIZE-1) XOR q_s(b-1) );

    gal: for i in SIZE-1 downto 0 generate
        LSB:  if(i=0) generate
        lsbb:     ffd port map(clock => clk, d=> (q_s(SIZE-1)), reset=> res, q=>q_s(i));
            end generate;
        coef_a:      if(i=a) generate
        a:        ffd port map(clock => clk, d=>a_s , reset=> res, q=>q_s(i));
            end generate;
        coef_b:     if(i=b) generate
        b:        ffd port map(clock => clk, d=> b_s, reset=> res, q=>q_s(i));
            end generate;
        elses:      if(i/=0 AND i/=a AND i/=b) generate
        outros:        ffd port map(clock => clk, d=> q_s(i-1) , reset=> res, q=>q_s(i));  
            end generate;
    end generate gal;

    q<=q_s;
    
end arch;