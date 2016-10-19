module orelang.operator.LogicOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

class NotOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    return new Value(!engine.eval(args[0]).getBool);
  }
}

class AndOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    return new Value(engine.eval(args[0]).getBool && engine.eval(args[1]).getBool);
  }
}

class OrOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    return new Value(engine.eval(args[0]).getBool || engine.eval(args[1]).getBool);
  }
}
