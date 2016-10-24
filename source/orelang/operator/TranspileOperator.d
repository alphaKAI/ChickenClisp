module orelang.operator.TranspileOperator;
import orelang.operator.IOperator,
       orelang.Transpiler,
       orelang.Engine,
       orelang.Value;

class TranspileOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    string code = args[0].getString;

    return Transpiler.transpile(code);
  }
}
