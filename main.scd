(
var main;
~global_APP_DIRECTORY = File.getcwd;
main = {
	var sampleFolderPath, sampleFactory, samplePaths, allSamples, trackFactory, tracks, addressFactory, trackAddress, guiFactory, gui, director, mftFactory, mft, setInitialSoundFile, allTrackGUIs;

  addressFactory = (~global_APP_DIRECTORY +/+ "/core/address.scd").load;
  sampleFolderPath = {
    var appDirectory;
    appDirectory = try(
      {"TRY".postln; thisProcess.nowExecutingPath.dirname;},
      {"CATCH".postln; File.getcwd;}
    );
    appDirectory +/+ 'samples/';
  }.value();
	director = "core/controlDirector.scd".loadRelative[0].value();
	guiFactory = "gui/top.scd".loadRelative[0];
	trackFactory = "core/track.scd".loadRelative[0];
	mftFactory = "midi/mft.scd".loadRelative[0];
	"core/synthdefs.scd".loadRelative[0].add;
  sampleFactory = "core/sample.scd".loadRelative[0];
  
  samplePaths = PathName.new(sampleFolderPath).files;
  allSamples = samplePaths.collect({
    arg path, s;
    sampleFactory.create(path.fullPath);
  });

  tracks = 4.collect({
    arg index;
    var track;

    track = trackFactory.create(allSamples, index);
		director.addTrack(track);
		track;
  });

  setInitialSoundFile = {
    arg trackGUI, index;
    var soundFile, address;
    addressFactory.postln;
    address = addressFactory.create(index, 'soundFile');
    soundFile = allSamples[index];
    trackGUI.waveformGUI.receiveParameter(address, soundFile);
  };

  QtGUI.palette = QPalette.dark;
	allTrackGUIs = guiFactory.create(director, allSamples);
  allTrackGUIs.do(setInitialSoundFile);

	//MIDIClient.init;
	//mft = mftFactory.create(director);
	// "Done";
};

s.waitForBoot(main);
)
