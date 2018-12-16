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

var createGUI = "./gui/buildGUI.scd".loadRelative[0];

var mapMFT = "midi/mapMFT.scd".loadRelative[0];
var mapLP = "midi/mapLP.scd".loadRelative[0];
var setupMIDI = { |trackControllers, masterController|
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

var setup = { |samples, masterBus|
  var masterController = TrackMediator(MasterTrack(masterBus));
  var trackControllers = 3.collect({ |index| 
    samples[index].name.postln;
    TrackMediator(Track(index, samples[index], masterBus));
  });
  var midi = setupMIDI.value(trackControllers, masterController);
  trackControllers.do({ |track|
    track.storage = Storage(64);
  });
  { createGUI.value(trackControllers, samples, masterController) }.defer;
  { resetAllControls.value(masterController, trackControllers) }.defer;
};

{ |masterBus|
  Routine({
    var samples = loadSamples.value;
    synthDefs.do({ |def| def.add; });
    s.sync;
    setup.value(samples, masterBus);
  }).play;
}
