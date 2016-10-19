module orelang.operator.EqualOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

class EqualOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    return new Value(engine.eval(args[0]) == engine.eval(args[1]));
  }
}

class NotEqualOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    return new Value(engine.eval(args[0]) != engine.eval(args[1]));
  }
}

class LessOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    return new Value(engine.eval(args[0]) < engine.eval(args[1]));
  }
}

class GreatOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    return new Value(engine.eval(args[0]) > engine.eval(args[1]));
  }
}

class LEqOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    return new Value(engine.eval(args[0]) <= engine.eval(args[1]));
  }
}

class GEqOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    return new Value(engine.eval(args[0]) >= engine.eval(args[1]));
  }
}
