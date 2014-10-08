library ieee;
use ieee.std_logic_1164.all;

entity full_adder is
	port (
		a: 		in std_logic;
		b: 		in std_logic;
		p_In:	in std_logic;
		s:		out std_logic;
		p_Out:	out std_logic
	);
end full_adder;

architecture full_adder of full_adder is
begin
	s <= a xor b xor p_In;
	p_Out <= (a and b) or ((a xor b) and p_In);
end full_adder;