module orelang.operator.MapOperator;
import orelang.expression.ImmediateValue,
       orelang.expression.IExpression,
       orelang.operator.IOperator,
       orelang.Closure,
       orelang.Engine,
       orelang.Value;
import std.algorithm,
       std.array;

class MapOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    Value efunc  = engine.eval(args[0]);
    Value eargs1 = engine.eval(args[1]);

    if (eargs1.convertsTo!(Value[])) {
      Value[] array = eargs1.get!(Value[]);

      if (efunc.convertsTo!Closure) {
        return Value(array.map!(elem => efunc.get!Closure.eval([Value(elem)])).array);
      } else {
        return Value(array.map!(elem => efunc.get!IOperator.call(engine, [Value(elem)])).array);
      }
    } else {
        if (!(eargs1.convertsTo!ImmediateValue) && !((*eargs1.peek!ImmediateValue).value.convertsTo!(Value[]))) {
          throw new Error("map requires array and function as a Operator");
        }

        Value[] array = *((*(*eargs1.peek!ImmediateValue).value.peek!(Value[]))[0]).peek!(Value[]);

        if (efunc.convertsTo!Closure) {
          return Value(array.map!(elem => efunc.get!Closure.eval([Value(elem)])).array);
        } else {
          return Value(array.map!(elem => efunc.get!IOperator.call(engine, [Value(elem)])).array);
        }
      }
  }
}
