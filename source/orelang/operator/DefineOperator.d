module orelang.operator.DefineOperator;
import orelang.operator.DynamicOperator,
       orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;
import std.algorithm,
       std.array;

class DefineOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    if (args[0].type == ValueType.SymbolValue) {// variable
      string varName = args[0].getString;
      Value  var     = args[1];

      engine.defineVariable(varName, var);

      return var;
    }  else if (args[0].type == ValueType.Array) {// function
      Value[] funcSignatures = args[0].getArray;
      string funcName = funcSignatures[0].getString;
      string[] funcArgs = funcSignatures[1..$].map!(value => value.getString).array;
      Value funcBody    = args[1];

      return engine.defineVariable(funcName, new Value(cast(IOperator)(new DynamicOperator(funcArgs, funcBody))));
    } else {
      throw new Error("Invalid");
    }
  }
}
