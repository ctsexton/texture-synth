var amplitudeWarp = \db.asWarp;
SynthDef(\windowLooper, {
	arg sample, rate = 1, window, position, playhead, volume, feedback, lpfCutoff, hpfCutoff, status;
	var out, index, resetPoint, isOutsideBounds, maxWindowSize, outsideBoundsTrigger, lowerBound, upperBound;

	outsideBoundsTrigger = InFeedback.ar(feedback);

	maxWindowSize = ((position + window) > 1) * (1 - position) + ((position + window) <= 1) * window;
  lowerBound = (rate >= 0) * position;
  upperBound = (rate < 0) * (position + maxWindowSize);
	resetPoint = lowerBound + upperBound;

	index = Phasor.ar(outsideBoundsTrigger, rate / BufFrames.kr(sample), 0, 1, resetPoint);
	isOutsideBounds = 1 - InRange.ar(index, position, position + maxWindowSize);
	Out.ar(feedback, isOutsideBounds);
	Out.kr(playhead, index * BufFrames.kr(sample));

	out = BufRd.ar(1, sample, index * BufFrames.kr(sample), 1, 4) * amplitudeWarp.map(volume.varlag(0.005));
	out = HPF.ar(RLPF.ar(out, lpfCutoff.varlag(0.01).lincurve(0, 1, 20, 10000, 2.5), 1), hpfCutoff.varlag(0.05).lincurve(0, 1, 30, 2500, 2));

	Out.ar(0, out!4);
	FreeSelf.kr(status);
});
