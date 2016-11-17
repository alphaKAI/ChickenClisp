module orelang.Interpreter;
import orelang.Transpiler,
       orelang.Engine,
       orelang.Value;
import std.string,
       std.stdio,
       std.conv;

// TODO: Need to implement exit operator

class Interpreter {
  private {
    Engine     engine;
    Transpiler transpiler;
    long       bracketState;
  }

  this() {
    this.engine       = new Engine();
    this.bracketState = 0;
  }

  this(Engine engine) {
    this.engine       = engine;
    this.bracketState = 0;
  }

  void defineARGS(string[] args) {
    Value[] vargs;

    foreach (arg; args) {
      vargs ~= new Value(arg);
    }

    this.engine.defineVariable("ARGS", new Value(vargs));
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

  Value executer(string code) {
    string buf;
    Value ret;

    void e(char val) {
      if (checkBracket(val.to!string) && (buf.length != 0)) {
        auto transpiled = Transpiler.transpile(buf);
        ret = engine.eval(transpiled);
        buf = [];
      }
    }

    foreach(input; code.split("\n")) {
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
    }

    return ret;
  }
}
