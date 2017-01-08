module orelang.expression.Macro;
import orelang.expression.IExpression,
       orelang.Engine,
       orelang.Value;
import std.string,
       std.conv;

class Macro {
  string   macro_name;
  string[] macro_args;
  Value    macro_body;

  this(string name, string[] args, Value _body) {
    this.macro_name = name;
    this.macro_args = args;
    this.macro_body = _body;
  }

  public Value call(Engine engine, Value[] args) {
    import std.stdio;

    Value[string] convList;

    foreach (idx, arg; macro_args) {
      convList[arg] = args[idx];
    }

    Value[] analysis(Value source) {
      Value[] dist;

      if (source.type == ValueType.Array) {
        foreach (elem; source.getArray) {
          if (elem.type == ValueType.Array) {
            dist ~= new Value(analysis(elem));
          } else {
            if (elem.type == ValueType.SymbolValue) {
              if (elem.getString in convList) {
                elem = convList[elem.getString];
              }
            }

            dist ~= elem;
          }
        }
      } else {
        dist ~= source;
      }

      return dist;
    }

    return engine.eval(new Value(analysis(this.macro_body)));
  }

  override string toString() {
    return "Macro";
  }
}
