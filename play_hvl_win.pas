program play_hvl_win;

(*
    Project : Hively Tracker command line player 1.8
    Detail  : FPC Port based on hvl_play 1.8 for Win32
    URL     : http://www.petergordon.org.uk/files/hively_winplay_18.zip
*)

{$MODE OBJFPC}{$H+}

uses
  windows,
  mmsystem,
  hvl_replay,
  chelpers,
  SimpleDebug;



var
  ht            : Phvl_tune = nil;
  WaveOut       : HWAVEOUT  = INVALID_HANDLE_VALUE; //* Device handle */
  wfx           : WAVEFORMATEX;
  audiobuffer   : packed array[0..Pred(3), 0..Pred((44100*2*2) div 50)] of byte;



function init(name: PChar): Boolean;
begin
  wfx.nSamplesPerSec  := 44100;
  wfx.wBitsPerSample  := 16;
  wfx.nChannels       := 2;

  wfx.cbSize          := 0;
  wfx.wFormatTag      := WAVE_FORMAT_PCM;
  wfx.nBlockAlign     := (wfx.wBitsPerSample shr 3) * wfx.nChannels;
  wfx.nAvgBytesPerSec := wfx.nBlockAlign * wfx.nSamplesPerSec;

  DebugLn('before hvl_InitReplayer');
  hvl_InitReplayer();
  DebugLn('after  hvl_InitReplayer');
  
  DebugLn('before hvl_LoadTune');  
  ht := hvl_LoadTune( name, 44100, 0 );
  if ( ht = nil ) then exit (FALSE);
  DebugLn('after hvl_LoadTune');

  if ( waveOutOpen(@WaveOut, WAVE_MAPPER, @wfx, 0, 0, CALLBACK_NULL) <> MMSYSERR_NOERROR ) then
  begin
    WriteLn( 'Unable to open waveout' );
    exit ( FALSE );
  end
  else DebugLn('waveOutOpen succeeded');

  result := TRUE;
end;



procedure shut;
begin
  if ( ht <> nil ) then hvl_FreeTune(ht);
  if ( WaveOut <> INVALID_HANDLE_VALUE ) then waveOutClose(WaveOut);
end;



function main(argc: LongInt; argv: ppchar): integer;
var
  header    : array [0..3-1] of WAVEHDR;
  nextbuf   : LongInt;
  // ** base_mask, waiting_mask: sigset_t;
  i         : LongInt;
begin   
  nextbuf := 0;

  WriteLn( 'Hively Tracker command line player 1.8' );  

  if ( argc < 2 ) then
  begin
    WriteLn( 'Usage: play_hvl <tune>' );
    exit (0);
  end;

  if ( init(argv[1]) ) then
  begin
    WriteLn( 'Tune: ', ht^.ht_Name );
    WriteLn( 'Instruments:' );
    for i := 1 to ht^.ht_InstrumentNr
    do WriteLn(i, ' ', ht^.ht_Instruments[i].ins_Name );

    memset( @header[0], 0, sizeof(WAVEHDR) );
    memset( @header[1], 0, sizeof(WAVEHDR) );
    memset( @header[2], 0, sizeof(WAVEHDR) );

    header[0].dwBufferLength := ((44100*2*2) div 50);
    header[0].lpData         := LPSTR(@audiobuffer[0]);

    header[1].dwBufferLength := ((44100*2*2) div 50);
    header[1].lpData         := LPSTR(@audiobuffer[1]);

    header[2].dwBufferLength := ((44100*2*2) div 50);
    header[2].lpData         := LPSTR(@audiobuffer[2]);

   
    hvl_DecodeFrame         ( ht, @audiobuffer[nextbuf], Pointer(LongWord(@audiobuffer[nextbuf])+2), 4 );
    waveOutPrepareHeader    ( WaveOut, @header[nextbuf], sizeof( WAVEHDR ) );
    waveOutWrite            ( WaveOut, @header[nextbuf], sizeof( WAVEHDR ) );
    nextbuf := (nextbuf+1) mod 3;
    hvl_DecodeFrame         ( ht, @audiobuffer[nextbuf], Pointer(LongWord(@audiobuffer[nextbuf])+2), 4 );
    waveOutPrepareHeader    ( WaveOut, @header[nextbuf], sizeof( WAVEHDR ) );
    waveOutWrite            ( WaveOut, @header[nextbuf], sizeof( WAVEHDR ) );
    nextbuf := (nextbuf+1) mod 3;

    while true do 
    begin
      hvl_DecodeFrame       ( ht, @audiobuffer[nextbuf], Pointer(LongWord(@audiobuffer[nextbuf])+2), 4 );
      waveOutPrepareHeader  ( WaveOut, @header[nextbuf], sizeof( WAVEHDR ) );
      waveOutWrite          ( WaveOut, @header[nextbuf], sizeof( WAVEHDR ) );
      nextbuf := (nextbuf+1) mod 3;
     
      // Don't do this in your own player or plugin :-)
      while( waveOutUnprepareHeader( WaveOut, @header[nextbuf], sizeof( WAVEHDR ) ) = WAVERR_STILLPLAYING ) 
      do { explicitly do nothing } ;
    end;
    
  end;
  shut();

  result := 0;
end;



begin
  Exitcode := Main(argc, argv);
end.
