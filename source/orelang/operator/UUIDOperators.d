module orelang.operator.UUIDOperators;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;
import std.conv,
       std.uuid : randomUUID;

class RandomUUIDOperator : IOperator {
  /**
   * call
   */

   Value call(Engine engine, Value[] args) {
     return new Value(randomUUID.to!string);
   }
}