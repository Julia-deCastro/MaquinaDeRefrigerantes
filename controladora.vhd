library ieee;
use ieee.std_logic_1164.all;

entity controladora is
	port (
		    CLOCK      :    in std_logic;
			 
		CEDULA_SIGNAL			: in std_logic;
		MOEDA_SIGNAL			: in std_logic;
		SELECT_1             : in std_logic;
		SELECT_2             : in std_logic;
		CONFIRMA				   : in std_logic;
		CANCELA				   : in std_logic;
		
		LIBERAR					: out std_logic;
		TROCO				      : out std_logic;
		FREE_CASH				: out std_logic;
		
		VALOR_INSERIDO_LD		: out std_logic;
		VALOR_INSERIDO_CLR	: out std_logic;
		VALOR_REFRI1_LD		: out std_logic;
		VALOR_REFRI1_CLR		: out std_logic;
		VALOR_REFRI2_LD		: out std_logic;
		VALOR_REFRI2_CLR		: out std_logic;
		ESTOQUE1_LD				: out std_logic;
		ESTOQUE1_CLR			: out std_logic;
		ESTOQUE2_LD				: out std_logic;
		ESTOQUE2_CLR			: out std_logic;
		RG_REFRI_LD    		: out std_logic;
		RG_REFRI_CLR 			: out std_logic;
		--SELECT_ 					: out std_logic;
		

		VI_eq_VR1				: in std_logic; 		-- Valor inserido = Valor Refri 1
		VI_gt_VR1				: in std_logic;  		-- Valor inserido > Valor Refri 1 
		VI_eq_VR2				: in std_logic; 		-- Valor inserido = Valor Refri 2
		VI_gt_VR2				: in std_logic;  		-- Valor inserido > Valor Refri 2
		SELECTED_REFRI			: in std_logic;		-- Refri selecionado
		ESTOQUE1_gt_O 			: in std_logic;		-- Estoque 1 > 0
		ESTOQUE2_gt_O 			: in std_logic			-- Estoque 2 > 0
	
	);
end controladora;

architecture RTL of controladora is 

	type State_type is (INICIAR, ESPERA, CANCELAR, COCA, GUARANA, MOEDA, CEDULA, LIBERAR_1,
							  LIBERAR_2, TROCO_1, TROCO_2);
	
	signal estado_atual : State_type := INICIAR;
	
