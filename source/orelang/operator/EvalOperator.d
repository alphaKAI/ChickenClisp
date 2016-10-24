module orelang.operator.EvalOperator;
import orelang.operator.IOperator,
       orelang.Transpiler,
       orelang.Engine,
       orelang.Value;

class EvalOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    string code = args[0].getString;

    return engine.eval(Transpiler.transpile(code));
  }
}
