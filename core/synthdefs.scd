SynthDef(\windowLooper, {
	arg buffer, bufFrames, rate = 1, window, position, playhead, volume, feedback, lpfCutoff, hpfCutoff, stop;
	var out, index, resetPoint, isOutsideBounds, maxWindowSize, outsideBoundsTrigger, lower, upper;

	outsideBoundsTrigger = InFeedback.ar(feedback);

	maxWindowSize = ((position + window) > 1) * (1 - position) + ((position + window) <= 1) * window;
	resetPoint = Thing.kr(rate, position, maxWindowSize);

	index = Phasor.ar(outsideBoundsTrigger, rate / bufFrames, 0, 1, resetPoint);
	isOutsideBounds = 1 - InRange.ar(index, position, position + maxWindowSize);
	Out.ar(feedback, isOutsideBounds);
	Out.kr(playhead, index * bufFrames);

	out = BufRd.ar(1, buffer, index * bufFrames, 1, 4) * volume;
	out = HPF.ar(RLPF.ar(out, lpfCutoff.linexp(0, 1, 50, 10000), 1), hpfCutoff.lincurve(0, 1, 10, 2500, -2));

	Out.ar(0, out!4);
	FreeSelf.kr(stop);
	//stop.poll;
});