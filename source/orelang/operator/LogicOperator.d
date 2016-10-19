module orelang.operator.LogicOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;
import std.algorithm;

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
    return new Value(args.all!(arg => engine.eval(arg).getBool));
  }
}

class OrOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    return new Value(args.any!(arg => engine.eval(arg).getBool));
  }
}
