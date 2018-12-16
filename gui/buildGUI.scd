{ |trackControllers, sampleList, masterController|
  var topLevelWindow = Window.new('TextureSynth', Rect(0, 0, 1300, 1600)).front;
  var makeTrackGUI = { |track, initialSampleIndex|
    var action = { |item|
      track.setParameter('sample', item);
    };
    var onDrag = { |position, window|
      track.setParameter('position', position);
      track.setParameter('window', window);
    };
    var playhead = track.playheadPositionBus;

    var menu = SampleMenu(CompositeView(topLevelWindow, Rect(0, 0, 1000, 200)), sampleList, action, initialSampleIndex);
    var display = WaveDisplay(topLevelWindow, Rect(0, 100, 1000, 200), onDrag, playhead);
    (
      receive: { |self, parameterName, value|
        switch (parameterName,
          'sample', { display.updateSoundFile(value.soundFile) },
          'position', { display.setPosition(value) },
          'window', { display.setWindow(value) },
          'started', { display.togglePlayhead(value) }
        )
      }
    )
  };
  var trackUserInterface = makeTrackGUI.value(trackControllers[0], 0);
  trackControllers[0].userInterfaces = trackControllers[0].userInterfaces.add(trackUserInterface);
}
