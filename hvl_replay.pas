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



  procedure hvl_DecodeFrame( ht: Phvl_tune; buf1: pint8; buf2: pint8; bufmod: int32 );
  procedure hvl_InitReplayer;
  function  hvl_InitSubsong( ht: Phvl_tune; nr: uint32 ): LongBool;
  function  hvl_LoadTune( name: pchar; freq: uint32; defstereo: uint32 ): Phvl_Tune;
  procedure hvl_FreeTune( ht: phvl_tune );



implementation


uses
  simpledebug, sysutils;



function Period2Freq(period: int16): float64; inline;
begin
  Period2Freq := (3546897.0 * 65536.0) / (period);
end;



var
  stereopan_left    : array[0..4] of int32 = ( 128,  96,  64,  32,   0 );
  stereopan_right   : array[0..4] of int32 = ( 128, 160, 193, 225, 255 );



//*
//** Waves
//*
const
  WHITENOISELEN     = ($280*3);                                             
                    
  WO_LOWPASSES      = 0;
  WO_TRIANGLE_04    = (WO_LOWPASSES+(($fc+$fc+$80*$1f+$80+3*$280)*31));     
  WO_TRIANGLE_08    = (WO_TRIANGLE_04+$04);                                 
  WO_TRIANGLE_10    = (WO_TRIANGLE_08+$08);                                 
  WO_TRIANGLE_20    = (WO_TRIANGLE_10+$10);                                 
  WO_TRIANGLE_40    = (WO_TRIANGLE_20+$20);                                 
  WO_TRIANGLE_80    = (WO_TRIANGLE_40+$40);                                 
  WO_SAWTOOTH_04    = (WO_TRIANGLE_80+$80);                                 
  WO_SAWTOOTH_08    = (WO_SAWTOOTH_04+$04);                                 
  WO_SAWTOOTH_10    = (WO_SAWTOOTH_08+$08);                                 
  WO_SAWTOOTH_20    = (WO_SAWTOOTH_10+$10);                                 
  WO_SAWTOOTH_40    = (WO_SAWTOOTH_20+$20);                                 
  WO_SAWTOOTH_80    = (WO_SAWTOOTH_40+$40);                                 
  WO_SQUARES        = (WO_SAWTOOTH_80+$80);                                 
  WO_WHITENOISE     = (WO_SQUARES+($80*$20));                               
  WO_HIGHPASSES     = (WO_WHITENOISE+WHITENOISELEN);                        
  WAVES_SIZE        = (WO_HIGHPASSES+(($fc+$fc+$80*$1f+$80+3*$280)*31));    
  


Var
  waves     : packed array [0..Pred(WAVES_SIZE)] of int8;
  waves2    :        array [0..Pred(WAVES_SIZE)] of int16;



Const
  vib_tab   : array[0..63] of int16 = 
  ( 
    0,24,49,74,97,120,141,161,180,197,212,224,235,244,250,253,255,
    253,250,244,235,224,212,197,180,161,141,120,97,74,49,24,
    0,-24,-49,-74,-97,-120,-141,-161,-180,-197,-212,-224,-235,-244,-250,-253,-255,
    -253,-250,-244,-235,-224,-212,-197,-180,-161,-141,-120,-97,-74,-49,-24
  );



Const
  period_tab : array [0..60] of uint16 =
  (
    $0000, $0D60, $0CA0, $0BE8, $0B40, $0A98, $0A00, $0970,
    $08E8, $0868, $07F0, $0780, $0714, $06B0, $0650, $05F4,
    $05A0, $054C, $0500, $04B8, $0474, $0434, $03F8, $03C0,
    $038A, $0358, $0328, $02FA, $02D0, $02A6, $0280, $025C,
    $023A, $021A, $01FC, $01E0, $01C5, $01AC, $0194, $017D,
    $0168, $0153, $0140, $012E, $011D, $010D, $00FE, $00F0,
    $00E2, $00D6, $00CA, $00BE, $00B4, $00AA, $00A0, $0097,
    $008F, $0087, $007F, $0078, $0071
  );



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



procedure hvl_InitReplayer;
begin
  hvl_GenPanningTables();
  hvl_GenSawtooth( @waves[WO_SAWTOOTH_04], $04 );
  hvl_GenSawtooth( @waves[WO_SAWTOOTH_08], $08 );
  hvl_GenSawtooth( @waves[WO_SAWTOOTH_10], $10 );
  hvl_GenSawtooth( @waves[WO_SAWTOOTH_20], $20 );
  hvl_GenSawtooth( @waves[WO_SAWTOOTH_40], $40 );
  hvl_GenSawtooth( @waves[WO_SAWTOOTH_80], $80 );
  hvl_GenTriangle( @waves[WO_TRIANGLE_04], $04 );
  hvl_GenTriangle( @waves[WO_TRIANGLE_08], $08 );
  hvl_GenTriangle( @waves[WO_TRIANGLE_10], $10 );
  hvl_GenTriangle( @waves[WO_TRIANGLE_20], $20 );
  hvl_GenTriangle( @waves[WO_TRIANGLE_40], $40 );
  hvl_GenTriangle( @waves[WO_TRIANGLE_80], $80 );
  hvl_GenSquare     ( @waves[WO_SQUARES] );
  hvl_GenWhiteNoise ( @waves[WO_WHITENOISE], WHITENOISELEN );
  hvl_GenFilterWaves( @waves[WO_TRIANGLE_04], @waves[WO_LOWPASSES], @waves[WO_HIGHPASSES] );
end;



function  hvl_load_ahx(buf: puint8; buflen: uint32; defstereo: uint32; freq: uint32): Phvl_tune;
var
  bptr      : puint8;
  nptr      : pchar;
  i, j, k, l, posn, insn, ssn, hs, trkn, trkl   : uint32;
  ht        : Phvl_tune;
  ple       : Phvl_plsentry;
const
  defgain   : array[0..4] of int32 = (71, 72, 76, 85, 100);
