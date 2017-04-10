module orelang.operator.RandomOperators;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;
import std.random,
       std.conv;

class RandomUniformOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    long fst = engine.eval(args[0]).getNumeric.to!long,
         snd = engine.eval(args[1]).getNumeric.to!long;

    long ret = uniform(fst, snd);

    return new Value(ret);
  }
}
