library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is

	generic 
	(
		DATA_WIDTH : natural := 16
	);

    port (
                CLOCK        : in std_logic;
                            
									 
					 VALOR_INSERIDO_LD		: in std_logic;
					 VALOR_INSERIDO_CLR	   : in std_logic;
					 VALOR_INSERIDOM_LD		: in std_logic;
					 VALOR_INSERIDOM_CLR	   : in std_logic;
					 VALOR_INSERIDOC_LD		: in std_logic;
					 VALOR_INSERIDOC_CLR	   : in std_logic;
				    VALOR_REFRI1_LD			: in std_logic;
				    VALOR_REFRI1_CLR			: in std_logic;
					 VALOR_REFRI2_LD			: in std_logic;
					 VALOR_REFRI2_CLR			: in std_logic;
					 ESTOQUE1_LD				: in std_logic;
					 ESTOQUE1_CLR				: in std_logic;
					 ESTOQUE2_LD				: in std_logic;
					 ESTOQUE2_CLR				: in std_logic;
					 RG_REFRI_LD    			: in std_logic;
					 RG_REFRI_CLR 				: in std_logic;

                
					 VI_eq_VR1					: out std_logic; 		-- Valor inserido = Valor Refri 1
					 VI_gt_VR1					: out std_logic;  	-- Valor inserido > Valor Refri 1 
					 VI_eq_VR2					: out std_logic; 		-- Valor inserido = Valor Refri 2
					 VI_gt_VR2					: out std_logic;  	-- Valor inserido > Valor Refri 2
					 SELECTED_REFRI			: out std_logic;		-- Refri selecionado
					 ESTOQUE1_gt_O 			: out std_logic;		-- Estoque 1 > 0
					 ESTOQUE2_gt_O 			: out std_logic;		-- Estoque 2 > 0
					 
					 CEDULA						: in std_logic_vector (DATA_WIDTH-1 downto 0);
					 MOEDA						: in std_logic_vector (DATA_WIDTH-1 downto 0);
					 SELECT_1					: in std_logic;
					 TROCO_1						: out std_logic_vector (DATA_WIDTH-1 downto 0);
					 TROCO_2						: out std_logic_vector (DATA_WIDTH-1 downto 0);
					 QNT_ESTOQUE_1				: out std_logic_vector (DATA_WIDTH-1 downto 0);
					 QNT_ESTOQUE_2				: out std_logic_vector (DATA_WIDTH-1 downto 0)
	
    
    
    );
end entity;