begin
  posn := ((buf[6] and $0f) shl 8) or buf[7];
  insn := buf[12];
  ssn  := buf[13];
  trkl := buf[10];
  trkn := buf[11];

  hs  :=      sizeof( Thvl_tune       );
  hs  := hs + sizeof( Thvl_position   ) * posn;
  hs  := hs + sizeof( Thvl_instrument ) * (insn+1);
  hs  := hs + sizeof( uint16          ) * ssn;

  // Calculate the size of all instrument PList buffers
  bptr :=        @buf[14];
  bptr := bptr + ssn*2;     // Skip past the subsong list
  bptr := bptr + posn*4*2;  // Skip past the positions
  bptr := bptr + trkn*trkl*3;
  if ((buf[6] and $80) = 0) then bptr := bptr + trkl*3;
  
  // *NOW* we can finally calculate PList space
  i := 1;
  while (i <= insn) do
  begin
    hs   :=   hs +      bptr[21] * sizeof( Thvl_plsentry );
    bptr := bptr + 22 + bptr[21] * 4;
    inc(i);
  end;

  ht := GetMem ( hs );      // FPC: native memory handling
  if not(ht <> nil) then
  begin
    FreeMem( buf );         // FPC: native memory handling
    writeln( 'Out of memory!' );
    exit( nil );
  end;
  
  ht^.ht_Frequency       := freq;
  ht^.ht_FreqF           := float64(freq);

  ht^.ht_Positions       := Phvl_position(@ht[1]);
  ht^.ht_Instruments     := Phvl_instrument(@ht^.ht_Positions[posn]);
  ht^.ht_Subsongs        := puint16(@ht^.ht_Instruments[(insn+1)]);
  ple                    := Phvl_plsentry(@ht^.ht_Subsongs[ssn]);

  ht^.ht_WaveformTab[0]  := @waves[WO_TRIANGLE_04];
  ht^.ht_WaveformTab[1]  := @waves[WO_SAWTOOTH_04];
  ht^.ht_WaveformTab[3]  := @waves[WO_WHITENOISE];

  ht^.ht_Channels        := 4;
  ht^.ht_PositionNr      := posn;
  ht^.ht_Restart         := (buf[8] shl 8) or buf[9];
  ht^.ht_SpeedMultiplier := ((buf[6] shr 5) and 3)+1;
  ht^.ht_TrackLength     := trkl;
  ht^.ht_TrackNr         := trkn;
  ht^.ht_InstrumentNr    := insn;
  ht^.ht_SubsongNr       := ssn;
  ht^.ht_defstereo       := defstereo;
  ht^.ht_defpanleft      := stereopan_left[ht^.ht_defstereo];
  ht^.ht_defpanright     := stereopan_right[ht^.ht_defstereo];
  ht^.ht_mixgain         := (defgain[ht^.ht_defstereo]*256) div 100;
  
  if ( ht^.ht_Restart >= ht^.ht_PositionNr )
  then ht^.ht_Restart := ht^.ht_PositionNr-1;

  // Do some validation  
  if( ( ht^.ht_PositionNr   > 1000 ) or
      ( ht^.ht_TrackLength  >   64 ) or
      ( ht^.ht_InstrumentNr >   64 ) ) then
  begin
    writeln( format( '%d,%d,%d', [ ht^.ht_PositionNr,
                          ht^.ht_TrackLength,
                          ht^.ht_InstrumentNr ] ));

    FreeMem( ht );          // FPC: native memory handling
    FreeMem( buf );         // FPC: native memory handling
    writeln( 'Invalid file.' );
    exit(nil);
  end;

  DebugLn('validation passed');

  strlcopy( ht^.ht_Name, pchar( @buf[(buf[4] shl 8) or buf[5]]), 128 );
  nptr := pchar( @buf[((buf[4] shl 8) or buf[5] )   + strlen( ht^.ht_Name ) +1]);

  bptr := @buf[14];
  
  // Subsongs
  DebugLn('initialize subsongs #', [ht^.ht_SubsongNr]);
  i := 0;
  while (i < ht^.ht_SubsongNr) do
  begin
    DebugLn( ' init subsong ', [i]);
    ht^.ht_Subsongs[i] := (bptr[0] shl 8) or bptr[1];
    if ( ht^.ht_Subsongs[i] >= ht^.ht_PositionNr )
    then ht^.ht_Subsongs[i] := 0;

    bptr := bptr + 2;
    inc(i);
  end;

  // Position list
  DebugLn('initialize position list #', [ht^.ht_PositionNr]);
  i := 0;
  while (i < ht^.ht_PositionNr) do 
  begin
    for j := 0 to Pred(4) do
    begin
      ht^.ht_Positions[i].pos_Track[j]     := bptr^;         
      inc(bptr, 1);
      ht^.ht_Positions[i].pos_Transpose[j] := pint8(bptr)^;
      inc(bptr, 1);
    end;
    inc(i);
  end;

  // Tracks
  DebugLn('initialize tracks #', [ht^.ht_TrackNr]);
  i := 0;
  while (i <= ht^.ht_TrackNr) do
  begin
    if ( ( ( buf[6] and $80 ) = $80 ) and ( i = 0 ) ) then
    begin
      j := 0;
      while (j < ht^.ht_TrackLength) do
      begin
        ht^.ht_Tracks[i][j].stp_Note       := 0;
        ht^.ht_Tracks[i][j].stp_Instrument := 0;
        ht^.ht_Tracks[i][j].stp_FX         := 0;
        ht^.ht_Tracks[i][j].stp_FXParam    := 0;
        ht^.ht_Tracks[i][j].stp_FXb        := 0;
        ht^.ht_Tracks[i][j].stp_FXbParam   := 0;
        inc(j);
      end;
      inc(i);       // FPC: account for update
      continue;
    end;
    
    j := 0;
    while (j < ht^.ht_TrackLength) do
    begin
      ht^.ht_Tracks[i][j].stp_Note       := (bptr[0] shr 2) and $3f;
      ht^.ht_Tracks[i][j].stp_Instrument := ((bptr[0] and $3) shl 4) or (bptr[1] shr 4);
      ht^.ht_Tracks[i][j].stp_FX         := bptr[1] and $f;
      ht^.ht_Tracks[i][j].stp_FXParam    := bptr[2];
      ht^.ht_Tracks[i][j].stp_FXb        := 0;
      ht^.ht_Tracks[i][j].stp_FXbParam   := 0;
      bptr := bptr + 3;
      inc(j);
    end;

    inc(i);
  end;
  
  // Instruments
  DebugLn('initialize instruments #', [ht^.ht_InstrumentNr]);
  i := 1;
  while (i <= ht^.ht_InstrumentNr) do
  begin
    if ( nptr < pchar(buf+buflen) ) then
    begin
      strlcopy( ht^.ht_Instruments[i].ins_Name, nptr, 128 );
      nptr := nptr + strlen( nptr ) + 1;
    end
    else
    begin
      ht^.ht_Instruments[i].ins_Name[0] := #0;
    end;
    
    ht^.ht_Instruments[i].ins_Volume                := bptr[0];
    ht^.ht_Instruments[i].ins_FilterSpeed           := ((bptr[1] shr 3) and $1f) or ((bptr[12] shr 2) and $20);
    ht^.ht_Instruments[i].ins_WaveLength            := bptr[1] and $07;

    ht^.ht_Instruments[i].ins_Envelope.aFrames      := bptr[2];
    ht^.ht_Instruments[i].ins_Envelope.aVolume      := bptr[3];
    ht^.ht_Instruments[i].ins_Envelope.dFrames      := bptr[4];
    ht^.ht_Instruments[i].ins_Envelope.dVolume      := bptr[5];
    ht^.ht_Instruments[i].ins_Envelope.sFrames      := bptr[6];
    ht^.ht_Instruments[i].ins_Envelope.rFrames      := bptr[7];
    ht^.ht_Instruments[i].ins_Envelope.rVolume      := bptr[8];

    ht^.ht_Instruments[i].ins_FilterLowerLimit      := bptr[12] and $7f;
    ht^.ht_Instruments[i].ins_VibratoDelay          := bptr[13];
    ht^.ht_Instruments[i].ins_HardCutReleaseFrames  := (bptr[14] shr 4) and $07;
        
    if (( bptr[14] and $80) <> 0 )
    then ht^.ht_Instruments[i].ins_HardCutRelease   := 1
    else ht^.ht_Instruments[i].ins_HardCutRelease   := 0;

    ht^.ht_Instruments[i].ins_VibratoDepth          := bptr[14] and $0f;
    ht^.ht_Instruments[i].ins_VibratoSpeed          := bptr[15];
    ht^.ht_Instruments[i].ins_SquareLowerLimit      := bptr[16];
    ht^.ht_Instruments[i].ins_SquareUpperLimit      := bptr[17];
    ht^.ht_Instruments[i].ins_SquareSpeed           := bptr[18];
    ht^.ht_Instruments[i].ins_FilterUpperLimit      := bptr[19] and $3f;
    ht^.ht_Instruments[i].ins_PList.pls_Speed       := bptr[20];
    ht^.ht_Instruments[i].ins_PList.pls_Length      := bptr[21];
        
    ht^.ht_Instruments[i].ins_PList.pls_Entries     := ple;
    ple := ple + bptr[21];
    
    bptr := bptr + 22;

    j := 0;
    while ( j < ht^.ht_Instruments[i].ins_PList.pls_Length ) do
    begin
      k := ( bptr[0] shr 5 ) and 7;
      if ( k = 6 ) then k := 12;
      if ( k = 7 ) then k := 15;
      l := ( bptr[0] shr 2 ) and 7;
      if ( l = 6 ) then l := 12;
      if ( l = 7 ) then l := 15;
      ht^.ht_Instruments[i].ins_PList.pls_Entries[j].ple_FX[1]      := k;
      ht^.ht_Instruments[i].ins_PList.pls_Entries[j].ple_FX[0]      := l;
      ht^.ht_Instruments[i].ins_PList.pls_Entries[j].ple_Waveform   := ((bptr[0] shl 1) and 6) or (bptr[1] shr 7);
      ht^.ht_Instruments[i].ins_PList.pls_Entries[j].ple_Fixed      := (bptr[1] shr 6) and 1;
      ht^.ht_Instruments[i].ins_PList.pls_Entries[j].ple_Note       := bptr[1] and $3f;
      ht^.ht_Instruments[i].ins_PList.pls_Entries[j].ple_FXParam[0] := bptr[2];
      ht^.ht_Instruments[i].ins_PList.pls_Entries[j].ple_FXParam[1] := bptr[3];

      // 1.6: Strip "toggle filter" commands if the module is
      //      version 0 (pre-filters). This is what AHX also does.
      if ( ( buf[3] = 0 ) and ( l = 4 ) and ( (bptr[2] and $f0) <> 0 ) )
        then ht^.ht_Instruments[i].ins_PList.pls_Entries[j].ple_FXParam[0] := ht^.ht_Instruments[i].ins_PList.pls_Entries[j].ple_FXParam[0] and $0f;
      if ( ( buf[3] = 0 ) and ( k = 4 ) and ( (bptr[3] and $f0) <> 0 ) )
        then ht^.ht_Instruments[i].ins_PList.pls_Entries[j].ple_FXParam[1] := ht^.ht_Instruments[i].ins_PList.pls_Entries[j].ple_FXParam[1] and $0f; //1.8

      bptr := bptr + 4;
      inc(j);
    end;
    inc(i);
  end;
  
  Debug('Initializing subsongs...');
  hvl_InitSubsong( ht, 0 );
  DebugLn(' Done!');

  FreeMem( buf );       // FPC: native memory handling

  hvl_load_ahx := ht;
end;



function hvl_LoadTune(name: pchar; freq: uint32; defstereo: uint32): Phvl_Tune;
var
  ht        : Phvl_tune;
  buf, bptr : Puint8;
  nptr      : pchar;
  buflen, i, j, posn, insn, ssn, chnn, hs, trkl, trkn: uint32;
  ple       : Phvl_plsentry;  
var  // FPC: specifics
  fh        : Longint; // THandle;
  nbytes    : longint;
