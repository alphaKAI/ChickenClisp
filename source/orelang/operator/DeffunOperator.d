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
    string funcName   = *args[0].peek!string;
    string[] funcArgs = (*args[1].peek!(Value[])).map!(value => *value.peek!string).array;
    Value funcBody    = args[2];

    return engine.defineVariable(funcName, Value(cast(IOperator)(new DynamicOperator(funcArgs, funcBody))));
  }
}
