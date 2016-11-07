module orelang.operator.StringOperators;
import orelang.expression.ImmediateValue,
       orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;
import std.algorithm,
       std.string,
       std.array;

/**
 * This module provides operators with string.
 * Current provided operators:
 *  - string-concat
 *  - string-join
 *  - string-split
 *  - string-length
 *  - string-slice
 *  - as-string
 *  - string-repeat
 */

/**
 * concat strings into a string 
 */
class StringConcatOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    if (args[0].type == ValueType.Array && args.length == 1) {
      return new Value(
        engine.eval(args[0]).getArray
          .map!(arg => (arg.type == ValueType.SymbolValue ? engine.eval(arg) : arg).getString)
          .join
        );
    } else if (args[0].type == ValueType.ImmediateValue && args[0].getImmediateValue.value.type == ValueType.Array && args.length == 1) {
      return new Value(
        args[0].getImmediateValue.value.getArray
          .map!(arg => (arg.type == ValueType.SymbolValue ? engine.eval(arg) : arg).getString)
          .join
        );
    } else {
      return new Value(
        args
          .map!(arg => engine.eval(arg).getString)
          .join
      );
    }
  }
}

/**
 * join strings into a string with a separator
 */
class StringJoinOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    if (args[0].type == ValueType.Array && args.length >= 1) {
      return new Value(
        engine.eval(args[0]).getArray
          .map!(arg => engine.eval(arg).getString)
          .join(args.length == 1 ? "" : engine.eval(args[1]).getString)
        );
    } else if (args[0].type == ValueType.ImmediateValue && args[0].getImmediateValue.value.type == ValueType.Array && args.length >= 1) {
      return new Value(
        args[0].getImmediateValue.value.getArray
          .map!(arg => (arg.type == ValueType.SymbolValue ? engine.eval(arg) : arg).getString)
          .join(args.length == 1 ? "" : engine.eval(args[1]).getString)
        );
    } else {
      return new Value(
        args[0..$-1]
          .map!(arg => engine.eval(arg).getString)
          .join(engine.eval(args[$-1]).getString)
      );
    }
  }
}

/**
 * split a string into strings with a separator
 */ 
class StringSplitOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    Value[] rets;
    
    foreach (value; engine.eval(args[0]).getString.split(args.length == 1 ? "" : engine.eval(args[1]).getString)) {
      rets ~= new Value(value);
    }

    return new Value(rets);
  }
}

/**
 * return a length of the string
 */ 
class StringLengthOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    import std.conv;
    
    if (args[0].type == ValueType.String) {
      return new Value(args[0].getString.length.to!double);
    } else {
      Value eargs0 = engine.eval(args[0]);

      if (eargs0.type == ValueType.String) {
        return new Value(eargs0.getString.length.to!double);
      } else {
        throw new Error("[string-length] Invalid argument was given");
      }
    }
  }
}

/**
 * Tak a slice from the range of the string
 */
class StringSliceOperator : IOperator {
  /**
   * call
   */
  import std.conv;
  public Value call(Engine engine, Value[] args) {
    string str;
    Value eargs0 = engine.eval(args[0]);
    str = eargs0.getString;
    
    long slice1  = engine.eval(args[1]).getNumeric.to!long,
         slice2  = engine.eval(args[2]).getNumeric.to!long;

    if ((0 <= slice1 && 0 <= slice2) && (slice1 <= str.length && slice2 <= str.length)) {
      return new Value(str[slice1..slice2]);
    } else {
      throw new Error("[string-slice] Invalid");
    }
  }
}

class AsStringOperator : IOperator {
  /**
   * call
   */
  import std.conv;
  public Value call(Engine engine, Value[] args) {
    return new Value(new ImmediateValue(new Value((args[0].type == ValueType.SymbolValue ? engine.eval(args[0]) : args[0]).toString)));
  }
}

class StringRepeatOperator : IOperator {
  /**
   * call
   */
  import std.algorithm,
         std.string,
         std.array,
         std.range,
         std.conv;
  public Value call(Engine engine, Value[] args) {
    string pattern;
    long n;

    if (args[0].type == ValueType.SymbolValue) {
      pattern = engine.eval(args[0]).getString;
    } else if (args[0].type == ValueType.String) {
      pattern = args[0].getString;
    } 

    if (args[1].type == ValueType.Numeric) {
      n = args[1].getNumeric.to!long;
    } else {
      n = engine.eval(args[1]).getNumeric.to!long;
    }

    return new Value(n.iota.map!(i => pattern).array.join);
  }
}
