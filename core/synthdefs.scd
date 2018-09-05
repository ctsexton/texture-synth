SynthDef(\windowLooper, {
	arg buffer, bufFrames, rate = 1, window, position, playhead, volume;
	var out, index, feedback, resetPoint, isOutsideBounds, maxWindowSize, outsideBoundsTrigger, lower, upper;

	feedback = Bus.audio();
	outsideBoundsTrigger = InFeedback.ar(feedback);

	maxWindowSize = ((position + window) > 1) * (1 - position) + ((position + window) <= 1) * window;
	resetPoint = Thing.kr(rate, position, maxWindowSize);

	index = Phasor.ar(outsideBoundsTrigger, rate / bufFrames, 0, 1, resetPoint);
	isOutsideBounds = 1 - InRange.ar(index, position, position + maxWindowSize);
	Out.ar(feedback, isOutsideBounds);
	Out.kr(playhead, index * bufFrames);

	out = BufRd.ar(1, buffer, index * bufFrames, 1, 4) * volume;
	Out.ar(0, out!2)
});