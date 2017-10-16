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

class NewHashOperator : IOperator {
  /**
   * call
   */
  /*
    (new-hash)
   */
  public Value call(Engine engine, Value[] args) {
    Value[string] hash = null;
    Value ret = new Value(hash);

    return ret;
  }
}

class HashSetValueOperator : IOperator {
  /**
   * call
   */
  /*
    (hash-set-value hash key value)
  */
  public Value call(Engine engine, Value[] args) {
    Value ret;

    if (args[0].type == ValueType.SymbolValue) {
      Value obj = engine.getVariable(args[0].getString);

      if (obj.type == ValueType.HashMap) {
        Value[string] hash = obj.getHashMap;
        
        hash[engine.eval(args[1]).getString] = engine.eval(args[2]);
        ret = new Value(hash);
      
        engine.setVariable(args[0].getString, ret);
      } else {
        throw new Exception("No such a HashMap - " ~ args[0].getString);
      }
    } else if (args[0].type == ValueType.HashMap) {
      Value[string] hash = args[0].getHashMap;

      hash[engine.eval(args[1]).getString] = engine.eval(args[2]);
      ret = new Value(hash);

      engine.setVariable(args[0].getString, ret);
    } else {
      throw new Exception("set-value accepts (HashName Key Value) or (HashValue Key Value) only");
    }

    return ret;
  }
}

class HashGetValueOperator : IOperator {
  /**
   * call
   */
  /*
    (hash-get-value hash key)
  */
  public Value call(Engine engine, Value[] args) {
    if (args[0].type == ValueType.SymbolValue) {
      Value obj = engine.getVariable(args[0].getString);

      if (obj.type == ValueType.HashMap) {
        Value[string] hash = obj.getHashMap;
        return hash[engine.eval(args[1]).getString];
      } else {
        throw new Exception("No such a HashMap - " ~ args[0].getString);
      }
    } else if (engine.eval(args[0]).type == ValueType.HashMap) {
      Value[string] hash = engine.eval(args[0]).getHashMap;

      return hash[engine.eval(args[1]).getString];
    } else {
      throw new Exception("hash-get-value accepts (HashName Key Value) or (HashValue Key Value) only");
    }
  }
}

class HashGetKeysOperator : IOperator {
  /**
   * call
   */
  /*
    (hash-get-keys hash)
  */
  public Value call(Engine engine, Value[] args) {
    if (args[0].type == ValueType.SymbolValue) {
      Value obj = engine.getVariable(args[0].getString);

      if (obj.type == ValueType.HashMap) {
        Value[string] hash = obj.getHashMap;
        Value[] keys;

        foreach (key; hash.keys) {
          keys ~= new Value(key);
        }

        return new Value(keys);
      } else {
        throw new Exception("No such a HashMap - " ~ args[0].getString);
      }
    } else if (engine.eval(args[0]).type == ValueType.HashMap) {
      Value[string] hash = engine.eval(args[0]).getHashMap;
      Value[] keys;

      foreach (key; hash.keys) {
        keys ~= new Value(key);
      }

      return new Value(keys);
    } else {
      throw new Exception("hash-get-keys accepts (HashName Key Value) or (HashValue Key Value) only");
    }
  }
}

class HashGetValuesOperator : IOperator {
  /**
   * call
   */
  /*
    (hash-get-values hash)
  */
  public Value call(Engine engine, Value[] args) {
    if (args[0].type == ValueType.SymbolValue) {
      Value obj = engine.getVariable(args[0].getString);

      if (obj.type == ValueType.HashMap) {
        Value[string] hash = obj.getHashMap;
        Value[] values;

        foreach (value; hash.values) {
          values ~= value;
        }

        return new Value(values);
      } else {
        throw new Exception("No such a HashMap - " ~ args[0].getString);
      }
    } else if (engine.eval(args[0]).type == ValueType.HashMap) {
      Value[string] hash = engine.eval(args[0]).getHashMap;
      Value[] values;

      foreach (value; hash.values) {
        values ~= value;
      }

      return new Value(values);
    } else {
      throw new Exception("hash-get-values accepts (HashName Key Value) or (HashValue Key Value) only");
    }
  }
}