module orelang.operator.GetOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

class GetOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    return engine.getVariable(args[0].getString);
  }
}
