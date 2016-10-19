module orelang.operator.IfOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

class IfOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    Value ret;

/*    import std.stdio;

    writeln("[IfOperator] args -> ", args);
    writeln("[IfOperator] args.length -> ", args.length);*/

    if (engine.eval(args[0]).getBool) {
      ret = engine.eval(args[1]);
    } else {
      if (args.length != 3) {
        ret = new Value;
      } else {
        ret = engine.eval(args[2]);
      }
    }

    return ret;
  }
}
