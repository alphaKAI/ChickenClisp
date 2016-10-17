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

  if (eargs.convertsTo!(Value[])) {
    Value[] array = eargs.get!(Value[]);
    Value efunc = engine.eval(Value(func));

    if (efunc.convertsTo!Closure) {
      foreach (elem; array) {
        tmp = efunc.get!Closure.eval([tmp, elem]);
      }
    } else if (efunc.convertsTo!IOperator) {
      foreach (elem; array) {
        tmp = efunc.get!IOperator.call(engine, [tmp, elem]);
      }
    }

    return tmp;
  } else {
      if (!(eargs.convertsTo!ImmediateValue) && !(eargs.get!ImmediateValue.value.convertsTo!(Value[]))) {
        throw new Error("Fold requires array and function as a Operator");
      }

      Value[] array = eargs.get!ImmediateValue.value.get!(Value[]);
      Value efunc = engine.eval(Value(func));

      if (efunc.convertsTo!Closure) {
        foreach (elem; array) {
          tmp = efunc.get!Closure.eval([tmp, elem]);
        }
      } else {
              foreach (elem; array) {
        tmp = efunc.get!IOperator.call(engine, [tmp, elem]);
      }
      }

      return tmp;
    }
  }
}
