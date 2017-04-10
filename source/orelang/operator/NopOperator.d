module orelang.operator.NopOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

class NopOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    return new Value;
  }
}
