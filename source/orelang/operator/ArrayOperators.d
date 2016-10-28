module orelang.operator.ArrayOperators;
import orelang.expression.ImmediateValue,
       orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;
import std.algorithm,
       std.string,
       std.array,
       std.conv;

/**
 * revese given array 
 */
class ArrayReverseOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    Value[] ret;
    Value eargs0 = engine.eval(args[0]);

    if (eargs0.type == ValueType.Array) {
      foreach_reverse (elem; eargs0.getArray) {
        ret ~= elem;
      }
    } else if (eargs0.type == ValueType.ImmediateValue && eargs0.getImmediateValue.value.type == ValueType.Array) {
      foreach_reverse (elem; eargs0.getImmediateValue.value.getArray) {
        ret ~= elem;
      }
    } else {
      throw new Error("[number-to-string] Invalid argument was given.");
    }

    return new Value(ret);
  }
}

/**
 * Set a value into the order of the array
 */
class ArraySetNOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    Value[] arr;
    Value eargs0 = engine.eval(args[0]);

    if (eargs0.type == ValueType.ImmediateValue) {
      arr = eargs0.getImmediateValue.value.getArray;
    } else {
      arr = eargs0.getArray;
    }
    
    long  idx   = engine.eval(args[1]).getNumeric.to!long;
    Value value = args[2];

    if (0 < idx && idx < arr.length) {
      arr[idx] = value;

      return new Value(new ImmediateValue(new Value(arr)));
    } else {
      throw new Error("Invalid");
    }
  }
}

/**
 * Get a value from the order of the array
 */
class ArrayGetNOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    Value[] arr;
    Value eargs0 = engine.eval(args[0]);

    if (eargs0.type == ValueType.ImmediateValue) {
      arr = eargs0.getImmediateValue.value.getArray;
    } else {
      arr = eargs0.getArray;
    }
    
    long  idx   = engine.eval(args[1]).getNumeric.to!long;

    if (0 <= idx && idx < arr.length) {
      return arr[idx];
    } else {
      throw new Error("[get] Invalid");
    }
  }
}
