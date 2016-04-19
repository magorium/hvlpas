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


const
  MAX_CHANNELS              = 16;


Type
  Thvl_envelope             = record
    aFrames, aVolume        : int16;
    dFrames, dVolume        : int16;
    sFrames                 : int16;
    rFrames, rVolume        : int16;
    pad                     : int16;
  end;

  Thvl_plsentry             = record
    ple_Note                : uint8;
    ple_Waveform            : uint8;
    ple_Fixed               : int16;
    ple_FX                  : packed array[0..Pred(2)] of int8;
    ple_FXParam             : packed array[0..Pred(2)] of int8;
  end;
  Phvl_plsentry             = ^Thvl_plsentry;
    
  Thvl_plist                = record
    pls_Speed               : int16;
    pls_Length              : int16;
    pls_Entries             : Phvl_plsentry;
  end;  
  Phvl_plist                = ^Thvl_plist;
  
  Thvl_instrument           = record
    ins_Name                : packed array[0..Pred(128)] of char;
    ins_Volume              : uint8;
    ins_WaveLength          : uint8;
    ins_FilterLowerLimit    : uint8;
    ins_FilterUpperLimit    : uint8;
    ins_FilterSpeed         : uint8;
    ins_SquareLowerLimit    : uint8;
    ins_SquareUpperLimit    : uint8;
    ins_SquareSpeed         : uint8;
    ins_VibratoDelay        : uint8;
    ins_VibratoSpeed        : uint8;
    ins_VibratoDepth        : uint8;
    ins_HardCutRelease      : uint8;
    ins_HardCutReleaseFrames: uint8;
    ins_Envelope            : Thvl_envelope;
    ins_PList               : Thvl_plist;
  end;
  Phvl_instrument           = ^Thvl_instrument;

  Thvl_position             = record
    pos_Track               : packed array[0..Pred(MAX_CHANNELS)] of uint8;
    pos_Transpose           : packed array[0..Pred(MAX_CHANNELS)] of int8;
  end;
  Phvl_position             = ^Thvl_position;
      
  Thvl_step                 = record
    stp_Note                : uint8;
    stp_Instrument          : uint8;
    stp_FX                  : uint8;
    stp_FXParam             : uint8;
    stp_FXb                 : uint8;
    stp_FXbParam            : uint8;
  end;
  Phvl_Step                 = ^Thvl_step;

  Thvl_voice                = record
    vc_Track                : int16;
    vc_NextTrack            : int16;
    vc_Transpose            : int16;
    vc_NextTranspose        : int16;
    vc_OverrideTranspose    : int16;            // 1.5
    vc_ADSRVolume           : int32;
    vc_ADSR                 : Thvl_envelope;
    vc_Instrument           : Phvl_instrument;
    vc_SamplePos            : uint32;
    vc_Delta                : uint32;
    vc_InstrPeriod          : uint16;
    vc_TrackPeriod          : uint16;
    vc_VibratoPeriod        : uint16;
    vc_WaveLength           : uint16;
    vc_NoteMaxVolume        : int16;
    vc_PerfSubVolume        : uint16;
    vc_NewWaveform          : uint8;
    vc_Waveform             : uint8;
    vc_PlantPeriod          : uint8;
    vc_VoiceVolume          : uint8;
    vc_PlantSquare          : uint8;
    vc_IgnoreSquare         : uint8;
    vc_FixedNote            : uint8;
    vc_VolumeSlideUp        : int16;
    vc_VolumeSlideDown      : int16;
    vc_HardCut              : int16;
    vc_HardCutRelease       : uint8;
    vc_HardCutReleaseF      : int16;
    vc_PeriodSlideOn        : uint8;
    vc_PeriodSlideSpeed     : int16;
    vc_PeriodSlidePeriod    : int16;
    vc_PeriodSlideLimit     : int16;
    vc_PeriodSlideWithLimit : int16;
    vc_PeriodPerfSlideSpeed : int16;
    vc_PeriodPerfSlidePeriod: int16;
    vc_PeriodPerfSlideOn    : uint8;
    vc_VibratoDelay         : int16;
    vc_VibratoSpeed         : int16;
    vc_VibratoCurrent       : int16;
    vc_VibratoDepth         : int16;
    vc_SquareOn             : int16;
    vc_SquareInit           : int16;
    vc_SquareWait           : int16;
    vc_SquareLowerLimit     : int16;
    vc_SquareUpperLimit     : int16;
    vc_SquarePos            : int16;
    vc_SquareSign           : int16;
    vc_SquareSlidingIn      : int16;
    vc_SquareReverse        : int16;
    vc_FilterOn             : uint8;
    vc_FilterInit           : uint8;
    vc_FilterWait           : int16;
    vc_FilterSpeed          : int16;
    vc_FilterUpperLimit     : int16;
    vc_FilterLowerLimit     : int16;
    vc_FilterPos            : int16;
    vc_FilterSign           : int16;
    vc_FilterSlidingIn      : int16;
    vc_IgnoreFilter         : int16;
    vc_PerfCurrent          : int16;
    vc_PerfSpeed            : int16;
    vc_PerfWait             : int16;
    vc_PerfList             : Phvl_plist;
    vc_AudioPointer         : Pint8;
    vc_AudioSource          : Pint8;
    vc_NoteDelayOn          : uint8;
    vc_NoteCutOn            : uint8;
    vc_NoteDelayWait        : int16;
    vc_NoteCutWait          : int16;
    vc_AudioPeriod          : int16;
    vc_AudioVolume          : int16;
    vc_WNRandom             : int32;
    vc_MixSource            : Pint8;
    vc_SquareTempBuffer     : packed array[0..Pred($80)] of int8;
    vc_VoiceBuffer          : packed array[0..Pred($282*4)] of int8;
    vc_VoiceNum             : uint8;
    vc_TrackMasterVolume    : uint8;
    vc_TrackOn              : uint8;
    vc_VoicePeriod          : int16;
    vc_Pan                  : uint32;
    vc_SetPan               : uint32;    // New for 1.4
    vc_PanMultLeft          : uint32;
    vc_PanMultRight         : uint32;
    vc_RingSamplePos        : uint32;
    vc_RingDelta            : uint32;
    vc_RingMixSource        : Pint8;
    vc_RingPlantPeriod      : uint8;
    vc_RingInstrPeriod      : int16;
    vc_RingBasePeriod       : int16;
    vc_RingAudioPeriod      : int16;
    vc_RingAudioSource      : Pint8;
    vc_RingNewWaveform      : uint8;
    vc_RingWaveform         : uint8;
    vc_RingFixedPeriod      : uint8;
    vc_RingVoiceBuffer      : packed array[0..Pred($282*4)] of int8;
  end;
  Phvl_voice                = ^Thvl_voice;

  Thvl_tune                 = record
    ht_Name                 : packed array[0..Pred(128)] of char;
    ht_SongNum              : uint16;
    ht_Frequency            : uint32;
    ht_FreqF                : float64;
    ht_WaveformTab          : array[0..Pred(MAX_CHANNELS)] of Pint8;
    ht_Restart              : uint16;
    ht_PositionNr           : uint16;
    ht_SpeedMultiplier      : uint8;
    ht_TrackLength          : uint8;
    ht_TrackNr              : uint8;
    ht_InstrumentNr         : uint8;
    ht_SubsongNr            : uint8;
    ht_PosJump              : uint16;
    ht_PlayingTime          : uint32;
    ht_Tempo                : int16;
    ht_PosNr                : int16;
    ht_StepWaitFrames       : int16;
    ht_NoteNr               : int16;
    ht_PosJumpNote          : uint16;
    ht_GetNewPosition       : uint8;
    ht_PatternBreak         : uint8;
    ht_SongEndReached       : uint8;
    ht_Stereo               : uint8;
    ht_Subsongs             : Puint16;
    ht_Channels             : uint16;
    ht_Positions            : Phvl_position;
    ht_Tracks               : array[0..Pred(256), 0..Pred(64)] of Thvl_step;
    ht_Instruments          : Phvl_instrument;
    ht_Voices               : array[0..Pred(MAX_CHANNELS)] of Thvl_voice;         
    ht_defstereo            : int32;
    ht_defpanleft           : int32;
    ht_defpanright          : int32;
    ht_mixgain              : int32;
    ht_Version              : uint8;
  end;
  Phvl_tune                 = ^Thvl_tune;


