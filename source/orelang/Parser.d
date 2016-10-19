module orelang.Parser;
import orelang.expression.ImmediateValue,
       orelang.expression.SymbolValue,
       orelang.Value;
import std.regex,
       std.conv;

auto nrgx = ctRegex!"[0-9]";

class Parser {
  static size_t nextBracket(string code) {
    size_t index,
           leftCount = 1,
           rightCount;

    while (leftCount != rightCount) {
      if (code[index] == '(') { leftCount++; }
      if (code[index] == ')') { rightCount++; }
      ++index;
    }

    return index;
  }

  static Value[] parse(string code) {
    Value[] _out;

    for (size_t i; i < code.length; ++i) {
      char ch = code[i];

      if (ch == ' ') {
        continue;
      } else {
        if (ch == '(') {
          size_t j = nextBracket(code[i+1..$]);

          _out ~= new Value(parse(code[i+1..i+j]));

          i += j;
        } else if (ch == ')') {
          return _out;
        } else {
          if (ch.to!string.match(nrgx)) {
            string tmp;
            size_t j = i;

            do {
              tmp ~= code[j];
              ++j;
            } while (
                j < code.length &&
                ((code[j] != ' ' && code[j].to!string.match(nrgx))
                 ||  (code[j] == '.' && j + 1 < code.length && code[j + 1].to!string.match(nrgx)))
                );

            _out ~= new Value(tmp.to!double);

            i = j - 1;
          } else if (ch == '\"' || ch == '\'') {
            if (ch == '\'' && i + 1 < code.length && code[i + 1] == '(') {
              size_t j = nextBracket(code[i + 2..$]) + 1;

              _out ~= new Value(new ImmediateValue(new Value(parse(code[i+2..j+i]))));

              i += j;
            } else {
              string tmp;
              size_t j = i + 1;

              while (j < code.length && code[j] != ch) {
                if (j < code.length) {
                  tmp ~= code[j];
                } else {
                  throw new Error("Syntax Error");
                }

                ++j;
              }

              _out ~= new Value(tmp);
              i = j;
            }
          } else {
            string tmp;
            size_t j = i;

            while (
                j < code.length && code[j] != '\"' && code[j] != '\'' &&
                code[j] != '(' && code[j] != ')' && code[j] != ' '
                ) {
              tmp ~= code[j];
              ++j;
            }

            if (tmp == "true") {
              _out ~= new Value(true);
            } else if (tmp == "false") {
              _out ~= new Value(false);
            } else if (tmp == "null") {
              _out ~= new Value;
            } else {
              _out ~= new Value(new SymbolValue(tmp));
            }

            i = j;
          }
        }
      }
    }

    return _out;
  }
}
