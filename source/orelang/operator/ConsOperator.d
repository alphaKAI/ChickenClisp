module orelang.operator.ConsOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

class ConsOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    Value car = engine.eval(args[0]);
    Value cdr = engine.eval(args[1]);

    Value[] ret = [car];

    if (cdr.type == ValueType.Array) {
      foreach (elem; cdr.getArray) {
        ret ~= engine.eval(elem);
      }
    } else {
      ret ~= cdr;
    }

    return new Value(ret);
  }
}
