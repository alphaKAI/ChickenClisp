module orelang.operator.ModOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

class ModOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    Value ret = engine.eval(args[0]);

    foreach (arg; args[1..$]) {
      Value v = engine.eval(arg);
      ret %= v;
    }

    return ret;
  }
}
