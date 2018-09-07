(
MIDIClient.init;
b = Buffer.read(s, '/home/cts/Pd/soundfilez/funkay1.wav');
"core/synthdefs.scd".loadRelative[0].add;
)

(
var trackFactory, track, guiFactory, gui, director;

director = "core/controlDirector.scd".loadRelative[0].value();

guiFactory = "gui/top.scd".loadRelative[0];
trackFactory = "core/track.scd".loadRelative[0];

track = trackFactory.create(b);
gui = guiFactory.create(director);

director.registerUI(gui, [\position, \window, \rate, \volume]);
director.addTrack(track);
)