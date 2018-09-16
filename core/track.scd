var parameter;
parameter = "parameter.scd".loadRelative[0];
(
create: {
	arg self, buffer, trackIndex;
	var playbackIndex, synth, feedback;

	playbackIndex = Bus.control();
	feedback = Bus.audio();
	playbackIndex.set(0);

	(
		director: nil,
		buffer: buffer,
		playbackIndex: playbackIndex,
		position: parameter.create('position', trackIndex, 0, 0, 1, 0.01),
		window: parameter.create('window', trackIndex, 1, 0, 1, 0.01),
		rate: parameter.create('rate', trackIndex, 1, -2, 2, 0.01),
		lpfCutoff: parameter.create('lpfCutoff', trackIndex, 1, 0, 1, 0.005),
		hpfCutoff: parameter.create('hpfCutoff', trackIndex, 0, 0, 1, 0.005),
		volume: parameter.create('volume', trackIndex, 0, 0, 1, 0.01),
		theSynth: nil,
		stop: parameter.create('stop', trackIndex, 0, 0, 1, 1),

		start: {
			arg self;
			self.theSynth = Synth.new(\windowLooper, [
				\feedback: feedback,
				\buffer: self.buffer,
				\bufFrames: self.buffer.numFrames,
				\rate: self.rate.getValue(),
				\window: self.window.getValue(),
				\position: self.position.getValue,
				\playhead: playbackIndex,
				\volume: self.volume.getValue(),
				\lpfCutoff: self.lpfCutoff.getValue(),
				\hpfCutoff: self.hpfCutoff.getValue(),
				\stop: self.stop.getValue(),
			]);
		},
		stopSynth: {
			arg self;

			self['stop'].setValue(1);
			self.updateSynth('stop');
		},
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

			self.theSynth.set(parameter, self[parameter].getValue());
		}
	)
}
)
