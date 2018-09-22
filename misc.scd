(
"----------------".postln;
x = (
  one: 1,
  two: 2,
  three: 3

);
"collect".postln;
z = x.collect({
  arg val, key;
  val + 1
});
x.postln;
z.postln;
"keyval".postln;
y = x.keysValuesCollect({
  arg key, value;
  value * 2
});
x.postln;
y.postln;
)
