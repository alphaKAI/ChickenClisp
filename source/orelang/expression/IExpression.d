module orelang.expression.IExpression;
import orelang.Engine,
       orelang.Value;

interface IExpression {
  Value eval(Engine engine);
}
