module orelang.operator.CurlOperators;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;
import std.net.curl;

class CurlDownloadOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    string url        = engine.eval(args[0]).getString,
           saveToPath = engine.eval(args[1]).getString;

    try {
      download(url, saveToPath);

      return new Value(true); 
    } catch(Exception e) {
      return new Value(false);
    }
  }
}

class CurlUploadOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    string loadFromPath = engine.eval(args[0]).getString,
           url          = engine.eval(args[1]).getString;

    try {
      upload(loadFromPath, url);

      return new Value(true); 
    } catch(Exception e) {
      return new Value(false);
    }
  }
}

class CurlGetOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    string url = engine.eval(args[0]).getString;

    try {
      auto contents = get(url);
      Value[] ret;
      foreach (elem; contents) {
        ret ~= new Value(elem);
      }
      return new Value(ret);
    } catch(CurlException e) {
      return new Value;
    }
  }
}

class CurlGetStringOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    string url = engine.eval(args[0]).getString;

    try {
      auto contents = get(url);
      return new Value(cast(string)contents);
    } catch(CurlException e) {
      return new Value;
    }
  }
}
