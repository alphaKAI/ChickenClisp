module orelang.operator.RemoveOperator;
import orelang.expression.ImmediateValue,
       orelang.expression.IExpression,
       orelang.operator.IOperator,
       orelang.Closure,
       orelang.Engine,
       orelang.Value;
import std.algorithm,
       std.array;

class RemoveOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    Value efunc = engine.eval(args[0]);
    Value[] eargs1 = engine.eval(args[1]).get!(Value[]);
    Value[] ret;

    foreach (elem; eargs1) {
      bool cnd;

      if (efunc.convertsTo!Closure) {
        cnd = (efunc.get!Closure).eval([elem]).get!bool;
      } else {
        cnd = (efunc.get!IOperator).call(engine, [elem]).get!bool;
      }

      if (!cnd) {
        ret ~= elem;
      }
    }

    return Value(ret);
  }
}
