import std.stdio,
       std.regex;
import orelang.Transpiler;
void main() {
  string code = `
    (def foo (x)
      (step
      ;abc
        (set y 10)
        (set z (* x y))
        (println z)))
    `;

  //writeln(code.replaceAll(ctRegex!".*;.*", "").replaceAll(ctRegex!"\n", ""));
  writeln(Transpiler.transpile(code));
}
