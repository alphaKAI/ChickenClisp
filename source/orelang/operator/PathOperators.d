module orelang.operator.PathOperators;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;

/**
 * path-exists
 * path-is-dir
 * path-is-file
 */
import std.file;

class PathExistsOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    return new Value(engine.eval(args[0]).getString.exists);
  }
}

class PathIsDirOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    return new Value(engine.eval(args[0]).getString.isDir);
  }
}

class PathIsFileOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    return new Value(engine.eval(args[0]).getString.isFile);
  }
}