import orelang.Interpreter,
       orelang.Transpiler,
       orelang.Engine;
import std.stdio,
       std.file;

void main(string[] args) {
  if (args.length == 2) {
    string fpath = args[1];

    if (!exists(fpath)) {
      writeln("No such file - ", fpath);
    } else {
      Engine engine = new Engine();
      engine.eval(Transpiler.transpile(readText(fpath)));
    }
  } else if (args.length == 1) {
    Interpreter itpr = new Interpreter();
    itpr.interpreter();
  } else {
    writeln("error"); // this error comment needs improving
  }
}
