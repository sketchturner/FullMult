library ieee;
use ieee.std_logic_1164.all;

entity sm2 is
	generic (
		constant DATA_WIDTH:		integer := 32;
		constant TRUNCATED_BITS:	integer := 25
	);
	port (
		A:	in std_logic_vector(DATA_WIDTH-1 downto 0);
		B:	in std_logic_vector(DATA_WIDTH-1 downto 0);
		V:	out std_logic_vector(DATA_WIDTH*2-1 downto 0)
	);
end sm2;

architecture sm2 of sm2 is
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

signal S: std_logic_vector(DATA_WIDTH*(DATA_WIDTH-1)-1 downto 0);
signal C: std_logic_vector(DATA_WIDTH*(DATA_WIDTH-1)-1 downto 0);

begin
	genI0J:
	for j in TRUNCATED_BITS to DATA_WIDTH-2 generate
--		genI0Jx:
--		if j > TRUNCATED_BITS-1 and j < DATA_WIDTH-1 generate
			adder0x: half_adder port map (
				(A(j+1) and B(0)),
				(A(j) and B(1)),
				S(j),
				C(j)
			);
--		end generate;
	end generate;
	genIt:
	for i in 1 to TRUNCATED_BITS-1 generate
		addertt: half_adder port map (
			S((i-1)*(DATA_WIDTH-1)+TRUNCATED_BITS-i+1),
			(A(TRUNCATED_BITS-i) and B(i+1)),
			S(i*(DATA_WIDTH-1)+TRUNCATED_BITS-i),
			C(i*(DATA_WIDTH-1)+TRUNCATED_BITS-i)
		);
		genItJx:
		for j in TRUNCATED_BITS-i+1 to DATA_WIDTH-3 generate
		addertx: full_adder port map (
			S((i-1)*(DATA_WIDTH-1)+j+1),
			C((i-1)*(DATA_WIDTH-1)+j),
			(A(j) and B(i+1)),
			S(i*(DATA_WIDTH-1)+j),
			C(i*(DATA_WIDTH-1)+j)
		);
		end generate genItJx;
		addertn: full_adder port map (
			(A(DATA_WIDTH-1) and B(i)),
			C(i*(DATA_WIDTH-1)-1),
			(A(DATA_WIDTH-2) and B(i+1)),
			S(i*(DATA_WIDTH-1)+DATA_WIDTH-2),
			C(i*(DATA_WIDTH-1)+DATA_WIDTH-2)
		);
	end generate genIt;
	genI:
	for i in TRUNCATED_BITS to DATA_WIDTH-2 generate
		genIJx:
		for j in 0 to DATA_WIDTH-3 generate
		adderxx: full_adder port map (
			S((i-1)*(DATA_WIDTH-1)+j+1),
			C((i-1)*(DATA_WIDTH-1)+j),
			(A(j) and B(i+1)),
			S(i*(DATA_WIDTH-1)+j),
			C(i*(DATA_WIDTH-1)+j)
		);
		end generate;
		adderxn: full_adder port map (
			(A(DATA_WIDTH-1) and B(i)),
			C(i*(DATA_WIDTH-1)-1),
			(A(DATA_WIDTH-2) and B(i+1)),
			S(i*(DATA_WIDTH-1)+DATA_WIDTH-2),
			C(i*(DATA_WIDTH-1)+DATA_WIDTH-2)
		);
	end generate genI;
	genInJ:
	for j in 0 to DATA_WIDTH-2 generate
		genInJ0:
		if j = 0 generate
			addern0: full_adder port map (
			C((DATA_WIDTH-1)*(DATA_WIDTH-2)),
			S((DATA_WIDTH-1)*(DATA_WIDTH-2)+1),
			S((DATA_WIDTH-1)*(DATA_WIDTH-2)), --added to perform rounding
			S((DATA_WIDTH-1)*(DATA_WIDTH-1)),
			C((DATA_WIDTH-1)*(DATA_WIDTH-1))
		);
		end generate genInJ0;
		genInJx:
		if j > 0 and j < DATA_WIDTH-2 generate
			addernx: full_adder port map (
			S((DATA_WIDTH-1)*(DATA_WIDTH-2)+j+1),
			C((DATA_WIDTH-1)*(DATA_WIDTH-2)+j),
			C((DATA_WIDTH-1)*(DATA_WIDTH-1)+j-1),
			S((DATA_WIDTH-1)*(DATA_WIDTH-1)+j),
			C((DATA_WIDTH-1)*(DATA_WIDTH-1)+j)
		);
		end generate genInJx;
		genInJn:
		if j = DATA_WIDTH-2 generate
			addernn: full_adder port map (
			(A(j) and B(DATA_WIDTH-1)),
			C((DATA_WIDTH-1)*(DATA_WIDTH-1)-1),
			C((DATA_WIDTH-1)*(DATA_WIDTH-1)+j-1),
			S((DATA_WIDTH-1)*(DATA_WIDTH-1)+j),
			C((DATA_WIDTH-1)*(DATA_WIDTH-1)+j)
		);
		end generate genInJn;
	end generate;
	genV:
	for i in 0 to DATA_WIDTH*2-1 generate
		genV0:
		if i < DATA_WIDTH generate
--		if i < TRUNCATED_BITS generate
			V(i) <= '0';
		end generate;
--		genV1:
--		if (i > TRUNCATED_BITS-1 and i < DATA_WIDTH) generate
--			V(i) <= S((i-1)*(DATA_WIDTH-1));
--		end generate;
		genV2:
		if (i > DATA_WIDTH-1 and i < DATA_WIDTH*2-1) generate
			V(i) <= S((DATA_WIDTH-1)*(DATA_WIDTH-1)+i-DATA_WIDTH);
		end generate;
		genVn:
		if i=DATA_WIDTH*2-1 generate
			V(i) <= C(DATA_WIDTH*(DATA_WIDTH-1)-1);
		end generate;
	end generate;
end sm2;