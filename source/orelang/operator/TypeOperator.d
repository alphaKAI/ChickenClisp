module orelang.operator.TypeOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

class TypeOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    import std.conv;
    return new Value(engine.eval(args[0]).type.to!string);
  }
}
