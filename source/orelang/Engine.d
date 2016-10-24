module orelang.Engine;

/**
 * Premitive Interfaces and Value Classes
 */
import orelang.expression.ImmediateValue,
       orelang.expression.CallOperator,
       orelang.expression.IExpression,
       orelang.operator.IOperator,
       orelang.Closure,
       orelang.Value;

/**
 * variables
 */
import orelang.operator.AddOperator;
import orelang.operator.SubOperator;
import orelang.operator.MulOperator;
import orelang.operator.DivOperator;
import orelang.operator.ModOperator;
import orelang.operator.EqualOperator;
import orelang.operator.GetOperator;
import orelang.operator.SetOperator;
import orelang.operator.StepOperator;
import orelang.operator.UntilOperator;
import orelang.operator.IfOperator;
import orelang.operator.LogicOperator;
import orelang.operator.PrintOperator;
import orelang.operator.DeffunOperator;
import orelang.operator.WhileOperator;
import orelang.operator.GetfunOperator;
import orelang.operator.DynamicOperator;
import orelang.operator.LambdaOperator;
import orelang.operator.MapOperator;
import orelang.operator.SetIdxOperator;
import orelang.operator.AsIVOperator;
import orelang.operator.DefvarOperator;
import orelang.operator.SeqOperator;
import orelang.operator.FoldOperator;
import orelang.operator.LengthOperator;
import orelang.operator.CarOperator;
import orelang.operator.CdrOperator;
import orelang.operator.LoadOperator;
import orelang.operator.CondOperator;
import orelang.operator.AliasOperator;
import orelang.operator.LetOperator;
import orelang.operator.ForeachOperator;
import orelang.operator.RemoveOperator;
import orelang.operator.ConsOperator;
import orelang.operator.WhenOperator;
import orelang.operator.IsListOperator;
import orelang.operator.HashMapOperators;
import orelang.operator.DefineOperator;
import orelang.operator.TranspileOperator;
import orelang.operator.EvalOperator;
import orelang.operator.StringOperators;

import std.exception;

/**
 * Script Engine of ChickenClisp
 */
class Engine {
  /**
   * This holds variables and operators.
   * You can distinguish A VALUE of the child of this from whether a varibale or an operator.
   */
  Value[string] variables;

