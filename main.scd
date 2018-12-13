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
  // create a GUI for each track
  // add each GUI to master canvas
  // register each GUI for param updates from trackControllers
};

var setupMIDI = "midi/setup.scd".loadRelative[0];

var setup = {  
  var samples = loadSamples.value;
  var masterBus = Bus.audio(s, 2);
  var masterController = TrackMediator(MasterTrack(masterBus));
  var trackControllers = 3.collect({ |index| 
    samples[index].name.postln;
    TrackMediator(Track(index, samples[index], masterBus));
  });
  var gui = createGUI.value(trackControllers, masterController);
  var midi = setupMIDI.value(trackControllers, masterController);
  masterController.setParameter('volume', 1);
  trackControllers.do({ |track| 
    track.togglePlayback(true);
    ['position', 'window', 'rate', 'volume'].do({ |item| track.resetParameter(item) }) 
  });
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

