// app
import {Engine} from "./Engine";
import {Transpiler} from "./Transpiler";

var engine: Engine         = new Engine();
var transpiler: Transpiler = new Transpiler();
/**
 * sum of 1 to 10
 */

var x = engine.eval(
  ["step",
    ["set", "i", 10],
    ["set", "sum", 0],
    ["until", ["=", ["get", "i"], 0], [
      "step",
      ["set", "sum", ["+", ["get", "sum"], ["get", "i"]]],
      ["set", "i", ["+", ["get", "i"], -1]]
    ]],
    ["get", "sum"]
  ]
);

/**
 * S Expression
 */
// loop 10 times and square 10
var code1: string = `
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
var code2: string = `
(step
  (set sum 0)
  (set i 1)
  (while (<= i 10)
    (step
      (set sum (+ sum i))
      (set i (+ i 1))))
  (println sum))
`;

var code3: string = `
(step
  (def fun (x) (* x 40))
  (set f fun)
  (println (f (fun 10))))
`;

var code4: string = `
(step
  (set x (lambda (y) (* y y)))
  (println (x 500))
  (println ((lambda (z) (* z 40)) 10)))
`;

var code5: string = `
(step
  (print '(1 2 3 4 5 6 789))
  (print (map (lambda (x) (* x x )) '(1 2 3 4 5))))
`;

var code6: string = `
(step
  (set arr (set-idx '(1 2 3 4 5) 2 100))
  (println (map (lambda (x) (* x 10)) arr)))
`;

var code7: string = `
(step
  (set x 10)
  (println x))
`;

var factor: string = `
(step
  (def factor (x)
    (if (<= x 1)
      1
      (* x (factor (- x 1)))))
  (println (factor 4))
  (println (factor 5)))
`
var fib = `
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

var fold = "(println (fold + 0 (map (lambda (x) (* x x)) (seq 10))))";

var codes = [
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


var idx: number = 1;

codes.forEach(code => {
  console.log("Sample code", idx++, " :");
  console.log("CODE----------------------------------------");
  console.log(code);
  console.log("OUTPUTS--------------------------------------");

  engine.eval(transpiler.transpile(code));
  console.log("\n");
});
