program hvl2wav;


(*
    Project : HVL2WAV v1.2
    Detail  : FPC Port based on HVL2WAV v1.2 for Win32 and AmigaOS4
    URL     : http://www.petergordon.org.uk/files/hvl2wav12.zip 
*)


{$H+}


Uses
  sysutils,
  replay;       // unit replay, based on hvl replayer library 1.8


Var
  max_frames    : uint32    = 10 * 60 * 50;
  framelen      : uint32;
  mix_freq      : uint32    = 44100;
  subsong       : uint32    = 0;
  smplen        : uint32    = 0;
  stereosep     : uint32    = 0;
  autogain      : longbool  = FALSE;
  use_songend   : longbool  = TRUE;
  filename      : pchar     = Nil;
  outname       : pchar     = Nil;
  wavname       : packed array [0..pred(1020)] of char;
  tmpname       : packed array [0..pred(1024)] of char;
  mixbuf        : pint8     = Nil;
  ht            : Phvl_tune = Nil;
  outf          : longint;
  tempf         : longint;


procedure write32(f: THandle; n: uint32);
begin
  {$IFDEF ENDIAN_BIG}
  FileWrite(f, SwapEndian(n), SizeOf(n));
  {$ELSE}
  FileWrite(f, n, SizeOf(n));
  {$ENDIF}
end;


procedure write16(f: THandle; n: uint16);
begin
  {$IFDEF ENDIAN_BIG}
  FileWrite(f, SwapEndian(n), SizeOf(n));
  {$ELSE}
  FileWrite(f, n, SizeOf(n));
  {$ENDIF}
end;


function Main(argc: longint; argv: ppchar): longint;
var
  i, j  : LongInt;
  l     : int32;
  frm   : uint32;
  {$IFDEF ENDIAN_BIG}
  k     : int8;
  {$ENDIF}
