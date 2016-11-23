module orelang.operator.SetOperator;
import orelang.expression.ClassType,
       orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

class SetOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    return engine.setVariable(args[0].getString, engine.eval(args[1]));
  }
}


/**
 * Set a value to the variable defined in parent scope
 */
class SetPOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    return engine.peekSuper.setVariable(args[0].getString, engine.eval(args[1]));
  }
}


/**
 * Set a value to the variable defined in class value
 */
class SetCOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    ClassType cls  = engine.eval(args[0]).getClassType;
    string varName = args[1].type == ValueType.SymbolValue ? args[1].getString : engine.eval(args[1]).getString;
    Value  value   = engine.eval(args[2]);

    return cls._engine.setVariable(varName, value);
  }
}
