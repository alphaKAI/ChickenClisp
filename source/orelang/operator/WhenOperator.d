module orelang.operator.WhenOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

class WhenOperator : IOperator {
  /**
   * Loop while the condition is true.
   */
  public Value call(Engine engine, Value[] args) {
    if (engine.eval(args[0]).getBool) {
      Value ret = null;

      foreach (arg; args[1..$]) {
        ret = engine.eval(arg);
      }

      return ret;
    } else {
      return new Value;
    }
  }
}
