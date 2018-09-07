(
create: {
	arg self, buffer;
	var playbackIndex, synth;

	playbackIndex = Bus.control();
	playbackIndex.set(0);
	synth = Synth.new(\windowLooper, [
			\buffer: buffer,
			\bufFrames: buffer.numFrames,
			\rate: 1,
			\window: 0.1,
			\position: 0,
			\playhead: playbackIndex,
			\volume: 1
		]);

	(
		director: nil,
		position: 0,
		window: 1,
		rate: 1,
		lpfCutoff: 10000,
		hpfCutoff: 20,
		volume: 1,
		buffer: buffer,
		playbackIndex: playbackIndex,
		synth: synth,

		setParameter: {
			arg self, parameter, newValue;

			parameter.postln;
			newValue.postln;

			self[parameter] = newValue;
			self.updateSynth(parameter);
		},
		updateSynth: {
			arg self, parameter;

			self['synth'].set(parameter, self[parameter]);
		}
	)
}
)
