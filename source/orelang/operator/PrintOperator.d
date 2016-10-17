module orelang.operator.PrintOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;
import std.algorithm,
       std.range,
       std.stdio,
       std.conv;

class PrintOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    foreach (arg; args) {
      Value item = engine.eval(arg);

      if (item.convertsTo!IOperator) {
        item = arg;
      }

      if (item.convertsTo!(Value[])) {
        write("(");
        write((*item.peek!(Value[])).map!(e => e.to!string).join(" "));
        write(")");
      } else {
        write(item.toString());
      }
    }

    return Value(0L);
  }
}

export class PrintlnOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    foreach (arg; args) {
      Value item = engine.eval(arg);

      if (item.convertsTo!IOperator) {
        item = arg;
      }

      if (item.convertsTo!(Value[])) {
        write("(");
        write((*item.peek!(Value[])).map!(e => e.to!string).join(" "));
        write(")");
      } else {
        write(item.toString());
      }
    }

    writeln;

    return Value(0L);
  }
}
