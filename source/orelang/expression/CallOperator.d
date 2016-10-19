module orelang.expression.CallOperator;
import orelang.expression.IExpression,
       orelang.operator.IOperator,
       orelang.Closure,
       orelang.Engine,
       orelang.Value;

class CallOperator : IExpression {
  private {
    IOperator operator;
    Value[] args;
  }

  this(IOperator operator, Value[] args) {
    this.operator = operator;
    this.args     = args;
  }

  /**
   * eval
   */
  public Value eval(Engine engine) {
    Closure closure = engine.eval(new Value(this.operator)).getClosure;

    return closure.eval(this.args);
  }
}
