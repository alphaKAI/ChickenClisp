module orelang.operator.LogicOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

class NotOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    return Value(!engine.eval(args[0]).get!bool);
  }
}

class AndOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    return Value(engine.eval(args[0]).get!bool && engine.eval(args[1]).get!bool);
  }
}

class OrOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    return Value(engine.eval(args[0]).get!bool || engine.eval(args[1]).get!bool);
  }
}
