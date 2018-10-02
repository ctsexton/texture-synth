var addressFactory;
addressFactory = "../core/address.scd".loadRelative[0];
(
  create: {
    |self, canvas, director|
    var parameters, specs, knobSettings, knobs, trackIndex;
    trackIndex = 0;
    parameters = [\m_interpolationTime, \m_reverbIn, \m_lpf, \m_hpf, \m_distortion, \m_volume];


  specs = ();
  parameters.do({
    arg param;
    specs[param] = addressFactory.create(trackIndex, param)
  });

	knobSettings = (
		m_interpolationTime: (
      order: 0,
			label: 'Interpolation Time',
			controlSpec: ControlSpec.new(0, 5),
			onChange: {|self, val| director.setParameter(specs['m_interpolationTime'], val.value)},
			initVal: 0
		),
		m_reverbIn: (
      order: 1,
			label: \Reverb,
			controlSpec: ControlSpec.new(0, 1),
			onChange: {|self, val| director.setParameter(specs['m_reverbIn'], val.value)},
			initVal: 0
		),
		m_lpf: (
      order: 2,
			label: \LowPass,
			controlSpec: ControlSpec.new(0, 1),
			onChange: {|self, val| director.setParameter(specs['m_lpf'], val.value)},
			initVal: 1
		),
		m_hpf: (
      order: 3,
			label: \HiPass,
			controlSpec: ControlSpec.new(0, 1),
			onChange: {|self, val| director.setParameter(specs['m_hpf'], val.value)},
			initVal: 0
		),
		m_distortion: (
      order: 4,
			label: \Distortion,
			controlSpec: ControlSpec.new(0, 1),
			onChange: {|self, val| director.setParameter(specs['m_distortion'], val.value)},
			initVal: 0
		),
		m_volume: (
      order: 5,
			label: \Volume,
			controlSpec: ControlSpec.new(0, 1),
			onChange: {|self, val| director.setParameter(specs['m_volume'], val.value)},
			initVal: 0
		)
  );
	knobs = knobSettings.collect({
		arg knob, key;
		var ezKnob;
		EZKnob.new(canvas, Rect(knob['order'] * 225 + 250, 0, 200, 200), knob.label, knob.controlSpec, {|val| knob.onChange(val)}, knob.initVal);
	});
	knobs.do({
		|knob|
		knob.font = Font.new('Cantarell', 14);
	});
	(
		director: director,
		knobs: knobs,
    parameters: parameters,
		receiveParameter: {
			arg self, address, value;
			var parameter;

      [address.name, address.track, value].postln;

			if (address['track'] == trackIndex, {
				parameter = address['name'];
				{knobs[parameter].value = value}.defer;
			});
		}
	)
  }
)
