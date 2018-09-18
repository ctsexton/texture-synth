(
var main;
main = {
	var sampleFolderPath, samples, trackFactory, tracks, addressFactory, trackAddress, guiFactory, gui, director, mftFactory, mft;

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


	samples = ['08_Chains.wav', '13_Contact Mic 1.wav', '09_Floor Tom.wav', '01_Piano.wav'];

	t = samples.collect({
		arg name;
		var buffer, track;
		buffer = Buffer.read(s, sampleFolderPath +/+ name);
		track = trackFactory.create(buffer);
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
