
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
    -- adotar os mesmos tipos declarados no projeto do wisdom circuit   


ENTITY Disciple_Control IS
	PORT ( 	rst			: IN STD_LOGIC;
			clk 		: IN STD_LOGIC;
			
			star_step 	: IN STD_LOGIC;
			
			cnt_disc_rdy	: IN STD_LOGIC;
			
			go_disc :IN STD_LOGIC;
			
			duo_formed: IN STD_LOGIC;
			
			guru_right_behind: IN std_logic;
			
			end_of_disc : in std_logic;
				
			ula_control	: OUT std_logic;
			
			disc_wr_en : OUT STD_LOGIC;
			
			reg_control : out std_logic_vector(2 downto 0);
			
			sel_control : out std_logic_vector(1 downto 0);
			
			after_duo : out std_logic;
			
			rand_control : out std_logic);
			
			

END Disciple_Control;

ARCHITECTURE arc OF Disciple_Control IS
	TYPE state_type IS (START_WALKING,RAND,WRITE_RAND, WAIT_COUNT_DISC ,INCR,  CHECK_SAME_ADDR,  WRITE_DUO, WRITE_DISC ,CHECK_LAST,CLEAR_LAST, LAST ,CHECK_PREV ,CLEAR_PREV, CLEAR_AFTER_DUO);
	SIGNAL state, next_state : state_type;
	
BEGIN
	------------------------Lógica Sequencial-----------------------
	SEQ: PROCESS (rst, clk)
	BEGIN
		IF (rst='1') THEN
			state <= START_WALKING;
		ELSIF Rising_Edge(clk) THEN
			state <= next_state;
		END IF;
	END PROCESS SEQ;
	-----------------------Lógica Combinacional do estado siguinte--
	COMB: PROCESS (rst, clk, star_step, cnt_disc_rdy, go_disc, duo_formed, guru_right_behind, end_of_disc, state)  
	BEGIN
		CASE state IS
	
			WHEN START_WALKING =>
				IF ( star_step = '1') THEN
					next_state <= RAND;
				ELSE
					next_state <= START_WALKING;
				END IF;
			WHEN RAND =>
				next_state <= WRITE_RAND;

			WHEN WRITE_RAND =>	
				next_state <= WAIT_COUNT_DISC;
				
			WHEN WAIT_COUNT_DISC =>
				if(cnt_disc_rdy = '1') then
					next_state <= INCR;
				else	
					next_state <= WAIT_COUNT_DISC;
				end if;
					
			WHEN INCR => 
					next_state <= CHECK_LAST;
			
			WHEN CHECK_LAST =>
					if(go_disc = '1' and end_of_disc ='1') then
						next_state <= LAST;
					 
					elsif(go_disc = '1' and end_of_disc ='0') then
					    next_state <= CHECK_SAME_ADDR;
						
					else 
					    next_state <= CHECK_LAST;
						
					end if;
						
			WHEN CHECK_SAME_ADDR =>
			        if (duo_formed = '1') then
					    next_state <= WRITE_DUO;
					else 
					    next_state <= WRITE_DISC;
					end if;
			
			WHEN WRITE_DUO =>
			        next_state <= CLEAR_AFTER_DUO;
			
			WHEN WRITE_DISC	=>
			       next_state <= CHECK_PREV; 
				   
			WHEN CHECK_PREV	=>
			        if (guru_right_behind = '1') then
					    next_state <= WAIT_COUNT_DISC;
					else 
					    next_state <= CLEAR_PREV;
					end if;
						
			WHEN CLEAR_PREV	=>
			        next_state <= WAIT_COUNT_DISC;
					
		    WHEN LAST =>
			       if (guru_right_behind = '1') then
				        next_state <= START_WALKING;
                    else
                        next_state <= CLEAR_LAST;
					end if;

            WHEN CLEAR_LAST =>
			        next_state <= START_WALKING; 
             
			WHEN CLEAR_AFTER_DUO =>
					next_state <= START_WALKING;
		END CASE;
	END PROCESS COMB;

	-----------------------Lógica Combinacional saidas---------------------
	SAI: PROCESS (state)
	BEGIN
		CASE state IS

			WHEN START_WALKING =>
				ula_control	<= '0';
			    disc_wr_en <= '0';
			    reg_control <= "000";  --Não precisa carregar nenhum endereço
				sel_control <= "00";
				rand_control <= '0';
				after_duo <= '0';
			WHEN RAND =>
				ula_control	<= '0';
			    disc_wr_en <= '0';
			    reg_control <= "010";   --Carrega o endereço atual do disc com o numero aleatorio
				sel_control <= "00";
				rand_control <= '1';
				after_duo <= '0';
				
			WHEN WRITE_RAND =>
				ula_control	<= '0';
			    disc_wr_en <= '1';
			    reg_control <= "001"; -- Carrega o endereço antigo do disc com o endereço atual
				sel_control <= "01";
				rand_control <= '0';
				after_duo <= '0';
				
			WHEN WAIT_COUNT_DISC =>
			    ula_control	<= '0';
			    disc_wr_en <= '0';
			    reg_control <= "000"; 
				sel_control <= "00";
				rand_control <= '0'; 
				after_duo <= '0';
				
			WHEN INCR =>
			    ula_control	<= '1';
			    disc_wr_en <= '0';
			    reg_control <= "011";  -- Carrega o endereço atual do disc com o resultado da alu no proximo clock, e o coloca o valor atual no antigo.
				sel_control <= "00";
				rand_control <= '0';
				after_duo <= '0';
				
			WHEN CHECK_LAST =>	
			    ula_control	<= '1';
			    disc_wr_en <= '0';
			    reg_control <= "000";  -- Não precisa carregar nada
				sel_control <= "00";
				rand_control <= '0';
				after_duo <= '0';
				
			WHEN CHECK_SAME_ADDR =>
				ula_control	<= '0';
			    disc_wr_en <= '0';
			    reg_control <= "000";
				sel_control <= "00";
				rand_control <= '0';
				after_duo <= '0';
				
			WHEN WRITE_DUO =>
				ula_control	<= '0';
			    disc_wr_en <= '1';
			    reg_control <= "000";
				sel_control <="11";
				rand_control <= '0';
				after_duo <= '0';
				
			WHEN WRITE_DISC	=>
				ula_control	<= '0';
			    disc_wr_en <= '1';
			    reg_control <= "000";
				sel_control <= "01";
				rand_control <= '0';
				after_duo <= '0';
				
			WHEN CHECK_PREV	=>
				ula_control	<= '0';
			    disc_wr_en <= '0';
			    reg_control <= "000";
				sel_control <= "00";
				rand_control <= '0';
				after_duo <= '0';
				
			WHEN CLEAR_PREV	=>
				ula_control	<= '0';
			    disc_wr_en <= '1';
			    reg_control <= "100";
				sel_control <= "00";
				rand_control <= '0';
				after_duo <= '0';
				
			WHEN LAST =>
				ula_control	<= '0';
			    disc_wr_en <= '0';
			    reg_control <= "000";
				sel_control <= "00";
				rand_control <= '0';
				after_duo <= '0';
				
			WHEN CLEAR_LAST =>
				ula_control	<= '0';
			    disc_wr_en <= '1';
			    reg_control <= "100";
				sel_control <= "00";
				rand_control <= '0';
				after_duo <= '0';
				
			WHEN CLEAR_AFTER_DUO =>
				ula_control	<= '0';
			    disc_wr_en <= '1';
			    reg_control <= "100";
				sel_control <= "00";
				rand_control <= '0';
				after_duo <= '1';
				
		END CASE;
	END PROCESS SAI;

END arc;