module orelang.operator.LengthOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

export class LengthOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    Value obj = engine.eval(args[0]);

    if (obj.convertsTo!(Value[])) {
      import std.stdio;
      if (obj[0].convertsTo!(Value[])) {
        return Value(obj.get!(Value[])[0].length);
      } else {
        return Value(obj.get!(Value[]).length);
      }
    } else {
      throw new Error("Given object is not an Array or List");
    }
  }
}
