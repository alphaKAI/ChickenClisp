module orelang.operator.CarOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;
import std.conv;

class CarOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    Value obj = engine.eval(args[0]);

    if (obj.type == ValueType.Array) {
      Value[] obx = obj.getArray;

      if (obx.length >= 1) {
        return obx[0];
      } else {
        throw new Error("pair required, but got ()");
      }
    } else {
      throw new Error("pair required, but got invalid data, the type of which is " ~ obj.type.to!string);
    }
  }
}
