module orelang.operator.ConvOperators;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;
import std.algorithm,
       std.string,
       std.array,
       std.conv;

/**
 * convert value into string(number to string) 
 */
class numberToStringOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    return new Value(engine.eval(args[0]).getNumeric.to!string);
  }
}
