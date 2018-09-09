var addressFactory;
addressFactory = "address.scd".loadRelative[0];

(
create: {
	arg self, name, trackIndex, initVal, min, max, increment;
	var address;
	address = addressFactory.create(trackIndex, name);
	(
		currentValue: initVal,
		address: address,
		initValue: initVal,
		min: min,
		max: max,
		inc: increment,
		getValue: {arg self; self['currentValue']},
		setValue: {
			arg self, newVal;
			var choice;

			choice = case
			{newVal > max} { max }
			{newVal < min} { min }
			{newVal};
			self['currentValue'] = choice;
			choice;
		},
		accumValue: {
			arg self, direction;
			var accum, oldVal, newVal;

			oldVal = self['currentValue'];

			accum = (direction * 2 - 1) * increment;
			newVal = oldVal + accum;

			if ((newVal >= min) && (newVal <= max),
				{ self.setValue(newVal); }
			);

			newVal;
		}
	)
}
)
