module orelang.operator.IsHashMapOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

class IsHashMapOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    if (engine.eval(args[0]).type == ValueType.HashMap) {
      return new Value(true);
    } else {
      return new Value(false);
    }
  }
}
