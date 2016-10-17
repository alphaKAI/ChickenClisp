module orelang.operator.LambdaOperator;
import orelang.operator.DynamicOperator,
       orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;
import std.algorithm,
       std.array;

class LambdaOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    string[] funcArgs = args[0].get!(Value[]).map!(value => value.get!string).array;
    Value funcBody = args[1];

    return Value(new DynamicOperator(funcArgs, funcBody));
  }
}
