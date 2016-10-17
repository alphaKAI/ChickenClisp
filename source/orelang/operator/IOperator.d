module orelang.operator.IOperator;
import orelang.Engine,
       orelang.Value;
import std.variant;

interface IOperator {
  Value call(Engine engine, Value[] args);
}
