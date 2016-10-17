module orelang.operator.AliasOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

class AliasOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    string _new = args[0].get!string;
    string base = args[1].get!string;

    if (base in engine.variables) {
      Value v = engine.variables[base];

      engine.variables[_new] = v;

      return v;
    } else {
      throw new Error("No such variable or operator - " ~ base);
    }
  }
}
