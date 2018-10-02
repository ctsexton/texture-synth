var parameter;
parameter = "parameter.scd".loadRelative[0];
(
create: {
	arg self, masterBus;
	var parameters, synth;

  parameters = (
		m_interpolationTime: parameter.create('m_interpolationTime', 0, 0, 5, 0.01),
	  m_reverbIn: parameter.create('m_reverbIn', 0, 0, 1, 0.01),
		m_lpf: parameter.create('m_lpf', 1, 0, 1, 0.005),
		m_hpf: parameter.create('m_hpf', 0, 0, 1, 0.005),
		m_distortion: parameter.create('m_distortion', 0, 0, 1, 0.01),
		m_volume: parameter.create('m_volume', 0, 0, 1, 0.01),
  );

  synth = Synth.new(\master, [
    \masterBus: masterBus,
    \m_reverbIn: parameters['m_reverbIn'].getValueForSynth(),
    \m_lpf: parameters['m_lpf'].getValueForSynth(),
    \m_hpf: parameters['m_hpf'].getValueForSynth(),
    \m_distortion: parameters['m_distortion'].getValueForSynth(),
    \m_volume: parameters['m_volume'].getValueForSynth
  ]);

	(
		director: nil,

		start: {
			arg self;
		},
		stopSynth: {
			arg self;
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
			synth.set(parameter, parameters[parameter].getValueForSynth());
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
