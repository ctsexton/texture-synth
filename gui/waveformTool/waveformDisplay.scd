(
  create: {
    arg self, canvas, bounds, onDrag, playhead;
    var wave, updateTimeCursor, timeCursorAnimation, position, window, updatePosition, updateWindow;


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

    position = 0;
    window = 1;
    updatePosition = { {wave.setSelectionStart(0, position * wave.numFrames)}.defer };
    updateWindow = {{wave.setSelectionSize(0, window * wave.numFrames)}.defer;};

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
        if (wave.soundfile != newSoundFile, {{
          wave.soundfile = newSoundFile;
          wave.read(0, newSoundFile.numFrames);
          wave.refresh;
          updatePosition.value();
          updateWindow.value();
        }.defer});
      },
      setPosition: {
        arg self, newValue;
        position = newValue;
        updatePosition.value();
      },
      setWindow: {
        arg self, newValue;
        window = newValue;
        updateWindow.value();
      },
      startPlayhead: {
        timeCursorAnimation.play;
      },
      stopPlayhead: {
        timeCursorAnimation.stop;
        timeCursorAnimation.reset;
      },
      togglePlayhead: {
        arg self, value;
        switch (value,
          1, { timeCursorAnimation.play },
          0, { timeCursorAnimation.stop; timeCursorAnimation.reset }
        )
      }
    )
  }
)
