module orelang.operator.FoldOperator;
import orelang.expression.ImmediateValue,
       orelang.expression.IExpression,
       orelang.operator.IOperator,
       orelang.Closure,
       orelang.Engine,
       orelang.Value;
import std.algorithm,
       std.array;

class FoldOperator : IOperator {
  public Value call(Engine engine, Value[] args) {
    Value func  = args[0];
    Value tmp   = args[1];
    Value eargs = engine.eval(args[2]);

  //if (eargs.convertsTo!(Value[])) {
  if (eargs.type == ValueType.Array) {
    Value[] array = eargs.getArray;
    Value efunc = engine.eval(func);

    if (efunc.type == ValueType.Closure) {
      foreach (elem; array) {
        tmp = efunc.getClosure.eval([tmp, elem]);
      }
    } else if (efunc.type == ValueType.IOperator) {
      foreach (elem; array) {
        tmp = efunc.getIOperator.call(engine, [tmp, elem]);
      }
    }

    return tmp;
  } else {
      if (!(eargs.type == ValueType.ImmediateValue) && !(eargs.getImmediateValue.value.type == ValueType.Array)) {
        throw new Error("Fold requires array and function as a Operator");
      }

      Value[] array = eargs.getImmediateValue.value.getArray;
      Value efunc = engine.eval(func);

      if (efunc.type == ValueType.Closure) {
        foreach (elem; array) {
          tmp = efunc.getClosure.eval([tmp, elem]);
        }
      } else {
              foreach (elem; array) {
        tmp = efunc.getIOperator.call(engine, [tmp, elem]);
      }
      }

      return tmp;
    }
  }
}
