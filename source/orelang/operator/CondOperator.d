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
      Value[] state = args[i].get!(Value[]);
      Value pred = state[0];
      Value expr = state[1];

      Value epred = engine.eval(pred);

      if ((epred.peek!bool !is null && *epred.peek!bool) || pred == "else") {
        return engine.eval(expr);
      }
    }

    return Value(0L);
  }
}
