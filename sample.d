import orelang.Transpiler,
       orelang.Engine,
       orelang.Value;
import std.stdio;
void main() {
  /**
 * sum of 1 to 10
 */
/*
  Value x = engine.eval(
    new Value([new Value("step"),
      new Value([new Value("set"), new Value("i"), new Value(10.0)]),
      new Value([new Value("set"), new Value("sum"), new Value(0.0)]),
      new Value([new Value("until"), new Value([new Value("="), new Value([new Value("get"), new Value("i")]), new Value(0.0)]), new Value([
        new Value("step"),
        new Value([new Value("set"), new Value("sum"), new Value([new Value("+"), new Value([new Value("get"), new Value("sum")]), new Value([new Value("get"), new Value("i")])])]),
        new Value([new Value("set"), new Value("i"), new Value([new Value("+"), new Value([new Value("get"), new Value("i")]), new Value(-1.0)])])
      ])]),
      new Value([new Value("get"), new Value("sum")])
    ])
  );*/

  /**
   * S Expression
   */
  // loop 10 times and square 10
  string code1 = `
    (step
     (def square (x)
      (step
       (set y (* x x))
       (set z (* x x))
       (* y z)))
     (set x 1)
     (while (< x 11)
      (step
       (print x)
       (set x (+ x 1))))
     (println (square 10)))
    `;

  // sum 1 to 10
  string code2 = `
    (step
     (set sum 0)
     (set i 1)
     (while (<= i 10)
      (step
       (set sum (+ sum i))
       (set i (+ i 1))))
     (println sum))
    `;

  string code3 = `
    (step
     (def fun (x) (* x 40))
     (set f fun)
     (println (f (fun 10))))
    `;

  string code4 = `
    (step
     (set x (lambda (y) (* y y)))
     (println (x 500))
     (println ((lambda (z) (* z 40)) 10)))
    `;

  string code5 = `
    (step
     (print '(1 2 3 4 5 6 789))
     (print (map (lambda (x) (* x x)) '(1 2 3 4 5))))
    `;

  string code6 = `
    (step
     (set arr (set-idx '(1 2 3 4 5) 2 100))
     (println (map (lambda (x) (* x 10)) arr)))
    `;

  string code7 = `
    (step
     (set x 10)
     (println x))
    `;

  string factor = `
    (step
     (def factor (x)
      (if (<= x 1)
       1
       (* x (factor (- x 1)))))
     (println (factor 4))
     (println (factor 5)))
    `;
  string fib = `
    (step
     (def fib (n) (step
                   (if (= n 0) 0
                    (if (= n 1) 1
                     (+ (fib (- n 1)) (fib (- n 2)))))))
     (def-var i 0)
     (while (< i 10) (step
                      (println (fib i))
                      (set i (+ i 1)))))
    `;

  string fold = "(println (fold + 0 (map (lambda (x) (* x x)) (seq 10))))";

  string[] codes = [
    code1,
    code2,
    code3,
    code4,
    code5,
    code6,
    code7,
    factor,
    fib,
    fold
  ];


  size_t idx;

  foreach (code; codes) {
    Engine engine = new Engine();
    writeln("Sample code", idx++, " :");
    writeln("CODE----------------------------------------");
    writeln(code);
    writeln("OUTPUTS--------------------------------------");

    engine.eval(Transpiler.transpile(code));
    writeln("\n");
  }
}
