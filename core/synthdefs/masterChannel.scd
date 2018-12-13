var amplitudeWarp = \db.asWarp;
SynthDef(\master, {
  arg masterBus, reverb, lpf, hpf, distortion, volume;
  var signal;

  signal = In.ar(masterBus, 2);
  signal = signal + FreeVerb.ar(signal * reverb.varlag(0.01), 1, 0.95, 0.75);
	signal = HPF.ar(RLPF.ar(signal, lpf.varlag(0.01).lincurve(0, 1, 20, 10000, 2.5), 1), hpf.varlag(0.05).lincurve(0, 1, 30, 5000, 2));
  signal = signal * amplitudeWarp.map(volume.varlag(0.01));
  Out.ar(0, signal);
});
