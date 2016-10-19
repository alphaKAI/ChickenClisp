module orelang.operator.DefvarOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

class DefvarOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    return engine.defineVariable(args[0].getString, engine.eval(args[1]));
  }
}
