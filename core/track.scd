var parameter;
parameter = "parameter.scd".loadRelative[0];
(
create: {
	arg self, buffer, trackIndex;
	var playbackIndex, synth, position, window, rate, lpfCutoff, hpfCutoff, volume, feedback;

	position = parameter.create('position', trackIndex, 0, 0, 1, 0.01);
	window = parameter.create('window', trackIndex, 1, 0, 1, 0.01);
	rate = parameter.create('rate', trackIndex, 1, -2, 2, 0.01);
	lpfCutoff = parameter.create('lpfCutoff', trackIndex, 10000, 10, 10000, 1);
	hpfCutoff = parameter.create('hpfCutoff', trackIndex, 20, 10, 10000, 1);
	volume = parameter.create('volume', trackIndex, 0, 0, 1, 0.01);

	playbackIndex = Bus.control();
	feedback = Bus.audio();
	playbackIndex.set(0);

	synth = Synth.new(\windowLooper, [
		\feedback: feedback,
		\buffer: buffer,
		\bufFrames: buffer.numFrames,
		\rate: rate.initValue,
		\window: window.initValue,
		\position: position.initValue,
		\playhead: playbackIndex,
		\volume: volume.initValue
		]);

	(
		director: nil,
		position: position,
		window: window,
		rate: rate,
		lpfCutoff: lpfCutoff,
		hpfCutoff: hpfCutoff,
		volume: volume,
		buffer: buffer,
		playbackIndex: playbackIndex,
		synth: synth,

		getParameter: {
			arg self, parameter;

			self[parameter].getValue();
		},
		setParameter: {
			arg self, parameter, newValue;
			var updatedValue;

			updatedValue = self[parameter].setValue(newValue);
			self.updateSynth(parameter);
			updatedValue;
		},
		accumParameter: {
			arg self, parameter, direction;
			var updatedValue;

			updatedValue = self[parameter].accumValue(direction);
			self.updateSynth(parameter);
			updatedValue;
		},
		updateSynth: {
			arg self, parameter;

			self['synth'].set(parameter, self[parameter].getValue());
		}
	)
}
)
