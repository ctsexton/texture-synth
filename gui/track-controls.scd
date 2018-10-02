var addressFactory;
addressFactory = "../core/address.scd".loadRelative[0];

(
create: {
	arg self, canvas, director, trackIndex;
	var startStop, knobSettings, knobs, addresses, specs, parameters;

	parameters = [\rate, \lpfCutoff, \hpfCutoff, \volume, \status];

  specs = ();
  parameters.do({
    arg param;
    specs[param] = addressFactory.create(trackIndex, param)
  });

	startStop = Button.new(canvas, Rect(0, 0, 100, 200));
	startStop.states = [["Start", Color.white, Color.black], ["Stop", Color.black, Color.white]];
	startStop.action = {
		arg button;
		director.togglePlayback(specs.status, button.value);
	};

	knobSettings = (
		rate: (
			label: \Rate,
			x: 0,
			controlSpec: ControlSpec.new(-2, 2),
			onChange: {|self, val| director.setParameter(specs['rate'], val.value)},
			initVal: 1
		),
		lpfCutoff: (
			label: \LPF,
			x: 200,
			controlSpec: ControlSpec.new(0, 1),
			onChange: {|self, val| director.setParameter(specs['lpfCutoff'], val.value)},
			initVal: 1
		),
		hpfCutoff: (
			label: \HPF,
			x: 400,
			controlSpec: ControlSpec.new(0, 1),
			onChange: {|self, val| director.setParameter(specs['hpfCutoff'], val.value)},
			initVal: 0
		),
		volume: (
			label: \Volume,
			x: 600,
			controlSpec: ControlSpec.new(0, 1),
			onChange: {|self, val| director.setParameter(specs['volume'], val.value)},
			initVal: 0
		)
  );
	knobs = knobSettings.collect({
		arg knob;
		var ezKnob;
		EZKnob.new(canvas, Rect(knob.x + 100, 0, 200, 200), knob.label, knob.controlSpec, {|val| knob.onChange(val)}, knob.initVal);
	});
	knobs.do({
		|knob|
		knob.font = Font.new('Cantarell', 14);
	});
	(
		director: director,
		knobs: knobs,
		receiveParameter: {
			arg self, address, value;
			var parameter;

			if (address['track'] == trackIndex, {
				parameter = address['name'];
				{knobs[parameter].value = value}.defer;
			});
		}
	)
}
)
