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
    Value value = engine.eval(args[2]);

    if (0 <= idx && idx < arr.length) {
      arr[idx] = value;

      return new Value(arr);
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

/**
 * Append a value from the order of the array
 */
class ArrayAppendOperator : IOperator {
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
    
    foreach (arg; args[1..$]) {
      arr ~= engine.eval(arg);
    }

    return new Value(arr);
  }
}

/**
 * Tak a slice from the range of the array
 */
class ArraySliceOperator : IOperator {
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
    
    long slice1  = engine.eval(args[1]).getNumeric.to!long,
         slice2  = engine.eval(args[2]).getNumeric.to!long;

    if ((0 <= slice1 && 0 <= slice2) && (slice1 <= arr.length && slice2 <= arr.length)) {
      return new Value(arr[slice1..slice2]);
    } else {
      throw new Error("[get] Invalid");
    }
  }
}

/**
 * concat arrays
 */
class ArrayConcatOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    Value[] arr;

    foreach (arg; args) {
      Value earg = engine.eval(arg);
      Value[] tarr;

      if (earg.type == ValueType.ImmediateValue) {
        tarr = earg.getImmediateValue.value.getArray;
      } else {
        tarr = earg.getArray;
      }

      foreach (t; tarr) {
        arr ~= t;
      }
    }

    return new Value(arr);
  }
}

/**
 * return the length of the array
 */
class ArrayLengthOperator : IOperator {
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

    return new Value(arr.length.to!double);
  }
}

/**
 * make a new array 
 */
class ArrayNewOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    Value[] ret;

    foreach (arg; args) {
      ret ~= engine.eval(arg);
    }

    return new Value(ret);
  }
}

/**
 * return flattend array of the given array 
 */
class ArrayFlattenOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    Value[] ret;

    foreach (arg; args) {
      if (arg.type == ValueType.Array) {
        foreach (elem; engine.eval(arg).getArray) {
          foreach (ee; elem.getArray) {
            ret ~= ee;
          }
        }
      } else {
        Value earg = engine.eval(arg);
        import std.stdio; writeln("EARG!!!!!!!");
        ret ~= earg;
      }
    }

    return new Value(ret);
  }
}
