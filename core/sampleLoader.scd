var sampleFactory;
sampleFactory = "sample.scd".loadRelative[0];
(
  create: {
    arg self, sampleFolderPath;
    var files;

    files = PathName.new(sampleFolderPath).files;
    files.collect({
      arg path;
      sampleFactory.create(path.fullPath);
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
