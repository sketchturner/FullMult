library ieee;
use ieee.std_logic_1164.all;

entity half_adder is
	port (
		a: 		in std_logic;
		b: 		in std_logic;
		s:		out std_logic;
		p_Out:	out std_logic
	);
end half_adder;

architecture half_adder of half_adder is
begin
	s <= a xor b;
	p_Out <= a and b;
end half_adder;