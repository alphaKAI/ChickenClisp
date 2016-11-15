module orelang.Engine;

/**
 * Premitive Interfaces and Value Classes
 */
import orelang.expression.ImmediateValue,
       orelang.expression.CallOperator,
       orelang.expression.IExpression,
       orelang.expression.ClassType,
       orelang.operator.IOperator,
       orelang.Closure,
       orelang.Value;

/**
 * variables
 */
import orelang.operator.DatetimeOperators,
       orelang.operator.IsHashMapOperator,
       orelang.operator.TranspileOperator,
       orelang.operator.HashMapOperators,
       orelang.operator.DigestOperators,
       orelang.operator.DynamicOperator,
       orelang.operator.ForeachOperator,
       orelang.operator.StringOperators,
       orelang.operator.ArrayOperators,
       orelang.operator.DebugOperators,
       orelang.operator.ClassOperators,
       orelang.operator.DeffunOperator,
       orelang.operator.DefineOperator,
       orelang.operator.DefvarOperator,
       orelang.operator.GetfunOperator,
       orelang.operator.IsListOperator,
       orelang.operator.IsNullOperator,
       orelang.operator.LambdaOperator,
       orelang.operator.LengthOperator,
       orelang.operator.RemoveOperator,
       orelang.operator.SetIdxOperator,
       orelang.operator.AliasOperator,
       orelang.operator.ConvOperators,
       orelang.operator.CurlOperators,
       orelang.operator.EqualOperator,
       orelang.operator.LogicOperator,
       orelang.operator.PrintOperator,
       orelang.operator.TimesOperator,
       orelang.operator.UntilOperator,
       orelang.operator.UUIDOperators,
       orelang.operator.WhileOperator,
       orelang.operator.AsIVOperator,
       orelang.operator.CondOperator,
       orelang.operator.ConsOperator,
       orelang.operator.EvalOperator,
       orelang.operator.FoldOperator,
       orelang.operator.LoadOperator,
       orelang.operator.SortOperator,
       orelang.operator.StepOperator,
       orelang.operator.TypeOperator,
       orelang.operator.UriOperators,
       orelang.operator.WhenOperator,
       orelang.operator.AddOperator,
       orelang.operator.CarOperator,
       orelang.operator.CdrOperator,
       orelang.operator.DivOperator,
       orelang.operator.GetOperator,
       orelang.operator.LetOperator,
       orelang.operator.MapOperator,
       orelang.operator.MulOperator,
       orelang.operator.ModOperator,
       orelang.operator.SetOperator,
       orelang.operator.SeqOperator,
       orelang.operator.SubOperator,
       orelang.operator.IfOperator;

import std.exception;

/**
 * Lazed Associative Array
 *
 * For instance;
 *   assocArray["key"] = new ValueType
 *  The above code create a new instance of ValueType with some consts(memory amount and time).
 * However it likely to be a bobottleneck if the value isn't needed.
 * Then this class provides lazed associative array, this class willn't create an instance until the value become needed.
 * In other words, this is sort of lazy evaluation for performance.
 */
class LazedAssocArray(T) {
  /**
   * Flags, indicates whether the instance of the key is already created  
   */
  bool[string] called;
  /**
   * This variable holds the instance as a value of hashmap.
   */
  T[string]    storage;
  /**
   * This variable holds the constructor calling delegate to make the instance which will be called when the isntance become needed.
   */
  T delegate()[string] constructors;

  alias storage this;

  /**
   * This function works like:
   *  // laa is an instance of LazedAssocArray
   *  laa["key"] = new T;
   * with following way:
   *  laa.insert!("key", "new T");
   *
   * This function uses string-mixin for handling "new T", becase D can't allow make an alias of the expr liek `new T`
   */
  void insert(string key, string value)() {
    constructors[key] = mixin("delegate T () { return " ~ value ~ ";}");
    called[key]       = false;
  }

  void insert(string key, T delegate() value)() {
    constructors[key] = value;
    called[key]       = false;
  }

  void insert(string key, T function() value)() {
    constructors[key] = () => value();
    called[key]       = false;
  }

  void insert(string key, T delegate() value) {
    constructors[key] = value;
    called[key]       = false;
  }

