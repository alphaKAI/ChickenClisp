module orelang.operator.AddOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

class AddOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    Value ret = 0L;

    foreach (arg; args) {
      Value v = engine.eval(arg);
      ret += v;
    }

    return ret;
  }
}