begin
  (*
    Pascalized file and memory handling
  *)
  
  // Check if file exist at all.
  If not FileExists( name ) then
  begin  
    writeln('Unable to find "', name, '"');
    exit(nil);
  end;  

  // Open the file
  fh := FileOpen(name, fmOpenRead);
  if (fh = -1) then
  begin
    writeln( 'Can''t open file' );
    exit (nil);
  end;
  
  // determine size of file/buffer
  FileSeek(fh, 0, fsFromBeginning);         // make sure filepos is zero'ed
  buflen := FileSeek(fh, 0, fsFromEnd);     // seek to end and return its byrnumber
  writeln('determined buffer size of ', buflen);

  // Allocate memory for buffer.
  buf    := GetMem(buflen);                 // Allocate the memory. Classic would require alignment (AllocVec)
  if (buf = nil) then
  begin  
    FileClose(fh);
    writeln('Out of memory');
    exit(nil);
  end;

  // Read file into memory buffer
  FileSeek(fh, 0, fsFromBeginning);         // make sure filepos is zero'ed again
  nbytes := FileRead( fh, buf^, buflen);
  writeln(' read ', nbytes,' bytes');

  if ( nbytes <> buflen ) then
  begin
    FreeMem( buf );
    FileClose( fh );
    writeln( 'Unable to read from file!' );
    exit ( nil );
  end;

  // Finally close the file.
  FileClose( fh );

  //
  // usual analysis follows
  //
  if( ( buf[0] = uint8('T') ) and
      ( buf[1] = uint8('H') ) and
      ( buf[2] = uint8('X') ) and
      ( buf[3] < 3 ) )
  then exit(hvl_load_ahx( buf, buflen, defstereo, freq ));

  if( ( buf[0] <> uint8('H') ) or
      ( buf[1] <> uint8('V') ) or
      ( buf[2] <> uint8('L') ) or
      ( buf[3] > 1 ) )  then // 1.5
  begin
    FreeMem( buf );
    writeln( 'Invalid file.' );
    exit ( nil );
  end;
  
  DebugLn('constructing hvl');
  
  //  buf[4] + buf[5] = length of song without instrument(s) or instrument names
  
  posn := ((buf[6] and $0f) shl 8) or buf[7];       // number of positions ? (in position editor, starts counting from zero) noted in editor as songlength
  insn := buf[12];                                  // number of instruments (editor starts counting at 1)
  ssn  := buf[13];                                  // number of subsongs
  chnn := (buf[8] shr 2) + 4;                       // numbers of channels.. e.g. $10 = 16 shr 2 = 4 + 4 = 8 tracks
  trkl := buf[10];                                  // tracklength (editor start counting from 0, e.g. 64 means 0-63)
  trkn := buf[11];                                  // number of tracks ???? i've seen #90 = $5A, so no idea atm

  hs :=      sizeof( Thvl_tune       );              // reserve room for tune
  hs := hs + sizeof( Thvl_position   ) * posn;       // reserve room for positions
  hs := hs + sizeof( Thvl_instrument ) * (insn+1);   // reserve room for instruments
  hs := hs + sizeof( uint16          ) * ssn;        // reserve room for subsong numbers ?

  // Calculate the size of all instrument PList buffers
  bptr := @buf[16];
  bptr := bptr + (ssn*2);       // Skip past subsong list
  bptr := bptr + (posn*chnn*2); // Skip past positions
  

  // Skip past the tracks
  // 1.4: Fixed two really stupid bugs that cancelled each other
  //      out if the module had a blank first track (which is how
  //      come they were missed.
  if (buf[6] and $80) = $80 
  then i := 1 
  else i := 0;
  
  while (i <= trkn) do
  begin
    j := 0;
    while (j < trkl) do
    begin
      if ( bptr[0] = $3f ) then
      begin
        inc(bptr, 1);
        continue;       // FIXME: Does counter j need to be increased or not ?
      end;
      bptr := bptr + 5;
      inc(j);
    end;
    inc(i);
  end;

  // *NOW* we can finally calculate PList space
  i := 1;
  while (i <= insn) do
  begin
    hs   :=   hs + (      bptr[21] * sizeof( Thvl_plsentry ) );
    bptr := bptr + ( 22 + bptr[21] * 5 );
    inc(i);
  end;

  ht := GetMem( hs );       // FPC: native memory handling
  if not( ht <> nil ) then
  begin
    FreeMem( buf );         // FPC: native memory handling
    writeln( 'Out of memory!' );
    exit ( nil );
  end;
  DebugLn('allocated ht memory');


  ht^.ht_Version         := buf[3]; // 1.5
  ht^.ht_Frequency       := freq;
  ht^.ht_FreqF           := float64(freq);

  ht^.ht_Positions       := Phvl_position( @ht[1] );
  ht^.ht_Instruments     := Phvl_instrument( @ht^.ht_Positions[posn] );
  ht^.ht_Subsongs        := puint16( @ht^.ht_Instruments[(insn+1)] );
  ple                    := Phvl_plsentry( @ht^.ht_Subsongs[ssn] );

  ht^.ht_WaveformTab[0]  := @waves[WO_TRIANGLE_04];
  ht^.ht_WaveformTab[1]  := @waves[WO_SAWTOOTH_04];
  ht^.ht_WaveformTab[3]  := @waves[WO_WHITENOISE];

  ht^.ht_PositionNr      := posn;
  ht^.ht_Channels        := (buf[8] shr 2)+4;
  ht^.ht_Restart         := ((buf[8] and 3) shl 8) or buf[9];
  ht^.ht_SpeedMultiplier := ((buf[6] shr 5) and 3)+1;
  ht^.ht_TrackLength     := buf[10];
  ht^.ht_TrackNr         := buf[11];
  ht^.ht_InstrumentNr    := insn;
  ht^.ht_SubsongNr       := ssn;
  ht^.ht_mixgain         := (buf[14] shl 8) div 100;
  ht^.ht_defstereo       := buf[15];
  ht^.ht_defpanleft      := stereopan_left[ht^.ht_defstereo];
  ht^.ht_defpanright     := stereopan_right[ht^.ht_defstereo];

  if ( ht^.ht_Restart >= ht^.ht_PositionNr )
  then ht^.ht_Restart := ht^.ht_PositionNr-1;

  // Do some validation  
  if ( ( ht^.ht_PositionNr   > 1000 ) or
       ( ht^.ht_TrackLength  >   64 ) or
       ( ht^.ht_InstrumentNr >   64 ) ) then
  begin
    writeln(format( '%d,%d,%d', 
    [ 
      ht^.ht_PositionNr,
      ht^.ht_TrackLength,
      ht^.ht_InstrumentNr 
    ] ));
    FreeMem( ht );      // FPC: native memory handling
    FreeMem( buf );     // FPC: native memory handling
    writeln( 'Invalid file.' );
    exit ( nil );
  end;

  DebugLn('validation passed');
  
  strlcopy( ht^.ht_Name, pchar(@buf[(buf[4] shl 8) or buf[5]]), 128 );
  nptr := pchar(@buf[((buf[4] shl 8) or buf[5]) + strlen( ht^.ht_Name )+1]);

  bptr := @buf[16];

  // Subsongs
  DebugLn('initialize subsongs #', [ht^.ht_SubsongNr]);
  i := 0;
  while (i < ht^.ht_SubsongNr) do
  begin
    ht^.ht_Subsongs[i] := (bptr[0] shl 8) or bptr[1];
    bptr := bptr + 2;
    inc(i);
  end;

  // Position list
  DebugLn('initialize position list #', [ht^.ht_PositionNr]);
  i := 0;
  while (i < ht^.ht_PositionNr) do 
  begin
    j := 0;
    while (j < ht^.ht_Channels) do
    begin
      ht^.ht_Positions[i].pos_Track[j]     := bptr^;         
      inc(bptr, 1);
      ht^.ht_Positions[i].pos_Transpose[j] := pint8(bptr)^;
      inc(bptr, 1);
      inc(j);
    end;
    inc(i);
  end;

  // Tracks
  DebugLn('initialize tracks #', [ht^.ht_TrackNr]);  
  i := 0;
  while (i <= ht^.ht_TrackNr) do
  begin
    if ( ( ( buf[6] and $80 ) = $80 ) and ( i = 0 ) ) then
    begin
      j := 0;
      while (j < ht^.ht_TrackLength) do 
      begin
        ht^.ht_Tracks[i][j].stp_Note       := 0;
        ht^.ht_Tracks[i][j].stp_Instrument := 0;
        ht^.ht_Tracks[i][j].stp_FX         := 0;
        ht^.ht_Tracks[i][j].stp_FXParam    := 0;
        ht^.ht_Tracks[i][j].stp_FXb        := 0;
        ht^.ht_Tracks[i][j].stp_FXbParam   := 0;
        inc(j);
      end;
      inc(i);       // FPC: account for update
      continue;
    end;
    
    j := 0;
    while (j < ht^.ht_TrackLength) do
    begin
      if( bptr[0] = $3f ) then
      begin
        ht^.ht_Tracks[i][j].stp_Note       := 0;
        ht^.ht_Tracks[i][j].stp_Instrument := 0;
        ht^.ht_Tracks[i][j].stp_FX         := 0;
        ht^.ht_Tracks[i][j].stp_FXParam    := 0;
        ht^.ht_Tracks[i][j].stp_FXb        := 0;
        ht^.ht_Tracks[i][j].stp_FXbParam   := 0;
        inc(bptr, 1);
        inc(j);     // FPC: account for update
        continue;
      end;
      
      ht^.ht_Tracks[i][j].stp_Note       := bptr[0];
      ht^.ht_Tracks[i][j].stp_Instrument := bptr[1];
      ht^.ht_Tracks[i][j].stp_FX         := bptr[2] shr 4;
      ht^.ht_Tracks[i][j].stp_FXParam    := bptr[3];
      ht^.ht_Tracks[i][j].stp_FXb        := bptr[2] and $f;
      ht^.ht_Tracks[i][j].stp_FXbParam   := bptr[4];
      bptr := bptr + 5;
      inc(j);
    end;

    inc(i);
  end;


  // Instruments
  DebugLn('attempting to initialize instruments');

  i := 1;
  while (i <= ht^.ht_InstrumentNr) do
  begin
    if  ( nptr < pchar( buf+buflen ) ) then
    begin
      strlcopy( ht^.ht_Instruments[i].ins_Name, nptr, 128 );
      nptr := nptr + strlen( nptr )+1;
    end
    else
    begin
      ht^.ht_Instruments[i].ins_Name[0] := #0;
    end;

    ht^.ht_Instruments[i].ins_Volume                := bptr[0];
    ht^.ht_Instruments[i].ins_FilterSpeed           := ((bptr[1] shr 3) and $1f) or ((bptr[12] shr 2) and $20);
    ht^.ht_Instruments[i].ins_WaveLength            := bptr[1] and $07;

    ht^.ht_Instruments[i].ins_Envelope.aFrames      := bptr[2];
    ht^.ht_Instruments[i].ins_Envelope.aVolume      := bptr[3];
    ht^.ht_Instruments[i].ins_Envelope.dFrames      := bptr[4];
    ht^.ht_Instruments[i].ins_Envelope.dVolume      := bptr[5];
    ht^.ht_Instruments[i].ins_Envelope.sFrames      := bptr[6];
    ht^.ht_Instruments[i].ins_Envelope.rFrames      := bptr[7];
    ht^.ht_Instruments[i].ins_Envelope.rVolume      := bptr[8];

    ht^.ht_Instruments[i].ins_FilterLowerLimit      := bptr[12] and $7f;
    ht^.ht_Instruments[i].ins_VibratoDelay          := bptr[13];
    ht^.ht_Instruments[i].ins_HardCutReleaseFrames  := (bptr[14] shr 4) and $07;
    ht^.ht_Instruments[i].ins_HardCutRelease        := IIF(bptr[14] and $80 <> 0, byte(1), 0);
    ht^.ht_Instruments[i].ins_VibratoDepth          := bptr[14] and $0f;
    ht^.ht_Instruments[i].ins_VibratoSpeed          := bptr[15];
    ht^.ht_Instruments[i].ins_SquareLowerLimit      := bptr[16];
    ht^.ht_Instruments[i].ins_SquareUpperLimit      := bptr[17];
    ht^.ht_Instruments[i].ins_SquareSpeed           := bptr[18];
    ht^.ht_Instruments[i].ins_FilterUpperLimit      := bptr[19] and $3f;
    ht^.ht_Instruments[i].ins_PList.pls_Speed       := bptr[20];
    ht^.ht_Instruments[i].ins_PList.pls_Length      := bptr[21];


    ht^.ht_Instruments[i].ins_PList.pls_Entries     := ple;
    ple := ple + bptr[21];
    
    bptr := bptr + 22;
    
    j := 0;
    while (j < ht^.ht_Instruments[i].ins_PList.pls_Length) do
    begin
      ht^.ht_Instruments[i].ins_PList.pls_Entries[j].ple_FX[0]      := bptr[0] and $f;
      ht^.ht_Instruments[i].ins_PList.pls_Entries[j].ple_FX[1]      := (bptr[1] shr 3) and $f;
      ht^.ht_Instruments[i].ins_PList.pls_Entries[j].ple_Waveform   := bptr[1] and 7;
      ht^.ht_Instruments[i].ins_PList.pls_Entries[j].ple_Fixed      := (bptr[2] shr 6) and 1;
      ht^.ht_Instruments[i].ins_PList.pls_Entries[j].ple_Note       := bptr[2] and $3f;
      ht^.ht_Instruments[i].ins_PList.pls_Entries[j].ple_FXParam[0] := bptr[3];
      ht^.ht_Instruments[i].ins_PList.pls_Entries[j].ple_FXParam[1] := bptr[4];
      bptr := bptr + 5;
      inc(j);
    end;
    inc(i);
  end;

  DebugLn('Attempting to initialize subsongs');
  hvl_InitSubsong( ht, 0 );

  FreeMem( buf );       // FPC: native memory handling
  hvl_LoadTune := ht;
