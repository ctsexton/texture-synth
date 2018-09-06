(
name: 'Track Controller',
create: {
	arg self, canvas, track;
	var knobSettings, knobs;

	knobSettings = [
		(
			label: \Position,
			x: 0,
			controlSpec: ControlSpec.new(0.001, 0.999),
			onChange: {|self, val| track.setParam('position', val.value)},
			initVal: 0
		),
		(
			label: \Window,
			x: 200,
			controlSpec: ControlSpec.new(0.001, 0.999),
			onChange: {|self, val| track.set(\window, val.value)},
			initVal: 1
		),
		(
			label: \Rate,
			x: 400,
			controlSpec: ControlSpec.new(-2, 2),
			onChange: {|self, val| track.set(\rate, val.value)},
			initVal: 1
		),
		(
			label: \Volume,
			x: 600,
			controlSpec: ControlSpec.new(0, 1),
			onChange: {|self, val| track.set(\volume, val.value)},
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
		//knob.setColors(\stringColor, Color.green);
		knob.font = Font.new('Cantarell', 14);
	});
}
)
