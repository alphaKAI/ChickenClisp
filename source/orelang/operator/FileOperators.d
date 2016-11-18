module orelang.operator.FileOperators;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;
import std.conv,
       std.file;

class RemoveFileOperator {
  public Value call(Engine engine, Value[] args) {
    string path = args[0].type == ValueType.SymbolValue ? engine.eval(args[0]).getString : args[0].getString;

    if (exists(path)) {
      if (isFile(path)) {
        remove(path);
      } else {
        throw new Error("[remove-file]" ~ path ~ " is not a file, it is a directory, use remove-dir function instead.");
      }
    } else {
      throw new Error("[remove-file] No such a file or directory: " ~ path);
    }

    return new Value;
  }
}

class RemoveDirOperator {
  public Value call(Engine engine, Value[] args) {
    string path = args[0].type == ValueType.SymbolValue ? engine.eval(args[0]).getString : args[0].getString;

    if (exists(path)) {
      if (isDir(path)) {
        rmdir(path);
      } else {
        throw new Error("[remove-dir]" ~ path ~ " is not a directory, it is a file, use remove-file function instead.");
      }
    } else {
      throw new Error("[remove-dir] No such a file or directory: " ~ path);
    }

    return new Value;
  }
}

class GetcwdOperator : IOperator {
  public Value call(Engine engine, Value[] args) {
    return new Value(getcwd);
  }
}

class GetsizeOperator : IOperator {
  public Value call(Engine engine, Value[] args) {
    float ret;
    string path = args[0].type == ValueType.SymbolValue ? engine.eval(args[0]).getString : args[0].getString;

   if (exists(path)) {
      if (isFile(path)) {
        ret = getSize(path).to!float;
      } else {
        throw new Error("[get-size]" ~ path ~ " is not a file, it is a directory");
      }
    } else {
      throw new Error("[get-size] No such a file or directory: " ~ path);
    }


    return new Value(ret);
  }
}