end;



procedure hvl_FreeTune(ht: phvl_tune);
begin
  if not( ht <> nil ) then exit;
  FreeMem( ht );       // FPC: native memory handling
end;



procedure hvl_process_stepfx_1(ht: Phvl_tune; voice: Phvl_voice; FX: int32; FXParam: int32);
begin
  case ( FX ) of
    $0:  // Position Jump HI
    begin
      if ( ((FXParam and $0f) > 0) and ((FXParam and $0f) <= 9) )
      then ht^.ht_PosJump := FXParam and $f;
    end;

    $5,  // Volume Slide + Tone Portamento
    $a:  // Volume Slide
    begin
      voice^.vc_VolumeSlideDown := FXParam and $0f;
      voice^.vc_VolumeSlideUp   := FXParam shr 4;
    end;
    
    $7:  // Panning
    begin
      if ( FXParam > 127 )
      then FXParam := FXParam - 256;
      voice^.vc_Pan          := (FXParam+128);
      voice^.vc_SetPan       := (FXParam+128); // 1.4
      voice^.vc_PanMultLeft  := panning_left[voice^.vc_Pan];
      voice^.vc_PanMultRight := panning_right[voice^.vc_Pan];
    end;

    $b: // Position jump
    begin
      ht^.ht_PosJump      := ht^.ht_PosJump*100 + (FXParam and $0f) + (FXParam shr 4)*10;
      ht^.ht_PatternBreak := 1;
      if ( ht^.ht_PosJump <= ht^.ht_PosNr )
      then ht^.ht_SongEndReached := 1;
    end;
    
    $d: // Pattern break
    begin
      ht^.ht_PosJump      := ht^.ht_PosNr+1;
      ht^.ht_PosJumpNote  := (FXParam and $0f) + (FXParam shr 4)*10;
      ht^.ht_PatternBreak := 1;
      if ( ht^.ht_PosJumpNote >  ht^.ht_TrackLength )
      then ht^.ht_PosJumpNote := 0;
    end;

    $e: // Extended commands
    begin
      case ( FXParam shr 4 ) of
        $c: // Note cut
        begin
          if ( (FXParam and $0f) < ht^.ht_Tempo ) then
          begin
            voice^.vc_NoteCutWait := FXParam and $0f;
            if ( voice^.vc_NoteCutWait <> 0 ) then
            begin
              voice^.vc_NoteCutOn      := 1;
              voice^.vc_HardCutRelease := 0;
            end;
          end;
        end;
          
        // 1.6: 0xd case removed
      end; // case FXParam shr 4
    end;

    $f: // Speed
    begin
      ht^.ht_Tempo := FXParam;
      if ( FXParam = 0 )
      then ht^.ht_SongEndReached := 1;
    end;
  end; // case FX
end;



procedure hvl_process_stepfx_2(ht: Phvl_tune; voice: Phvl_voice; FX: int32; FXParam: int32; Note: Pint32);
var
  new, diff: int32;
begin
  case ( FX ) of
    $9: // Set squarewave offset
    begin
      voice^.vc_SquarePos    := FXParam shr (5 - voice^.vc_WaveLength);
// **     voice->vc_PlantSquare  = 1;
      voice^.vc_IgnoreSquare := 1;
    end;

    $5, // Tone portamento + volume slide
    $3: // Tone portamento
    begin
      if ( FXParam <> 0 ) then voice^.vc_PeriodSlideSpeed := FXParam;
      
      if ( Note^ <> 0 ) then
      begin
        new   := period_tab[Note^];
        diff  := period_tab[voice^.vc_TrackPeriod];
        diff  := diff - new;
        new   := diff + voice^.vc_PeriodSlidePeriod;
        
        if (new <> 0)
        then voice^.vc_PeriodSlideLimit := -diff;
      end;
      voice^.vc_PeriodSlideOn        := 1;
      voice^.vc_PeriodSlideWithLimit := 1;
      Note^ := 0;
    end;     
  end; // case FX
end;



procedure hvl_process_stepfx_3(ht: Phvl_tune; voice: Phvl_voice; FX: int32; FXParam: int32);
var
  i: int32;
label
  CaseBreak4, CaseBreak0C, CaseBreak0E_0F;
begin
  case ( FX ) of
    $01: // Portamento up (period slide down)
    begin
      voice^.vc_PeriodSlideSpeed     := -FXParam;
      voice^.vc_PeriodSlideOn        := 1;
      voice^.vc_PeriodSlideWithLimit := 0;
    end;
    
    $02: // Portamento down
    begin
      voice^.vc_PeriodSlideSpeed     := FXParam;
      voice^.vc_PeriodSlideOn        := 1;
      voice^.vc_PeriodSlideWithLimit := 0;
    end;

    $04: // Filter override
    begin
      if ( ( FXParam = 0 ) or ( FXParam = $40 ) ) then goto CaseBreak4;
      
      if( FXParam < $40 ) then
      begin
        voice^.vc_IgnoreFilter := FXParam;
        goto CaseBreak4;
      end;
      if ( FXParam > $7f ) then goto CaseBreak4;
      voice^.vc_FilterPos := FXParam - $40;
      
      CaseBreak4:
    end;

    $0c: // Volume
    begin
      FXParam := FXParam and $ff;
      if( FXParam <= $40 ) then
      begin
        voice^.vc_NoteMaxVolume := FXParam;
        Goto CaseBreak0C;
      end;
      
      FXParam := FXParam - $50;
      if( ( FXParam ) < 0 ) then Goto CaseBreak0C;  // 1.6

      if( FXParam <= $40 ) then
      begin
        for i := 0 to Pred(ht^.ht_Channels)
        do ht^.ht_Voices[i].vc_TrackMasterVolume := FXParam;
        goto CaseBreak0c;
      end;

      FXParam := FXParam - $a0 - $50;
      if ( FXParam < 0 ) then goto CaseBreak0C; // 1.6

      if( FXParam <= $40 )
      then voice^.vc_TrackMasterVolume := FXParam;

      CaseBreak0C:
    end;

    $e: // Extended commands;
    begin
      case( FXParam shr 4 ) of
        $1: // Fineslide up
        begin
          voice^.vc_PeriodSlidePeriod := voice^.vc_PeriodSlidePeriod - (FXParam and $0f); // 1.8
          voice^.vc_PlantPeriod := 1;
        end;
        
        $2: // Fineslide down
        begin
          voice^.vc_PeriodSlidePeriod := voice^.vc_PeriodSlidePeriod + (FXParam and $0f); // 1.8
          voice^.vc_PlantPeriod := 1;
        end;
        
        $4: // Vibrato control
        begin
          voice^.vc_VibratoDepth := FXParam and $0f;
        end;

        $0a: // Fine volume up
        begin
          voice^.vc_NoteMaxVolume := voice^.vc_NoteMaxVolume + FXParam and $0f;
          
          if ( voice^.vc_NoteMaxVolume > $40 )
          then voice^.vc_NoteMaxVolume := $40;
        end;
        
        $0b: // Fine volume down
        begin
          voice^.vc_NoteMaxVolume := voice^.vc_NoteMaxVolume - FXParam and $0f;
          
          if ( voice^.vc_NoteMaxVolume < 0 )
          then voice^.vc_NoteMaxVolume := 0;
        end;
        
        $0f: // Misc flags (1.5)
        begin
          if ( ht^.ht_Version < 1 ) then goto CaseBreak0E_0F;
          case ( FXParam and $f ) of
            1:
            begin
              voice^.vc_OverrideTranspose := voice^.vc_Transpose;
            end;
          end; // case FXParam and $f of

          CaseBreak0E_0F:
        end; // case $0f of misc flags
      end; // case FXParam shr 4
    end;  // case $e
  end; // case FX
end;



procedure hvl_process_step(ht: Phvl_tune; voice: Phvl_voice);
var
  Note, Instr, donenotedel : int32;
  Step: Phvl_step;
var
  Ins: Phvl_instrument;
  SquareLower, SquareUpper, d6, d3, d4: int16;
var
  t: int16;
