(
create: {
	arg self, buffer;
	var position, window, rate, lowCutoff, hiCutoff, volume, playbackIndex, synth;
	position = Bus.control();
	position.set(0);
	window = Bus.control();
	window.set(1);
	rate = Bus.control();
	rate.set(1);
	lowCutoff = Bus.control();
	lowCutoff.set(10000);
	hiCutoff = Bus.control();
	hiCutoff.set(20);
	volume = Bus.control();
	volume.set(1);
	playbackIndex = Bus.control();
	playbackIndex.set(0);
	synth = Synth.new(\windowLooper, [
			\buffer: buffer,
			\bufFrames: buffer.numFrames,
			\rate: 1,
			\window: 1,
			\position: 0,
			\playhead: playbackIndex,
			\volume: 1
		]);
	(
		position: position,
		window: window,
		rate: rate,
		lowCutoff: lowCutoff,
		hiCutoff: hiCutoff,
		volume: volume,
		buffer: buffer,
		playbackIndex: playbackIndex,
		synth: synth
	)
}
)
