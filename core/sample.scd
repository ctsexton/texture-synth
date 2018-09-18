(
  create: {
    arg self, path, server;
    var buffer, soundFile, frames;

    buffer = Buffer.read(server, path);
    frames = buffer.numFrames;
    soundFile = SoundFile.new;
    soundFile.openRead(path.asString);
    (
      buffer: buffer,
      soundFile: soundFile,
      frames: frames
    )
  }
)
