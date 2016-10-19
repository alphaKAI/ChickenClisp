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

      if (arg.type == ValueType.String || (arg.type == ValueType.SymbolValue && (item.type == ValueType.IExpression || item.type == ValueType.ImmediateValue || item.type == ValueType.IOperator))) {
        item = arg;
      }

      if (item.type == ValueType.Array) {
        write("(");
        write(item.getArray.map!(e => e.toString).join(" "));
        write(")");
      } else {
        write(item.toString());
      }
    }

    return new Value(0.0);
  }
}

class PrintlnOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    foreach (arg; args) {
      Value item = engine.eval(arg);

      if (arg.type == ValueType.String || (arg.type == ValueType.SymbolValue && (item.type == ValueType.IExpression || item.type == ValueType.ImmediateValue || item.type == ValueType.IOperator))) {
        item = arg;
      }

      if (item.type == ValueType.Array) {
        write("(");
        write(item.getArray.map!(e => e.toString).join(" "));
        write(")");
      } else {
        write(item.toString());
      }
    }

    writeln;

    return new Value(0.0);
  }
}
