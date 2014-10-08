library ieee;
use ieee.std_logic_1164.all;

entity sm is
	generic (
		constant DATA_WIDTH:		integer := 32;
		constant TRUNCATED_BITS:	integer := 27
	);
	port (
		A:	in std_logic_vector(DATA_WIDTH-1 downto 0);
		B:	in std_logic_vector(DATA_WIDTH-1 downto 0);
		V:	out std_logic_vector(DATA_WIDTH*2-1 downto 0)
	);
end sm;

architecture sm of sm is
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
	genI1J:
	for j in TRUNCATED_BITS-1 to DATA_WIDTH-1 generate
		genI1J0:
		if j = TRUNCATED_BITS-1 generate
			adder11: half_adder port map (
				(A(TRUNCATED_BITS-1) and B(1)), (A(TRUNCATED_BITS) and B(0)), T(0), C(0)
			);
		end generate;
		genI1Jn:
		if j = DATA_WIDTH-1 generate
			adder1n: half_adder port map (
				(A(DATA_WIDTH-1) and B(1)), C(DATA_WIDTH-2), T(DATA_WIDTH-1), C(DATA_WIDTH-1)
			);
		end generate;
		genI1Jx:
		if j > TRUNCATED_BITS-1 and j < DATA_WIDTH-1 generate
			adder1x: full_adder port map (
				(A(j) and B(1)), (A(j+1) and B(0)), C(j-1), T(j), C(j)
			);
		end generate;
	end generate;
	genI:
	for i in 1 to DATA_WIDTH-2 generate
		genIJ0n:
		if i<TRUNCATED_BITS generate
		adderx0n: half_adder port map (
			T((i-1)*DATA_WIDTH+TRUNCATED_BITS-i), (A(TRUNCATED_BITS-i) and B(i+1)), T(i*DATA_WIDTH+TRUNCATED_BITS-i-1), C(i*DATA_WIDTH+TRUNCATED_BITS-i-1)
		);
		end generate genIJ0n;
		genIJ0:
		if i>TRUNCATED_BITS-1 generate
		adderx0: half_adder port map (
			T((i-1)*DATA_WIDTH+1), (A(0) and B(i+1)), T(i*DATA_WIDTH), C(i*DATA_WIDTH)
		);
		end generate genIJ0;
		genIJx:
		for j in TRUNCATED_BITS-i to DATA_WIDTH-2 generate
			genIJXn0:
			if j>0 generate
				adderxx: full_adder port map (
					T((i-1)*DATA_WIDTH+j+1), (A(j) and B(i+1)), C(i*DATA_WIDTH+j-1), T(i*DATA_WIDTH+j), C(i*DATA_WIDTH+j)
				);
			end generate genIJXn0;
		end generate genIJx;
		adderxn: full_adder port map (
			C(i*DATA_WIDTH-1), (A(DATA_WIDTH-1) and B(i+1)), C((i+1)*DATA_WIDTH-2), T((i+1)*DATA_WIDTH-1), C((i+1)*DATA_WIDTH-1)
		);
	end generate genI;
	genV:
	for i in 0 to DATA_WIDTH*2-1 generate
		genV0:
		if i < TRUNCATED_BITS generate
			V(i) <= '0';
		end generate;
		genV1:
		if (i > TRUNCATED_BITS-1 and i < DATA_WIDTH) generate
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
end sm;