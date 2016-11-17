module orelang.operator.ClassOperators;
import orelang.operator.DynamicOperator,
       orelang.expression.ClassType,
       orelang.operator.IOperator,
       orelang.Closure,
       orelang.Engine,
       orelang.Value;

class ClassOperator : IOperator {
  public Value call(Engine engine, Value[] args) {
    string className = engine.eval(args[0]).getString;
    Engine cEngine   = engine.clone;

    if (args.length > 1) {
      foreach (member; args[1..$]) {
        cEngine.eval(member);
      }
    }

    if ("constructor" !in cEngine.variables.called) {
      cEngine.defineVariable("constructor", new Value(cast(IOperator)(new DynamicOperator((string[]).init, new Value)))); 
    }

    ClassType clst = new ClassType(className, cEngine);
    Value cls      = new Value(clst);
    engine.defineVariable(className, cls);

    return cls;
  }
}


class NewOperator : IOperator {
  public Value call(Engine engine, Value[] args) {
    string className;
    if (args[0].type == ValueType.SymbolValue) {
      className = args[0].getString;
    } else {
      className = engine.eval(args[0]).getString;
    }

    ClassType _cls = engine.getVariable(className).getClassType;
    ClassType cls = new ClassType(_cls.className, _cls._engine.clone);

    Value[] cArgs;

    if (args.length > 0) {
      foreach (arg; args[1..$]) {
        cArgs ~= engine.eval(arg);
      }
    }

    cls._engine.variables["constructor"].getIOperator.call(cls._engine, cArgs);

    return new Value(cls);
  }
}