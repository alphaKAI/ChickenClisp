module orelang.operator.DatetimeOperators;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;
import std.datetime,
       std.conv;

class GetCurrentUNIXTime : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    return new Value(Clock.currTime.toUnixTime.to!string);
  }
}