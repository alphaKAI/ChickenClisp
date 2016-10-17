module orelang.operator.GetfunOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

class GetfunOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    return engine.variables[args[0].get!string];
  }
}
