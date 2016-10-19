module orelang.operator.WhileOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

class WhileOperator : IOperator {
  /**
   * Loop while the condition is true.
   */
  public Value call(Engine engine, Value[] args) {
    Value ret = null;

    while (engine.eval(args[0]).getBool) {
      ret = engine.eval(args[1]);
    }

    return ret;
  }
}