  void insert(string key, T function() value) {
    constructors[key] = () => value();
    called[key]       = false;
  }


  /**
   * Set the value with the key.
   * This function works like:
   *  laa["key"] = value;
   * with
   * laa.set("key", value) 
   */
  void set(string key, T value) {
    storage[key] = value;
    called[key]  = true;
  }

  /**
   * Make an alias of the key
   */
  void link(string alternative, string key) {
    const flag = called[key];
    called[alternative] = flag;

    if (flag) {
      storage[alternative] = storage[key];
    } else {
      constructors[alternative] = constructors[key];
    }
  }

  /**
   * An overloaded function of opIndexAssing
   * This function hooks: laa["key"] = value; event but this function might be no use
   */
  void opIndexAssing(T value, string key) {
    storage[key] = value;
    called[key] = true;
  }

  /**
   * An overloaded function of opIndex
   * This function hooks: laa["key"] event.
   */ 
  T opIndex(string key) {
    if (!called[key]) {
      T newT = constructors[key]();

      storage[key] = newT;
      called[key]  = true;

      return newT;
    }

    return storage[key];
  }
}

/**
 * Script Engine of ChickenClisp
 */
class Engine {
  enum ConstructorMode {
    CLONE
  }

  /**
   * This holds variables and operators.
   * You can distinguish A VALUE of the child of this from whether a varibale or an operator.
   */
  LazedAssocArray!Value variables;

  bool sync_storage;

