module orelang.operator.DeffunOperator;
import orelang.operator.DynamicOperator,
       orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;
import std.algorithm,
       std.array;

class DeffunOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    string funcName   = args[0].getString;
    string[] funcArgs = args[1].getArray.map!(value => value.getString).array;
    Value funcBody    = args[2];

    return engine.defineVariable(funcName, new Value(cast(IOperator)(new DynamicOperator(funcArgs, funcBody))));
  }
}
