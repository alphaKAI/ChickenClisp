module orelang.operator.StdioOperators;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;
import std.stdio,
       std.conv;

class ReadlnOperator : IOperator {
  public Value call(Engine engine, Value[] args) {
    return new Value(stdin.readln);
  }
}

class StdinByLINEOperator : IOperator {
  public Value call(Engine engine, Value[] args) {
    Value[] ret;

    foreach (line; stdin.byLine) {
      ret ~= new Value(line.to!string);
    }

    return new Value(ret);
  }
}