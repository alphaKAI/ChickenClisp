module orelang.Interpreter;
import orelang.Transpiler,
       orelang.Engine;
import std.conv,
       std.stdio,
       std.string;

class Interpreter {
  private {
    Engine engine;
    Transpiler transpiler;
    long bracketState;
  }

  this() {
    this.engine     = new Engine();
    this.bracketState = 0;
  }

  bool checkBracket(string code) {
    for (size_t i; i < code.length; ++i) {
      char ch = code[i];

      if (ch == '(') { this.bracketState++; }
      if (ch == ')') { this.bracketState--; }
    }

    if (this.bracketState == 0) {
      return true;
    } else {
      return false;
    }
  }

  void interpreter() {
    string buf;
    write("=> ");

    void e(char val) {
      if (checkBracket(val.to!string) && (buf.length != 0)) {
//        writeln("buf -> ", buf);
        auto transpiled = Transpiler.transpile(buf);
//        writeln("transpiled -> ", transpiled);
        writeln(engine.eval(transpiled));
        buf = [];
      }
    }

    while (true) {
      string input = readln.chomp;

      if (input == "exit" || input == "(exit)") {
        break;
      }

      foreach (char val; input) {
        if ('\n' == val) {
          e(val);
        } else {
          buf ~= val;
          e(val);
        }
      }

      for (size_t i; i < bracketState + 1; ++i) {
        write("=");
      }
      write("> ");
    }
  }
}
