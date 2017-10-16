module orelang.Transpiler;
import orelang.Parser,
       orelang.Value;
import std.regex;

class Transpiler {
  static Value transpile(string code) {
    import std.stdio;
    auto ret = Parser.parse(code.replaceAll(ctRegex!"\n", ""));
    if (ret.length) {
      return ret[0];
    } else {
      return new Value(0);
    }
  }
}
