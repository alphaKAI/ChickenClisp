module orelang.operator.IsListOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

class IsListOperator : IOperator {
  /**
   * Loop while the condition is true.
   */
  public Value call(Engine engine, Value[] args) {
    if (engine.eval(args[0]).convertsTo!(Value[])) {
      return Value(true);
    } else {
      return Value(false);
    }
  }
}
