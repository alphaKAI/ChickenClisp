module orelang.operator.AssertOperator;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

class AssertOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    Value evaled = engine.eval(args[0]);
    bool flag;

    switch (evaled.type) with (ValueType) {
      case Bool:
        flag = evaled.getBool;
        break;
      case Numeric:
        flag = cast(bool)evaled.getNumeric;
        break;
      default:
        flag = true;
        break;
    }

    if (!flag) {
      throw new Exception("Assertion failed: " ~ args[0].toString);
    }

    return new Value(true);
  }
}
