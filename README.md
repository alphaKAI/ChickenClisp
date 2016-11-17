# ChickenClisp
A minimal implementation of Orelang in D.  
This program was translated from [Orelang\_TS](https://github.com/alphaKAI/Orelang_TS)  
ChickenClisp means an interpreter of extended Orelang and the language itself.  
ChickenClisp is just like a Scheme like Lisp.  

# What's Orelang?
Orelang is simple and minimal programming language declared at the article[プログラミング言語を作る。１時間で](http://qiita.com/shuetsu@github/items/ac21e597265d6bb906dc)  

# Features
This is an implementation of Orelang and provides more functions

* if/cond expression
* compare functions: >,>=,<,<=
* logics : and(&&), or(||), not(!)
* function definition
* Function/Operator is first-class object
* Lambda Expression (lambda keyword)
* Closure
* List support(and utilities like car, cdr)

This language aims an original scheme like lisp.  

# Specification of Orelang
This is not an original specification original is can be found at the article.  

## Grammer
Orelang provide only one grammer.

`Expr := (operator args1 args2...) <- this is CallOperator`  
`Expr := value <- this is ImmediateValue`

This looks like lisp.  

# Sample codes
Some sample code can be found at samples/ and sample.d is sample code runner, you can see sample codes have only to run it, but I'll show you some sample codes of ChickenClisp here.  

## Sum 1 to 10
### Procedural impl:
```scheme
(step
  (set i 0)
  (set sum 0)
  (while (<= i 10)
    (step
      (set sum (+ i sum))
      (set i (+ i 1))))
  (println "sum 1 to 10 : " sum))
```

### Functional(use high order function)
```scheme
; seq(n) creates a sequence of '(0 1 2 ... n)
(println (fold + 0 (seq 11)))
```

## Square 1 to 10 with high order function - map(/foreach)
```scheme
(println (map (lambda (x) (* x x)) (cdr (seq 11))))
```
  
You can define an function to square:
  
```scheme
(def square (x) (* x x))
(println (map square (cdr (seq 11))))
```
  
As you can see, Function is a first-class Object in ChickenClisp!.  
  
## Fibonacci
```scheme
(def fib (n)
  (step
    (if (= n 0) 0
      (if (= n 1) 1
        (+ (fib (- n 1)) (fib (- n 2)))))))
```
  
or:
  
```scheme
(def fib (n)
  (step
    (def fib-iter (n a b)
      (if (= n 0)
        a
        (fib-iter (- n 1) b (+ a b))))
    (fib-iter n 0 1)))
```
  
then:
  
```scheme
(println (map fib (seq 10)))
```
  
  
## More sample codes
More sample codes are wrote in `sample.d`.  

# Installation
## Requirements

- dmd(v2.070 or later)
- dub(1.0.0 or later) 

## Commands

```zsh:
$ git clone https://github.com/alphaKAI/ChickenClisp
$ cd ChickenClisp
$ dub build
$ ./chickenclisp
```

# License
ChickenClisp is released under the MIT License.  
Please see `LICENSE` file for details.  

Copyright (C) 2016 Akihiro Shoji
