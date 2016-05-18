unit replay;


(*
   Pascal port of replay, based on HVL2WAV v1.2 (THX v1.8 replayer) (xx.xx.xxxx) by Xeron/IRIS
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


Uses
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
  i         : int32;
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
    buf := buf + 1;
    val  := val + add;

    inc(i);
  end;
end;



procedure hvl_GenTriangle(buf: pint8; len: uint32);
var
  i              : int32;
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

  for i := 0 to Pred(d5) do
  begin
    buf^ := val;
    buf := buf + 1;
    val := val + d1;
  end;
  buf^ := $7f;
  buf := buf + 1;

  if ( d5 <> 1 ) then
  begin
    val := 128;

    for i := 0 to Pred(d5-1) do
    begin
      val := val - d1;
      buf^ := val;
      buf := buf + 1;
    end;
  end;

  buf2 := buf + d4;
  for i := 0 to Pred(d5 * 2) do
  begin
    c := buf2^;
    buf2 := buf2 + 1;

    if ( c = $7f )
    then c := int8($80)                     // FPC: cast to suppress warning
    else c := -c;

    buf^ := c;
    buf := buf + 1;
  end;
end;



procedure hvl_GenSquare(buf: pint8);
var
  i, j: int32;
begin
  for i := 1 to $20 do
  begin
    for j := 0 to Pred(($40 - i) * 2) do
    begin
      buf^ := int8($80);                    // FPC: cast to suppress warning
      buf := buf + 1;
    end;

    for j := 0 to Pred(i * 2) do
    begin
      buf^ := $7f;
      buf := buf + 1;
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
  lentab : array[0..Pred(45)] of uint16 =
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

      for i := 0 to lentab[wv] do           // FPC: Note <= lentab[wv]
      begin
        high  := a0[i] - mid - low;
        high  := clip( high );
        mid   := mid + (high * fre);
        mid   := clip( mid );
        low   := low + (mid * fre);
        low   := clip( low );
      end;

      for i := 0 to lentab[wv] do           // FPC: Note <= lentab[wv]
      begin
        high  := a0[i] - mid - low;
        high  := clip( high );
        mid   := mid + (high * fre);
        mid   := clip( mid );
        low   := low + (mid * fre);
        low   := clip( low );
        lowbuf^  := int8( trunc(low) );     // FPC: requires truncation
        lowbuf   := lowbuf + 1;
        highbuf^ := int8( trunc(high) );    // FPC: requires truncation
        highbuf  := highbuf + 1;
      end;

      a0 := a0 + lentab[wv]+1;
    end; // next wv

    freq := freq + 3.0;
  end; // next temp
end;



end.
