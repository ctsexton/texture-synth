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

	out = BufRd.ar(1, sample, index * BufFrames.kr(sample), 1, 4) * volume;
	out = HPF.ar(RLPF.ar(out, lpfCutoff.linexp(0, 1, 50, 10000), 1), hpfCutoff.lincurve(0, 1, 10, 2500, -2));

	Out.ar(0, out!4);
	FreeSelf.kr(status);
});
