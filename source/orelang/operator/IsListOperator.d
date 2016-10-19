module orelang.operator.IsListOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

class IsListOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    if (engine.eval(args[0]).type == ValueType.Array) {
      return new Value(true);
    } else {
      return new Value(false);
    }
  }
}
