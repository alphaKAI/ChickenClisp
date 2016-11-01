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
 * convert string into number 
 */
class stringToNumberOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    return new Value(engine.eval(args[0]).getString.to!double);
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
