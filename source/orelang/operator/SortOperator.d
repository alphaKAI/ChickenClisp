module orelang.operator.SortOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;
import std.algorithm,
       std.array;

class SortOperator : IOperator {
  public Value call(Engine engine, Value[] args) {
    Value eargs0 = engine.eval(args[0]);
    Value[] array,
            ret;

    if (eargs0.type == ValueType.Array) {
      array = eargs0.getArray;
    } else if (eargs0.type == ValueType.ImmediateValue && eargs0.getImmediateValue.value.type == ValueType.Array) {
      array = eargs0.getImmediateValue.value.getArray;
    } else {
      throw new Error("[SortOperator] Invaild argument was given. SortOperator accepts list or array only.");
    }

    switch (array[0].type) with (ValueType) {
      case Numeric:
        double[] tmp = array.map!(value => value.getNumeric).array;
        std.algorithm.sort(tmp);

        foreach (t; tmp) {
          ret ~= new Value(t);
        }
        break;
      case String:
        string[] tmp = array.map!(value => value.getString).array;
        std.algorithm.sort(tmp);

        foreach (t; tmp) {
          ret ~= new Value(t);
        }
        break;
      default:
        throw new Error("[SortOperator] Can't sort given array, all element of the array must be typed Numeric or String and the types are unified");
    }

    return new Value(ret);
  }
}