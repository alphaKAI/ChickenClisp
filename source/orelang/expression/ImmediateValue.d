module orelang.expression.ImmediateValue;
import orelang.expression.IExpression,
       orelang.Engine,
       orelang.Value;
import std.variant,
       std.string,
       std.conv;

class ImmediateValue : IExpression {
  Value value;

  this(Value value) {
    this.value = value;
  }

  public Value eval(Engine engine) {
    return this.value;
  }

  override string toString() {
    string base = "orelang.expression.ImmediateValue.ImmediateValue {";
    string _body;

    if (value.convertsTo!(Value[])) {
      string[] elems;

      foreach (elem; value.get!(Value[])) {
        elems ~= elem.to!string;
      }

      _body = "[" ~ elems.join(", ") ~ "]"; 
    } else {
      _body = value.to!string;
    }

    return base ~ _body ~ "}";
  }
}
