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

var mapMFT = "midi/mapMFT.scd".loadRelative[0];
var mapLP = "midi/mapLP.scd".loadRelative[0];
var setupMIDI = { |trackControllers, masterController|
  MIDIClient.init;
  mapMFT.value(trackControllers, masterController);
  mapLP.value(trackControllers);
};

var resetAllControls = { |masterController, trackControllers|
  ['reverb', 'hpf', 'lpf', 'volume'].do({ |item| masterController.resetParameter(item) });
  trackControllers.do({ |track| 
    track.togglePlayback(true);
    ['position', 'window', 'rate', 'lpfCutoff', 'hpfCutoff', 'volume'].do({ |item| track.resetParameter(item) });
  });
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
  var midi = setupMIDI.value(trackControllers, masterController);
  trackControllers.do({ |track|
    track.storage = Storage(64);
  });
  resetAllControls.value(masterController, trackControllers);
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

