module orelang.operator.IOperator;
import orelang.Engine,
       orelang.Value;

interface IOperator {
  Value call(Engine engine, Value[] args);
}