begin
  for i := 1 to pred(argc) do
  begin
    if (argv[i][0] = '-') then
    begin
      case ( argv[i][1] ) of
        't' :
        begin
          max_frames := StrToInt( argv[i][2] ) * 50;
          j := 2;
          while( ( argv[i][j] >= '0' ) and ( argv[i][j] <= '9' ) ) do inc(j);
          if ( argv[i][j] = ':' ) then
          begin
            max_frames := max_frames * 60;
            max_frames := max_frames + (StrToInt( argv[i][j+1] )*50);
          end;

          if ( max_frames = 0 ) then
          begin
            WriteLn( 'Invalid timeout' );
            exit( 0 );
          end;

          use_songend := FALSE;
        end;

        'f' :
        begin
          mix_freq := StrToInt( argv[i][2] );
          if( ( mix_freq < 8000 ) or ( mix_freq > 48000 ) ) then
          begin
            WriteLn( 'Frequency should be between 8000 and 48000' );
            exit( 0 )
          end;
        end;

        's' :
        begin
          subsong := StrToInt( argv[i][2] );
        end;

        'a' :
        begin
          autogain := TRUE;
        end;

        'o' :
        begin
          outname := @argv[i][2];
          if ( outname[0] = #0 ) then
          begin
            WriteLn( 'Invalid output name' );
            exit( 0 );
          end;
        end;

        'x' :
        begin
          stereosep := StrToInt( argv[i][2] );
          if( stereosep > 4 ) then stereosep := 4;
        end;

      end; //  case
    end
    else
    begin
      if filename = nil then filename := argv[i];
    end;
  end;


  if ( filename = nil ) then
  begin
    WriteLn( 'HVL2WAV 1.2, replayer v1.8' );
    WriteLn( 'By Xeron/IRIS (pete@petergordon.org.uk)' );
    WriteLn;
    WriteLn( 'Usage: hvl2wav [options] <filename>' );
    WriteLn;
    WriteLn( 'Options:' );
    WriteLn( '  -ofile Output to "file"' );
    WriteLn( '  -tm:ss Timeout after m minutes and ss seconds' );
    WriteLn( '         (overrides songend detection, defaults to 10:00' );
    WriteLn( '  -fn    Set frequency, where n is 8000 to 48000' );
    WriteLn( '  -sn    Use subsong n' );
    WriteLn( '  -a     Calculate optimal gain before converting' );
    WriteLn( '  -xn    Set stereo seperation (ahx only, no effect on HVL files)' );
    WriteLn( '            0 = 0% (Mono)' );
    WriteLn( '            1 = 25%' );
    WriteLn( '            2 = 50%' );
    WriteLn( '            3 = 75%' );
    WriteLn( '            4 = 100% (Paula)' );
    exit   ( 0 );
  end;


  framelen := (mix_freq*2*2) div 50;  // framelen = 3528 bytes
  mixbuf   := GetMem( framelen );
  if ( mixbuf = nil ) then
  begin
    WriteLn( 'Out of memory :-(' );
    exit( 0 );
  end;


  hvl_InitReplayer;


  ht := hvl_LoadTune( filename, mix_freq, stereosep );
  if ( ht = nil ) then
  begin
    FreeMem( mixbuf );
    WriteLn(Format( 'Unable to open "%s"', [filename] ));
    exit( 0 );
  end;


  if ( not hvl_InitSubsong( ht, subsong ) ) then
  begin
    hvl_FreeTune( ht );
    FreeMem( mixbuf );
    WriteLn( Format( 'Unable to initialise subsong %d', [subsong] ));
    exit( 0 );
  end;


  if ( autogain ) then
  begin
    WriteLn( 'Calculating optimal gain...' );
    l := hvl_FindLoudest( ht, max_frames, use_songend );
    if ( l > 0 )
    then l := 3276700 div l
    else l := 100;

    if ( l > 200 ) then l := 200;
    ht^.ht_mixgain := (l * 256) div 100;

    hvl_InitSubsong( ht, subsong );
    ht^.ht_SongEndReached := 0;
  end;


  writeln( 'Converting tune...' );


  if ( outname <> nil ) then
  begin
    strlcopy( wavname, outname, 1020 );
  end
  else
  begin
    if ( ( strlen( filename ) > 4 ) and
         ( ( strlcomp( filename, 'hvl.', 4 ) = 0 ) or
           ( strlcomp( filename, 'ahx.', 4 ) = 0 ) ) )
    then strlcopy( wavname, @filename[4], 1020 )
    else strlcopy( wavname, filename, 1020 );

    if ( ( strlen( wavname ) > 4 ) and
         ( ( strcomp( @wavname[strlen(wavname)-4], '.hvl' ) = 0 ) or
           ( strcomp( @wavname[strlen(wavname)-4], '.ahx' ) = 0 ) ) )
    then wavname[strlen(wavname)-4] := #0;
    strcat( wavname, '.wav' );
  end;


  strcopy( tmpname, wavname );
  strcat ( tmpname, '.tmp'  );


  tempf := FileCreate( tmpname, fmOpenReadWrite);
  if ( tempf = -1 ) then
  begin
    hvl_FreeTune( ht );
    FreeMem( mixbuf );
    WriteLn(Format( 'Unable to open "%s" for output', [tmpname] ));
    exit( 0 );
  end;


  frm    := 0;
  smplen := 0;
  while ( frm < max_frames ) do
  begin
    if ( ( use_songend ) and ( ht^.ht_SongEndReached <> 0) )
    then break;

    hvl_DecodeFrame( ht, mixbuf, @mixbuf[2], 4 );

    {$IFDEF ENDIAN_BIG}
    // The replayer generates audio samples in the same
    // endian mode as the CPU. So on big endian systems
    // we have to swap it all to stupid endian for the
    // WAV format.
    i := 0;
    while ( i < framelen ) do
    begin
      k           := mixbuf[i]; 
      mixbuf[i]   := mixbuf[i+1]; 
      mixbuf[i+1] := k;
      i := i + 2;
    end;
    {$ENDIF}

    filewrite( tempf, mixbuf^, framelen );
    smplen := smplen + framelen;
    frm := frm + 1;
  end;


  FileClose( tempf );


  outf := filecreate( wavname, fmOpenReadWrite );
  if ( outf = -1 ) then
  begin
    hvl_FreeTune( ht );
    FreeMem( mixbuf );
    //unlink( tmpname );
    WriteLn( Format('Unable to open "%s" for output', [wavname] ));
    exit( 0 );
  end;


  tempf := FileOpen( tmpname, fmOpenRead );
  if ( tempf = -1 ) then
  begin
    FileClose( outf );
    //unlink( wavname );
    //unlink( tmpname );
    hvl_FreeTune( ht );
    FreeMem( mixbuf );
    WriteLn( Format( 'Unable to open "%s" for input', [tmpname] ));
    exit( 0 );
  end;


  FileWrite( outf, 'RIFF', 4 );
  write32  ( outf, smplen+36 );
  FileWrite( outf, 'WAVE', 4 );
  FileWrite( outf, 'fmt ', 4 );
  write32  ( outf, 16 );
  write16  ( outf, 1 );
  write16  ( outf, 2 );
  write32  ( outf, mix_freq );
  write32  ( outf, mix_freq*4 );
  write16  ( outf, 4 );
  write16  ( outf, 16 );
  FileWrite( outf, 'data', 4 );
  write32  ( outf, smplen );


  i := 0;
  while ( i < smplen ) do
  begin
    FileRead ( tempf, mixbuf^, framelen);
    FileWrite(  outf, mixbuf^, framelen);

    i := i + framelen;
  end;


  FileClose( outf );
  FileClose( tempf );
  //unlink( tmpname );
  hvl_FreeTune( ht );
  FreeMem( mixbuf );
  WriteLn( 'ALL DONE!' );
  exit( 0 );
end;


begin
  ExitCode := Main(argc, argv);
end.