implementation


uses
  simpledebug, sysutils;



function Period2Freq(period: int16): float64; inline;
begin
  Period2Freq := (3546897.0 * 65536.0) / (period);
end;



Var
  panning_left  : array [0..Pred(256)] of uint32;
  panning_right : array [0..Pred(256)] of uint32;



procedure hvl_GenPanningTables;
var
  i         : uint32;
  aa, ab    : float64;
begin
  // Sine based panning table
  aa := (3.14159265*2.0) / 4.0;   // Quarter of the way through the sinewave == top peak
  ab := 0.0;                      // Start of the climb from zero

  for i := 0 to Pred(256) do 
  begin
    panning_left[i]  := uint32( trunc ( sin(aa) * 255.0 ) ); // FPC: requires truncation
    panning_right[i] := uint32( trunc ( sin(ab) * 255.0 ) ); // FPC: requires truncation
    
    aa := aa + (3.14159265 * 2.0 / 4.0) / 256.0;
    ab := ab + (3.14159265 * 2.0 / 4.0) / 256.0;
  end;
  panning_left[255] := 0;
  panning_right[0]  := 0;
end;



procedure hvl_GenSawtooth(buf: pint8; len: uint32);
var
  i     : uint32;
  val, 
  add   : int32;
begin
  add := 256 div (len-1);
  val := -128;

  i := 0;
  while (i < len) do 
  begin
    buf^ := int8(val);   
    inc(buf, 1);
    val  := val + add;

    inc(i);
  end;    
