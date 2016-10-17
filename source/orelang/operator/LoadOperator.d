module orelang.operator.LoadOperator;
import orelang.operator.IOperator,
       orelang.Transpiler,
       orelang.Engine,
       orelang.Value;
import std.algorithm,
       std.array,
       std.file;

class LoadOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    string[] loaded;
    Value eargs0 = engine.eval(args[0]);

    if (eargs0.convertsTo!(Value[])) {
      args = eargs0.get!(Value[]);
    }

    string[] fpaths = args.map!(arg => (engine.eval(arg)).get!string ~ ".ore").array;

    foreach (fpath; fpaths) {
      if (!exists(fpath)) {
        throw new Error("No such file - " ~ fpath);
      } else {
        engine.eval(Transpiler.transpile(readText(fpath)));
        loaded ~= fpath;
      }
    }

    return Value(loaded.map!(load => Value(load)).array);
  }
}
