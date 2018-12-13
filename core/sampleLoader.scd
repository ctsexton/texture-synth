(
  create: {
    arg self, sampleFolderPath;
    var files;

    files = PathName.new(sampleFolderPath).files;
    files.collect({
      arg path;
      Sample(path);
    });
  },
  getRelativeFolderPath: {
    arg self, folderName;
    var appDirectory;
    appDirectory = try(
      {"TRY".postln; thisProcess.nowExecutingPath.dirname;},
      {"CATCH".postln; File.getcwd;}
    );
    appDirectory +/+ folderName;
  }
)
