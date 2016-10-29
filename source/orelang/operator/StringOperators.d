module orelang.operator.StringOperators;
import orelang.operator.IOperator,
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
          .map!(arg => engine.eval(arg).getString)
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
    if (args[0].type == ValueType.SymbolValue) {
      return new Value(engine.eval(args[0]).getString.length.to!double);
    } else if (args[0].type == ValueType.String) {
      return new Value(args[0].getString.length.to!double);
    } else {
      throw new Error("[string-length] Invalid argument was given");
    }
  }
}