begin

	sequencial:
	process(CEDULA_SIGNAL, MOEDA_SIGNAL, SELECT_1, SELECT_2, CONFIRMA, CANCELA, 
			  VI_eq_VR1, VI_gt_VR1, VI_eq_VR2, VI_gt_VR2, SELECTED_REFRI, ESTOQUE1_gt_O, ESTOQUE2_gt_O) is
	variable ESTADO : State_type;
	begin	
		if (rising_edge(CLOCK)) then
			case estado_atual is
				when INICIAR =>	

					estado_atual <= ESPERA;
					
			
				when ESPERA =>
					
					if (((SELECT_1='1') and (SELECT_2 ='0')) and (ESTOQUE1_gt_O='1')) then
						estado_atual <= COCA;
					elsif (((SELECT_1='0') and (SELECT_2 ='1')) and (ESTOQUE1_gt_O='0')) then
						estado_atual <= GUARANA;
					else
						estado_atual <= ESPERA;
					end if;
					
						
				when CANCELAR =>
					
					estado_atual <= INICIAR;
															
				
				when COCA =>
					
					if ((VI_eq_VR1='1') and (CONFIRMA='1')) then
						estado_atual <= LIBERAR_1;
					elsif ((VI_gt_VR1='1') and (CONFIRMA='1')) then
						estado_atual <= TROCO_1;
					elsif (CANCELA='1') then
						estado_atual <= CANCELAR;
					elsif (MOEDA_SIGNAL='1') then
						estado_atual <= MOEDA;
					elsif (CEDULA_SIGNAL='1') then
						estado_atual <= CEDULA;
					else
						estado_atual <= COCA;
					end if;
					
			
				when GUARANA =>
					
					if ((VI_eq_VR2='1') and (CONFIRMA='1')) then
						estado_atual <= LIBERAR_1;
					elsif ((VI_gt_VR2='1') and (CONFIRMA='1')) then
						estado_atual <= TROCO_1;
					elsif (CANCELA='1') then
						estado_atual <= CANCELAR;
					elsif (MOEDA_SIGNAL='1') then
						estado_atual <= MOEDA;
					elsif (CEDULA_SIGNAL='1') then
						estado_atual <= CEDULA;
					else
						estado_atual <= GUARANA;
					end if;
			
			
				when MOEDA =>
					
					if (CANCELA='1') then
						estado_atual <= CANCELAR;
					elsif (SELECTED_REFRI='1') then
						estado_atual <= COCA;
					else
						estado_atual <= GUARANA;
					end if;
					
					
				when  CEDULA =>
					
					if (CANCELA='1') then
						estado_atual <= CANCELAR;
					elsif (SELECTED_REFRI='1') then
						estado_atual <= COCA;
					else
						estado_atual <= GUARANA;
					end if;
														
				
				when LIBERAR_1 =>
					
					estado_atual <= INICIAR;
					
					
				when LIBERAR_2 =>
					
					estado_atual <= INICIAR;
					
					
				when TROCO_1 =>
					
					estado_atual <= INICIAR;
				
				
				when TROCO_2 =>
					
					estado_atual <= INICIAR;
					
			
			end case;
		end if;
	end process;
	
	combinational:
	process(estado_atual) is
	begin
		case estado_atual is
		when INICIAR =>
			
		LIBERAR <='0';
		TROCO <='0';
		FREE_CASH <='0';
		VALOR_INSERIDO_LD <='0';
		VALOR_INSERIDO_CLR <='1';
		VALOR_REFRI1_LD <='0';
		VALOR_REFRI1_CLR <='0';
		VALOR_REFRI2_LD <='0';
		VALOR_REFRI2_CLR <='0';
		ESTOQUE1_LD <='0';
		ESTOQUE1_CLR <='0';
		ESTOQUE2_LD <='0';
		ESTOQUE2_CLR <='0';
		RG_REFRI_LD <='0';
		RG_REFRI_CLR <='0';
		--SELECT_ <='0';
		
	
		when ESPERA =>
			
		LIBERAR <='0';
		TROCO <='0';
		FREE_CASH <='0';
		VALOR_INSERIDO_LD <='0';
		VALOR_INSERIDO_CLR <='0';
		VALOR_REFRI1_LD <='0';
		VALOR_REFRI1_CLR <='0';
		VALOR_REFRI2_LD <='0';
		VALOR_REFRI2_CLR <='0';
		ESTOQUE1_LD <='0';
		ESTOQUE1_CLR <='0';
		ESTOQUE2_LD <='0';
		ESTOQUE2_CLR <='0';
		RG_REFRI_LD <='0';
		RG_REFRI_CLR <='0';
		--SELECT_ <='0';
				
		when CANCELAR =>
			
		LIBERAR <='0';
		TROCO <='0';
		FREE_CASH <='1';
		VALOR_INSERIDO_LD <='0';
		VALOR_INSERIDO_CLR <='0';
		VALOR_REFRI1_LD <='0';
		VALOR_REFRI1_CLR <='0';
		VALOR_REFRI2_LD <='0';
		VALOR_REFRI2_CLR <='0';
		ESTOQUE1_LD <='0';
		ESTOQUE1_CLR <='0';
		ESTOQUE2_LD <='0';
		ESTOQUE2_CLR <='0';
		RG_REFRI_LD <='0';
		RG_REFRI_CLR <='0';
		--SELECT_ <='0';
			
		when COCA =>
			
		LIBERAR <='0';
		TROCO <='0';
		FREE_CASH <='0';
		VALOR_INSERIDO_LD <='0';
		VALOR_INSERIDO_CLR <='0';
		VALOR_REFRI1_LD <='0';
		VALOR_REFRI1_CLR <='0';
		VALOR_REFRI2_LD <='0';
		VALOR_REFRI2_CLR <='0';
		ESTOQUE1_LD <='0';
		ESTOQUE1_CLR <='0';
		ESTOQUE2_LD <='0';
		ESTOQUE2_CLR <='0';
		RG_REFRI_LD <='1';
		RG_REFRI_CLR <='0';
		--SELECT_ <='0';
			
		when GUARANA =>
			
		LIBERAR <='0';
		TROCO <='0';
		FREE_CASH <='0';
		VALOR_INSERIDO_LD <='0';
		VALOR_INSERIDO_CLR <='0';
		VALOR_REFRI1_LD <='0';
		VALOR_REFRI1_CLR <='1';
		VALOR_REFRI2_LD <='0';
		VALOR_REFRI2_CLR <='0';
		ESTOQUE1_LD <='0';
		ESTOQUE1_CLR <='0';
		ESTOQUE2_LD <='0';
		ESTOQUE2_CLR <='0';
		RG_REFRI_LD <='0';
		RG_REFRI_CLR <='0';
		---SELECT_ <='0';
			
		when  MOEDA =>
			
		LIBERAR <='0';
		TROCO <='0';
		FREE_CASH <='0';
		VALOR_INSERIDO_LD <='1';
		VALOR_INSERIDO_CLR <='0';
		VALOR_REFRI1_LD <='0';
		VALOR_REFRI1_CLR <='0';
		VALOR_REFRI2_LD <='0';
		VALOR_REFRI2_CLR <='0';
		ESTOQUE1_LD <='0';
		ESTOQUE1_CLR <='0';
		ESTOQUE2_LD <='0';
		ESTOQUE2_CLR <='0';
		RG_REFRI_LD <='0';
		RG_REFRI_CLR <='0';
		--SELECT_ <='0';
		
		when CEDULA =>
			
		LIBERAR <='0';
		TROCO <='0';
		FREE_CASH <='0';
		VALOR_INSERIDO_LD <='1';
		VALOR_INSERIDO_CLR <='0';
		VALOR_REFRI1_LD <='0';
		VALOR_REFRI1_CLR <='0';
		VALOR_REFRI2_LD <='0';
		VALOR_REFRI2_CLR <='0';
		ESTOQUE1_LD <='0';
		ESTOQUE1_CLR <='0';
		ESTOQUE2_LD <='0';
		ESTOQUE2_CLR <='0';
		RG_REFRI_LD <='0';
		RG_REFRI_CLR <='0';
		--SELECT_ <='0';
			
		when LIBERAR_1 =>
			
		LIBERAR <='1';
		TROCO <='0';
		FREE_CASH <='0';
		VALOR_INSERIDO_LD <='0';
		VALOR_INSERIDO_CLR <='0';
		VALOR_REFRI1_LD <='0';
		VALOR_REFRI1_CLR <='0';
		VALOR_REFRI2_LD <='0';
		VALOR_REFRI2_CLR <='0';
		ESTOQUE1_LD <='1';
		ESTOQUE1_CLR <='0';
		ESTOQUE2_LD <='0';
		ESTOQUE2_CLR <='0';
		RG_REFRI_LD <='0';
		RG_REFRI_CLR <='0';
		--SELECT_ <='0';
		
		when LIBERAR_2 =>
			
		LIBERAR <='1';
		TROCO <='0';
		FREE_CASH <='0';
		VALOR_INSERIDO_LD <='0';
		VALOR_INSERIDO_CLR <='0';
		VALOR_REFRI1_LD <='0';
		VALOR_REFRI1_CLR <='0';
		VALOR_REFRI2_LD <='0';
		VALOR_REFRI2_CLR <='0';
		ESTOQUE1_LD <='0';
		ESTOQUE1_CLR <='0';
		ESTOQUE2_LD <='1';
		ESTOQUE2_CLR <='0';
		RG_REFRI_LD <='0';
		RG_REFRI_CLR <='0';
		--SELECT_ <='0';
		
		when TROCO_1 =>
		
		LIBERAR <='1';
		TROCO <='0';
		FREE_CASH <='1';
		VALOR_INSERIDO_LD <='0';
		VALOR_INSERIDO_CLR <='0';
		VALOR_REFRI1_LD <='0';
		VALOR_REFRI1_CLR <='0';
		VALOR_REFRI2_LD <='0';
		VALOR_REFRI2_CLR <='0';
		ESTOQUE1_LD <='1';
		ESTOQUE1_CLR <='0';
		ESTOQUE2_LD <='0';
		ESTOQUE2_CLR <='0';
		RG_REFRI_LD <='0';
		RG_REFRI_CLR <='0';
		--SELECT_ <='0';
	
		when TROCO_2 =>
			
		LIBERAR <='1';
		TROCO <='0';
		FREE_CASH <='1';
		VALOR_INSERIDO_LD <='0';
		VALOR_INSERIDO_CLR <='0';
		VALOR_REFRI1_LD <='0';
		VALOR_REFRI1_CLR <='0';
		VALOR_REFRI2_LD <='0';
		VALOR_REFRI2_CLR <='0';
		ESTOQUE1_LD <='0';
		ESTOQUE1_CLR <='0';
		ESTOQUE2_LD <='1';
		ESTOQUE2_CLR <='0';
		RG_REFRI_LD <='0';
		RG_REFRI_CLR <='0';
		--SELECT_ <='0';
		
	
	end case;
	end process;
	
end RTL;