module orelang.operator.SeqOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;
import std.conv;

class SeqOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    long n = engine.eval(args[0]).getNumeric.to!long;
    Value[] array;

    for (long i; i < n; ++i) {
      array ~= new Value(i.to!double);
    }

    return new Value(array);
  }
}
