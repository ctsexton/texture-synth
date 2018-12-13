{ |synthDefs, onAllComplete|
  var length, complete, checkAll;
  complete = 0;
  length = synthDefs.size;
  length.postln;
  checkAll = {
    if (complete == length,
      {"SynthDefs Loaded".postln; onAllComplete.value()}
    )
  };
  synthDefs.do({
    arg item;
    item.add(completionMsg: {
      complete = complete + 1; 
      "Added:".postln;
      item.name.postln; 
      checkAll.value();
    })
  })
}