end;



procedure hvl_GenTriangle(buf: pint8; len: uint32);
var
  i              : uint32;
  d1, d2, d4, d5 : int32;
  val            : int32;
  buf2           : pint8;
  c              : int8;
begin
  d2  := len;
  d5  := len shr 2;
  d1  := 128 div d5;

  d4  := -(d2 shr 1);
  val := 0;
  
  i := 0;
  while ( i < d5 ) do
  begin
    buf^ := val;  
    inc(buf, 1);
    val := val + d1;
    inc(i);
  end;
  buf^ := $7f; 
  inc(buf, 1);

  if ( d5 <> 1 ) then
  begin
    val := 128;

    i := 0;
    while ( i < d5-1 ) do
    begin
      val := val - d1;
      buf^ := val;  
      inc(buf, 1);
      inc(i);
    end;
  end;

  buf2 := buf + d4;

  i := 0;
  while ( i < d5*2 ) do
  begin
    c := buf2^; 
    inc(buf2, 1);

    if ( c = $7f )
    then c := int8($80)         // FPC: cast to suppress warning
    else c := -c;

    buf^ := c;  
    inc(buf, 1);
    inc(i);
  end;
end;



procedure hvl_GenSquare(buf: pint8);
var
  i, j: uint32;
begin
  for i := 1 to $20 do
  begin
    for j := 0 to pred(($40 - i) * 2) do
    begin
      buf^ := int8($80);        // FPC: cast to suppress warning
      inc(buf, 1);
    end;

    for j := 0 to pred(i * 2) do
    begin
      buf^ := $7f;
      inc(buf, 1);
    end;
  end;
end;



function clip(x: float64): float64; inline;
begin
  if ( x > 127.0 )
  then x := 127.0
  else if ( x < -128.0 )
       then x := -128.0;
  clip := x;
end;



procedure hvl_GenFilterWaves(buf: pint8; lowbuf: pint8; highbuf: pint8);
const
  lentab : array[0..pred(45)] of uint16 =
  (
    3, 7, $f, $1f, $3f, $7f, 
    3, 7, $f, $1f, $3f, $7f,
    $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f, 
    $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,
    ($280*3)-1
  );
var
  freq  : float64;
  temp  : uint32;

  wv    : uint32;
  a0    : pint8;

  fre, 
  high, 
  mid, 
  low   : float64;

  i     : uint32;
