module orelang.operator.ConsOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

class ConsOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    import std.stdio;
    writeln("[ConsOperator]");
    writeln("args -> ", args);
    Value car = engine.eval(args[0]);
    Value cdr = engine.eval(args[1]);

    writeln("car -> ", car);
    writeln("cdr -> ", cdr);
    writeln("[car, cdr... -> ", [car, cdr]);

    Value[] ret = [car];

    if (cdr.type == ValueType.Array) {
      foreach (elem; cdr.getArray) {
        ret ~= engine.eval(elem);
      }
    } else {
      ret ~= cdr;
    }

    auto r = new Value(ret);
    writeln("r -> ", r);
    writeln("r.type -> ", r.type);
    return r;
  }
}
