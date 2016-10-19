module orelang.operator.LengthOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;
import std.conv;

class LengthOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    Value obj = engine.eval(args[0]);

    if (obj.type == ValueType.Array) {
      return new Value(obj.getArray.length.to!double);
    } else {
      throw new Error("Given object is not an Array or List");
    }
  }
}
