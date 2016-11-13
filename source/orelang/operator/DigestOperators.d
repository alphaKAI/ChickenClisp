module orelang.operator.DigestOperators;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;
import std.digest.hmac,
       std.digest.sha,
       std.string;

class HMACSHA1Operator : IOperator {
  public Value call(Engine engine, Value[] args) {
    string key  = engine.eval(args[0]).getString,
           base = engine.eval(args[1]).getString;
    ubyte[20] dgst = base.representation.hmac!SHA1(key.representation);
    Value[] ret;

    foreach (e; dgst) {
      ret ~= new Value(e);
    }

    return new Value(ret);
  }
}