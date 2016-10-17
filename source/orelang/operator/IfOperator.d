module orelang.operator.IfOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

class IfOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    Value ret = null;

    if (engine.eval(args[0]).get!bool) {
      ret = engine.eval(args[1]);
    } else {
      ret = engine.eval(args[2]);
    }

    return ret;
  }
}
