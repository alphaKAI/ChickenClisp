module orelang.operator.SubOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

class SubOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    Value ret = engine.eval(args[0]);
    
    if (args.length == 1) {
      ret.mulTo(new Value(-1));
    }

    foreach (arg; args[1..$]) {
      Value v = engine.eval(arg);
      ret.subTo(v);
    }

    return ret;
  }
}
