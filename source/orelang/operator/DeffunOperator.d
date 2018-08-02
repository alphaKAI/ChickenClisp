module orelang.operator.DeffunOperator;
import orelang.operator.DynamicOperator, orelang.operator.IOperator,
  orelang.Engine, orelang.Value;
import std.algorithm, std.array;
import kontainer.orderedAssocArray;

class DeffunOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    string funcName = args[0].getString;
    string[] funcArgs;
    OrderedAssocArray!(string, Value) optionArgs = new OrderedAssocArray!(string, Value)();

    foreach (maybeArg; args[1].getArray) {
      if (maybeArg.type == ValueType.String || maybeArg.type == ValueType.SymbolValue) {
        funcArgs ~= maybeArg.getString;
      } else if (maybeArg.type == ValueType.Array) {
        auto pair = maybeArg.getArray;
        string name = pair[0].getString;
        Value value = pair[1];
        optionArgs[name] = value;
      } else {
        throw new Error("Invalid argument list");
      }
    }

    Value funcBody = args[2];

    return engine.defineVariable(funcName,
        new Value(cast(IOperator)(new DynamicOperator(funcArgs, funcBody, optionArgs))));
  }
}
