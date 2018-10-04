var addressFactory;
addressFactory = "../core/address.scd".loadRelative[0];
(
  create: {
    |self, canvas, storage|
    var knob, changeInterp;

    changeInterp = {
      |val|
      storage.setInterpolationTime(val.value);
    };

    knob = EZKnob.new(canvas, Rect(0, 0, 200, 200), 'Interpolation Time', ControlSpec.new(0, 5), changeInterp, 0);
    knob.font = Font.new('Cantarell', 14);
    (
      receiveInterpolationTime: {
        |self, time|
        {knob.value = time}.defer;
      }
    )
  }
)
