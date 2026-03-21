unit zadanie;

interface

type
	IntArray = array of Integer;

function randomNumbers(l, h, c: Integer): IntArray;
procedure sortNumbers(var num: IntArray);

implementation

function randomNumbers(l, h, c: Integer): IntArray;
var
	i: Integer;
begin
	SetLength(randomNumbers, c);
	for i := 0 to c-1 do randomNumbers[i] := random(h-l) + l;
end;

procedure sortNumbers(var num: IntArray);
var
	i, j, index, l: Integer;
begin
	l := Low(num);
	for i := l+1 to High(num) do 
	begin
		index := num[i];
		j := i;
		while ((j > l) and (num[j-1] > index)) do
		begin
			num[j] := num[j-1];
			j := j - 1
		end;
		num[j] := index;
	end;
end;

end.
