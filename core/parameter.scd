(
create: {
	arg self, parameter, init, min, max, increment, updateFunc = nil, getValueForSynth = nil;
	var value, setNumber, changeFunction, setSynth;
  value = init;

  setNumber = {
    arg newVal;
    var choice = case
    {newVal > max} { max }
    {newVal < min} { min }
    {newVal};
    value = choice;
    value;
  };

  changeFunction = case {updateFunc != nil} { updateFunc } { setNumber };
  getValueForSynth = case {getValueForSynth != nil} { getValueForSynth } { {value} };

	(
		getValue: {value;},
    getValueForSynth: { getValueForSynth.value(value) },
		accum: {
			arg self, direction;
			var accum, oldVal, newVal;

			oldVal = value;

			accum = (direction * 2 - 1) * increment;
			newVal = oldVal + accum;

			if ((newVal >= min) && (newVal <= max),
				{ setNumber.value(newVal); }
			);

			newVal;
		},
    change: {
      arg self, newValue;
      value = changeFunction.value(newValue);
      value;
    },
    resetValue: { value = changeFunction.value(init); value; }
	)
}
)
