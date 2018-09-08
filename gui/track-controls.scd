var addressFactory;
addressFactory = "../core/address.scd".loadRelative[0];

(
create: {
	arg self, canvas, director, trackIndex;
	var knobSettings, knobs, addresses, specsArr;

	addresses = [];
	specsArr = [\position, \window, \rate, \volume];
	for (0, 3, {arg i; addresses = addresses.add(addressFactory.create(trackIndex, specsArr[i]))});

	knobSettings = [
		(
			label: \Position,
			x: 0,
			controlSpec: ControlSpec.new(0.001, 0.999),
			onChange: {|self, val| director.setParameter(addresses[0], val.value)},
			initVal: 0
		),
		(
			label: \Window,
			x: 200,
			controlSpec: ControlSpec.new(0.001, 0.999),
			onChange: {|self, val| director.setParameter(addresses[1], val.value)},
			initVal: 1
		),
		(
			label: \Rate,
			x: 400,
			controlSpec: ControlSpec.new(-2, 2),
			onChange: {|self, val| director.setParameter(addresses[2], val.value)},
			initVal: 1
		),
		(
			label: \Volume,
			x: 600,
			controlSpec: ControlSpec.new(0, 1),
			onChange: {|self, val| director.setParameter(addresses[3], val.value)},
			initVal: 1
		),
	];
	knobs = knobSettings.collect({
		arg knob;
		var ezKnob;
		EZKnob.new(canvas, Rect(knob.x, 0, 200, 200), knob.label, knob.controlSpec, {|val| knob.onChange(val)}, knob.initVal);
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
			var specs, parameter;
			specs = (\position: 0, \window: 1, \rate: 2, \volume: 3);

			if (address['track'] == trackIndex, {
				parameter = address['name'];
				{knobs[specs[parameter]].value = value}.defer;
			});
		}
	)
}
)
