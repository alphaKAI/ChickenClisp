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
class NumberToStringOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    return new Value(engine.eval(args[0]).getNumeric.to!string);
  }
}

/**
 * convert string into number
 */
class StringToNumberOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    return new Value(engine.eval(args[0]).getString.to!ulong);
  }
}


/**
 * convert number into char
 */
class NumberToCharOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    return new Value(engine.eval(args[0]).getNumeric.to!char.to!string);
  }
}

/**
 * convert char into number 
 */
class CharToNumberOperator : IOperator {
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
class FloatToIntegerOperator : IOperator {
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
class UbytesToStringOperator : IOperator {
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
class UbytesToIntegersOperator : IOperator {
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