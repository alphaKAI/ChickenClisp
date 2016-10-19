module orelang.operator.HashMapOperators;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

class MakeHashOperator : IOperator {
  /**
   * call
   */
  /*
    (make-hash name)
   */
  public Value call(Engine engine, Value[] args) {
    string name = args[0].getString;
    Value[string] hash = null;
    Value ret = new Value(hash);

    engine.defineVariable(name, ret);

    return ret;
  }
}

class SetValueOperator : IOperator {
  /**
   * call
   */
  /*
    (set-value hash key value)
  */
  public Value call(Engine engine, Value[] args) {
    Value ret;

    if (args[0].type == ValueType.SymbolValue) {
      Value obj = engine.getVariable(args[0].getString);

      if (obj.type == ValueType.HashMap) {
        Value[string] hash = obj.getHashMap;
        
        hash[args[1].getString] = args[2];
        ret = new Value(hash);
      
        engine.setVariable(args[0].getString, ret);
      } else {
        throw new Error("No such a HashMap - " ~ args[0].getString);
      }
    } else if (args[0].type == ValueType.HashMap) {
      Value[string] hash = args[0].getHashMap;

      hash[args[1].getString] = args[2];
      ret = new Value(hash);

      engine.setVariable(args[0].getString, ret);
    } else {
      import std.stdio;
      writeln("args -> ", args);
      writeln("args[0].type -> ", args[0].type);
      throw new Error("set-value accepts (HashName Key Value) or (HashValue Key Value) only");
    }

    return ret;
  }
}

class GetValueOperator : IOperator {
  /**
   * call
   */
  /*
    (get-value hash key)
  */
  public Value call(Engine engine, Value[] args) {
    if (args[0].type == ValueType.SymbolValue) {
      Value obj = engine.getVariable(args[0].getString);

      if (obj.type == ValueType.HashMap) {
        Value[string] hash = obj.getHashMap;
        return hash[args[1].getString];
      } else {
        throw new Error("No such a HashMap - " ~ args[0].getString);
      }
    } else if (args[0].type == ValueType.HashMap) {
      Value[string] hash = args[0].getHashMap;

      return hash[args[1].getString];
    } else {
      throw new Error("get-value accepts (HashName Key Value) or (HashValue Key Value) only");
    }
  }
}
