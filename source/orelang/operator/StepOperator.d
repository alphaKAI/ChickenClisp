module orelang.operator.StepOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

class StepOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    Value ret = null;

    foreach (arg; args) {
      ret = engine.eval(arg);
    }

    return ret;
  }
}
