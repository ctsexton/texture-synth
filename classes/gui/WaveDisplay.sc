WaveDisplay {
  var wave, position, window, action, updatePosition, updateWindow, updateTimeCursor, timeCursorAnimation;
  *new { |canvas, bounds, onDrag, playhead|
    ^super.new.init(canvas, bounds, onDrag, playhead);
  }
  init { |canvas, bounds, onDrag, playhead|
    wave = this.setupWaveform(canvas, bounds, onDrag);
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
  }

  updateSoundFile { |newSoundFile|
    if (wave.soundfile != newSoundFile, {{
      wave.soundfile = newSoundFile;
      wave.read(0, newSoundFile.numFrames);
      wave.refresh;
      updatePosition.value();
      updateWindow.value();
    }.defer});
  }

  setPosition { |newValue|
    position = newValue;
    updatePosition.value();
  }

  setWindow { |newValue|
    window = newValue;
    updateWindow.value();
  }

  startPlayhead {
    timeCursorAnimation.reset.play;
  }

  stopPlayhead {
    timeCursorAnimation.stop;
  }

  togglePlayhead { |value|
    switch (value,
      true, { this.startPlayhead },
      false, { this.stopPlayhead }
    )
  }

  setupWaveform { |canvas, bounds, onDrag|
    var waveform = SoundFileView(canvas, bounds);
    waveform.gridOn = false;
    waveform.peakColor = Color.new(0.85, 0.55, 0.85);
    waveform.rmsColor = Color.new(0.8, 0.5, 0.8);
    waveform.setSelectionColor(0, Color.new(1, 1, 1, 0.2));
    waveform.timeCursorOn = true;
    waveform.timeCursorColor = Color.red;
    waveform.mouseUpAction = {
      var position, window, couple, frames;
      frames = waveform.numFrames;
      couple = waveform.selections[waveform.currentSelection];
      position = couple[0] / frames;
      window = couple[1] / frames;
      onDrag.value(position, window);
    };
    ^waveform;
  }
}
