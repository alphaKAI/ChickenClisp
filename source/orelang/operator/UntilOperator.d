module orelang.operator.UntilOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

class UntilOperator : IOperator {
  /**
   * Loop while the condition is false
   */
  public Value call(Engine engine, Value[] args) {
    Value ret = null;

    while (!engine.eval(args[0]).get!bool) {
      ret = engine.eval(args[1]);
    }

    return ret;
  }
}
