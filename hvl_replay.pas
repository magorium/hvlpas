unit hvl_replay;

(*
   Pascal port of THX replayer, based on HVL play v1.8 (xx.xx.xxx) by xxxxx
*)


{$H+}


interface


uses
  chelpers;


{$IFDEF WINDOWS}
Type
  pint8                     = ^int8;
  pint16                    = ^int16;
  pint32                    = ^int32;
  puint8                    = ^uint8;
  puint16                   = ^uint16;
{$ENDIF}


implementation



uses
  simpledebug, sysutils;


end.