begin
  freq := 8.0;
  
  for temp := 0 to Pred(31) do
  begin
    a0  := buf;

    for wv := 0 to Pred(6+6+$20+1) do
    begin    
      mid := 0.0;
      low := 0.0;
      fre := freq * 1.25 / 100.0;
    
      for i := 0 to lentab[wv] do
      begin
        high  := a0[i] - mid - low;
        high  := clip( high );
        mid   := mid + (high * fre);
        mid   := clip( mid );
        low   := low + (mid * fre);
        low   := clip( low );
      end;

      for i := 0 to lentab[wv] do
      begin
        high  := a0[i] - mid - low;
        high  := clip( high );
        mid   := mid + (high * fre);
        mid   := clip( mid );
        low   := low + (mid * fre);
        low   := clip( low );
        lowbuf^  := int8( trunc(low ));   // FPC: requires truncation
        inc(lowbuf, 1);  
        highbuf^ := int8( trunc(high));   // FPC: requires truncation
        inc(highbuf, 1);
      end;

      a0 := a0 + lentab[wv]+1;    
    end; // next wv

    freq := freq + 3.0;
  end; // next temp
end;



procedure hvl_GenWhiteNoise(buf: pint8; len: uint32);
var
  ays   : uint32;
var
  ax, 
  bx    : uint16;
  s     : int8;
begin
  ays := $41595321;

  repeat
    s := ays;

    if ( ays and $100 <> 0 ) then
    begin
      s := int8($80);                   // FPC: cast to suppress warning

      if ( LongInt(ays and $ffff) >= 0 )
      then s := $7f;
    end;

    buf^ := s;  inc(buf, 1);
    dec(len, 1);

    ays := (ays shr 5) or (ays shl 27);
    ays := (ays and $ffffff00) or ((ays and $ff) xor $9a);
    bx  := ays;
    ays := (ays shl 2) or (ays shr 30);
    ax  := ays;
    bx  := bx + ax;
    ax  := ax xor bx;
    ays := (ays and $ffff0000) or ax;
    ays := (ays shr 3) or (ays shl 29);
  until ( len <= 0 );
end;



procedure hvl_reset_some_stuff(ht: Phvl_tune);
var
  i : uint32;
