var amplitudeWarp = \db.asWarp;
SynthDef(\master, {
  arg masterBus, m_reverbIn, m_lpf, m_hpf, m_distortion, m_volume;
  var signal, reverb;

  signal = In.ar(masterBus, 2);
  //signal = SinOsc.ar();
  //signal = (signal * (m_distortion * 10)).tanh / (m_distortion * 10);
  reverb = FreeVerb.ar(signal * m_reverbIn.varlag(0.01), 1, 0.95, 0.75);
  signal = signal + reverb;
	signal = HPF.ar(RLPF.ar(signal, m_lpf.varlag(0.01).lincurve(0, 1, 20, 10000, 2.5), 1), m_hpf.varlag(0.05).lincurve(0, 1, 30, 5000, 2));
  signal = signal * amplitudeWarp.map(m_volume.varlag(0.01));

  Out.ar(0, signal);
});
