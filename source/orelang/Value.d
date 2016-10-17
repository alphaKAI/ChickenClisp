module orelang.Value;
import orelang.expression.ImmediateValue,
       orelang.operator.DynamicOperator,
       orelang.expression.IExpression,
       orelang.operator.IOperator,
       orelang.Closure;
import std.variant;

alias Value = Algebraic!(ulong, long, double, string, bool, typeof(null), This*, This[], ImmediateValue, IExpression, IOperator, Closure, DynamicOperator);
