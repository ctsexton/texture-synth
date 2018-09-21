
(
  create: {
    arg self, canvas, bounds, onDrag, playhead;
    var wave, updateTimeCursor, timeCursorAnimation;

    wave = SoundFileView.new(canvas, bounds);
    wave.gridOn = false;
    wave.timeCursorOn = true;
    wave.timeCursorColor = Color.red;
    wave.mouseUpAction = {
      var position, window, couple, frames;
      frames = wave.numFrames;
      couple = wave.selections[wave.currentSelection];
      position = couple[0] / frames;
      window = couple[1] / frames;
      onDrag.value(position, window);
    };

    updateTimeCursor = { 
      playhead.get(
        {|val| {wave.timeCursorPosition = val}.defer }
      ); 
      0.02.wait;
    };
    timeCursorAnimation = Routine({updateTimeCursor.loop});

    (
      updateSoundFile: {
        arg self, newSoundFile;
        {
          wave.soundfile = newSoundFile;
          wave.read(0, newSoundFile.numFrames);
          wave.refresh;
        }.defer;
      },
      setPosition: {
        arg self, positionValue;
        {wave.setSelectionStart(0, positionValue * wave.numFrames)}.defer;
      },
      setWindow: {
        arg self, windowValue;
        {wave.setSelectionSize(0, windowValue * wave.numFrames)}.defer;
      },
      startPlayhead: {
        timeCursorAnimation.play;
      },
      stopPlayhead: {
        timeCursorAnimation.stop;
      },
      togglePlayhead: {
        arg self, value;
        switch (value,
          1, { timeCursorAnimation.play },
          0, { timeCursorAnimation.stop }
        )
      }
    )
  }
)