  /**
   * Default Constructor
   */
  this() {
    this.variables = new LazedAssocArray!Value;

    // Arithmetic operations
    this.variables.insert!("+",        q{new Value(cast(IOperator)(new AddOperator))});
    this.variables.insert!("-",        q{new Value(cast(IOperator)(new SubOperator))});
    this.variables.insert!("*",        q{new Value(cast(IOperator)(new MulOperator))});
    this.variables.insert!("/",        q{new Value(cast(IOperator)(new DivOperator))});
    this.variables.insert!("%",        q{new Value(cast(IOperator)(new ModOperator))});

    // Comparison operators
    this.variables.insert!("=",        q{new Value(cast(IOperator)(new EqualOperator))});
    this.variables.insert!("<",        q{new Value(cast(IOperator)(new LessOperator))});
    this.variables.insert!(">",        q{new Value(cast(IOperator)(new GreatOperator))});
    this.variables.insert!("<=",       q{new Value(cast(IOperator)(new LEqOperator))});
    this.variables.insert!(">=",       q{new Value(cast(IOperator)(new GEqOperator))});

    // Varibale/Function operators
    this.variables.insert!("def",      q{new Value(cast(IOperator)(new DeffunOperator))});
    this.variables.insert!("set",      q{new Value(cast(IOperator)(new SetOperator))});
    this.variables.insert!("set-p",      q{new Value(cast(IOperator)(new SetPOperator))});
    this.variables.set("get",          new Value(cast(IOperator)(new GetOperator)));
    this.variables.insert!("let",      q{new Value(cast(IOperator)(new LetOperator))});
    this.variables.insert!("as-iv",    q{new Value(cast(IOperator)(new AsIVOperator))});
    this.variables.insert!("define",   q{new Value(cast(IOperator)(new DefineOperator))});
    this.variables.insert!("def-var",  q{new Value(cast(IOperator)(new DefvarOperator))});
    this.variables.insert!("get-fun",  q{new Value(cast(IOperator)(new GetfunOperator))});
    this.variables.insert!("set-idx",  q{new Value(cast(IOperator)(new SetIdxOperator))});

    // Loop operators
    this.variables.insert!("step",     q{new Value(cast(IOperator)(new StepOperator))});
    this.variables.insert!("times",    q{new Value(cast(IOperator)(new TimesOperator))});
    this.variables.insert!("until",    q{new Value(cast(IOperator)(new UntilOperator))});
    this.variables.insert!("while",    q{new Value(cast(IOperator)(new WhileOperator))});

    // Logic operators
    this.variables.insert!("!",        q{new Value(cast(IOperator)(new NotOperator))});
    this.variables.insert!("&&",       q{new Value(cast(IOperator)(new AndOperator))});
    this.variables.insert!("||",       q{new Value(cast(IOperator)(new OrOperator))});

    // I/O operators
    this.variables.insert!("print",    q{new Value(cast(IOperator)(new PrintOperator))});
    this.variables.insert!("println",  q{new Value(cast(IOperator)(new PrintlnOperator))});
    
    // Condition operators
    this.variables.insert!("if",       q{new Value(cast(IOperator)(new IfOperator))});
    this.variables.insert!("cond",     q{new Value(cast(IOperator)(new CondOperator))});
    this.variables.insert!("when",     q{new Value(cast(IOperator)(new WhenOperator))});
    
    // Functional operators
    this.variables.insert!("lambda",   q{new Value(cast(IOperator)(new LambdaOperator))});
    this.variables.insert!("map",      q{new Value(cast(IOperator)(new MapOperator))});
    this.variables.insert!("for-each", q{new Value(cast(IOperator)(new ForeachOperator))});
    this.variables.insert!("fold",     q{new Value(cast(IOperator)(new FoldOperator))});

    // List operators
    this.variables.insert!("car",      q{new Value(cast(IOperator)(new CarOperator))});
    this.variables.insert!("cdr",      q{new Value(cast(IOperator)(new CdrOperator))});
    this.variables.insert!("seq",      q{new Value(cast(IOperator)(new SeqOperator))});
    this.variables.insert!("cons",     q{new Value(cast(IOperator)(new ConsOperator))});
    this.variables.insert!("sort",     q{new Value(cast(IOperator)(new SortOperator))});
    this.variables.insert!("list?",    q{new Value(cast(IOperator)(new IsListOperator))});
    this.variables.insert!("remove",   q{new Value(cast(IOperator)(new RemoveOperator))});
    this.variables.insert!("length",   q{new Value(cast(IOperator)(new LengthOperator))});

    // HashMap operators
    this.variables.insert!("new-hash",        q{new Value(cast(IOperator)(new NewHashOperator))});
    this.variables.insert!("make-hash",        q{new Value(cast(IOperator)(new MakeHashOperator))});
    this.variables.insert!("hash-set-value",   q{new Value(cast(IOperator)(new HashSetValueOperator))});
    this.variables.insert!("hash-get-value",   q{new Value(cast(IOperator)(new HashGetValueOperator))});
    this.variables.insert!("hash-get-keys",    q{new Value(cast(IOperator)(new HashGetKeysOperator))});
    this.variables.insert!("hash-get-values",    q{new Value(cast(IOperator)(new HashGetValuesOperator))});

    // String operators
    this.variables.insert!("string-concat",    q{new Value(cast(IOperator)(new StringConcatOperator))});
    this.variables.insert!("string-join",      q{new Value(cast(IOperator)(new StringJoinOperator))});
    this.variables.insert!("string-split",     q{new Value(cast(IOperator)(new StringSplitOperator))});
    this.variables.insert!("string-length",    q{new Value(cast(IOperator)(new StringLengthOperator))});
    this.variables.insert!("string-slice",     q{new Value(cast(IOperator)(new StringSliceOperator))});
    this.variables.insert!("as-string",        q{new Value(cast(IOperator)(new AsStringOperator))});
    this.variables.insert!("string-repeat",    q{new Value(cast(IOperator)(new StringRepeatOperator))});

    // Conversion operators
    this.variables.insert!("number-to-string", q{new Value(cast(IOperator)(new numberToStringOperator))});
    this.variables.insert!("char-to-number",   q{new Value(cast(IOperator)(new charToNumberOperator))});
    this.variables.insert!("float-to-integer", q{new Value(cast(IOperator)(new floatToIntegerOperator))});
    this.variables.insert!("ubytes-to-string", q{new Value(cast(IOperator)(new ubytesToStringOperator))});
    this.variables.insert!("ubytes-to-integers", q{new Value(cast(IOperator)(new ubytesToIntegersOperator))});
    
    // Array Operators
    this.variables.insert!("array-new",        q{new Value(cast(IOperator)(new ArrayNewOperator))});
    this.variables.insert!("array-get-n",      q{new Value(cast(IOperator)(new ArrayGetNOperator))});
    this.variables.insert!("array-set-n",      q{new Value(cast(IOperator)(new ArraySetNOperator))});
    this.variables.insert!("array-slice",      q{new Value(cast(IOperator)(new ArraySliceOperator))});
    this.variables.insert!("array-append",     q{new Value(cast(IOperator)(new ArrayAppendOperator))});
    this.variables.insert!("array-concat",     q{new Value(cast(IOperator)(new ArrayConcatOperator))});
    this.variables.insert!("array-length",     q{new Value(cast(IOperator)(new ArrayLengthOperator))});
    this.variables.insert!("array-flatten",    q{new Value(cast(IOperator)(new ArrayFlattenOperator))});
    this.variables.insert!("array-reverse",    q{new Value(cast(IOperator)(new ArrayReverseOperator))});

    // Utility operators
    this.variables.insert!("eval",      q{new Value(cast(IOperator)(new EvalOperator))});
    this.variables.insert!("load",      q{new Value(cast(IOperator)(new LoadOperator))});
    this.variables.insert!("type",      q{new Value(cast(IOperator)(new TypeOperator))});
    this.variables.insert!("alias",     q{new Value(cast(IOperator)(new AliasOperator))});
    this.variables.insert!("is-null?",  q{new Value(cast(IOperator)(new IsNullOperator))});
    this.variables.insert!("is-hash?",  q{new Value(cast(IOperator)(new IsHashMapOperator))});
    this.variables.insert!("transpile", q{new Value(cast(IOperator)(new TranspileOperator))});

    // Curl Operators
    this.variables.insert!("curl-download",    q{new Value(cast(IOperator)(new CurlDownloadOperator))});
    this.variables.insert!("curl-upload",      q{new Value(cast(IOperator)(new CurlUploadOperator))});
    this.variables.insert!("curl-get",         q{new Value(cast(IOperator)(new CurlGetOperator))});
    this.variables.insert!("curl-get-string",  q{new Value(cast(IOperator)(new CurlGetStringOperator))});
    this.variables.insert!("curl-post",        q{new Value(cast(IOperator)(new CurlPostOperator))});
    this.variables.insert!("curl-post-string", q{new Value(cast(IOperator)(new CurlPostStringOperator))});

    // Uri Operators
    this.variables.insert!("url-encode-component", q{new Value(cast(IOperator)(new UrlEncodeComponentOperator))});

    // UUID Operators
    this.variables.insert!("random-uuid", q{new Value(cast(IOperator)(new RandomUUIDOperator))});

    // Datetime Operators
    this.variables.insert!("get-current-unixtime", q{new Value(cast(IOperator)(new GetCurrentUNIXTime))});

    // Digest Operators
    this.variables.insert!("hmac-sha1", q{new Value(cast(IOperator)(new HMACSHA1Operator))});

    // Debug Operators
    this.variables.insert!("dump-variables", q{new Value(cast(IOperator)(new DumpVaribalesOperator))});
    this.variables.insert!("peek-closure", q{new Value(cast(IOperator)(new PeekClosureOperator))});
    this.variables.insert!("call-closure", q{new Value(cast(IOperator)(new CallClosureOperator))});

    // Class Operators
    this.variables.insert!("class",     q{new Value(cast(IOperator)(new ClassOperator))});
    this.variables.insert!("new",     q{new Value(cast(IOperator)(new NewOperator))});

    // Aliases
    this.variables.link("not", "!");
    this.variables.link("and", "&&");
    this.variables.link("or",  "||");
    this.variables.link("begin", "step");
  }

