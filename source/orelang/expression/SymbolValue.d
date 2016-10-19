module orelang.expression.SymbolValue;
import orelang.expression.IExpression,
       orelang.Engine,
       orelang.Value;
import std.string,
       std.conv;

class SymbolValue : IExpression {
  string value;

  this(string value) {
    this.value = value;
  }

  public Value eval(Engine engine) {
    return new Value(this.value);
  }

  override string toString() {
    return "SymbolValue(" ~ this.value ~ ")";
  }
}