architecture rtl of datapath is

    component somador is
        port(
        a            : in std_logic_vector (DATA_WIDTH-1 downto 0);
        b            : in std_logic_vector (DATA_WIDTH-1 downto 0);
        result   : out std_logic_vector (DATA_WIDTH-1 downto 0)
                );
    end component;
                
    component subtrator is
        port(
        a            : in std_logic_vector (4 downto 0);
        result   : out std_logic_vector (4 downto 0)
                );
    end component;
    
    component subtrator_16bits is
        port(
        a            : in std_logic_vector (DATA_WIDTH-1 downto 0);
        b            : in std_logic_vector (DATA_WIDTH-1 downto 0);
        result   : out std_logic_vector (DATA_WIDTH-1 downto 0)
                );
    end component;
    	 
	 component comparador is
        port(
        a         : in std_logic_vector (DATA_WIDTH-1 downto 0); 
        b         : in std_logic_vector (DATA_WIDTH-1 downto 0);
        a_gt_b    : out std_logic
                );
    end component;
	 
	 component comparador_igualdade is
        port(
        a         : in std_logic_vector (DATA_WIDTH-1 downto 0); 
        b         : in std_logic_vector (DATA_WIDTH-1 downto 0);
        a_eq_b    : out std_logic
                );
    end component;

    component comparador_zero is
        port(
        a         : in std_logic_vector (4 downto 0); 
        a_eq_0    : out std_logic

                );
    end component;
    
    component mux is
        port(
        a       : in std_logic;
		  b       : in std_logic;
	     enable  : in std_logic;
		  saida   : out std_logic
                );
    end component;
    
    component registrador_16bits
        Port (
		  clock: in std_logic;
		  registrador_ld: in std_logic;
		  registrador_clr: in std_logic;
		  registrador_in: in std_logic_vector(DATA_WIDTH-1 downto 0);
		  registrador_out: out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
        
    end component;
	 
	 component registrador_5bits
        Port (
		  clock: in std_logic;
		  registrador_ld: in std_logic;
		  registrador_clr: in std_logic;
		  registrador_in: in std_logic_vector(4 downto 0);
		  registrador_out: out std_logic_vector(4 downto 0)
        );
        
    end component;
	 
	 component registrador_1bit
        Port (
		  clock: in std_logic;
		  registrador_ld: in std_logic;
		  registrador_clr: in std_logic;
		  registrador_in: in std_logic;
		  registrador_out: out std_logic
        );
        
    end component;

    
	 signal  valor_inseridoOut : std_logic_vector(DATA_WIDTH-1 downto 0);
	 signal  valor_inseridoMOut : std_logic_vector(DATA_WIDTH-1 downto 0);
	 signal  valor_inseridoCOut : std_logic_vector(DATA_WIDTH-1 downto 0);
	 
	 signal  rgSelecionadoOut : std_logic;
	 signal  muxOut : std_logic;
	 signal  a : std_logic := '0';
	 signal  b : std_logic := '1';
	 
	 signal  subtratorOut : std_logic_vector(4 downto 0);
	 signal  subtrator_estoque1Out : std_logic_vector(4 downto 0);
	 signal  subtrator_estoque2Out : std_logic_vector(4 downto 0);
	 signal  subtrator16Out1 : std_logic_vector(DATA_WIDTH-1 downto 0);
	 signal  subtrator16Out2 : std_logic_vector(DATA_WIDTH-1 downto 0);
	 
	 signal  somadorCedulasOut : std_logic_vector(DATA_WIDTH-1 downto 0);
	 signal  somadorMoedasOut : std_logic_vector(DATA_WIDTH-1 downto 0);
	 signal  somadorOut : std_logic_vector(DATA_WIDTH-1 downto 0);
	 
	 signal  valorRefri1 : std_logic_vector(DATA_WIDTH-1 downto 0) := x"0004";
	 signal  valorRefri2 : std_logic_vector(DATA_WIDTH-1 downto 0) := x"0002";
	 
	 signal  estoque1Out : std_logic_vector(4 downto 0) := "11000";
	 signal  estoque2Out : std_logic_vector(4 downto 0) := "11000";
	 

	begin

	-- Instancia Registradores
	instancia_valor_inseridoM : registrador_16bits port map(CLOCK, VALOR_INSERIDOM_LD, VALOR_INSERIDOM_CLR, somadorMoedasOut, valor_inseridoMOut);
	instancia_valor_inseridoC : registrador_16bits port map(CLOCK, VALOR_INSERIDOC_LD, VALOR_INSERIDOC_CLR, somadorCedulasOut, valor_inseridoCOut);
	instancia_valor_inserido : registrador_16bits port map(CLOCK, VALOR_INSERIDO_LD, VALOR_INSERIDO_CLR, somadorOut, valor_inseridoOut);
	instancia_valor_refri1 : registrador_16bits port map(CLOCK, VALOR_REFRI1_LD, VALOR_REFRI1_CLR, valorRefri1, valorRefri1);
	instancia_valor_refri2 : registrador_16bits port map(CLOCK, VALOR_REFRI1_LD, VALOR_REFRI1_CLR, valorRefri2, valorRefri2);
	instancia_estoque1 : registrador_5bits port map(CLOCK, ESTOQUE1_LD, ESTOQUE1_CLR, subtrator_estoque1Out, estoque1Out);
	instancia_estoque2 : registrador_5bits port map(CLOCK, ESTOQUE2_LD, ESTOQUE2_CLR, subtrator_estoque2Out, estoque2Out);
	intancia_rg_selecionado : registrador_1bit port map(CLOCK, RG_REFRI_LD, RG_REFRI_CLR, muxOut, rgSelecionadoOut);
	instancia_mux : mux port map(a, b, SELECT_1, muxOut);
	

	-- Instancia somadores
	instancia_somador_cedula : somador port map(CEDULA, valor_inseridoCOut, somadorCedulasOut);
	instancia_somador_moeda : somador port map(MOEDA, valor_inseridoMOut, somadorMoedasOut);
	instancia_somador_inserido : somador port map(valor_inseridoMOut, valor_inseridoCOut, somadorOut);
	
	
	-- Instancia comparadores
	instancia_comparador_vr1 : comparador port map(valor_inseridoOut, valorRefri1, VI_gt_VR1);
	instancia_comparador_vr2 : comparador port map(valor_inseridoOut, valorRefri2, VI_gt_VR2);
	instancia_comparador_igualdade_vr1 : comparador_igualdade port map (valor_inseridoOut, valorRefri1, VI_eq_VR1);
	instancia_comparador_igualdade_vr2 : comparador_igualdade port map (valor_inseridoOut, valorRefri2, VI_eq_VR2);
	instancia_comparador_zero1 : comparador_zero port map(estoque1Out,ESTOQUE1_gt_O);
	instancia_comparador_zero2 : comparador_zero port map(estoque2Out,ESTOQUE2_gt_O);
	
	-- Instancia subtratores
	instancia_subtrator_16its_vr1 : subtrator_16bits port map(valor_inseridoOut, valorRefri1, subtrator16Out1);	
	instancia_subtrator_16its_vr2 : subtrator_16bits port map(valor_inseridoOut, valorRefri2, subtrator16Out2);
	instancia_subtrator_estoque1 : subtrator port map(estoque1Out, subtrator_estoque1Out);
	instancia_subtrator_estoque2 : subtrator port map(estoque2Out, subtrator_estoque2Out);
	
	SELECTED_REFRI <= rgSelecionadoOut;
	TROCO_1 <= subtrator16Out1;
	TROCO_2 <= subtrator16Out2;

	
end rtl;