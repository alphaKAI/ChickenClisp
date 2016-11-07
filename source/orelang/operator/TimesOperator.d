module orelang.operator.TimesOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;
import std.range,
       std.conv;

class TimesOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    Value ret = null;
    long n = engine.eval(args[0]).getNumeric.to!long;
    import std.stdio;
    writeln("[TIMES] n -> ", n);
    foreach (_; n.iota) {
      ret = engine.eval(args[1]);
    }

    return ret;
  }
}
