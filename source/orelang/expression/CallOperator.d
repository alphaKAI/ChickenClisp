module orelang.expression.CallOperator;
import orelang.expression.IExpression,
       orelang.operator.IOperator,
       orelang.Closure,
       orelang.Engine,
       orelang.Value;
import std.variant;

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
    Closure closure = engine.eval(Value(this.operator)).get!Closure;
    return closure.eval(this.args);
  }
}
