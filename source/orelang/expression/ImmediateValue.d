module orelang.expression.ImmediateValue;
import orelang.expression.IExpression,
       orelang.Engine,
       orelang.Value;
import std.string,
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
    string base = "ImmediateValue {";
    string _body;

    if (value.type == ValueType.Array) {
      string[] elems;

      foreach (elem; value.getArray) {
        elems ~= elem.toString;
      }

      _body = "[" ~ elems.join(", ") ~ "]"; 
    } else {
      _body = value.toString;
    }

    return base ~ _body ~ "}";
  }
}