  /**
   * Constructor to make a clone
   */
  this(ConstructorMode mode) {}

  /**
   * Super Class for a cloned object
   */
  private Engine _super;

  Engine peekSuper() {
    return this._super;
  }

  /**
   * Clone this object
   */
  Engine clone() {
    Engine newEngine = new Engine(ConstructorMode.CLONE);

    newEngine._super = this;

    newEngine.variables = new LazedAssocArray!Value;

    if (!sync_storage) {
      newEngine.variables.called       = this.variables.called.dup;
      newEngine.variables.constructors = this.variables.constructors;
      newEngine.variables.storage      = this.variables.storage.dup;
    } else {
      newEngine.variables.called       = this.variables.called;
      newEngine.variables.constructors = this.variables.constructors;
      newEngine.variables.storage      = this.variables.storage;
    }

    return newEngine;
  }

  /**
   * Define new variable
   */
  public Value defineVariable(string name, Value value) {
    this.variables.set(name, value.dup);

    return value;
  }

  /**
   * Set a value into certain variable
   */
  public Value setVariable(string name, Value value) {
    Engine engine = this;

    while (true) {
      if (name in engine.variables) {
        engine.variables.set(name, value.dup);
        return value;
      } else if (engine._super !is null) {
        engine = engine._super;
      } else {
        engine.defineVariable(name, value);
      }
    }
  }

