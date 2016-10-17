# Orelang\_TS
A minimal implementation of Orelang in TypeScript

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


# Implementation
Original implementation of Orelang in Java uses JSON and JSONIC for Syntax Analysis.  
You can write like Lisp(S-Expression) with trainspiler.  
Orelang\_TS provides a transpiler which converts S-Expression into internal expression of Orelang\_TS(JSON Array).  


# Installation
## Requirements

- tsc(1.8.7 or later)
- typings(1.4.0) <- install by `npm install -g typings`
- date-utils <- install by `npm install date-utils`

## Commands

```zsh:
$ git clone https://github.com/alphaKAI/Orelang_TS
$ cd Orelang_TS
$ typings install dt~node --global
$ tsc app.ts
```

app.ts includes some sample code.  


# License
Orelang\_TS is released under the MIT License.  
Please see `LICENSE` file for details.  

Copyright (C) 2016 Akihiro Shoji
