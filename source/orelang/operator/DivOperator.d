module orelang.operator.DivOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

class DivOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    Value ret = engine.eval(args[0]);

    foreach (arg; args[1..$]) {
      Value v = engine.eval(arg);
      ret /= v;
    }

    return ret;
  }
}
