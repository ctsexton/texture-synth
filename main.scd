(
MIDIClient.init;
b = Buffer.read(s, '/home/cts/Pd/soundfilez/funkay1.wav');
"core/synthdefs.scd".loadRelative[0].add;
)

(
var trackFactory, track, addressFactory, trackAddress, guiFactory, gui, director, mftFactory, mft;

director = "core/controlDirector.scd".loadRelative[0].value();

guiFactory = "gui/top.scd".loadRelative[0];
trackFactory = "core/track.scd".loadRelative[0];
mftFactory = "midi/mftFactory.scd".loadRelative[0];


track = trackFactory.create(b);
director.addTrack(track);

guiFactory.create(director);
mft = mftFactory.create(director);
"Done";
)
