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
    if (args[0].type == ValueType.ImmediateValue) {
      arr = args[0].getImmediateValue.value.getArray;
    } else {
      arr = engine.eval(args[0]).getArray;
    }
    long  idx   = args[1].getNumeric.to!long;
    Value value = args[2];

    if (0 < idx && idx < arr.length) {
      arr[idx] = value;

      return new Value(arr);
    } else {
      throw new Error("Invalid");
    }
  }
}