begin
  for i := 0 to Pred(MAX_CHANNELS) do
  begin
    ht^.ht_Voices[i].vc_Delta                 := 1;
    ht^.ht_Voices[i].vc_OverrideTranspose     := 1000;  // 1.5

    ht^.ht_Voices[i].vc_SamplePos             := 0;
    ht^.ht_Voices[i].vc_Track                 := 0;
    ht^.ht_Voices[i].vc_Transpose             := 0;
    ht^.ht_Voices[i].vc_NextTrack             := 0;
    ht^.ht_Voices[i].vc_NextTranspose         := 0;

    ht^.ht_Voices[i].vc_ADSRVolume            := 0;
    ht^.ht_Voices[i].vc_InstrPeriod           := 0;
    ht^.ht_Voices[i].vc_TrackPeriod           := 0;
    ht^.ht_Voices[i].vc_VibratoPeriod         := 0;
    ht^.ht_Voices[i].vc_NoteMaxVolume         := 0;
    ht^.ht_Voices[i].vc_PerfSubVolume         := 0;
    ht^.ht_Voices[i].vc_TrackMasterVolume     := 0;

    ht^.ht_Voices[i].vc_NewWaveform           := 0;
    ht^.ht_Voices[i].vc_Waveform              := 0;
    ht^.ht_Voices[i].vc_PlantSquare           := 0;
    ht^.ht_Voices[i].vc_PlantPeriod           := 0;
    ht^.ht_Voices[i].vc_IgnoreSquare          := 0;

    ht^.ht_Voices[i].vc_TrackOn               := 0;
    ht^.ht_Voices[i].vc_FixedNote             := 0;
    ht^.ht_Voices[i].vc_VolumeSlideUp         := 0;
    ht^.ht_Voices[i].vc_VolumeSlideDown       := 0;
    ht^.ht_Voices[i].vc_HardCut               := 0;
    ht^.ht_Voices[i].vc_HardCutRelease        := 0;
    ht^.ht_Voices[i].vc_HardCutReleaseF       := 0;

    ht^.ht_Voices[i].vc_PeriodSlideSpeed      := 0;
    ht^.ht_Voices[i].vc_PeriodSlidePeriod     := 0;
    ht^.ht_Voices[i].vc_PeriodSlideLimit      := 0;
    ht^.ht_Voices[i].vc_PeriodSlideOn         := 0;
    ht^.ht_Voices[i].vc_PeriodSlideWithLimit  := 0;

    ht^.ht_Voices[i].vc_PeriodPerfSlideSpeed  := 0;
    ht^.ht_Voices[i].vc_PeriodPerfSlidePeriod := 0;
    ht^.ht_Voices[i].vc_PeriodPerfSlideOn     := 0;
    ht^.ht_Voices[i].vc_VibratoDelay          := 0;
    ht^.ht_Voices[i].vc_VibratoCurrent        := 0;
    ht^.ht_Voices[i].vc_VibratoDepth          := 0;
    ht^.ht_Voices[i].vc_VibratoSpeed          := 0;

    ht^.ht_Voices[i].vc_SquareOn              := 0;
    ht^.ht_Voices[i].vc_SquareInit            := 0;
    ht^.ht_Voices[i].vc_SquareLowerLimit      := 0;
    ht^.ht_Voices[i].vc_SquareUpperLimit      := 0;
    ht^.ht_Voices[i].vc_SquarePos             := 0;
    ht^.ht_Voices[i].vc_SquareSign            := 0;
    ht^.ht_Voices[i].vc_SquareSlidingIn       := 0;
    ht^.ht_Voices[i].vc_SquareReverse         := 0;

    ht^.ht_Voices[i].vc_FilterOn              := 0;
    ht^.ht_Voices[i].vc_FilterInit            := 0;
    ht^.ht_Voices[i].vc_FilterLowerLimit      := 0;
    ht^.ht_Voices[i].vc_FilterUpperLimit      := 0;
    ht^.ht_Voices[i].vc_FilterPos             := 0;
    ht^.ht_Voices[i].vc_FilterSign            := 0;
    ht^.ht_Voices[i].vc_FilterSpeed           := 0;
    ht^.ht_Voices[i].vc_FilterSlidingIn       := 0;
    ht^.ht_Voices[i].vc_IgnoreFilter          := 0;

    ht^.ht_Voices[i].vc_PerfCurrent           := 0;
    ht^.ht_Voices[i].vc_PerfSpeed             := 0;
    ht^.ht_Voices[i].vc_WaveLength            := 0;
    ht^.ht_Voices[i].vc_NoteDelayOn           := 0;
    ht^.ht_Voices[i].vc_NoteCutOn             := 0;

    ht^.ht_Voices[i].vc_AudioPeriod           := 0;
    ht^.ht_Voices[i].vc_AudioVolume           := 0;
    ht^.ht_Voices[i].vc_VoiceVolume           := 0;
    ht^.ht_Voices[i].vc_VoicePeriod           := 0;
    ht^.ht_Voices[i].vc_VoiceNum              := 0;
    ht^.ht_Voices[i].vc_WNRandom              := 0;

    ht^.ht_Voices[i].vc_SquareWait            := 0;
    ht^.ht_Voices[i].vc_FilterWait            := 0;
    ht^.ht_Voices[i].vc_PerfWait              := 0;
    ht^.ht_Voices[i].vc_NoteDelayWait         := 0;
    ht^.ht_Voices[i].vc_NoteCutWait           := 0;

    ht^.ht_Voices[i].vc_PerfList              := nil;

    ht^.ht_Voices[i].vc_RingSamplePos         := 0;
    ht^.ht_Voices[i].vc_RingDelta             := 0;
    ht^.ht_Voices[i].vc_RingPlantPeriod       := 0;
    ht^.ht_Voices[i].vc_RingAudioPeriod       := 0;
    ht^.ht_Voices[i].vc_RingNewWaveform       := 0;
    ht^.ht_Voices[i].vc_RingWaveform          := 0;
    ht^.ht_Voices[i].vc_RingFixedPeriod       := 0;
    ht^.ht_Voices[i].vc_RingBasePeriod        := 0;

    ht^.ht_Voices[i].vc_RingMixSource         := nil;
    ht^.ht_Voices[i].vc_RingAudioSource       := nil;

    memset(@ht^.ht_Voices[i].vc_SquareTempBuffer[0], 0, $80);   // FPC
    memset(@ht^.ht_Voices[i].vc_ADSR               , 0, sizeof(Thvl_envelope));
    memset(@ht^.ht_Voices[i].vc_VoiceBuffer[0]     , 0, $281);  // FPC
    memset(@ht^.ht_Voices[i].vc_RingVoiceBuffer[0] , 0, $281);  // FPC
  end;

  for i := 0 to Pred(MAX_CHANNELS) do
  begin
    ht^.ht_Voices[i].vc_WNRandom          := $280;
    ht^.ht_Voices[i].vc_VoiceNum          := i;
    ht^.ht_Voices[i].vc_TrackMasterVolume := $40;
    ht^.ht_Voices[i].vc_TrackOn           := 1;
    ht^.ht_Voices[i].vc_MixSource         := @ht^.ht_Voices[i].vc_VoiceBuffer[0];  // FPC
  end;
