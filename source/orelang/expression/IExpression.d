module orelang.expression.IExpression;
import orelang.Engine,
       orelang.Value;
import std.variant;

interface IExpression {
  Value eval(Engine engine);
}
