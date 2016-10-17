module orelang.operator.CdrOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

class CdrOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    Value obj = engine.eval(args[0]);

    if (obj.convertsTo!(Value[])) {
      Value[] obx = obj.get!(Value[])[0].get!(Value[]);

      if (obx.length == 1) {
        typeof(obx[0])[] arr;
        return Value(arr);
      } else if (obx.length > 1) {
        return Value(obx[1..$]);
      } else {
        throw new Error("pair required, but got ()");
      }
    } else {
      throw new Error("pair required, but got invalid data, the type of which is " ~ obj.type.toString);
    }
  }
}
