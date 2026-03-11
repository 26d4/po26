program zadanie;

procedure randomNumbers();
var
	i: integer;
begin
	for i := 1 to 50 do writeln(random(100));
end;

begin
	randomize;
	randomNumbers();
end.
