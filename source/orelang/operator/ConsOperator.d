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

    Value[] ret = [Value(car)];

    if (cdr.convertsTo!(Value[])) {
      foreach (elem; cdr.get!(Value[])[0].get!(Value[])) {
        ret ~= engine.eval(elem);
      }
    } else {
      ret ~= cdr;
    }

    return Value(ret);
  }
}