begin  
  if ( voice^.vc_TrackOn = 0 )
  then exit;
  
  voice^.vc_VolumeSlideUp   := 0; 
  voice^.vc_VolumeSlideDown := 0;
  
  Step := @ht^.ht_Tracks[ht^.ht_Positions[ht^.ht_PosNr].pos_Track[voice^.vc_VoiceNum]] [ht^.ht_NoteNr];
  
  Note    := Step^.stp_Note;
  Instr   := Step^.stp_Instrument;

  // --------- 1.6: from here --------------

  donenotedel := 0;

  // Do notedelay here
  if( ((Step^.stp_FX and $f) = $e) and ((Step^.stp_FXParam and $f0) = $d0) ) then
  begin
    if ( voice^.vc_NoteDelayOn <> 0 ) then
    begin
      voice^.vc_NoteDelayOn := 0;
      donenotedel := 1;
    end
    else
    begin
      if ( (Step^.stp_FXParam and $0f) < ht^.ht_Tempo ) then
      begin
        voice^.vc_NoteDelayWait := Step^.stp_FXParam and $0f;
        if( voice^.vc_NoteDelayWait <> 0) then
        begin
          voice^.vc_NoteDelayOn := 1;
          exit;
        end;
      end;
    end;
  end;

  if ( (donenotedel = 0) and ((Step^.stp_FXb and $f) = $e) and ((Step^.stp_FXbParam and $f0) = $d0) ) then
  begin
    if ( voice^.vc_NoteDelayOn <> 0 ) then
    begin
      voice^.vc_NoteDelayOn := 0;
    end
    else
    begin
      if ( (Step^.stp_FXbParam and $0f) < ht^.ht_Tempo ) then
      begin
        voice^.vc_NoteDelayWait := Step^.stp_FXbParam and $0f;
        if ( voice^.vc_NoteDelayWait <> 0 ) then
        begin
          voice^.vc_NoteDelayOn := 1;
          exit;
        end;
      end;
    end;
  end;

  // --------- 1.6: to here --------------

  if ( Note <> 0 ) then voice^.vc_OverrideTranspose := 1000; // 1.5

  hvl_process_stepfx_1( ht, voice, Step^.stp_FX  and $f, Step^.stp_FXParam  );  
  hvl_process_stepfx_1( ht, voice, Step^.stp_FXb and $f, Step^.stp_FXbParam );
  
  if ( ( Instr <> 0 ) and ( Instr <= ht^.ht_InstrumentNr ) ) then
  begin

    //* 1.4: Reset panning to last set position */
    voice^.vc_Pan               := voice^.vc_SetPan;
    voice^.vc_PanMultLeft       := panning_left[voice^.vc_Pan];
    voice^.vc_PanMultRight      := panning_right[voice^.vc_Pan];

    voice^.vc_PeriodSlideSpeed  := 0; voice^.vc_PeriodSlidePeriod := 0; voice^.vc_PeriodSlideLimit := 0;

    voice^.vc_PerfSubVolume     := $40;
    voice^.vc_ADSRVolume        := 0;
    voice^.vc_Instrument        := @ht^.ht_Instruments[Instr]; Ins := @ht^.ht_Instruments[Instr];
    voice^.vc_SamplePos         := 0;

    voice^.vc_ADSR.aFrames      := Ins^.ins_Envelope.aFrames;
    voice^.vc_ADSR.aVolume      := Ins^.ins_Envelope.aVolume * 256 div voice^.vc_ADSR.aFrames;
    voice^.vc_ADSR.dFrames      := Ins^.ins_Envelope.dFrames;
    voice^.vc_ADSR.dVolume      := (Ins^.ins_Envelope.dVolume - Ins^.ins_Envelope.aVolume)*256 div voice^.vc_ADSR.dFrames;
    voice^.vc_ADSR.sFrames      := Ins^.ins_Envelope.sFrames;
    voice^.vc_ADSR.rFrames      := Ins^.ins_Envelope.rFrames;
    voice^.vc_ADSR.rVolume      := (Ins^.ins_Envelope.rVolume - Ins^.ins_Envelope.dVolume)*256 div voice^.vc_ADSR.rFrames;

    voice^.vc_WaveLength        := Ins^.ins_WaveLength;
    voice^.vc_NoteMaxVolume     := Ins^.ins_Volume;

    voice^.vc_VibratoCurrent    := 0;
    voice^.vc_VibratoDelay      := Ins^.ins_VibratoDelay;
    voice^.vc_VibratoDepth      := Ins^.ins_VibratoDepth;
    voice^.vc_VibratoSpeed      := Ins^.ins_VibratoSpeed;
    voice^.vc_VibratoPeriod     := 0;

    voice^.vc_HardCutRelease    := Ins^.ins_HardCutRelease;
    voice^.vc_HardCut           := Ins^.ins_HardCutReleaseFrames;

    voice^.vc_IgnoreSquare := 0; voice^.vc_SquareSlidingIn := 0;
    voice^.vc_SquareWait   := 0; voice^.vc_SquareOn        := 0;
    
    SquareLower := Ins^.ins_SquareLowerLimit shr (5 - voice^.vc_WaveLength);
    SquareUpper := Ins^.ins_SquareUpperLimit shr (5 - voice^.vc_WaveLength);

    if( SquareUpper < SquareLower ) then
    begin
      t           := SquareUpper;
      SquareUpper := SquareLower;
      SquareLower := t;
    end;
    
    voice^.vc_SquareUpperLimit := SquareUpper;
    voice^.vc_SquareLowerLimit := SquareLower;
    
    voice^.vc_IgnoreFilter    := 0; voice^.vc_FilterWait := 0; voice^.vc_FilterOn := 0;
    voice^.vc_FilterSlidingIn := 0;

    d6 := Ins^.ins_FilterSpeed;
    d3 := Ins^.ins_FilterLowerLimit;
    d4 := Ins^.ins_FilterUpperLimit;
    
    if ( d3 and $80 <> 0) then d6 := d6 or $20;
    if ( d4 and $80 <> 0) then d6 := d6 or $40;
    
    voice^.vc_FilterSpeed := d6;
    d3 := d3 and (not $80);
    d3 := d4 and (not $80);
    
    if( d3 > d4 ) then
    begin
      t  := d3;
      d3 := d4;
      d4 :=  t;
    end;

    voice^.vc_FilterUpperLimit := d4;
    voice^.vc_FilterLowerLimit := d3;
    voice^.vc_FilterPos        := 32;

    voice^.vc_PerfWait  := 0; voice^.vc_PerfCurrent := 0;
    voice^.vc_PerfSpeed := Ins^.ins_PList.pls_Speed;
    voice^.vc_PerfList  := @voice^.vc_Instrument^.ins_PList;

    voice^.vc_RingMixSource   := nil;   // No ring modulation
    voice^.vc_RingSamplePos   := 0;
    voice^.vc_RingPlantPeriod := 0;
    voice^.vc_RingNewWaveform := 0;
  end;

  voice^.vc_PeriodSlideOn := 0;

  hvl_process_stepfx_2( ht, voice, Step^.stp_FX  and $f, Step^.stp_FXParam,  @Note );  
  hvl_process_stepfx_2( ht, voice, Step^.stp_FXb and $f, Step^.stp_FXbParam, @Note );

  if (Note <> 0) then
  begin
    voice^.vc_TrackPeriod := Note;
    voice^.vc_PlantPeriod := 1;
  end;

  hvl_process_stepfx_3( ht, voice, Step^.stp_FX  and $f, Step^.stp_FXParam  );
  hvl_process_stepfx_3( ht, voice, Step^.stp_FXb and $f, Step^.stp_FXbParam );
end;



procedure hvl_plist_command_parse(ht: Phvl_tune; voice: Phvl_voice; FX: int32; FXParam: int32);
label
  CaseBreak7, CaseBreak8, CaseBreak12;
begin
  case ( FX ) of
    0:
    begin
      if (( FXParam > 0 ) and ( FXParam < $40 )) then
      begin
        if (voice^.vc_IgnoreFilter <> 0) then
        begin
          voice^.vc_FilterPos    := voice^.vc_IgnoreFilter;
          voice^.vc_IgnoreFilter := 0;
        end
        else
        begin
          voice^.vc_FilterPos    := FXParam;
        end;
        voice^.vc_NewWaveform := 1;
      end;
    end;

    1:
    begin
      voice^.vc_PeriodPerfSlideSpeed := FXParam;
      voice^.vc_PeriodPerfSlideOn    := 1;
    end;

    2:
    begin
      voice^.vc_PeriodPerfSlideSpeed := -FXParam;
      voice^.vc_PeriodPerfSlideOn    := 1;
    end;

    3:
    begin
      if ( voice^.vc_IgnoreSquare = 0 )
      then voice^.vc_SquarePos    := FXParam shr (5-voice^.vc_WaveLength)
      else voice^.vc_IgnoreSquare := 0;
    end;

    4:
    begin
      if ( FXParam = 0 ) then
      begin
        voice^.vc_SquareOn   := voice^.vc_SquareOn xor 1;   // FPC: modification
        voice^.vc_SquareInit := (voice^.vc_SquareOn);
        voice^.vc_SquareSign := 1;
      end
      else
      begin
        if ( FXParam and $0f <> 0) then
        begin
          voice^.vc_SquareOn := voice^.vc_SquareOn xor 1;   // FPC: modification
          voice^.vc_SquareInit := (voice^.vc_SquareOn);
          voice^.vc_SquareSign := 1;
          if (( FXParam and $0f ) = $0f )
          then voice^.vc_SquareSign := -1;
        end;
        
        if ( FXParam and $f0 <> 0) then
        begin
          voice^.vc_FilterOn := voice^.vc_FilterOn xor 1;   // FPC: modification
          voice^.vc_FilterInit := (voice^.vc_FilterOn);
          voice^.vc_FilterSign := 1;
          if (( FXParam and $f0 ) = $f0 )
          then voice^.vc_FilterSign := -1;
        end;
      end;
    end;

    5:
    begin
      voice^.vc_PerfCurrent := FXParam;
    end;

    7:
    begin
      // Ring modulate with triangle
      if (( FXParam >= 1 ) and ( FXParam <= $3C )) then
      begin
        voice^.vc_RingBasePeriod  := FXParam;
        voice^.vc_RingFixedPeriod := 1;
      end
      else 
      if (( FXParam >= $81 ) and ( FXParam <= $BC )) then
      begin
        voice^.vc_RingBasePeriod  := FXParam-$80;
        voice^.vc_RingFixedPeriod := 0;
      end
      else
      begin
        voice^.vc_RingBasePeriod  := 0;
        voice^.vc_RingFixedPeriod := 0;
        voice^.vc_RingNewWaveform := 0;
        voice^.vc_RingAudioSource := nil; // turn it off
        voice^.vc_RingMixSource   := nil;
        Goto CaseBreak7;
      end;    
      voice^.vc_RingWaveform    := 0;
      voice^.vc_RingNewWaveform := 1;
      voice^.vc_RingPlantPeriod := 1;
      
      CaseBreak7:
    end;

    8:  // Ring modulate with sawtooth
    begin
      if (( FXParam >= 1 ) and ( FXParam <= $3C )) then
      begin
        voice^.vc_RingBasePeriod  := FXParam;
        voice^.vc_RingFixedPeriod := 1;
      end
      else 
      if (( FXParam >= $81 ) and ( FXParam <= $BC )) then
      begin
        voice^.vc_RingBasePeriod  := FXParam - $80;
        voice^.vc_RingFixedPeriod := 0;
      end
      else
      begin
        voice^.vc_RingBasePeriod  := 0;
        voice^.vc_RingFixedPeriod := 0;
        voice^.vc_RingNewWaveform := 0;
        voice^.vc_RingAudioSource := nil;
        voice^.vc_RingMixSource   := nil;
        Goto CaseBreak8;
      end;

      voice^.vc_RingWaveform    := 1;
      voice^.vc_RingNewWaveform := 1;
      voice^.vc_RingPlantPeriod := 1;
      
      CaseBreak8:
    end;

    //* New in HivelyTracker 1.4 */    
    9:    
    begin
      if ( FXParam > 127 )
      then FXParam := FXParam - 256;
      voice^.vc_Pan          := (FXParam + 128);
      voice^.vc_PanMultLeft  := panning_left[voice^.vc_Pan];
      voice^.vc_PanMultRight := panning_right[voice^.vc_Pan];
    end;

    12:
    begin
      if ( FXParam <= $40 ) then
      begin
        voice^.vc_NoteMaxVolume := FXParam;
        goto CaseBreak12;
      end;

      FXParam := FXParam - $50;                        // FPC: modification
      if ( (FXParam) < 0 ) then goto CaseBreak12;

      if ( FXParam <= $40 ) then
      begin
        voice^.vc_PerfSubVolume := FXParam;
        goto CaseBreak12;
      end;

      FXParam := FXParam - $a0-$50;                     // FPC: modification
      if ( (FXParam) < 0 ) then goto CaseBreak12;
      
      if ( FXParam <= $40 )
      then voice^.vc_TrackMasterVolume := FXParam;

      CaseBreak12:      
    end;

    15:
    begin
      voice^.vc_PerfSpeed := FXParam; voice^.vc_PerfWait := FXParam;
    end;

  end; // case FX
