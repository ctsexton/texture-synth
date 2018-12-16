var setup = "setup.scd".loadRelative[0];
s.waitForBoot({ 
  MIDIClient.init; 
  setup.value(Bus.audio(s, 2));
})
