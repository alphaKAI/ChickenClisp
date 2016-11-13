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
      auto contents = {
        if (args.length == 2) {
          auto http = HTTP();
          Value[string] headers = engine.eval(args[1]).getHashMap;

          foreach (key, value; headers) {
            http.addRequestHeader(key, value.getString);
          }

          return get(url, http);
        } else {
          return get(url);
        }
      }();
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
    CurlGetOperator cgo = new CurlGetOperator;
    Value[] ret = cgo.call(engine, args).getArray;
    ubyte[] data;
    
    foreach (e; ret) {
      if (e.type == ValueType.Ubyte) {
        data ~= e.getUbyte;
      } else {
        throw new Error("Fatal internal error - Invalid typed data was given to curl-get-string");
      }
    }

    return new Value(cast(string)data);
  }
}

class CurlPostOperator : IOperator {
  /**
   * call
   */
  import std.algorithm,
         std.string,
         std.array,
         std.range,
         std.conv;
  public Value call(Engine engine, Value[] args) {
    string url  = engine.eval(args[0]).getString;
    Value pargs = engine.eval(args[1]);

    if (pargs.type == ValueType.HashMap) {
      string[string] params;
      Value[string] dict = pargs.getHashMap;

      foreach (key, value; dict) {
        params[key] = value.getString;
      }

      auto contents = {
        if (args.length == 3) {
          auto http = HTTP();
          Value[string] headers = engine.eval(args[2]).getHashMap;

          foreach (key, value; headers) {
            http.addRequestHeader(key, value.getString);
          }

          return post(url, params.keys.map!(k => k ~ "=" ~ params[k]).join("&"), http);
        } else {
          return post(url, params.keys.map!(k => k ~ "=" ~ params[k]).join("&"));
        }
      }();
      Value[] ret;

      foreach (elem; contents) {
        ret ~= new Value(elem);
      }

      return new Value(ret);
    } else if (pargs.type == ValueType.Array || (pargs.type == ValueType.ImmediateValue && (pargs.getImmediateValue.value.type == ValueType.Array))) {
      Value[] array;
      if (pargs.type == ValueType.Array) {
        array = pargs.getArray;
      } else {
        array = pargs.getImmediateValue.value.getArray;
      }

      ubyte[] postData;

      foreach (value; array) {
        switch (value.type) with (ValueType) {
          case Ubyte:
            postData ~= value.getUbyte;
            break;
          case Numeric:
            postData ~= value.getNumeric.to!ubyte;
            break;
          default:
            throw new Exception("Invalid argument was given to curl-post");
        }
      }

      auto contents = {
        if (args.length == 3) {
          auto http = HTTP();
          Value[string] headers = engine.eval(args[2]).getHashMap;

          foreach (key, value; headers) {
            http.addRequestHeader(key, value.getString);
          }

          return post(url, postData, http);
        } else {
          return post(url, postData);
        }
      }();
      Value[] ret;

      foreach (elem; contents) {
        ret ~= new Value(elem);
      }

      return new Value(ret);
    } else if (pargs.type == ValueType.String) {
      auto contents = {
        if (args.length == 3) {
          auto http = HTTP();
          Value[string] headers = engine.eval(args[2]).getHashMap;

          foreach (key, value; headers) {
            http.addRequestHeader(key, value.getString);
          }

          return post(url, pargs.getString, http);
        } else {
          return post(url, pargs.getString);
        }
      }();
      Value[] ret;

      foreach (elem; contents) {
        ret ~= new Value(elem);
      }

      return new Value(ret);
    } else {
      throw new Exception("Invalid argument was given to curl-post");
    }
  }
}

class CurlPostStringOperator : IOperator {
  /**
   * call
   */
  public Value call(Engine engine, Value[] args) {
    CurlPostOperator cpo = new CurlPostOperator;
    Value[] ret = cpo.call(engine, args).getArray;
    ubyte[] data;
    
    foreach (e; ret) {
      if (e.type == ValueType.Ubyte) {
        data ~= e.getUbyte;
      } else {
        throw new Error("Fatal internal error - Invalid typed data was given to curl-post-string");
      }
    }

    return new Value(cast(string)data);
  }
}
