var amplitudeWarp = \db.asWarp;
SynthDef(\windowLooper, {
  arg sample, rate = 1, window, position, playhead, volume, feedback, lpfCutoff, hpfCutoff, status, outputBus;
  var out, index, resetPoint, isOutsideBounds, maxWindowSize, outsideBoundsTrigger, lowerBound, upperBound, previousIndex, boundAmplitude, currentAmplitude, resetPointAmplitude, swandr, env, diff;

  outsideBoundsTrigger = InFeedback.ar(feedback);
  previousIndex = InFeedback.ar(playhead);

  maxWindowSize = ((position + window) > 1) * (1 - position) + ((position + window) <= 1) * window;
  lowerBound = (rate >= 0) * position;
  upperBound = (rate < 0) * (position + maxWindowSize);
  resetPoint = lowerBound + upperBound;

  index = Phasor.ar(outsideBoundsTrigger, rate / BufFrames.kr(sample), 0, 1, resetPoint);
  isOutsideBounds = 1 - InRange.ar(index, position, position + maxWindowSize);
  Out.ar(feedback, isOutsideBounds);
  Out.kr(playhead, index * BufFrames.kr(sample));
   
  currentAmplitude = BufRd.ar(1, sample, index * BufFrames.kr(sample), 1, 4);

  boundAmplitude = BufRd.ar(1, sample, DC.ar(1) * (position + maxWindowSize) * BufFrames.kr(sample), 1, 4);
  resetPointAmplitude = BufRd.ar(1, sample, DC.ar(1) * position * BufFrames.kr(sample), 1, 4);

  swandr = Env.perc(0, 0.05, 1);
  diff = boundAmplitude - resetPointAmplitude;
  env = EnvGen.ar(swandr, outsideBoundsTrigger) * diff;
  out = currentAmplitude + env;
  out = out * amplitudeWarp.map(volume.varlag(0.005));
  out = HPF.ar(RLPF.ar(out, lpfCutoff.varlag(0.01).lincurve(0, 1, 20, 10000, 2.5), 1), hpfCutoff.varlag(0.05).lincurve(0, 1, 30, 2500, 2));

  Out.ar(outputBus, out!4);
  FreeSelf.kr(status);
});
