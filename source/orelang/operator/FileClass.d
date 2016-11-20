module orelang.operator.FileClass;
import orelang.expression.ClassType,
       orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

import std.stdio,
       std.conv;

class FileClass : ClassType {
  File fp;

  this (Engine _engine) {
    _engine = _engine.clone;
    super("FileClass", _engine);

    _engine.defineVariable("constructor", new Value(cast(IOperator)(
      new class () IOperator {
        public Value call(Engine engine, Value[] args) {
          string fileName = engine.eval(args[0]).getString,
                 openType = engine.eval(args[1]).getString;
          fp.open(fileName, openType);
          return new Value;
        }
      })));

    _engine.defineVariable("raw-read", new Value(cast(IOperator)(
      new class () IOperator {
        public Value call(Engine engine, Value[] args) {
          Value[] ret;
          ubyte[] buf;
          buf.length = fp.size;
          fp.rawRead(buf);

          foreach (e; buf) {
            ret ~= new Value(e);
          }

          return new Value(ret);
        }})));

    _engine.defineVariable("raw-write", new Value(cast(IOperator)(
      new class () IOperator {
        public Value call(Engine engine, Value[] args) {
          Value[] data = engine.eval(args[0]).getArray;
          ubyte[] buf;

          foreach (e; data) {
            switch (e.type) with (ValueType) {
              case Numeric:
                buf ~= e.getNumeric.to!ubyte;
                break;
              case Ubyte:
                buf ~= e.getUbyte;
                break;
              case String:
                buf ~= e.getString.to!(ubyte[]);
                break;
              default:
                throw new Error("[raw-write] can't write non numeric/ubyte/string value"); 
            }
          }

          fp.rawWrite(buf);
          return new Value(data);
        }})));

    _engine.defineVariable("write", new Value(cast(IOperator)(
      new class () IOperator {
        public Value call(Engine engine, Value[] args) {
          Value data = engine.eval(args[0]);

          switch (data.type) with (ValueType) {
            case Numeric:
              fp.write(data.getNumeric);
              break;
            case Ubyte:
              fp.write(data.getUbyte);
              break;
            case String:
              fp.write(data.getString);
              break;
            default:
              throw new Error("[raw-write] can't write non numeric/ubyte/string value"); 
          }

          return data;
        }})));

    _engine.defineVariable("writeln", new Value(cast(IOperator)(
      new class () IOperator {
        public Value call(Engine engine, Value[] args) {
          Value data = engine.eval(args[0]);

          switch (data.type) with (ValueType) {
            case Numeric:
              fp.writeln(data.getNumeric);
              break;
            case Ubyte:
              fp.writeln(data.getUbyte);
              break;
            case String:
              fp.writeln(data.getString);
              break;
            default:
              throw new Error("[raw-writeln] can't write non numeric/ubyte/string value"); 
          }

          return new Value;
        }})));

    _engine.defineVariable("readln", new Value(cast(IOperator)(
      new class () IOperator {
        public Value call(Engine engine, Value[] args) {
          return new Value(fp.readln);
        }})));

    _engine.defineVariable("readall", new Value(cast(IOperator)(
      new class () IOperator {
        public Value call(Engine engine, Value[] args) {
          import std.string;
          static string[] buf;
          foreach (line; fp.byLine) {
            buf ~= line.to!string;
          }
          return new Value(buf.join("\n"));
        }})));
  }
}