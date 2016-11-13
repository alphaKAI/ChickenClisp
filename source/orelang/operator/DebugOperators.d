module orelang.operator.DebugOperators;
import orelang.operator.DynamicOperator,
       orelang.expression.SymbolValue,
       orelang.operator.IOperator,
       orelang.Closure,
       orelang.Engine,
       orelang.Value;
import std.stdio;

class DumpVaribalesOperator : IOperator {
  public Value call(Engine engine, Value[] args) {
    auto storage = engine.variables;

    writeln("[DEBUG - DumpVaribalesOperator]");
    foreach (key, value; storage) {
      writeln("[Varibale] ", key, " <=> ", value);
    }

    return new Value;
  }
}

class PeekClosureOperator : IOperator {
  public Value call(Engine engine, Value[] args) {
    Closure cls = engine.eval(args[0]).getClosure;
    auto storage = cls.engine.variables;

    writeln("[DEBUG - PeekClosureOperator]");
    writeln(" - cls.engine -> ", cls.engine);
    writeln(" - cls.operator -> ", cls.operator);
    
    foreach (key, value; storage) {
      writeln("[Varibale] ", key, " <=> ", value);
    }

    return new Value;
  }
}

class CallClosureOperator : IOperator {
  public Value call(Engine engine, Value[] args) {
    Closure cls = engine.eval(args[0]).getClosure;
    writeln("[DEBUG - CallClosureOperator]");
    writeln(" - cls.engine -> ", cls.engine);
    writeln(" - cls.operator -> ", cls.operator);
  
    return cls.eval(args[1..$]);
  }
}

class LookupSymbolOperator : IOperator {
  public Value call(Engine engine, Value[] args) {
    SymbolValue cls = engine.eval(args[0]).getSymbolValue;
  
    return new Value;
  }
}