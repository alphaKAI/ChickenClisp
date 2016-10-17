module orelang.Parser;
import orelang.expression.ImmediateValue,
       orelang.Value;
import std.variant,
       std.regex,
       std.conv;

enum isN = ctRegex!(r"[0-9]+");

class Parser {
  static size_t nextBracket(string code) {
    size_t i;
    size_t leftCount = 1;
    size_t rightCount;

    while (leftCount != rightCount) {
      if (code[i] == '(') { leftCount++; }
      if (code[i] == ')') { rightCount++; }
      ++i;
    }

    return i;
  }

  static Value parse(string code) {
    Value _out = Value([Value([Value(1L)])]);
    _out.peek!(Value[]).length = 0;

    for (size_t i; i < code.length; i++) {
      char ch = code[i];

      if (ch == ' ') {
        continue;
      } else {
        if (ch == '(') {
          size_t j = Parser.nextBracket(code[i+1..$]);

          _out ~= Value([Parser.parse(code[i+1..i + j])]);
          //_out ~= Parser.parse(code[i+1..i + j]);

          i += j;
        } else if (ch == ')') {
          return Value(_out);
        } else {
          if (ch.to!string.match(isN) ? true : false) {
            string tmp;
            size_t j = i;
            bool flt;

            do {
              tmp ~= code[j];
              if (code[j] == '.') { flt = true; }
              ++j;
            } while (
                j < code.length &&
                (
                  (code[j] != ' ' && code[j].to!string.match(isN) ? true : false)
               || (code[j] == '.' && j + 1 < code.length && (code[j + 1]).to!string.match(isN) ? true : false)));

            _out ~= Value([Value(tmp.to!double)]);
//            _out ~= Value(tmp.to!double);

            i = j-1;
          } else if (ch == '\"' || ch == '\'') {
            if (ch == '\'' && code[i + 1] && code[i + 1] == '(') {
              size_t j = Parser.nextBracket(code[i + 2..$]) + 1;

//              Value x = Parser.parse(code[i+2..j+i]);
//              _out ~= x;
              import std.stdio;
              writeln("Parser.parse(code[i+2..j+i]) -> ", Parser.parse(code[i+2..j+i]));
              
                _out ~= Value([Value(new ImmediateValue(Value(
                          [Parser.parse(code[i+2..j+i])]
                        )))]);             

              i += j;
            } else {
              string tmp;
              size_t j = i+1;

              while (code[j] != ch && code[j] ) {
                if (j < code.length) {
                  tmp ~= code[j];
                } else {
                  throw new Error("Syntax Error");
                }
                ++j;
              }

              _out ~= Value([Value(tmp)]);
//              _out ~= Value(tmp);
              i = j;
            }
          } else {
            string tmp;
            size_t j = i;

            while (
              j < code.length &&
              code[j] && code[j] != '\"' && code[j] != '\'' &&
              code[j] != '(' && code[j] != ')' && code[j] != ' ') {
              tmp ~= code[j];
              ++j;
            }

            if (tmp == "true") {
              _out ~= Value([Value(true)]);
//              _out ~= Value(true);
            } else if (tmp == "false") {
              _out ~= Value([Value(false)]);
//              _out ~= Value(false);
            } else if (tmp == "null") {
              _out ~= Value([Value(null)]);
//              _out ~= Value(null);
            } else {
              _out ~= Value([Value(tmp)]);
//              _out ~= Value(tmp);
            }

            i = j;
          }
        }
      }
    }

    return Value(_out);
  }
}
/*
void main() {
  import std.stdio;
  writeln("parsed -> ", Parser.parse(`(foo 12345 "abcdef" (abc hij) '(1 2 3 4 5 6 789))`));
}*/
