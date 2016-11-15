module orelang.expression.ClassType;
import orelang.Engine,
       orelang.Value;

class ClassType {
  string className;
  Engine _engine;

  this(string className, Engine _engine) {
    this.className = className;
    this._engine   = _engine;
  }

  public Value call(Engine engine, Value[] args) {
    string funcName;
    if (args[0].type == ValueType.SymbolValue) {
      funcName = args[0].getString;
    } else {
      funcName = engine.eval(args[0]).getString;
    }

    Value member = this._engine.variables[funcName];

    if (member.type == ValueType.IOperator) {
      return member.getIOperator.call(this._engine, args.length > 1 ? args[1..$] : (Value[]).init);
    } else {
      return member;
    }
  }
}
