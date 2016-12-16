module orelang.operator.RegexClass;
import orelang.expression.ClassType,
       orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

import std.stdio,
       std.conv;
import std.regex;
class RegexClass : ClassType {
  Regex!char rgx;

  this (Engine _engine) {
    _engine = _engine.clone;
    super(_engine);

    _engine.defineVariable("constructor", new Value(cast(IOperator)(
      new class () IOperator {
        public Value call(Engine engine, Value[] args) {
          string pattern = engine.eval(args[0]).getString;

          rgx = regex(pattern);

          return new Value;
        }
      })));

    _engine.defineVariable("reset", new Value(cast(IOperator)(
      new class () IOperator {
        public Value call(Engine engine, Value[] args) {
          string pattern = engine.eval(args[0]).getString;

          rgx = regex(pattern);

          return new Value;
        }})));

    _engine.defineVariable("match", new Value(cast(IOperator)(
      new class () IOperator {
        public Value call(Engine engine, Value[] args) {
          return new Value(cast(bool)(engine.eval(args[0]).getString.match(rgx)));
        }})));

    _engine.defineVariable("match-all", new Value(cast(IOperator)(
      new class () IOperator {
        public Value call(Engine engine, Value[] args) {
          writeln(engine.eval(args[0]).getString.matchAll(rgx));
          return new Value;
        }})));

    _engine.defineVariable("show-ptn", new Value(cast(IOperator)(
      new class () IOperator {
        public Value call(Engine engine, Value[] args) {
          import std.stdio;
          writeln(rgx);
          return new Value;
        }})));
  }
}