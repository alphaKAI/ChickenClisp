module orelang.operator.SystemOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

import std.process,
       std.string;

class SystemOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    string[] args_strs;
    
    foreach (arg; args) {
      args_strs ~= engine.eval(arg).toString;
    }

    try {
      auto pid = spawnProcess(args_strs);//execute(args_strs.join(" "));

      return new Value(wait(pid));
    } catch (Throwable) {
      return new Value(-1);
    }
  }
}
