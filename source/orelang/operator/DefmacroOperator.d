module orelang.operator.DefmacroOperator;
import orelang.operator.DynamicOperator,
       orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;
import std.algorithm,
       std.array;

class DefmacroOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    string   macro_name = args[0].getString;
    string[] macro_args = args[1].getArray.map!(value => value.getString).array;
    Value    _body      = args[2];

    import orelang.expression.Macro;
    auto mcr = new Macro(macro_name, macro_args, _body);
    Value vmcr = new Value(mcr);

    engine.defineVariable(macro_name, vmcr);

    return vmcr;
  }
}