end;



procedure hvl_process_frame( ht: Phvl_tune; voice: Phvl_voice );
const
  OffSets : packed array[0..5] of uint8 = 
  (
    $00, $04, $04+$08, $04+$08+$10, $04+$08+$10+$20, $04+$08+$10+$20+$40
  );
var
  nextinst          : int32;
  d0, d1, d2, d3    : int32;
  i, FMax           : uint32;
  cur, delta, X     : int32;
  SquarePtr, 
  rasrc, 
  AudioSource       : pint8;
begin  
  if ( voice^.vc_TrackOn = 0 )
  then exit;

  if ( voice^.vc_NoteDelayOn <> 0 ) then
  begin
    if ( voice^.vc_NoteDelayWait <= 0 )
    then hvl_process_step( ht, voice )
    else dec(voice^.vc_NoteDelayWait, 1);
  end;

  if ( voice^.vc_HardCut <> 0 ) then
  begin
    if ( (ht^.ht_NoteNr + 1) < ht^.ht_TrackLength )
    then nextinst := ht^.ht_Tracks[voice^.vc_Track][ht^.ht_NoteNr+1].stp_Instrument
    else nextinst := ht^.ht_Tracks[voice^.vc_NextTrack][0].stp_Instrument;
    
    if ( nextinst <> 0 ) then
    begin
      d1 := ht^.ht_Tempo - voice^.vc_HardCut;
      
      if ( d1 < 0 ) then d1 := 0;
    
      if not( voice^.vc_NoteCutOn <> 0) then
      begin
        voice^.vc_NoteCutOn       := 1;
        voice^.vc_NoteCutWait     := d1;
        voice^.vc_HardCutReleaseF := -(d1-ht^.ht_Tempo);
      end
      else
      begin
        voice^.vc_HardCut := 0;
      end;
    end;
  end;

  if ( voice^.vc_NoteCutOn <> 0) then
  begin
    if ( voice^.vc_NoteCutWait <= 0 ) then
    begin
      voice^.vc_NoteCutOn := 0;
        
      if ( voice^.vc_HardCutRelease <> 0 ) then
      begin
        voice^.vc_ADSR.rVolume := -(voice^.vc_ADSRVolume - (voice^.vc_Instrument^.ins_Envelope.rVolume shl 8)) div voice^.vc_HardCutReleaseF;
        voice^.vc_ADSR.rFrames := voice^.vc_HardCutReleaseF;
        voice^.vc_ADSR.aFrames := 0; voice^.vc_ADSR.dFrames := 0; voice^.vc_ADSR.sFrames := 0;
      end
      else
      begin
        voice^.vc_NoteMaxVolume := 0;
      end;
    end  
    else
    begin
      dec(voice^.vc_NoteCutWait, 1);
    end
  end;

  // ADSR envelope
  if ( voice^.vc_ADSR.aFrames <> 0 ) then
  begin
    voice^.vc_ADSRVolume := voice^.vc_ADSRVolume + voice^.vc_ADSR.aVolume;
    
    dec(voice^.vc_ADSR.aFrames, 1);
    if ( voice^.vc_ADSR.aFrames <= 0 )
    then voice^.vc_ADSRVolume := voice^.vc_Instrument^.ins_Envelope.aVolume shl 8;
  end
  else 
  if ( voice^.vc_ADSR.dFrames <> 0 ) then
  begin
    voice^.vc_ADSRVolume := voice^.vc_ADSRVolume + voice^.vc_ADSR.dVolume;

    dec(voice^.vc_ADSR.dFrames, 1);
    if ( voice^.vc_ADSR.dFrames <= 0 )
    then voice^.vc_ADSRVolume := voice^.vc_Instrument^.ins_Envelope.dVolume shl 8;    
  end
  else 
  if ( voice^.vc_ADSR.sFrames <> 0 ) then
  begin
    voice^.vc_ADSR.sFrames := voice^.vc_ADSR.sFrames - 1;
  end 
  else 
  if ( voice^.vc_ADSR.rFrames <> 0 ) then
  begin
    voice^.vc_ADSRVolume := voice^.vc_ADSRVolume + voice^.vc_ADSR.rVolume;

    dec(voice^.vc_ADSR.rFrames, 1);
    if ( voice^.vc_ADSR.rFrames <= 0 )
    then voice^.vc_ADSRVolume := voice^.vc_Instrument^.ins_Envelope.rVolume shl 8;
  end;

  // VolumeSlide
  voice^.vc_NoteMaxVolume := voice^.vc_NoteMaxVolume + voice^.vc_VolumeSlideUp - voice^.vc_VolumeSlideDown;

  if ( voice^.vc_NoteMaxVolume < 0 )
  then voice^.vc_NoteMaxVolume := 0
  else 
  if ( voice^.vc_NoteMaxVolume > $40 )
  then voice^.vc_NoteMaxVolume := $40;

  // Portamento
  if ( voice^.vc_PeriodSlideOn <> 0 ) then
  begin
    if ( voice^.vc_PeriodSlideWithLimit <> 0 ) then
    begin
      d0 := voice^.vc_PeriodSlidePeriod - voice^.vc_PeriodSlideLimit;
      d2 := voice^.vc_PeriodSlideSpeed;
      
      if ( d0 > 0 )
      then d2 := -d2;
      
      if ( d0 <> 0) then
      begin
        d3 := (d0 + d2) xor d0;
        
        if ( d3 >= 0 )
        then d0 := voice^.vc_PeriodSlidePeriod + d2
        else d0 := voice^.vc_PeriodSlideLimit;
        
        voice^.vc_PeriodSlidePeriod := d0;
        voice^.vc_PlantPeriod := 1;
      end
    end
    else
    begin
      voice^.vc_PeriodSlidePeriod := voice^.vc_PeriodSlidePeriod + voice^.vc_PeriodSlideSpeed;
      voice^.vc_PlantPeriod := 1;
    end;
  end;

  // Vibrato
  if ( voice^.vc_VibratoDepth <> 0 ) then
  begin
    if ( voice^.vc_VibratoDelay <= 0 ) then
    begin
      voice^.vc_VibratoPeriod := (vib_tab[voice^.vc_VibratoCurrent] * voice^.vc_VibratoDepth) shr 7;
      voice^.vc_PlantPeriod := 1;
      voice^.vc_VibratoCurrent := (voice^.vc_VibratoCurrent + voice^.vc_VibratoSpeed) and $3f;
    end
    else
    begin
      voice^.vc_VibratoDelay := voice^.vc_VibratoDelay - 1;
    end;
  end;

  // PList
  if ( voice^.vc_PerfList <> nil ) then
  begin
    if ( (voice^.vc_Instrument <> nil) and (voice^.vc_PerfCurrent < voice^.vc_Instrument^.ins_PList.pls_Length) ) then
    begin
      dec(voice^.vc_PerfWait, 1);                   // FPC modification
      if ( voice^.vc_PerfWait <= 0 ) then
      begin
        cur := voice^.vc_PerfCurrent;
        inc(voice^.vc_PerfCurrent, 1);              // FPC modification
        
        voice^.vc_PerfWait := voice^.vc_PerfSpeed;
        
        if ( voice^.vc_PerfList^.pls_Entries[cur].ple_Waveform <> 0 ) then
        begin
          voice^.vc_Waveform             := voice^.vc_PerfList^.pls_Entries[cur].ple_Waveform-1;
          voice^.vc_NewWaveform          := 1;
          voice^.vc_PeriodPerfSlideSpeed := 0; voice^.vc_PeriodPerfSlidePeriod := 0;
        end;
        
        // Holdwave
        voice^.vc_PeriodPerfSlideOn := 0;
        
        for i := 0 to Pred(2) 
        do hvl_plist_command_parse( ht, voice, voice^.vc_PerfList^.pls_Entries[cur].ple_FX[i] and $ff, voice^.vc_PerfList^.pls_Entries[cur].ple_FXParam[i] and $ff );
        
        // GetNote
        if ( voice^.vc_PerfList^.pls_Entries[cur].ple_Note <> 0 ) then
        begin
          voice^.vc_InstrPeriod := voice^.vc_PerfList^.pls_Entries[cur].ple_Note;
          voice^.vc_PlantPeriod := 1;
          voice^.vc_FixedNote   := voice^.vc_PerfList^.pls_Entries[cur].ple_Fixed;
        end;
      end;
    end 
    else
    begin
      if ( voice^.vc_PerfWait <> 0 )
      then voice^.vc_PerfWait := voice^.vc_PerfWait - 1
      else voice^.vc_PeriodPerfSlideSpeed := 0;
    end;
  end;

  // PerfPortamento
  if ( voice^.vc_PeriodPerfSlideOn <> 0 ) then
  begin
    voice^.vc_PeriodPerfSlidePeriod := voice^.vc_PeriodPerfSlidePeriod - voice^.vc_PeriodPerfSlideSpeed;
    
    if ( voice^.vc_PeriodPerfSlidePeriod <> 0)
    then voice^.vc_PlantPeriod := 1;
  end;

  if ( voice^.vc_Waveform = 3-1) and ( voice^.vc_SquareOn <> 0) then
  begin
    dec(voice^.vc_SquareWait, 1);
    if ( voice^.vc_SquareWait <= 0 ) then
    begin
      d1 := voice^.vc_SquareLowerLimit;
      d2 := voice^.vc_SquareUpperLimit;
      d3 := voice^.vc_SquarePos;
      
      if ( voice^.vc_SquareInit <> 0 ) then
      begin
        voice^.vc_SquareInit := 0;
        
        if ( d3 <= d1 ) then
        begin
          voice^.vc_SquareSlidingIn := 1;
          voice^.vc_SquareSign      := 1;
        end
        else 
        if ( d3 >= d2 ) then
        begin
          voice^.vc_SquareSlidingIn := 1;
          voice^.vc_SquareSign      := -1;
        end;
      end;
      
      // NoSquareInit
      if ( ( d1 = d3 ) or ( d2 = d3 ) ) then
      begin
        if ( voice^.vc_SquareSlidingIn <> 0 )
        then voice^.vc_SquareSlidingIn := 0
        else voice^.vc_SquareSign := -voice^.vc_SquareSign;
      end;
      
      d3 := d3 + voice^.vc_SquareSign;
      voice^.vc_SquarePos   := d3;
      voice^.vc_PlantSquare := 1;
      voice^.vc_SquareWait  := voice^.vc_Instrument^.ins_SquareSpeed;
    end;
  end;


  if ( voice^.vc_FilterOn <> 0 ) then        // FPC modification !!!
  begin
    dec(voice^.vc_FilterWait, 1);  
    if ( voice^.vc_FilterWait <= 0 ) then
    begin    
      d1 := voice^.vc_FilterLowerLimit;
      d2 := voice^.vc_FilterUpperLimit;
      d3 := voice^.vc_FilterPos;
    
      if ( voice^.vc_FilterInit <> 0 ) then
      begin
        voice^.vc_FilterInit := 0;
        if ( d3 <= d1 ) then
        begin
          voice^.vc_FilterSlidingIn := 1;
          voice^.vc_FilterSign      := 1;
        end
        else 
        if ( d3 >= d2 ) then
        begin
          voice^.vc_FilterSlidingIn := 1;
          voice^.vc_FilterSign      := -1;
        end;
      end;

      // NoFilterInit
      if ( voice^.vc_FilterSpeed < 3 )
      then FMax :=  (5-voice^.vc_FilterSpeed) 
      else FMax := 1;

      for i := 0 to Pred(FMax) do 
      begin
        if ( ( d1 = d3 ) or ( d2 = d3 ) ) then
        begin
          if ( voice^.vc_FilterSlidingIn <> 0)
          then voice^.vc_FilterSlidingIn := 0
          else voice^.vc_FilterSign := -voice^.vc_FilterSign;
        end;
        d3 := d3 + voice^.vc_FilterSign;
      end;
    
      if ( d3 < 1 )  then d3 := 1;
      if ( d3 > 63 ) then d3 := 63;
      voice^.vc_FilterPos   := d3;
      voice^.vc_NewWaveform := 1;
      voice^.vc_FilterWait  := voice^.vc_FilterSpeed - 3;
    
      if ( voice^.vc_FilterWait < 1 )
      then voice^.vc_FilterWait := 1;
    end;
  end;


  if ( (voice^.vc_Waveform = 3-1) or (voice^.vc_PlantSquare <> 0) ) then
  begin
    // CalcSquare
    SquarePtr := @waves[WO_SQUARES+(voice^.vc_FilterPos-$20)*($fc+$fc+$80*$1f+$80+$280*3)];
    X := voice^.vc_SquarePos shl (5 - voice^.vc_WaveLength);
    
    if ( X > $20 ) then
    begin
      X := $40 - X;
      voice^.vc_SquareReverse := 1;
    end;
    
    // OkDownSquare
    if ( X > 0 )
    then SquarePtr := SquarePtr + ((X-1) shl 7);
    
    Delta := 32 shr voice^.vc_WaveLength;
    ht^.ht_WaveformTab[2] := @voice^.vc_SquareTempBuffer[0];    // FPC change
    
    for i := 0 to Pred((1 shl voice^.vc_WaveLength)*4) do
    begin
      voice^.vc_SquareTempBuffer[i] := SquarePtr^;
      SquarePtr := SquarePtr + Delta;
    end;
    
    voice^.vc_NewWaveform := 1;
    voice^.vc_Waveform    := 3-1;
    voice^.vc_PlantSquare := 0;
  end;


  if ( voice^.vc_Waveform = 4-1 )
  then voice^.vc_NewWaveform := 1;
  
  if ( voice^.vc_RingNewWaveform <> 0 ) then
  begin

    if ( voice^.vc_RingWaveform > 1 ) then voice^.vc_RingWaveform := 1;

    rasrc := ht^.ht_WaveformTab[voice^.vc_RingWaveform];
    rasrc := rasrc + Offsets[voice^.vc_WaveLength];
    
    voice^.vc_RingAudioSource := rasrc;
  end;   


  if ( voice^.vc_NewWaveform <> 0 ) then
  begin
    AudioSource := ht^.ht_WaveformTab[voice^.vc_Waveform];

    if ( voice^.vc_Waveform <> 3-1 )
    then AudioSource := AudioSource + (voice^.vc_FilterPos-$20)*($fc+$fc+$80*$1f+$80+$280*3);

    if ( voice^.vc_Waveform < 3-1) then
    begin
      // GetWLWaveformlor2
      AudioSource := AudioSource + Offsets[voice^.vc_WaveLength];
    end;

    if ( voice^.vc_Waveform = 4-1 ) then
    begin
      // AddRandomMoving
      AudioSource := AudioSource + ( voice^.vc_WNRandom and (2*$280-1) ) and (not 1);  // FPC note: check not(1)
      // GoOnRandom
      voice^.vc_WNRandom := voice^.vc_WNRandom + 2239384;
      voice^.vc_WNRandom := ((((voice^.vc_WNRandom shr 8) or (voice^.vc_WNRandom shl 24)) + 782323) xor 75) - 6735;
    end;

    voice^.vc_AudioSource := AudioSource;
  end;


  // Ring modulation period calculation
  if ( voice^.vc_RingAudioSource <> nil ) then
  begin
    voice^.vc_RingAudioPeriod := voice^.vc_RingBasePeriod;
  
    if ( not(voice^.vc_RingFixedPeriod <> 0) ) then
    begin
      if ( voice^.vc_OverrideTranspose <> 1000 )  // 1.5
      then voice^.vc_RingAudioPeriod := voice^.vc_RingAudioPeriod + voice^.vc_OverrideTranspose + voice^.vc_TrackPeriod - 1
      else voice^.vc_RingAudioPeriod := voice^.vc_RingAudioPeriod + voice^.vc_Transpose         + voice^.vc_TrackPeriod - 1;
    end;
  
    if ( voice^.vc_RingAudioPeriod > 5*12 )
    then voice^.vc_RingAudioPeriod := 5*12;
  
    if ( voice^.vc_RingAudioPeriod < 0 )
    then voice^.vc_RingAudioPeriod := 0;
  
    voice^.vc_RingAudioPeriod := period_tab[voice^.vc_RingAudioPeriod];

    if ( not(voice^.vc_RingFixedPeriod <> 0) )
    then voice^.vc_RingAudioPeriod := voice^.vc_RingAudioPeriod + voice^.vc_PeriodSlidePeriod;

    voice^.vc_RingAudioPeriod := voice^.vc_RingAudioPeriod + voice^.vc_PeriodPerfSlidePeriod + voice^.vc_VibratoPeriod;

    if ( voice^.vc_RingAudioPeriod > $0d60 )
    then voice^.vc_RingAudioPeriod := $0d60;

    if ( voice^.vc_RingAudioPeriod < $0071 )
    then voice^.vc_RingAudioPeriod := $0071;
  end;


  // Normal period calculation
  voice^.vc_AudioPeriod := voice^.vc_InstrPeriod;
  
  if ( not (voice^.vc_FixedNote <> 0) ) then
  begin
    if ( voice^.vc_OverrideTranspose <> 1000 ) // 1.5
    then voice^.vc_AudioPeriod := voice^.vc_AudioPeriod + voice^.vc_OverrideTranspose + voice^.vc_TrackPeriod - 1
    else voice^.vc_AudioPeriod := voice^.vc_AudioPeriod + voice^.vc_Transpose         + voice^.vc_TrackPeriod - 1;
  end;

  if ( voice^.vc_AudioPeriod > 5*12 )
  then voice^.vc_AudioPeriod := 5*12;
  
  if ( voice^.vc_AudioPeriod < 0 )
  then voice^.vc_AudioPeriod := 0;
  
  voice^.vc_AudioPeriod := period_tab[voice^.vc_AudioPeriod];
  
  if ( not(voice^.vc_FixedNote <> 0) )
  then voice^.vc_AudioPeriod := voice^.vc_AudioPeriod + voice^.vc_PeriodSlidePeriod;

  voice^.vc_AudioPeriod := voice^.vc_AudioPeriod + voice^.vc_PeriodPerfSlidePeriod + voice^.vc_VibratoPeriod;

  if ( voice^.vc_AudioPeriod > $0d60 )
  then voice^.vc_AudioPeriod := $0d60;

  if ( voice^.vc_AudioPeriod < $0071 )
  then voice^.vc_AudioPeriod := $0071;
  
  voice^.vc_AudioVolume := (((((((voice^.vc_ADSRVolume shr 8) * voice^.vc_NoteMaxVolume) shr 6) * voice^.vc_PerfSubVolume) shr 6) * voice^.vc_TrackMasterVolume) shr 6);
