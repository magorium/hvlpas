unit chelpers;


interface

Type
  size_t    = SizeInt;
  float64   = extended; // fixes precision errors shown when using double
  pvoid     = pointer;
  sigset_t  = LongWord;


function  IIF(expression: boolean; TrueValue: LongWord; FalseValue: LongWord): LongWord; overload; inline;
function  IIF(expression: boolean; TrueValue: Byte; FalseValue: Byte): Byte; overload; inline;

function  memcpy(destination: pvoid; const source: pvoid; num: size_t): pvoid; inline;
function  memset(ptr: pvoid; value: byte; num: size_t): pvoid; inline;


implementation



(*
  Copy block of memory

  Copies the values of num bytes from the location pointed by source directly to 
  the memory block pointed by destination.

  The underlying type of the objects pointed by both the source and destination 
  pointers are irrelevant for this function; The result is a binary copy of the 
  data.

  The function does not check for any terminating null character in source - it 
  always copies exactly num bytes.

  To avoid overflows, the size of the arrays pointed by both the destination 
  and source parameters, shall be at least num bytes, and should not overlap 
  (for overlapping memory blocks, memmove is a safer approach).
*)
function  memcpy(destination: pvoid; const source: pvoid; num: size_t): pvoid; inline;
begin
  Move(Source^, Destination^, num);
  memcpy := destination;
end;


(*
  Fill block of memory

  Sets the first num bytes of the block of memory pointed by ptr to the 
  specified value (interpreted as an unsigned char).
*)
function  memset(ptr: pvoid; value: byte; num: size_t): pvoid; inline;
begin
  FillChar(ptr^, num, value);
  memset := ptr;
end;


(*
  Immediate If 'simulation'.
*)
function  IIF(expression: boolean; TrueValue: LongWord; FalseValue: LongWord): LongWord; overload; inline;
begin
  if expression 
  then IIF := truevalue 
  else IIF := falsevalue;
end;


function  IIF(expression: boolean; TrueValue: Byte; FalseValue: Byte): Byte; overload; inline;
begin
  if expression 
  then IIF := truevalue 
  else IIF := falsevalue;
end;


end.
