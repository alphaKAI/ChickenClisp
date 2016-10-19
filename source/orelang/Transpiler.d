module orelang.Transpiler;
import orelang.Parser,
       orelang.Value;
import std.regex;

class Transpiler {
  static Value transpile(string code) {
    return Parser.parse(code.replaceAll(ctRegex!".*;.*", "").replaceAll(ctRegex!"\n", ""))[0];
  }
}
