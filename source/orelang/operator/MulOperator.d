module orelang.operator.MulOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

class MulOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    Value ret = 1L;

    foreach (arg; args) {
      Value v = engine.eval(arg);
      ret *= v;
    }

    return ret;
  }
}
