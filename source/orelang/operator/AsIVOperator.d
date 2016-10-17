module orelang.operator.AsIVOperator;
import orelang.expression.ImmediateValue,
       orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

class AsIVOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    return Value(new ImmediateValue(engine.eval(args[0])));
  }
}
