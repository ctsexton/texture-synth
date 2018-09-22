var parameter;
parameter = "parameter.scd".loadRelative[0];
(
create: {
	arg self, allSamples, trackIndex;
	var playbackIndex, synth, feedback, initialSound, synthParameters;

  initialSound = allSamples[trackIndex];

	playbackIndex = Bus.control();
	feedback = Bus.audio();
	playbackIndex.set(0);

  synthParameters = (
		position: parameter.create('position', trackIndex, 0, 0, 1, 0.01),
		window: parameter.create('window', trackIndex, 1, 0, 1, 0.01),
		rate: parameter.create('rate', trackIndex, 1, -2, 2, 0.01),
		lpfCutoff: parameter.create('lpfCutoff', trackIndex, 1, 0, 1, 0.005),
		hpfCutoff: parameter.create('hpfCutoff', trackIndex, 0, 0, 1, 0.005),
		volume: parameter.create('volume', trackIndex, 0, 0, 1, 0.01),
		stop: parameter.create('stop', trackIndex, 0, 0, 1, 1),
  );

	(
		director: nil,
		buffer: initialSound.buffer,
    soundFile: initialSound.soundFile,
		playbackIndex: playbackIndex,
		theSynth: nil,

		start: {
			arg self;
			self.theSynth = Synth.new(\windowLooper, [
				\feedback: feedback,
				\buffer: self.buffer,
				\bufFrames: self.buffer.numFrames,
				\rate: synthParameters.rate.getValue(),
				\window: synthParameters.window.getValue(),
				\position: synthParameters.position.getValue,
				\playhead: playbackIndex,
				\volume: synthParameters.volume.getValue(),
				\lpfCutoff: synthParameters.lpfCutoff.getValue(),
				\hpfCutoff: synthParameters.hpfCutoff.getValue(),
				\stop: synthParameters.stop.getValue(),
			]);
		},
		stopSynth: {
			arg self;

			synthParameters['stop'].setValue(1);
			self.updateSynth('stop');
		},
		getParameter: {
			arg self, parameter;

			synthParameters[parameter].getValue();
		},
		setParameter: {
			arg self, parameter, newValue;
			var updatedValue;

			updatedValue = synthParameters[parameter].setValue(newValue);
			self.updateSynth(parameter);
			updatedValue;
		},
		accumParameter: {
			arg self, parameter, direction;
			var updatedValue;

			updatedValue = synthParameters[parameter].accumValue(direction);
			self.updateSynth(parameter);
			updatedValue;
		},
		updateSynth: {
			arg self, parameter;

			self.theSynth.set(parameter, synthParameters[parameter].getValue());
		},
    switchSample: {
      arg self, sample;

      self['buffer'] = sample.buffer;
      self['soundFile'] = sample.soundFile;
			self.theSynth.set('buffer', self['buffer']);
      self.theSynth.set('bufFrames', self['buffer'].numFrames);
    },
    makeMemento: {
      arg self;
      synthParameters.collect({
        arg parameter;
        parameter.getValue();
      });
    }
	)
}
)
