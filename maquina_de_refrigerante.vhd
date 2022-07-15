library ieee;
use ieee.std_logic_1164.all;

entity maquina_de_refrigerante is
	generic 
	(
		DATA_WIDTH : natural := 16
	);
	port(
	
	CLOCK : in std_logic;
	
	
	--controladora
	
	CEDULA_SIGNAL			: in std_logic;
	MOEDA_SIGNAL			: in std_logic;
	SELECT_1             : in std_logic;
	SELECT_2             : in std_logic;
	CONFIRMA				   : in std_logic;
	CANCELA				   : in std_logic;
	LIBERAR					: out std_logic;
	TROCO				      : out std_logic;
	FREE_CASH				: out std_logic;
	
	
	--bloco operacional
	 
	CEDULA						: in std_logic_vector (DATA_WIDTH-1 downto 0);
	MOEDA							: in std_logic_vector (DATA_WIDTH-1 downto 0);
	SELECT_0						: in std_logic;
	TROCO_1						: out std_logic_vector (DATA_WIDTH-1 downto 0);
	TROCO_2						: out std_logic_vector (DATA_WIDTH-1 downto 0);
	QNT_ESTOQUE_1				: out std_logic_vector (4 downto 0);
	QNT_ESTOQUE_2				: out std_logic_vector (4 downto 0)


	);
end entity;

architecture rtl of maquina_de_refrigerante is

	signal VALOR_INSERIDO_LD, VALOR_INSERIDO_CLR, VALOR_REFRI1_LD, VALOR_REFRI1_CLR    			: std_logic;
	signal VALOR_INSERIDOM_LD, VALOR_INSERIDOM_CLR, VALOR_INSERIDOC_LD, VALOR_INSERIDOC_CLR 	: std_logic;
	signal VALOR_REFRI2_LD, VALOR_REFRI2_CLR, ESTOQUE1_LD, ESTOQUE1_CLR         					: std_logic;	
	signal ESTOQUE2_LD, ESTOQUE2_CLR, RG_REFRI_LD, RG_REFRI_CLR               						: std_logic;
	signal VI_eq_VR1, VI_gt_VR1, VI_eq_VR2, VI_gt_VR2, SELECTED_REFRI									: std_logic;
	signal ESTOQUE1_gt_O, ESTOQUE2_gt_O												 							: std_logic;
	
	component controladora is
	port(
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
	end component;
	
	
	component datapath is
	port(
		CLOCK       				: in std_logic;
					 
		VALOR_INSERIDO_LD			: in std_logic;
		VALOR_INSERIDO_CLR	   : in std_logic;
		VALOR_INSERIDOM_LD		: in std_logic;
		VALOR_INSERIDOM_CLR	   : in std_logic;
		VALOR_INSERIDOC_LD		: in std_logic;
		VALOR_INSERIDOC_CLR	   : in std_logic;
		VALOR_REFRI1_LD			: in std_logic;
		VALOR_REFRI1_CLR			: in std_logic;
		VALOR_REFRI2_LD			: in std_logic;
		VALOR_REFRI2_CLR			: in std_logic;
		ESTOQUE1_LD					: in std_logic;
		ESTOQUE1_CLR				: in std_logic;
		ESTOQUE2_LD					: in std_logic;
		ESTOQUE2_CLR				: in std_logic;
		RG_REFRI_LD    			: in std_logic;
		RG_REFRI_CLR 				: in std_logic;

                
		VI_eq_VR1					: out std_logic; 		-- Valor inserido = Valor Refri 1
		VI_gt_VR1					: out std_logic;  	-- Valor inserido > Valor Refri 1 
		VI_eq_VR2					: out std_logic; 		-- Valor inserido = Valor Refri 2
		VI_gt_VR2					: out std_logic;  	-- Valor inserido > Valor Refri 2
		SELECTED_REFRI				: out std_logic;		-- Refri selecionado
		ESTOQUE1_gt_O 				: out std_logic;		-- Estoque 1 > 0
		ESTOQUE2_gt_O 				: out std_logic;		-- Estoque 2 > 0
		 
		CEDULA						: in std_logic_vector (DATA_WIDTH-1 downto 0);
		MOEDA							: in std_logic_vector (DATA_WIDTH-1 downto 0);
		SELECT_0						: in std_logic;
		TROCO_1						: out std_logic_vector (DATA_WIDTH-1 downto 0);
		TROCO_2						: out std_logic_vector (DATA_WIDTH-1 downto 0);
		QNT_ESTOQUE_1				: out std_logic_vector (4 downto 0);
		QNT_ESTOQUE_2				: out std_logic_vector (4 downto 0)

	);
	end component;
	
	begin

		instancia_controladora : controladora port map(CLOCK, CEDULA_SIGNAL, MOEDA_SIGNAL, SELECT_1, SELECT_2, CONFIRMA, CANCELA,
																	  LIBERAR, TROCO, FREE_CASH, VALOR_INSERIDO_LD, VALOR_INSERIDO_CLR,
																	  VALOR_REFRI1_LD, VALOR_REFRI1_CLR, VALOR_REFRI2_LD, VALOR_REFRI2_CLR, ESTOQUE1_LD, ESTOQUE1_CLR,
																	  ESTOQUE2_LD, ESTOQUE2_CLR, RG_REFRI_LD, RG_REFRI_CLR, VI_eq_VR1,
																	  VI_gt_VR1, VI_eq_VR2, VI_gt_VR2, SELECTED_REFRI, ESTOQUE1_gt_O, ESTOQUE2_gt_O);

		
		
		instancia_datapath : datapath port map(CLOCK, VALOR_INSERIDO_LD, VALOR_INSERIDO_CLR, VALOR_INSERIDOM_LD, VALOR_INSERIDOM_CLR, VALOR_INSERIDOC_LD,
															VALOR_INSERIDOC_CLR, VALOR_REFRI1_LD, VALOR_REFRI1_CLR, VALOR_REFRI2_LD, VALOR_REFRI2_CLR, ESTOQUE1_LD,
															ESTOQUE1_CLR, ESTOQUE2_LD, ESTOQUE2_CLR, RG_REFRI_LD, RG_REFRI_CLR, VI_eq_VR1, VI_gt_VR1, VI_eq_VR2, VI_gt_VR2, SELECTED_REFRI,
															ESTOQUE1_gt_O, ESTOQUE2_gt_O, CEDULA, MOEDA, SELECT_0, TROCO_1, TROCO_2, QNT_ESTOQUE_1, QNT_ESTOQUE_2);

end rtl;