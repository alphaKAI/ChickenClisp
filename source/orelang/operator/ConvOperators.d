module orelang.operator.ConvOperators;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;
import std.algorithm,
       std.string,
       std.array,
       std.conv;

/**
 * convert number into string 
 */
class numberToStringOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    return new Value(engine.eval(args[0]).getNumeric.to!string);
  }
}

/**
 * convert char into number 
 */
class charToNumberOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    return new Value(engine.eval(args[0]).getString[0].to!double);
  }
}

/**
 * convert float into integer 
 */
class floatToIntegerOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    return new Value(engine.eval(args[0]).getNumeric.to!long.to!double);
  }
}

/**
 * convert ubytes into string 
 */
class ubytesToStringOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    Value[] array = engine.eval(args[0]).getArray;
    ubyte[] ubytes;

    foreach (elem; array) {
      ubytes ~= elem.getUbyte;
    }

    return new Value(cast(string)ubytes);
  }
}

/**
 * convert ubytes into string 
 */
class ubytesToIntegersOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    Value[] array = engine.eval(args[0]).getArray;
    Value[] ret;


    foreach (elem; array) {
      ret ~= new Value(elem.getUbyte.to!double);
    }

    return new Value(ret);
  }
}