library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_maquina_de_refrigerante is
end entity;

architecture teste of tb_maquina_de_refrigerante is

component maquina_de_refrigerante is
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
end component;
    
	 
    -- controladora
    
	 signal clock           			: std_logic := '0';
    signal cedula_signal            : std_logic;
    signal moeda_signal  				: std_logic; 
    signal select_1         			: std_logic;
    signal select_2           		: std_logic;
    signal confirma         			: std_logic;
    signal cancela       				: std_logic;
	 signal liberar       				: std_logic;
	 signal troco       					: std_logic;
	 signal free_cash       			: std_logic;
    
    -- datapath
    
    signal cedula     					: std_logic_vector(15 downto 0);
    signal moeda     					: std_logic_vector(15 downto 0);
	 signal select_0       				: std_logic;
    signal troco_1  						: std_logic_vector(15 downto 0);
    signal troco_2  						: std_logic_vector(15 downto 0);
    signal qnt_estoque_1            : std_logic_vector(4 downto 0);
	 signal qnt_estoque_2            : std_logic_vector(4 downto 0);
    
        
    begin 
    
	  instancia_maquina : maquina_de_refrigerante port map(clock,cedula_signal, moeda_signal, select_1, select_2, confirma, cancela,
																			 liberar, troco, free_cash, cedula, moeda, select_0, troco_1, troco_2, qnt_estoque_1, qnt_estoque_2);
																							
	  
		clock <= not(clock) after 5 ns;
		SELECT_1 <= '0', '1' after 5 ns, '0' after 10 ns;
		MOEDA_SIGNAL <= '0', '1' after 20 ns, '0' after 25 ns, '1' after 30 ns, '0' after 35 ns, '1' after 40 ns, '0' after 45 ns, '1' after 50 ns, '0' after 55 ns;
		MOEDA <= x"0000", x"0004" after 20 ns;
		CONFIRMA <= '0', '1' after 60 ns;
		CANCELA <= '0';
		
		CEDULA_SIGNAL <= '0';
		SELECT_2 <= '0';
		CEDULA <= x"0000";
		SELECT_0 <= '0';
		  	
		
end teste;