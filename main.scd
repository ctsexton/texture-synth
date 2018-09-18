(
var main;
main = {
	var sampleFolderPath, sampleFactory, samplePaths, allSamples, trackFactory, tracks, addressFactory, trackAddress, guiFactory, gui, director, mftFactory, mft;

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

  QtGUI.palette = QPalette.dark;
	guiFactory.create(director);

	//MIDIClient.init;
	//mft = mftFactory.create(director);
	// "Done";
};

s.waitForBoot(main);
)
