program zadanie;

type
	IntArray = array of Integer;

function randomNumbers(): IntArray;
var
	i: Integer;
begin
	SetLength(randomNumbers, 50);
	for i := 0 to 49 do randomNumbers[i] := random(100);
end;

procedure sortNumbers(var num: IntArray);
var
	i, j, index, l : Integer;
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

var
	arr: array of Integer;
	i: Integer;

begin
	randomize;
	arr := randomNumbers();
	writeln('Before sort');
	for i := Low(arr) to High(arr) do writeln(arr[i]);
	sortNumbers(arr);
	writeln('After sort');
	for i := Low(arr) to High(arr) do writeln(arr[i]);
end.
