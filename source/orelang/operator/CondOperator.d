module orelang.operator.CondOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

class CondOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    for (size_t i; i < args.length; ++i) {
      Value[] state = args[i].getArray;//!(Value[]);
      Value pred = state[0];
      Value expr = state[1];

      Value epred = engine.eval(pred);

      if ((epred.type == ValueType.Bool && epred.getBool) || ((pred.type == ValueType.SymbolValue || pred.type == ValueType.String) && pred.getString == "else")) {
        return engine.eval(expr);
      }
    }

    return new Value(0.0);
  }
}
