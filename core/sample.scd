(
  create: {
    arg self, path, server;
    var buffer, soundFile, frames;

    soundFile = SoundFile.new;
    soundFile.openRead(path.fullPath.asString);
    buffer = soundFile.asBuffer();
    frames = buffer.numFrames;
    (
      buffer: buffer,
      soundFile: soundFile,
      frames: frames,
      name: path.fileNameWithoutExtension
    )
  }
)
