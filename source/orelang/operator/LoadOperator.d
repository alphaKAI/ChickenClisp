module orelang.operator.LoadOperator;
import orelang.operator.IOperator,
       orelang.Interpreter,
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
    Interpreter itpr = new Interpreter(engine);

    if (eargs0.type == ValueType.Array) {
      args = eargs0.getArray;
    }

    string[] fpaths = args.map!(arg => (engine.eval(arg)).getString ~ ".ore").array;

    foreach (fpath; fpaths) {
      if (!exists(fpath)) {
        throw new Error("No such file - " ~ fpath);
      } else {
        itpr.executer(readText(fpath));
        loaded ~= fpath;
      }
    }

    Value[] ret;

    foreach (load; loaded) {
      ret ~= new Value(load);
    }

    return new Value(ret);
  }
}