end;



procedure hvl_set_audio( voice : Phvl_voice; freqf: float64 );
var
  freq2     : float64;  
  delta     : uint32;
  src       : pint8;
  i, 
  WaveLoops : int32;
begin
  if ( voice^.vc_TrackOn = 0 ) then
  begin
    voice^.vc_VoiceVolume := 0;
    exit;
  end;
  
  voice^.vc_VoiceVolume := voice^.vc_AudioVolume;

  if ( voice^.vc_PlantPeriod <> 0) then
  begin
    voice^.vc_PlantPeriod := 0;
    voice^.vc_VoicePeriod := voice^.vc_AudioPeriod;
    
    freq2 := Period2Freq( voice^.vc_AudioPeriod );
    delta := uint32( trunc(freq2 / freqf) );    // FPC: requires truncation

    if ( delta > ($280 shl 16) ) then delta := delta - ($280 shl 16);
    if ( delta = 0 ) then delta := 1;
    voice^.vc_Delta := delta;
  end;

  if ( voice^.vc_NewWaveform <> 0 ) then
  begin
    src := voice^.vc_AudioSource;
    
    if ( voice^.vc_Waveform = (4-1) ) then
    begin
      memcpy(@voice^.vc_VoiceBuffer[0], @src[0], $280);
    end
    else
    begin
      WaveLoops := (1 shl (5 - voice^.vc_WaveLength)) * 5;

      for i := 0 to Pred(WaveLoops)
      do memcpy(@voice^.vc_VoiceBuffer[i*4*(1 shl voice^.vc_WaveLength)], @src[0], 4 * (1 shl voice^.vc_WaveLength) );
    end;

    voice^.vc_VoiceBuffer[$280] := voice^.vc_VoiceBuffer[0];
    voice^.vc_MixSource         := @voice^.vc_VoiceBuffer[0];    // FPC: change
  end;


  //* Ring Modulation */
  if ( voice^.vc_RingPlantPeriod <> 0 ) then
  begin
    voice^.vc_RingPlantPeriod := 0;
    freq2 := Period2Freq( voice^.vc_RingAudioPeriod );

    delta := uint32( trunc (freq2 / freqf) );     // FPC: requires truncation
    
    if ( delta > ($280 shl 16) ) then delta := delta - ($280 shl 16);
    if ( delta = 0 ) then delta := 1;
    voice^.vc_RingDelta := delta;
  end;

  if ( voice^.vc_RingNewWaveform <> 0 ) then
  begin
    src := voice^.vc_RingAudioSource;

    WaveLoops := (1 shl (5 - voice^.vc_WaveLength)) * 5;

    for i := 0 to Pred(WaveLoops)
    do memcpy( @voice^.vc_RingVoiceBuffer[i*4*(1 shl voice^.vc_WaveLength)], @src[0], 4 * (1 shl voice^.vc_WaveLength) );
    
    voice^.vc_RingVoiceBuffer[$280] := voice^.vc_RingVoiceBuffer[0];
    voice^.vc_RingMixSource         := @voice^.vc_RingVoiceBuffer[0]; // FPC: change
  end;
