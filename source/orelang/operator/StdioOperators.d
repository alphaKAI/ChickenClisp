module orelang.operator.StdioOperators;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;
import std.stdio;

class ReadlnOperator : IOperator {
  public Value call(Engine engine, Value[] args) {
    return new Value(stdin.readln);
  }
}