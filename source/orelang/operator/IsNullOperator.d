module orelang.operator.IsNullOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

class IsNullOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    if (engine.eval(args[0]).type == ValueType.Null) {
      return new Value(true);
    } else {
      return new Value(false);
    }
  }
}
