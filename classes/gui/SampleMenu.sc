SampleMenu {
  *new { |canvas, sampleList, action, initial|
    ^super.new.init(canvas, sampleList, action, initial);
  }
  init { |canvas, sampleList, action, initial|
    var items = sampleList.collect({ |item, i|
      item.name -> { action.value(item) };
    });
    EZPopUpMenu.new(parentView: canvas, bounds: Rect(0, 0, 1000, 22), items: items, initVal: initial);
  }
}
