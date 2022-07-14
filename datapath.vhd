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
					 ESTOQUE2_gt_O 			: out std_logic		-- Estoque 2 > 0
					 
					 CEDULA						: in std_logic_vector (DATA_WIDTH-1 downto 0);
					 MOEDA						: in std_logic_vector (DATA_WIDTH-1 downto 0);
					 TROCO						: out std_logic_vector (DATA_WIDTH-1 downto 0);
					 ESTOQUE_1					: out std_logic_vector (DATA_WIDTH-1 downto 0);
					 ESTOQUE_2					: out std_logic_vector (DATA_WIDTH-1 downto 0);
	
    
    
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
        a            : in std_logic_vector (DATA_WIDTH-1 downto 0);
        result   : out std_logic_vector (DATA_WIDTH-1 downto 0)
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

        component comparador_zero is
        port(
        a         : in std_logic_vector (DATA_WIDTH-1 downto 0); 
        a_eq_0    : out std_logic

                );
    end component;
    
    component mux is
        port(
        a       : in std_logic_vector (DATA_WIDTH-1 downto 0);
		  b       : in std_logic_vector (DATA_WIDTH-1 downto 0);
	     enable  : in std_logic;
		  saida   : out std_logic_vector(DATA_WIDTH-1 downto 0)
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

    
	 signal  selecionadoOut : std_logic_vector(DATA_WIDTH-1 downto 0);
	 signal  subtratorOut : std_logic_vector(DATA_WIDTH-1 downto 0);
	 signal  subtrator16Out : std_logic_vector(DATA_WIDTH-1 downto 0);
	 signal  muxOut : std_logic_vector(DATA_WIDTH-1 downto 0);
	 signal  somadorOut : std_logic_vector(DATA_WIDTH-1 downto 0);
	 signal  cedulasOut : std_logic_vector(DATA_WIDTH-1 downto 0);
	 signal  moedasOut : std_logic_vector(DATA_WIDTH-1 downto 0);
	 signal  trocoOut : std_logic_vector(DATA_WIDTH-1 downto 0);

	begin


	
end rtl;