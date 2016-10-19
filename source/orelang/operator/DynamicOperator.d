module orelang.operator.DynamicOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

/**
 * Dynamic Operator
 */

class DynamicOperator : IOperator {
  private {
    string[] funcArgs;
    Value    funcBody;
  }

  this (string[] funcArgs, Value funcBody) {
    this.funcArgs = funcArgs;
    this.funcBody = funcBody;
  }

  public Value call(Engine engine, Value[] args) {
    size_t i = 0;
    Engine _engine = engine.clone;

    foreach (arg; this.funcArgs) {
      _engine.defineVariable(arg, engine.eval(args[i++]));
    }

    return _engine.eval(this.funcBody);
  }

  override string toString() {
    string base = "orelang.operator.DynamicOperator.DynamicOperator {";
    import std.string;
    string _body = "[funcArgs : [" ~ funcArgs.join(", ") ~ "], " ~ "funcBody : " ~ funcBody.toString ~ "]";

    return base ~ _body ~ "}";
  }
}
