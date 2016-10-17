module orelang.operator.SetOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

class SetOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    return engine.setVariable(*args[0].peek!string, engine.eval(args[1]));
  }
}
