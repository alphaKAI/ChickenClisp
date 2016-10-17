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
    if (!(args[0].convertsTo!(Value[]))) {
      string  name   = args[0].get!string;
      Value[] binds  = args[1].get!(Value[]);
      Value  _body   = args[2];
      Engine _engine = engine.clone();

      string[] names;
      Value[] vars;

      foreach (bind; binds) {
        string bname = bind.get!(Value[])[0].get!string;
        Value  val   = bind.get!(Value[])[1];

        names ~= bname;
        vars  ~= val;
      }

      _engine.defineVariable(name, Value(new DynamicOperator(names, _body)));
      Value ret = (_engine.getVariable(name).get!IOperator).call(_engine, vars);

//      if (ret is null) {
      if (ret.hasValue) {
        return Value(0L);
      } else {
        return ret;
      }
    } else {
      Value[] binds  = args[0].get!(Value[]);
      Value  _body   = args[1];
      Engine _engine = engine.clone();

      foreach (bind; binds) {
        string name = bind.get!(Value[])[0].get!string;
        Value  val  = engine.eval(bind.get!(Value[])[1]);

        _engine.defineVariable(name, val);
      }

      return _engine.eval(_body);
    }
  }
}