end;



function  hvl_InitSubsong(ht: Phvl_tune; nr: uint32): LongBool;
var
  PosNr : uint16;       // FPC
  i     : uint32;
begin
  if ( nr > ht^.ht_SubsongNr )
  then exit(false);

  ht^.ht_SongNum := nr;
  
  PosNr := 0;
  if ( nr <> 0 ) then PosNr := ht^.ht_Subsongs[nr-1];
  
  ht^.ht_PosNr          := PosNr;
  ht^.ht_PosJump        := 0;
  ht^.ht_PatternBreak   := 0;
  ht^.ht_NoteNr         := 0;
  ht^.ht_PosJumpNote    := 0;
  ht^.ht_Tempo          := 6;
  ht^.ht_StepWaitFrames	:= 0;
  ht^.ht_GetNewPosition := 1;
  ht^.ht_SongEndReached := 0;
  ht^.ht_PlayingTime    := 0;

  i := 0;
  while ( i < MAX_CHANNELS ) do
  begin
    ht^.ht_Voices[i+0].vc_Pan          := ht^.ht_defpanleft;
    ht^.ht_Voices[i+0].vc_SetPan       := ht^.ht_defpanleft;    // 1.4
    ht^.ht_Voices[i+0].vc_PanMultLeft  := panning_left[ht^.ht_defpanleft];
    ht^.ht_Voices[i+0].vc_PanMultRight := panning_right[ht^.ht_defpanleft];
    ht^.ht_Voices[i+1].vc_Pan          := ht^.ht_defpanright;
    ht^.ht_Voices[i+1].vc_SetPan       := ht^.ht_defpanright;   // 1.4
    ht^.ht_Voices[i+1].vc_PanMultLeft  := panning_left[ht^.ht_defpanright];
    ht^.ht_Voices[i+1].vc_PanMultRight := panning_right[ht^.ht_defpanright];
    ht^.ht_Voices[i+2].vc_Pan          := ht^.ht_defpanright;
    ht^.ht_Voices[i+2].vc_SetPan       := ht^.ht_defpanright;   // 1.4
    ht^.ht_Voices[i+2].vc_PanMultLeft  := panning_left[ht^.ht_defpanright];
    ht^.ht_Voices[i+2].vc_PanMultRight := panning_right[ht^.ht_defpanright];
    ht^.ht_Voices[i+3].vc_Pan          := ht^.ht_defpanleft;
    ht^.ht_Voices[i+3].vc_SetPan       := ht^.ht_defpanleft;    // 1.4
    ht^.ht_Voices[i+3].vc_PanMultLeft  := panning_left[ht^.ht_defpanleft];
    ht^.ht_Voices[i+3].vc_PanMultRight := panning_right[ht^.ht_defpanleft];
    i := i + 4;
  end;

  hvl_reset_some_stuff( ht );
  
  hvl_InitSubsong := true;
end;



end.