  this() {
    this.variables["+"]        = new Value(cast(IOperator)(new AddOperator));
    this.variables["-"]        = new Value(cast(IOperator)(new SubOperator));
    this.variables["*"]        = new Value(cast(IOperator)(new MulOperator));
    this.variables["/"]        = new Value(cast(IOperator)(new DivOperator));
    this.variables["%"]        = new Value(cast(IOperator)(new ModOperator));
    this.variables["="]        = new Value(cast(IOperator)(new EqualOperator));
    this.variables["<"]        = new Value(cast(IOperator)(new LessOperator));
    this.variables[">"]        = new Value(cast(IOperator)(new GreatOperator));
    this.variables["<="]       = new Value(cast(IOperator)(new LEqOperator));
    this.variables[">="]       = new Value(cast(IOperator)(new GEqOperator));
    this.variables["set"]      = new Value(cast(IOperator)(new SetOperator));
    this.variables["get"]      = new Value(cast(IOperator)(new GetOperator));
    this.variables["until"]    = new Value(cast(IOperator)(new UntilOperator));
    this.variables["step"]     = new Value(cast(IOperator)(new StepOperator));
    this.variables["if"]       = new Value(cast(IOperator)(new IfOperator));
    this.variables["!"]        = new Value(cast(IOperator)(new NotOperator));
    this.variables["not"]      = this.variables["!"];
    this.variables["&&"]       = new Value(cast(IOperator)(new AndOperator));
    this.variables["and"]      = this.variables["&&"];
    this.variables["||"]       = new Value(cast(IOperator)(new OrOperator));
    this.variables["or"]       = this.variables["||"];
    this.variables["print"]    = new Value(cast(IOperator)(new PrintOperator));
    this.variables["println"]  = new Value(cast(IOperator)(new PrintlnOperator));
    this.variables["def"]      = new Value(cast(IOperator)(new DeffunOperator));
    this.variables["while"]    = new Value(cast(IOperator)(new WhileOperator));
    this.variables["get-fun"]  = new Value(cast(IOperator)(new GetfunOperator));
    this.variables["lambda"]   = new Value(cast(IOperator)(new LambdaOperator));
    this.variables["map"]      = new Value(cast(IOperator)(new MapOperator));
    this.variables["set-idx"]  = new Value(cast(IOperator)(new SetIdxOperator));
    this.variables["as-iv"]    = new Value(cast(IOperator)(new AsIVOperator));
    this.variables["def-var"]  = new Value(cast(IOperator)(new DefvarOperator));
    this.variables["seq"]      = new Value(cast(IOperator)(new SeqOperator));
    this.variables["fold"]     = new Value(cast(IOperator)(new FoldOperator));
    this.variables["length"]   = new Value(cast(IOperator)(new LengthOperator));
    this.variables["car"]      = new Value(cast(IOperator)(new CarOperator));
    this.variables["cdr"]      = new Value(cast(IOperator)(new CdrOperator));
    this.variables["load"]     = new Value(cast(IOperator)(new LoadOperator));
    this.variables["cond"]     = new Value(cast(IOperator)(new CondOperator));
    this.variables["alias"]    = new Value(cast(IOperator)(new AliasOperator));
    this.variables["let"]      = new Value(cast(IOperator)(new LetOperator));
    this.variables["for-each"] = new Value(cast(IOperator)(new ForeachOperator));
    this.variables["remove"]   = new Value(cast(IOperator)(new RemoveOperator));
    this.variables["cons"]     = new Value(cast(IOperator)(new ConsOperator));
    this.variables["when"]     = new Value(cast(IOperator)(new WhenOperator));
    this.variables["list?"]    = new Value(cast(IOperator)(new IsListOperator));
    this.variables["make-hash"]   = new Value(cast(IOperator)(new MakeHashOperator));
    this.variables["set-value"]   = new Value(cast(IOperator)(new SetValueOperator));
    this.variables["get-value"]   = new Value(cast(IOperator)(new GetValueOperator));
    this.variables["define"]      = new Value(cast(IOperator)(new DefineOperator));
    this.variables["transpile"]   = new Value(cast(IOperator)(new TranspileOperator));
    this.variables["eval"]        = new Value(cast(IOperator)(new EvalOperator));
    this.variables["string-concat"] = new Value(cast(IOperator)(new StringConcatOperator));
    this.variables["string-join"]   = new Value(cast(IOperator)(new StringJoinOperator));
    this.variables["string-split"]  = new Value(cast(IOperator)(new StringSplitOperator)); 
  }

  /*
    Clone this object
  */
  private Engine _super;
  Engine clone() {
    Engine newEngine = new Engine();

    newEngine._super = this;

    newEngine.variables = this.variables.dup;

    return newEngine;
  }

  public Value defineVariable(string name, Value value) {
    this.variables[name] = value.dup;

    return value;
  }

  public Value setVariable(string name, Value value) {
    Engine engine = this;

    while (true) {
      if (name in engine.variables) {
        engine.variables[name] = value.dup;
        return value;
      } else if (engine._super !is null) {
        engine = engine._super;
      } else {
        engine.defineVariable(name, value);
      }
    }
  }

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
  import std.stdio;
  public IExpression getExpression(Value script) {

    if (script.type == ValueType.ImmediateValue) {
      return script.getImmediateValue;
    }

    if (script.type == ValueType.Array) {
      Value[] scriptList = script.getArray;

      if (scriptList[0].type == ValueType.Array) {
        CallOperator ret = new CallOperator(this.variables[scriptList[0][0].getString].getIOperator, scriptList[0].getArray[1..$]);
        Value tmp = ret.eval(this);

        if (tmp.type == ValueType.Closure) {
          return new ImmediateValue(tmp.getClosure.eval(scriptList[1..$]));
        } else if (tmp.type == ValueType.IOperator) {
          return new ImmediateValue(tmp.getIOperator.call(this, scriptList[1..$]));
        }
      }

      Value tmp = this.variables[scriptList[0].getString];

      if (tmp.type == ValueType.IOperator) {
        IOperator op = tmp.getIOperator;
        return new CallOperator(op, scriptList[1..$]);
      } else {
        return new CallOperator(tmp.getClosure.operator, scriptList[1..$]);
      }
    } else {
      if (script.type == ValueType.SymbolValue || script.type == ValueType.String) {
        Value tmp;
        tmp = this.getVariable(script.getString).dup;

        if (tmp.type != ValueType.Null) {
          return new ImmediateValue(tmp);
        }
      }

      return new ImmediateValue(script);
    }
  }
}
