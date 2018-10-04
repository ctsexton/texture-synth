(
var main, setup, sampleLoader, trackFactory, masterTrackFactory, addressFactory, guiFactory, director, masterDirector, mftFactory, storageFactory, launchpadFactory, synthDefLoader, synthDefs;
~global_APP_DIRECTORY = thisProcess.nowExecutingPath.dirname.asString;
addressFactory = (~global_APP_DIRECTORY +/+ "/core/address.scd").load;
director = "core/controlDirector.scd".loadRelative[0].value();
masterDirector = "core/controlDirector.scd".loadRelative[0].value();
guiFactory = "gui/top.scd".loadRelative[0];
trackFactory = "core/track.scd".loadRelative[0];
masterTrackFactory = "core/masterTrack.scd".loadRelative[0];
mftFactory = "midi/mft.scd".loadRelative[0];
launchpadFactory = "midi/launchpad.scd".loadRelative[0];
storageFactory = "core/storage.scd".loadRelative[0];
sampleLoader = "core/sampleLoader.scd".loadRelative[0];
synthDefLoader = "core/synthdefLoader.scd".loadRelative[0];
synthDefs = [
  "core/synthdefs/masterChannel.scd".loadRelative[0],
  "core/synthdefs/sampler.scd".loadRelative[0]
];

setup = {
	var samples, tracks, mft, launchpad, setInitialSoundFile, allTrackGUIs, storage, params, masterTrack, masterBus;

  samples = sampleLoader.create(sampleLoader.getRelativeFolderPath('samples'));
  masterBus = Bus.audio(s, 2);
  masterTrack = masterTrackFactory.create(masterBus);
  masterDirector.addTrack(masterTrack);

  tracks = 3.collect({
    arg index;
    var track;

    track = trackFactory.create(samples, index, masterBus);
		director.addTrack(track);
		track;
  });


  setInitialSoundFile = {
    arg trackGUI, index;
    var soundFile, address;
    address = addressFactory.create(index, 'sample');
    soundFile = samples[index];
    trackGUI.waveformGUI.receiveParameter(address, soundFile);
  };

  storage = storageFactory.create(director, 65);
  x = storage;

  QtGUI.palette = QPalette.dark;
	allTrackGUIs = guiFactory.create(director, samples, masterDirector, storage);
  allTrackGUIs.do(setInitialSoundFile);

	MIDIClient.init;
	mft = mftFactory.create(director, storage, masterDirector);
	director.registerUI(mft, [\position, \window, \rate, \lpfCutoff, \hpfCutoff, \volume]);
  masterDirector.registerUI(mft, [\m_reverbIn, \m_hpf, \m_lpf, \m_distortion, \m_volume]);
  storage.registerUI(mft);
  launchpad = launchpadFactory.create(storage, director);
  l = launchpad;

  params = [\position, \window, \rate, \lpfCutoff, \hpfCutoff, \volume];
  3.do({
    arg track;
    params.do({
      arg parameter;
      var address = (track: track, name: parameter);
      director.resetParameter(address);
    })
  })
};

main = {
  synthDefLoader.addAllSynthDefs(synthDefs, setup);
  "DONE".postln;
};

s.waitForBoot(main);
)

x.saveToDisk();

x.restoreFromDisk();

l.restore();

Platform.userAppSupportDir