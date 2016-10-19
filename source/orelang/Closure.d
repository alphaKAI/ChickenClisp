module orelang.Closure;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

class Closure {
  public {
    Engine    engine;
    IOperator operator;
  }

  this (Engine engine, IOperator operator) {
    this.engine   = engine;
    this.operator = operator;
  }

  Value eval(Value[] args) {
    return this.operator.call(this.engine, args);
  }
}
