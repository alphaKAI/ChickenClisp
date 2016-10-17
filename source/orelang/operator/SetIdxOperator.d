module orelang.operator.SetIdxOperator;
import orelang.expression.ImmediateValue,
       orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;
import std.conv;

class SetIdxOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    Value[] arr;
    if (args[0].convertsTo!ImmediateValue) {
      arr = args[0].get!ImmediateValue.value.get!(Value[])[0].get!(Value[]);
    } else {
      arr = engine.eval(args[0]).get!(Value[]);
    }
    long  idx   = args[1].get!double.to!long;
    Value value = args[2];

    if (0 < idx && idx < arr.length) {
      arr[idx] = value;

      return Value(new ImmediateValue(Value(arr)));
    } else {
      throw new Error("Invalid");
    }
  }
}
