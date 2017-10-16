module orelang.operator.ForeachOperator;
import orelang.expression.ImmediateValue,
       orelang.expression.IExpression,
       orelang.operator.IOperator,
       orelang.Closure,
       orelang.Engine,
       orelang.Value;
import std.algorithm,
       std.array;

class ForeachOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    engine.sync_storage = true;
    scope(exit) engine.sync_storage = false;

    Value efunc  = engine.eval(args[0]);
    Value eargs1 = engine.eval(args[1]);

    if (eargs1.type == ValueType.Array) {
      Value[] array = eargs1.getArray;

      if (efunc.type == ValueType.Closure) {
        Value[] ret;

        foreach (elem; array) {
          ret ~= efunc.getClosure.eval([elem]);
        }

        return new Value(ret);
      } else {
        Value[] ret;

        foreach (elem; array) {
          ret ~= efunc.getIOperator.call(engine, [elem]);
        }

        return new Value(ret);
      }
    } else {
        if (!(eargs1.type == ValueType.ImmediateValue) && !(eargs1.getImmediateValue.value.type == ValueType.Array)) {
          throw new Exception("for-each requires array and function as a Operator");
        }

        Value[] array = eargs1.getImmediateValue.value.getArray;

        if (efunc.type == ValueType.Closure) {
          Value[] ret;

          foreach (elem; array) {
            ret ~= efunc.getClosure.eval([elem]);
          }

          return new Value(ret);
        } else {
          Value[] ret;

          foreach (elem; array) {
            ret ~= efunc.getIOperator.call(engine, [elem]);
          }

          return new Value(ret);
        }
      }
  }
}
