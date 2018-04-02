module orelang.operator.DynamicOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;
import kontainer.orderedAssocArray;
/**
 * Dynamic Operator
 */

class DynamicOperator : IOperator {
  private {
    string[] funcArgs;
    Value    funcBody;
    OrderedAssocArray!(string, Value) opArgs;
  }

  this (string[] funcArgs, Value funcBody) {
    this.funcArgs = funcArgs;
    this.funcBody = funcBody;
    this.opArgs = new OrderedAssocArray!(string, Value);
  }

  this (string[] funcArgs, Value funcBody, OrderedAssocArray!(string, Value) opArgs) {
    this.funcArgs = funcArgs;
    this.funcBody = funcBody;
    this.opArgs   = opArgs;
  }

  public Value call(Engine engine, Value[] args) {
    size_t i = 0;
    Engine _engine = engine.clone;

    size_t allFuncArgs = this.opArgs.length + this.funcArgs.length;

    if (this.funcArgs.length < args.length && args.length <= allFuncArgs) {
      size_t j;
      size_t orders = args.length - this.funcArgs.length;
      foreach (arg; this.opArgs) {
        if (j < orders) {
          _engine.defineVariable(arg.key, engine.eval(args[i++]));
        } else {
          _engine.defineVariable(arg.key, engine.eval(arg.value));
        }
        j++;
      }
    } else {
      foreach (arg; this.opArgs) {
        _engine.defineVariable(arg.key, engine.eval(arg.value));
      }
    }

    foreach (arg; this.funcArgs) {
      if (arg[0] == '&') {
        Value[] arr;
        
        arr = args[i..$];

        _engine.defineVariable(arg[1..$], new Value(arr));
        break;
      } else {
        _engine.defineVariable(arg, engine.eval(args[i++]));
      }
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
