library ieee;
use ieee.std_logic_1164.all;

entity fm2 is
	generic (
		constant DATA_WIDTH: integer:= 
32
);
	port (
		A:	in std_logic_vector(DATA_WIDTH-1 downto 0);
		B:	in std_logic_vector(DATA_WIDTH-1 downto 0);
		V:	out std_logic_vector(DATA_WIDTH*2-1 downto 0)
	);
end fm2;

architecture fm2 of fm2 is
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
	for j in 0 to DATA_WIDTH-2 generate
		adder0x: half_adder port map (
			(A(j+1) and B(0)), (A(j) and B(1)), S(j), C(j)
		);
	end generate;
	genIx:
	for i in 1 to DATA_WIDTH-2 generate
		genIxJx:
		for j in 0 to DATA_WIDTH-3 generate
			adderxx: full_adder port map (
				S((i-1)*(DATA_WIDTH-1)+j+1), (A(j) and B(i+1)), C((i-1)*(DATA_WIDTH-1)+j), S(i*(DATA_WIDTH-1)+j), C(i*(DATA_WIDTH-1)+j)
			);
		end generate genIxJx;
		adderxn: full_adder port map (
			(A(DATA_WIDTH-1) and B(i)), (A(DATA_WIDTH-2) and B(i+1)), C(i*(DATA_WIDTH-1)-1), S(i*(DATA_WIDTH-1)+DATA_WIDTH-2), C(i*(DATA_WIDTH-1)+DATA_WIDTH-2)
		);
	end generate genIx;
	addern0: half_adder port map (
		C((DATA_WIDTH-1)*(DATA_WIDTH-2)), S((DATA_WIDTH-1)*(DATA_WIDTH-2)+1), S((DATA_WIDTH-1)*(DATA_WIDTH-1)), C((DATA_WIDTH-1)*(DATA_WIDTH-1))
		);
	addernn: full_adder port map (
		(A(DATA_WIDTH-1) and B(DATA_WIDTH-1)), C((DATA_WIDTH-1)*(DATA_WIDTH-1)-1), C((DATA_WIDTH-1)*(DATA_WIDTH-1)+DATA_WIDTH-3), S((DATA_WIDTH-1)*(DATA_WIDTH-1)+(DATA_WIDTH-2)), C((DATA_WIDTH-1)*(DATA_WIDTH-1)+(DATA_WIDTH-2))
		);
	genInJx: for j in 1 to DATA_WIDTH-3 generate
		addernx: full_adder port map (
			S((DATA_WIDTH-1)*(DATA_WIDTH-2)+j+1), C((DATA_WIDTH-1)*(DATA_WIDTH-2)+j), C((DATA_WIDTH-1)*(DATA_WIDTH-1)+j-1), S((DATA_WIDTH-1)*(DATA_WIDTH-1)+j), C((DATA_WIDTH-1)*(DATA_WIDTH-1)+j)
		);
	end generate genInJx;
	V(0) <= A(0) and B(0);
	genV:
	for i in 1 to DATA_WIDTH*2-1 generate
		genV1:
		if i < DATA_WIDTH generate
			V(i) <= S((i-1)*(DATA_WIDTH-1));
		end generate;
		genV2:
		if (i > DATA_WIDTH-1 and i < DATA_WIDTH*2-1) generate
			V(i) <= S((DATA_WIDTH-1)*(DATA_WIDTH-1)+i-DATA_WIDTH);
		end generate;
		genVn:
		if i=DATA_WIDTH*2-1 generate
			V(i) <= C(DATA_WIDTH*(DATA_WIDTH-1)-1);
		end generate;
	end generate;
end fm2;
