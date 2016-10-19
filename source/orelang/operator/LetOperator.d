module orelang.operator.LetOperator;
import orelang.expression.ImmediateValue,
       orelang.operator.DynamicOperator,
       orelang.expression.IExpression,
       orelang.operator.IOperator,
       orelang.Closure,
       orelang.Engine,
       orelang.Value;
import std.algorithm,
       std.array;

class LetOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    if (!(args[0].type == ValueType.Array)) {
      string  name   = args[0].getString;
      Value[] binds  = args[1].getArray;
      Value  _body   = args[2];
      Engine _engine = engine.clone();

      string[] names;
      Value[] vars;

      foreach (bind; binds) {
        string bname = bind.getArray[0].getString;
        Value  val   = bind.getArray[1];

        names ~= bname;
        vars  ~= val;
      }

      _engine.defineVariable(name, new Value(new DynamicOperator(names, _body)));
      Value ret = (_engine.getVariable(name).getIOperator).call(_engine, vars);

      if (ret.type == ValueType.Null) {
        return new Value(0.0);
      } else {
        return ret;
      }
    } else {
      Value[] binds  = args[0].getArray;
      Value  _body   = args[1];
      Engine _engine = engine.clone();

      foreach (bind; binds) {
        string name = bind.getArray[0].getString;
        Value  val  = engine.eval(bind.getArray[1]);

        _engine.defineVariable(name, val);
      }

      return _engine.eval(_body);
    }
  }
}
