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
    Value[] eargs1 = engine.eval(args[1]).getArray;
    Value[] ret;

    foreach (elem; eargs1) {
      bool cnd;

      if (efunc.type == ValueType.Closure) {
        cnd = efunc.getClosure.eval([elem]).getBool;
      } else {
        cnd = efunc.getIOperator.call(engine, [elem]).getBool;
      }

      if (!cnd) {
        ret ~= elem;
      }
    }

    return new Value(ret);
  }
}
