/*
3. run SETUP:
  - create GUI for each track and connect
  - create GUI for master and connect
  - reset all track params
*/

var addAllSynthDefs = "core/synthdefLoader.scd".loadRelative[0];
var synthDefs = [
  "core/synthdefs/sampler.scd".loadRelative[0],
  "core/synthdefs/masterChannel.scd".loadRelative[0]
];

var loadSamples = {
  var files;
  //PathName.scroot("/home/cts/SuperCollider/texture-synth");
  files = PathName.new("/home/cts/SuperCollider/texture-synth/old_samples").files;
  files.collect({ |path| Sample(path) });
};

var createGUI = {
  //
};

var setup = {  
  var samples = loadSamples.value;
  var masterBus = Bus.audio(s, 2);
  var masterController = TrackMediator(MasterTrack(masterBus));
  var trackControllers = 3.collect({ |index| 
    samples[index].name.postln;
    TrackMediator(Track(index, samples[index], masterBus));
  });
  var gui = createGUI.value(trackControllers, masterController);
  // set initial soundfile for gui
};

s.waitForBoot( {
  Routine({
    synthDefs.do({ |def| def.add; });
    s.sync;
    setup.value;
  }).play;
  s.plotTree;
  s.scope;
} );

