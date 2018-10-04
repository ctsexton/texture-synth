var amplitudeWarp = \db.asWarp;
SynthDef(\windowLooper, {
  arg sample, rate = 1, window, position, playhead, volume, feedback, lpfCutoff, hpfCutoff, status, outputBus;
  var out, index, resetPoint, isOutsideBounds, maxWindowSize, outsideBoundsTrigger, previousIndex, ramp, env, diff, playback;

  outsideBoundsTrigger = InFeedback.ar(feedback);

  maxWindowSize = ((position + window) > 1) * (1 - position) + ((position + window) <= 1) * window;
  resetPoint = ((rate >= 0) * position) + ((rate < 0) * (position + maxWindowSize));

  index = Phasor.ar(outsideBoundsTrigger, rate / BufFrames.kr(sample), 0, 1, resetPoint);
  isOutsideBounds = 1 - InRange.ar(index, position, position + maxWindowSize);
  Out.ar(feedback, isOutsideBounds);
  Out.kr(playhead, index * BufFrames.kr(sample));
   
  playback = BufRd.ar(1, sample, index * BufFrames.kr(sample), 1, 4);

  // Ramp & Switch
  env = Env([1, 1, 0], [0, 512/SampleRate.ir]);
  ramp = EnvGen.ar(env, outsideBoundsTrigger);
  diff = Latch.ar(HPZ1.ar(playback, 2), outsideBoundsTrigger);

  out = playback - (diff * ramp);
  out = out.tanh * amplitudeWarp.map(volume.varlag(0.005));
  out = HPF.ar(RLPF.ar(out, lpfCutoff.varlag(0.01).lincurve(0, 1, 20, 10000, 2.5), 1), hpfCutoff.varlag(0.05).lincurve(0, 1, 30, 5000, 2));

  Out.ar(outputBus, out!2);
  FreeSelf.kr(status);
});
