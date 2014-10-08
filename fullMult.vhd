library ieee;
use ieee.std_logic_1164.all;

entity fm is
	generic (
		constant DATA_WIDTH: integer:= 32
	);
	port (
		A:	in std_logic_vector(DATA_WIDTH-1 downto 0);
		B:	in std_logic_vector(DATA_WIDTH-1 downto 0);
		V:	out std_logic_vector(DATA_WIDTH*2-1 downto 0)
	);
end fm;

architecture fm of fm is
component full_adder is
	port (
		a: 		in std_logic;
		b: 		in std_logic;
		p_In:	in std_logic;
		s:		out std_logic;
		p_Out:	out std_logic
	);
end component;

component half_adder is
	port (
		a: 		in std_logic;
		b: 		in std_logic;
		s:		out std_logic;
		p_Out:	out std_logic
	);
end component;

signal T: std_logic_vector(DATA_WIDTH*(DATA_WIDTH-1)-1 downto 0);
signal C: std_logic_vector(DATA_WIDTH*(DATA_WIDTH-1)-1 downto 0);

begin
	V(0) <= A(0) and B(0);
	genI1J:
	for j in 0 to DATA_WIDTH-1 generate
		genI1J0:
		if j = 0 generate
			adder11: half_adder port map (
				(A(0) and B(1)), (A(1) and B(0)), T(0), C(0)
			);
		end generate;
		genI1Jn:
		if j = DATA_WIDTH-1 generate
			adder1n: half_adder port map (
				(A(DATA_WIDTH-1) and B(1)), C(DATA_WIDTH-2), T(DATA_WIDTH-1), C(DATA_WIDTH-1)
			);
		end generate;
		genI1Jx:
		if j > 0 and j < DATA_WIDTH-1 generate
			adder1x: full_adder port map (
				(A(j) and B(1)), (A(j+1) and B(0)), C(j-1), T(j), C(j)
			);
		end generate;
	end generate;
	genI:
	for i in 1 to DATA_WIDTH-2 generate
		adderx0: half_adder port map (
			T((i-1)*DATA_WIDTH+1), (A(0) and B(i+1)), T(i*(DATA_WIDTH)), C(i*(DATA_WIDTH))
		);
		genIJx:
		for j in 1 to DATA_WIDTH-2 generate
			adderxx: full_adder port map (
				T((i-1)*DATA_WIDTH+j+1), (A(j) and B(i+1)), C(i*DATA_WIDTH+j-1), T(i*DATA_WIDTH+j), C(i*DATA_WIDTH+j)
			);
		end generate genIJx;
		adderxn: full_adder port map (
			C(i*DATA_WIDTH-1), (A(DATA_WIDTH-1) and B(i+1)), C((i+1)*DATA_WIDTH-2), T((i+1)*DATA_WIDTH-1), C((i+1)*DATA_WIDTH-1)
		);
	end generate genI;
	genV:
	for i in 1 to DATA_WIDTH*2-1 generate
		genV1:
		if i < DATA_WIDTH generate
			V(i) <= T((i-1)*DATA_WIDTH);
		end generate;
		genV2:
		if (i > DATA_WIDTH-1 and i < DATA_WIDTH*2-1) generate
			V(i) <= T(DATA_WIDTH*(DATA_WIDTH-3)+i+1);
		end generate;
		genVn:
		if i=DATA_WIDTH*2-1 generate
			V(i) <= C(DATA_WIDTH*(DATA_WIDTH-1)-1);
		end generate;
	end generate;
end fm;