end;



procedure hvl_play_irq( ht: Phvl_tune );
var
  i         : uint32;
  nextpos   : int32;
begin
  if ( ht^.ht_StepWaitFrames <= 0 ) then
  begin
    if ( ht^.ht_GetNewPosition <> 0 ) then
    begin
      if (ht^.ht_PosNr+1 = ht^.ht_PositionNr)
      then nextpos := 0
      else nextpos := (ht^.ht_PosNr+1);

      for i:= 0 to Pred(ht^.ht_Channels) do
      begin
        ht^.ht_Voices[i].vc_Track         := ht^.ht_Positions[ht^.ht_PosNr].pos_Track[i];
        ht^.ht_Voices[i].vc_Transpose     := ht^.ht_Positions[ht^.ht_PosNr].pos_Transpose[i];
        ht^.ht_Voices[i].vc_NextTrack     := ht^.ht_Positions[nextpos].pos_Track[i];
        ht^.ht_Voices[i].vc_NextTranspose := ht^.ht_Positions[nextpos].pos_Transpose[i];
      end;
      ht^.ht_GetNewPosition := 0;
    end;

    for i := 0 to Pred(ht^.ht_Channels) 
    do hvl_process_step( ht, @ht^.ht_Voices[i] );
    
    ht^.ht_StepWaitFrames := ht^.ht_Tempo;
  end;

  for i := 0 to Pred(ht^.ht_Channels)
  do hvl_process_frame( ht, @ht^.ht_Voices[i] );

  ht^.ht_PlayingTime := ht^.ht_PlayingTime + 1;

  if ( ht^.ht_Tempo > 0 ) then                  // FPC modification !!!
  begin
    dec(ht^.ht_StepWaitFrames, 1);
    if ( ht^.ht_StepWaitFrames <= 0 ) then
    begin
      if not( ht^.ht_PatternBreak <> 0 ) then
      begin
        ht^.ht_NoteNr := ht^.ht_NoteNr + 1;
        if ( ht^.ht_NoteNr >= ht^.ht_TrackLength ) then
        begin
          ht^.ht_PosJump      := ht^.ht_PosNr+1;
          ht^.ht_PosJumpNote  := 0;
          ht^.ht_PatternBreak := 1;
        end;
      end;

      if ( ht^.ht_PatternBreak <> 0 ) then
      begin
        ht^.ht_PatternBreak := 0;
        ht^.ht_PosNr        := ht^.ht_PosJump;
        ht^.ht_NoteNr       := ht^.ht_PosJumpNote;
      
        if ( ht^.ht_PosNr = ht^.ht_PositionNr ) then
        begin
          ht^.ht_SongEndReached := 1;
          ht^.ht_PosNr          := ht^.ht_Restart;
        end;
        ht^.ht_PosJumpNote  := 0;
        ht^.ht_PosJump      := 0;

        ht^.ht_GetNewPosition := 1;
      end;
    end;
  end;

  for i := 0 to Pred(ht^.ht_Channels)
  do hvl_set_audio( @ht^.ht_Voices[i], ht^.ht_Frequency );
end;



procedure hvl_mixchunk( ht: Phvl_tune; samples: uint32; buf1: Pint8; buf2: Pint8; bufmod: int32 );
var
  src       : array [0..Pred(MAX_CHANNELS)] of pint8;
  rsrc      : array [0..Pred(MAX_CHANNELS)] of pint8;
  delta     : array [0..Pred(MAX_CHANNELS)] of uint32;
  rdelta    : array [0..Pred(MAX_CHANNELS)] of uint32;
  vol       : array [0..Pred(MAX_CHANNELS)] of int32;
  pos       : array [0..Pred(MAX_CHANNELS)] of uint32;
  rpos      : array [0..Pred(MAX_CHANNELS)] of uint32;
  cnt       : uint32;
  panl      : array [0..Pred(MAX_CHANNELS)] of int32;
  panr      : array [0..Pred(MAX_CHANNELS)] of int32;
  // **  uint32  vu[MAX_CHANNELS];
  a,b,j     : int32;
  i,  chans, loops : uint32;

begin
  a:=0; b:=0;
  
  chans := ht^.ht_Channels;
  for i := 0 to Pred(chans) do
  begin
    delta[i] := ht^.ht_Voices[i].vc_Delta;
    vol[i]   := ht^.ht_Voices[i].vc_VoiceVolume;
    pos[i]   := ht^.ht_Voices[i].vc_SamplePos;
    src[i]   := ht^.ht_Voices[i].vc_MixSource;
    panl[i]  := ht^.ht_Voices[i].vc_PanMultLeft;
    panr[i]  := ht^.ht_Voices[i].vc_PanMultRight;
    
    //* Ring Modulation */
    rdelta[i]:= ht^.ht_Voices[i].vc_RingDelta;
    rpos[i]  := ht^.ht_Voices[i].vc_RingSamplePos;
    rsrc[i]  := ht^.ht_Voices[i].vc_RingMixSource;
    
    //  vu[i] = 0;
  end;


  repeat
    loops := samples;
    for i := 0 to Pred(chans) do 
    begin
      if ( pos[i] >= ($280 shl 16)) then pos[i] := pos[i] - ($280 shl 16);
      cnt := (($280 shl 16) - pos[i] - 1) div delta[i] + 1;
      if ( cnt < loops ) then loops := cnt;
      
      if ( rsrc[i] <> nil ) then
      begin
        if ( rpos[i] >= ($280 shl 16)) then rpos[i] := rpos[i] - ($280 shl 16);
        cnt := (($280 shl 16) - rpos[i] - 1) div rdelta[i] + 1;
        if ( cnt < loops ) then loops := cnt;
      end;
    end;

    samples := samples - loops;

    // Inner loop
    repeat
      a :=0;
      b :=0;
      for i := 0 to Pred(chans) do 
      begin
        if ( rsrc[i] <> nil ) then
        begin
          //* Ring Modulation */
          j := ((src[i][pos[i] shr 16] * rsrc[i][rpos[i] shr 16]) shr 7) * vol[i];
          rpos[i] := rpos[i] + rdelta[i];
        end
        else
        begin
          j := src[i][pos[i] shr 16] * vol[i];
        end;
        
// **     if( abs( j ) > vu[i] ) vu[i] = abs( j );

        a := a + ( (j * panl[i]) shr 7 );
        b := b + ( (j * panr[i]) shr 7 );
        pos[i] := pos[i] + delta[i];
      end;

      a := (a*ht^.ht_mixgain) shr 8;
      b := (b*ht^.ht_mixgain) shr 8;
      
      pint16(buf1)^ := a;
      pint16(buf2)^ := b;

      loops := loops - 1;
      
      buf1 := buf1 + bufmod;
      buf2 := buf2 + bufmod;
    until ( loops <= 0);     // not(loops > 0);     // do ... while( loops > 0 );
  until ( samples <= 0 );    // not(samples > 0);   // do ... while( samples > 0 );

  for i := 0 to Pred(chans) do
  begin
    ht^.ht_Voices[i].vc_SamplePos     := pos[i];
    ht^.ht_Voices[i].vc_RingSamplePos := rpos[i];
// **   ht^.ht_Voices[i].vc_VUMeter = vu[i];
  end;
end;



procedure hvl_DecodeFrame( ht: Phvl_tune; buf1: pint8; buf2: pint8; bufmod: int32 );
var
  samples, loops: uint32;
begin
  samples := ht^.ht_Frequency div 50 div ht^.ht_SpeedMultiplier;
  loops   := ht^.ht_SpeedMultiplier;
  
  repeat
    hvl_play_irq( ht );
    hvl_mixchunk( ht, samples, buf1, buf2, bufmod );
    buf1 := buf1 + ( samples * bufmod );
    buf2 := buf2 + ( samples * bufmod );
    loops := loops - 1;
  until (loops <= 0);  // do ... while (loops)
end;



end.
