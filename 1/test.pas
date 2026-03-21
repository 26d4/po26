program zadanieTest;
{$MODE OBJFPC}
uses
	zadanie, Classes, fpcunit, testutils, testregistry, consoletestrunner, SysUtils;

type
	TestCase1 = Class(TTestCase)
	private
		arr: IntArray;
	protected
		procedure SetUp; override;
		procedure TearDown; override;
	published
		procedure TestRandom1;
		procedure TestRandom2;
		procedure TestSort1;
		procedure TestSort2;
		procedure TestSort3;
	end;

procedure TestCase1.SetUp;
begin
	arr := randomNumbers(1, 10, 100);
end;

procedure TestCase1.TearDown;
begin
	arr := nil;
end;

procedure TestCase1.TestRandom1;
begin
	AssertEquals('bad array size', 100, Length(arr));
end;

procedure TestCase1.TestRandom2;
var
	i: Integer;
begin
	for i := Low(arr) to High(arr) do
	begin
		if arr[i] < 1 then Fail('number too low');
		if arr[i] >= 10 then Fail('number too high');
	end;
end;

procedure TestCase1.TestSort1;
var
	i: Integer;
begin
	sortNumbers(arr);
	for i := Low(arr)+1 to High(arr) do
	begin
		if arr[i] < arr[i-1] then Fail('not sorted');
	end;
end;

procedure TestCase1.TestSort2;
var
	i: Integer;
begin
	arr := [9, 34, 10, 45, 112, 177, 2, 76, 86, 3, 5, 21, 22, 44, 99, 225, 343, 777, 832, 211, 494];
	sortNumbers(arr);
	for i := Low(arr)+1 to High(arr) do
	begin
		if arr[i] < arr[i-1] then Fail('not sorted');
	end;
end;

procedure TestCase1.TestSort3;
var
	i: Integer;
	arrExp: IntArray;
begin
	arr := [9, 34, 10, 45, 112, 177, 2, 76, 86, 3, 5, 21, 22, 44, 99, 225, 343, 777, 832, 211, 494];
	arrExp := [2, 3, 5, 9, 10, 21, 22, 34, 44, 45, 76, 86, 99, 112, 177, 211, 225, 343, 494, 777, 832];
	sortNumbers(arr);
	for i := 0 to Length(arr)-1 do
	begin
		if arr[Low(arr)+i] <> arrExp[Low(arrExp)+i] then Fail('not sorted at ' + IntToStr(i) + ': ' + IntToStr(arr[Low(arr)+i]) + '<>' + IntToStr(arrExp[Low(arrExp)+i]));
	end;
end;

var
  runner: TTestRunner;

begin
	RegisterTest(TestCase1);
	runner := TTestRunner.Create(nil);
	try	
		runner.Initialize;
		runner.Title := 'Mój runner testowy';
		runner.Run;
	finally
		runner.Free;
	end;
end.
