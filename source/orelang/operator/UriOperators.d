module orelang.operator.UriOperators;
import orelang.operator.IOperator,
       orelang.Engine,
       orelang.Value;
import std.regex,
       std.uri : encodeComponentUnsafe = encodeComponent;

static string encodeComponent(string s) {
  char hexChar(ubyte c) {
    assert(c >= 0 && c <= 15);
    if (c < 10)
      return cast(char)('0' + c);
    else
      return cast(char)('A' + c - 10);
  }

  enum InvalidChar = ctRegex!`[!\*'\(\)]`;

  return s.encodeComponentUnsafe.replaceAll!((s) {
        char c = s.hit[0];
        char[3] encoded;
        encoded[0] = '%';
        encoded[1] = hexChar((c >> 4) & 0xF);
        encoded[2] = hexChar(c & 0xF);
        return encoded[].idup;
      })(InvalidChar);
}

class UrlEncodeComponentOperator : IOperator {
  /**
   * call
   */

   Value call(Engine engine, Value[] args) {
     string s = engine.eval(args[0]).getString;

     return new Value(encodeComponent(s));
   }
}