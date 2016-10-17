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
    long n = engine.eval(args[0]).get!double.to!long;
    Value[] array = new Value[n];

    for (long i; i < n; ++i) {
      array[i] = i;
    }

    return Value(array);
  }
}
