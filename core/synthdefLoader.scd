var adder;

adder = {
  arg synthDefs, onAllComplete;
  var length, complete, checkAll;
  complete = 0;
  length = synthDefs.size;
  checkAll = {
    if (complete == length,
      {onAllComplete.value()}
    )
  };
  synthDefs.do({
    arg item;
    item.add(completionMsg: {complete = complete + 1; checkAll.value();})
  })
};

(
  addAllSynthDefs: {
    arg self, synthDefs, completionMsg;
    adder.value(synthDefs, completionMsg);
  }
)
