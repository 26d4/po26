program zadanieMain;
uses zadanie;

var
	arr: array of Integer;
	i: Integer;

begin
	randomize;
	arr := randomNumbers(10, 50, 16);
	writeln('Before sort');
	for i := Low(arr) to High(arr) do writeln(arr[i]);
	sortNumbers(arr);
	writeln('After sort');
	for i := Low(arr) to High(arr) do writeln(arr[i]);
end.
