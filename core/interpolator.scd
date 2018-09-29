var interpolate;
interpolateValues = {
  arg fromValue, toValue, interpolation;
  if (fromValue.isNumber,
    {(fromValue * (1 - interpolation) + (toValue * interpolation))},
    {if (interpolation > 0.5, fromValue, toValue)}
  );
};
interpolateMementos = {
  arg fromMem, toMem, interpolation;
  fromMem.collect({|item, i| interpolateValues.value(item, toMem[i], interpolation)});
}