  /**
   * Get a value from variables table
   */ 
  public Value getVariable(string name) {
    Engine engine = this;

    while (true) {
      if (name in engine.variables) {
        return engine.variables[name];
      } else if (engine._super !is null) {
        engine = engine._super;
      } else {
        return new Value;
      }
    }
  }

  /**
   * Evalute Object
   */
  public Value eval(Value script) {
    Value ret = new Value(this.getExpression(script));

    if (ret.type == ValueType.IOperator) {
      return ret;
    }

    enforce(ret.type == ValueType.IExpression);

    ret = ret.getIExpression.eval(this);

    if (ret.type == ValueType.IOperator) {
      return new Value(new Closure(this, ret.getIOperator));
    } else {
      return ret;
    }
  }

  /**
   * getExpression
   * Build Script Tree
   */
  public IExpression getExpression(Value script) {
    if (script.type == ValueType.ImmediateValue) {
      return script.getImmediateValue;
    }

    if (script.type == ValueType.Array) {
      Value[] scriptList = script.getArray;

      if (scriptList[0].type == ValueType.Array) {
        Value op = this.variables[scriptList[0][0].getString];
        if (op.type == ValueType.Closure) {
          Closure   closure  = op.getClosure;
          Engine    engine   = closure.engine;
          IOperator operator = closure.operator;

          Closure cls = operator.call(engine, scriptList[0].getArray[1..$]).getClosure;

          if (scriptList.length == 2) {
            return new ImmediateValue(cls.eval(scriptList[1..$]));
          } else {
            return new ImmediateValue(cls.eval([]));
          }
        } else if (op.type == ValueType.IOperator) {
          CallOperator ret = new CallOperator(
                                this.variables[scriptList[0][0].getString].getIOperator,
                                scriptList[0].getArray[1..$]);
          Value        tmp = ret.eval(this);

          if (tmp.type == ValueType.Closure) {
            return new ImmediateValue(tmp.getClosure.eval(scriptList[1..$]));
          } else if (tmp.type == ValueType.IOperator) {
            return new ImmediateValue(tmp.getIOperator.call(this, scriptList[1..$]));
          } else if (tmp.type == ValueType.ClassType) {
            ClassType cls = tmp.getClassType;
            return new ImmediateValue(cls.call(cls._engine, scriptList[1..$]));
          }
        } else {
          throw new Error("Invalid Operator was given!");
        }
      }

      Value tmp = this.variables[scriptList[0].getString];

      if (tmp.type == ValueType.IOperator) {
        IOperator op = tmp.getIOperator;
        return new CallOperator(op, scriptList[1..$]);
      } else if (tmp.type == ValueType.Closure) {
        return new CallOperator(tmp.getClosure.operator, scriptList[1..$]);
      } else if (tmp.type == ValueType.ClassType) {
        //import std.stdio; writeln("ClassType!");
        //writeln("scriptList -> ", scriptList);
        ClassType cls = tmp.getClassType;
        return new ImmediateValue(cls.call(cls._engine, scriptList[1..$]));
      } else {
        throw new Error("Invalid Operator was given!");
      }
    } else {
      if (script.type == ValueType.SymbolValue || script.type == ValueType.String) {
        if (script.type == ValueType.SymbolValue) {
          Value tmp;
          tmp = this.getVariable(script.getString).dup;

          if (tmp.type != ValueType.Null) {
            return new ImmediateValue(tmp);
          }
        } else {
          return new ImmediateValue(new Value(script.getString));
        }
      }

      return new ImmediateValue(script);
    }
  }
}
