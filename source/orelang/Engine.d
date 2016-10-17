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
/+
import {TimeOperator} from "orelang.operator.TimeOperator;
+/
import orelang.operator.LetOperator;
import orelang.operator.ForeachOperator;
import orelang.operator.RemoveOperator;
import orelang.operator.ConsOperator;
import orelang.operator.WhenOperator;
import orelang.operator.IsListOperator;
/**
 * Script Engine of Orelang_D
 */
class Engine {
  /**
   * This holds variables and operators.
   * You can distinguish A VALUE of the child of this from whether a varibale or an operator.
   */
  Value[string] variables;

  this() {
    this.variables["+"] = cast(IOperator)(new AddOperator);
    this.variables["-"] = cast(IOperator)(new SubOperator);
    this.variables["*"] = cast(IOperator)(new MulOperator);
    this.variables["/"] = cast(IOperator)(new DivOperator);
    this.variables["%"] = cast(IOperator)(new ModOperator);
    this.variables["="] = cast(IOperator)(new EqualOperator);
    this.variables["<"] = cast(IOperator)(new LessOperator);
    this.variables[">"] = cast(IOperator)(new GreatOperator);
    this.variables["<="]  = cast(IOperator)(new LEqOperator);
    this.variables[">="]  = cast(IOperator)(new GEqOperator);
    this.variables["set"] = cast(IOperator)(new SetOperator);
    this.variables["get"] = cast(IOperator)(new GetOperator);
    this.variables["until"] = cast(IOperator)(new UntilOperator);
    this.variables["step"]  = cast(IOperator)(new StepOperator);
    this.variables["if"] = cast(IOperator)(new IfOperator);
    this.variables["!"]  = cast(IOperator)(new NotOperator);
    this.variables["not"] = this.variables["!"];
    this.variables["&&"]  = cast(IOperator)(new AndOperator);
    this.variables["and"] = this.variables["&&"];
    this.variables["||"]  = cast(IOperator)(new OrOperator);
    this.variables["or"]  = this.variables["||"];
    this.variables["print"] = cast(IOperator)(new PrintOperator);
    this.variables["println"] = cast(IOperator)(new PrintlnOperator);
    this.variables["def"]   = cast(IOperator)(new DeffunOperator);
    this.variables["while"] = cast(IOperator)(new WhileOperator);
    this.variables["get-fun"] = cast(IOperator)(new GetfunOperator);
    this.variables["lambda"]  = cast(IOperator)(new LambdaOperator);
    this.variables["map"]     = cast(IOperator)(new MapOperator);
    this.variables["set-idx"] = cast(IOperator)(new SetIdxOperator);
    this.variables["as-iv"]   = cast(IOperator)(new AsIVOperator);
    this.variables["def-var"] = cast(IOperator)(new DefvarOperator);
    this.variables["seq"]     = cast(IOperator)(new SeqOperator);
    this.variables["fold"]    = cast(IOperator)(new FoldOperator);
    this.variables["length"]  = cast(IOperator)(new LengthOperator);
    this.variables["car"]     = cast(IOperator)(new CarOperator);
    this.variables["cdr"]     = cast(IOperator)(new CdrOperator);
    this.variables["load"]    = cast(IOperator)(new LoadOperator);
    this.variables["cond"]    = cast(IOperator)(new CondOperator);
    this.variables["alias"]   = cast(IOperator)(new AliasOperator);
    /*
    this.variables["time"]    = new TimeOperator();
    */
    this.variables["let"]     = cast(IOperator)(new LetOperator);
    this.variables["for-each"] = cast(IOperator)(new ForeachOperator);
    this.variables["remove"]   = cast(IOperator)(new RemoveOperator);
    this.variables["cons"]   = cast(IOperator)(new ConsOperator);
    this.variables["when"]   = cast(IOperator)(new WhenOperator);
    this.variables["list?"]  = cast(IOperator)(new IsListOperator);
  }

  /*
    Clone this object
  */
  private Engine _super;
  Engine clone() {
    Engine newEngine = new Engine();

    newEngine._super = this;

    foreach (key, value; this.variables) {
      newEngine.variables[key] = value;
    }

    return newEngine;
  }

  public Value defineVariable(string name, Value value) {
    this.variables[name] = value;

    return value;
  }

  public Value setVariable(string name, Value value) {
    Engine engine = this;

    while (true) {
      if (name in engine.variables) {
        engine.variables[name] = value;

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
        return Value(null);
      }
    }
  }

  /**
   * Evalute Object
   */
  public Value eval(Value script) {
    writeln("[eval] script -> ", script);
    Value ret = this.getExpression(script);

    if (ret.convertsTo!IOperator) {
      return ret;
    }

    ret = (ret.get!IExpression).eval(this);

    if (ret.convertsTo!IOperator) {
      return Value(new Closure(this, ret.get!IOperator));
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
    writeln("[getExpression] script -> ", script);
    if (script.convertsTo!ImmediateValue) {
      return script.get!ImmediateValue;
    }

    if (script.convertsTo!(Value[])) {
      auto scriptList = script;
      if (scriptList[0].convertsTo!(Value[])) {
        CallOperator ret = new CallOperator(this.variables[scriptList[0][0].get!string].get!IOperator, (scriptList[0].get!(Value[]))[1..$]);
        Value tmp = ret.eval(this);

        if (tmp.convertsTo!Closure) {
          return new ImmediateValue(Value(tmp.get!Closure.eval((scriptList.get!(Value[]))[1..$])));
        } else if (tmp.convertsTo!IOperator) {
          return new ImmediateValue(Value(tmp.get!IOperator.call(this, (scriptList.get!(Value[]))[1..$])));
        }
      }

      Value tmp = this.variables[scriptList[0].get!string];
      if (tmp.convertsTo!IOperator) {
        IOperator op = tmp.get!IOperator;
        return new CallOperator(op, scriptList.get!(Value[])[1..$]);
      } else {
        return new CallOperator(tmp.get!Closure.operator, scriptList.get!(Value[])[1..$]);
      }
    } else {
      if (script.peek!string !is null) {
        Value tmp = this.getVariable(script.get!string);

        if (tmp != null) {
          return new ImmediateValue(tmp);
        }
      }

      return new ImmediateValue(script);
    }
  }
}
