var parameter;
parameter = "parameter.scd".loadRelative[0];
(
create: {
	arg self, allSamples, trackIndex, masterBus;
	var playbackIndex, synth, feedback, initialSound, parameters;

  initialSound = allSamples[trackIndex];

	playbackIndex = Bus.control();
	feedback = Bus.audio();
	playbackIndex.set(0);

  parameters = (
		position: parameter.create('position', 0, 0, 1, 0.01),
		window: parameter.create('window', 1, 0, 1, 0.01),
		rate: parameter.create('rate', 1, -2, 2, 0.01),
		lpfCutoff: parameter.create('lpfCutoff', 1, 0, 1, 0.005),
		hpfCutoff: parameter.create('hpfCutoff', 0, 0, 1, 0.005),
		volume: parameter.create('volume', 0, 0, 1, 0.01),
    sample: parameter.create('sample', initialSound, nil, nil, nil, { |newV| newV }, { |sample| sample.buffer })
  );

	(
		director: nil,
		playbackIndex: playbackIndex,
		theSynth: nil,

		start: {
			arg self;
			self.theSynth = Synth.new(\windowLooper, [
				\feedback: feedback,
				\sample: parameters.sample.getValueForSynth(),
				\rate: parameters.rate.getValueForSynth(),
				\window: parameters.window.getValueForSynth(),
				\position: parameters.position.getValueForSynth,
				\playhead: playbackIndex,
				\volume: parameters.volume.getValueForSynth(),
				\lpfCutoff: parameters.lpfCutoff.getValueForSynth(),
				\hpfCutoff: parameters.hpfCutoff.getValueForSynth(),
        \status: 0,
        \outputBus: masterBus
			]);
		},
		stopSynth: {
			arg self;

      self.theSynth.set('status', 1);
		},
		getParameter: {
			arg self, parameter;

			parameters[parameter].getValue();
		},
		setParameter: {
			arg self, parameter, newVal;
			var updatedValue;

			updatedValue = parameters[parameter].change(newVal);
      self.updateSynth(parameter);
			updatedValue;
		},
    resetParam: {
      arg self, parameter;
      var updatedValue;
      updatedValue = parameters[parameter].resetValue();
      self.updateSynth(parameter);
      updatedValue;
    },
		accumParameter: {
			arg self, parameter, direction;
			var updatedValue;

			updatedValue = parameters[parameter].accum(direction);
			self.updateSynth(parameter);
			updatedValue;
		},
		updateSynth: {
			arg self, parameter;
			self.theSynth.set(parameter, parameters[parameter].getValueForSynth());
		},
    makeMemento: {
      arg self;
      parameters.collect({
        arg parameter;
        parameter.getValue();
      });
    }
	)
}
)
