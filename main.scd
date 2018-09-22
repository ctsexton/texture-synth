(
var main, sampleLoader, trackFactory, addressFactory, guiFactory, director, mftFactory, storageFactory, launchpadFactory;
~global_APP_DIRECTORY = thisProcess.nowExecutingPath.dirname.asString;
addressFactory = (~global_APP_DIRECTORY +/+ "/core/address.scd").load;
director = "core/controlDirector.scd".loadRelative[0].value();
guiFactory = "gui/top.scd".loadRelative[0];
trackFactory = "core/track.scd".loadRelative[0];
mftFactory = "midi/mft.scd".loadRelative[0];
launchpadFactory = "midi/launchpad.scd".loadRelative[0];
storageFactory = "core/storage.scd".loadRelative[0];
sampleLoader = "core/sampleLoader.scd".loadRelative[0];
main = {
	var samples, tracks, mft, launchpad, setInitialSoundFile, allTrackGUIs, storage;

	"core/synthdefs.scd".loadRelative[0].add;

  samples = sampleLoader.create(sampleLoader.getRelativeFolderPath('samples'));
  tracks = 4.collect({
    arg index;
    var track;

    track = trackFactory.create(samples, index);
		director.addTrack(track);
		track;
  });

  setInitialSoundFile = {
    arg trackGUI, index;
    var soundFile, address;
    address = addressFactory.create(index, 'soundFile');
    soundFile = samples[index];
    trackGUI.waveformGUI.receiveParameter(address, soundFile);
  };

  QtGUI.palette = QPalette.dark;
	allTrackGUIs = guiFactory.create(director, samples);
  allTrackGUIs.do(setInitialSoundFile);

  storage = storageFactory.create(director, 64);
  x = storage;

	MIDIClient.init;
	mft = mftFactory.create(director);
	// "Done";
  launchpad = launchpadFactory.create(director);
};

s.waitForBoot(main);
)
/*
x.save();
x.restore();
*/
