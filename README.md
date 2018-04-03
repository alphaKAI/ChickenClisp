# ChickenClisp
Scheme風の文法を持つLisp言語(インタプリタ)  
ChickenClispには複数の処理系を自分で実装したが([TypeScriptによるもの](https://github.com/alphaKAI/ChickenClisp_ts), [Pythonによるもの](https://github.com/alphaKAI/ChickenClisp_py))これはD言語で実装したものである．  
GithubにてMITライセンスのもとでオープンソースで公開している: [ChickenClisp](https://github.com/alphaKAI/ChickenClisp)  
  
  
## ChickenClispの文法
ChickenClispのプログラムは[S式](https://ja.wikipedia.org/wiki/S式)で記述する．  

```scheme
(関数名 引数1 引数2)
```

というように書く．  
複数行の式を1つの式としたい場合は次のように書く(1番最後の式がその式の値になる)  

```scheme
(begin
  (式1)
  (式2)
  (式3 ←この式の値がbeginから始まるブロックの値となる))
```

(beginの代わりにstepを用いてもいい)

## ChickenClispの機能

ChickenClispでは関数は第1級オブジェクトである．  
また，提供するリテラルとして，10進整数(64bit符号付き整数型)，倍精度浮動小数点数，string型，クロージャ型，マクロ，クラスがある．  

ChickenClispは以下の機能を提供する  

* 関数型プログラミングやオブジェクト指向プログラミングなどマルチパラダイムサポート
* ifやcondによる条件分岐
* whileやloop関数によるループ
* 関数定義
* 無名関数(ラムダ式)
* クロージャ
* マクロ(構文木を操作可能)
* クラス定義可能なclass構文
* File操作やネットワークプログラミング，正規表現を行うための標準ライブラリ
* リスト操作のための豊富な標準関数
  
  
以下には標準ライブラリとして実装した関数について説明する．

### 算術演算子

|関数名|説明|使用例|
|:-----|:---|:-----|
|+|和(2項演算子)|(+ 1 2)|
|-|差(2項演算子)|(- 1 2)|
|\*|積(2項演算子)|(\* 1 2)|
|/|商(2項演算子)|(/ 1 2)|
|%|剰余(2項演算子)|(% 3 2)|

### 比較演算子

|関数名|説明|使用例|
|:-----|:---|:-----|
|=|a = bとしたとき，aとbが等しいかを比較する(2項演算子)|(= 1 1)|
|<|a < bとしたとき，a < b となるか比較する(2項演算子)|(< 1 2)|
|>|a > bとしたとき，a > b となるか比較する(2項演算子)|(> 1 2)|
|<=|a <= bとしたとき，a <= b となるか比較する(2項演算子)|(<= 1 2)|
|>=|a >= bとしたとき，a >= b となるか比較する(2項演算子)|(>= 1 2)|
  
  
### 変数/関数定義のための関数

|関数名|説明|使用例|
|:-----|:---|:-----|
|def|関数を定義する|(def square (x) (\* x x))|
|set|変数に値を設定する|(set x 0)|
|set-p|大域スコープの変数に値をセットする|(set-p x 0)|
|set-c|インスタンス変数に値をセットする|(set-c x 0)|
|get|変数の値を取得する|(get x)|
|let|ブロック変数を定義する|(let ((x 1) (y 2)) (+ x y))|
|as-iv|リテラルを即値型(ImmediateValue型)に変換する|(as-iv 1)|
|def-var|変数を定義する|(def-var x 0)|
|def-macro|マクロを定義する|(def-macro calc (op a b) (op a b))とした後に(calc + 1 3)や(calc * 1 3)|
  
  
### ループのための関数

|関数名|説明|使用例|
|:-----|:---|:-----|
|step|複数行の式を1つの式にする関数(複文のための関数)|(step <br> &nbsp; &nbsp; &nbsp; &nbsp; (expr1) <br> &nbsp; &nbsp; &nbsp; &nbsp; (expr2) <br> &nbsp; &nbsp; &nbsp; &nbsp; (expr3))|
|times|第1引数に指定した回数，第2引数に渡した式を評価する|(times 4 (println "foo"))|
|until|第1引数に指定した条件式が真になるまで，第2引数に渡した式を評価する|(def-var x 0)<br>(until (> x 5)<br>&nbsp;(step<br>&nbsp;&nbsp;  (println x)<br>&nbsp;&nbsp;  (set x (+ x 1))))|
|until|第1引数に指定した条件式が真であるあいだ，2引数に渡した式を評価する|(def-var x 0)<br>(while (< x 5)<br>&nbsp;(step<br>&nbsp;&nbsp;  (println x)<br>&nbsp;&nbsp;  (set x (+ x 1))))|
  
  
### 論理演算子

|関数名|説明|使用例|
|:-----|:---|:-----|
|!|論理否定をする|(! true)|
|&&|論理積|a && b|
|&#124;&#124;|論理和|a &#124;&#124; b|
  
  
### 標準出力関数
|関数名|説明|使用例|
|:-----|:---|:-----|
|print|与えられた複数個の式を標準出力に出力する|(print 1 2 3)|
|println|与えられた複数個の式を標準出力に出力し，末尾で改行を行う|(println 1 2 3)|
  
  
### 条件分岐のための関数
|関数名|説明|使用例|
|:-----|:---|:-----|
|if|第1引数に与えられた式を評価し，真なら第2引数に与えられた式を，<br>偽なら第3引数に与えられた式を評価する<br>(第3引数は省略可能で，その場合は偽の場合は何も行われない)| (if (= 1 1) "true" "false")|
|cond|複数の式をとり，その式は<br>((条件式) (条件式式が真の場合に評価される式))という形となって，<br>上から順に評価していき，条件式が真になった場合に対応する式を評価する．<br>1つもマッチしなかった場合かつelseがある場合はelseが評価される|(def-var x 2)<br>(cond ((= x 0) (println "x is 0"))<br>&nbsp;&nbsp;((= x 1) (println "x is 1"))<br>&nbsp;&nbsp;(else (println "x is not 0 or 1)))|
|when|第1引数に与えられた式を評価し，真なら第2引数以降に与えられた式を評価する|(def-var x true)<br>(when x<br>&nbsp;&nbsp;(print "x is ")<br>&nbsp;&nbsp;(println x))|
  
  
### リスト操作のための関数
|関数名|説明|使用例|
|:-----|:---|:-----|
|car|リストの第1要素を取り出す|(car '(1 2 3))|
|cdr|リストの第2要素以降を取り出す|(cdr '(1 2 3))|
|seq|与えられた個数の整数からなるリストを生成する|(seq 5) ←これは'(0 1 2 3 4)と等しい|
|cons|与えられた引数からリストを生成する|(cons 1 2)|
|sort|与えられたリストをソートする|(sort '(3 2 1))|
|list?|与えられたリテラルがリストであるかを判定する|(list? x)|
|remove|filterと似ているが，マッチした要素を消す|(remove (lambda (x) (= x 1)) '(1 2 3))|
|length|リストの長さを得る|(length '(1 2 3))|
  
  
### 関数型プログラミング言語由来の関数
|関数名|説明|使用例|
|:-----|:---|:-----|
|lambda|無名関数(ラムダ式)を定義する|(lambda (x) (+ x x))|
|map|リストに対し関数を射影する|(map (lambda (x) (\* x x)) '(1 2 3))|
|for-each|リストに対し関数を適応する|(for-each (lambda (x) (\* x x)) '(1 2 3))|
|fold|リストに対し関数を適用し畳み込む|(def max (x y) (if (> x y) x y))<br>(print (fold max 0 '(5 3 4 2 1)))|
|filter|第1引数に与えられた関数に，第2引数に与えられたリストから値をそれぞれ適用し，関数が真になる値だけを集める|(filter (lambda (x) (= 0 (% x 2))) '(1 2 3 4 5 6))|
  
  
### ハッシュマップに関する関数
|関数名|説明|使用例|
|:-----|:---|:-----|
|new-hash|hashを生成する|(new-hash)|
|make-hash|hashを生成する|(make-hash a) ←aという変数名のhashmapを生成する|
|hash-set-value|hashに値を設定する|(hash-set-value a "apple" "red")|
|hash-get-value|hashの値を取得する|(hash-get-value a "apple")|
|hash-get-keys|hashのkeyを全てリストとして取得する|(hash-set-keys a)|
|hash-get-values|hashのvalueを全てリストとして取得する|(hash-set-values a)|
  
  
### 文字列操作の関数
|関数名|説明|使用例|
|:-----|:---|:-----|
|string-concat|文字列を連結する|(string-concat "Apple is " "red")|
|string-join|リストをjoinする|(string-join '("a" "b" "c") ",")|
|string-split|区切り文字で文字列を分割する|(string-split "a,b,c" ",")|
|string-length|文字列の長さを取得する|(string-length "abc")|
|string-slice|文字列のスライスを取得する|(string-slice "abcd" 1 3)|
|as-string|リテラルを文字列に変換する|(as-string 5)|
|string-repeat|与えられた文字列を指定回繰り返す|(string-repeat "abc" 5)|
|string-chomp|与えられた文字列の末尾の改行を除く|(string-chomp "abc\n")|
  
  
### 型変換関数
|関数名|説明|使用例|
|:-----|:---|:-----|
|number-to-string|数値を文字列に変換する|(number-to-string 1)|
|string-to-number|文字列を数値に変換する|(string-to-number "1")|
|number-to-char|数値をASCII charに変換する|(number-to-char 97)|
|char-to-number|ASCII charを数値に変換する|(char-to-number "a")|
|float-to-integer|浮動小数点数を整数に変換する|(float-to-integer 1.0)|
|ubytes-to-string|バイト列を文字列に変換する|省略|
|ubytes-to-integers|バイト列を整数列に変換する|省略|
  
  
### 配列操作系の関数
|関数名|説明|使用例|
|:-----|:---|:-----|
|array-new|配列を生成する|(array-new)|
|array-get-n|配列のn番目を取得する|(array-get-n arr 2)|
|array-set-n|配列のn番目に値を設定する|(array-set-n arr 2 100)|
|array-slice|配列のスライスをとる|(array-slice '(1 2 3 4 5 6) 1 3)|
|array-append|配列に値を追加する|(array-append '(1 2 3) 4)|
|array-concat|配列を連結する|(array-concat '(1 2) '(3 4))|
|array-length|配列の長さを取得する|(array-length '(1 2 3))|
|array-flatten|配列を平坦化する|(array-flatten '('(1 2 3) '(4 5 6)))|
|array-reverse|配列を反転させる|(array-reverse '(3 2 1))|
  
  
### ユーティリティ関数
|関数名|説明|使用例|
|:-----|:---|:-----|
|eval|与えられた文字列をChickenClispのインタプリタで実行する|(eval "(+ 1 2)")|
|load|文字列として与えられたpathのファイルを読み込む|(load "foo.ore")|
|type|リテラルの型を得る|(type 0)|
|alias|関数や変数のaliasをつくる|(alias x y)|
|assert|与えられた式が真であるかを判定し，偽の場合，例外を投げる|(assert (list? l))|
|is-null?|与えられたリテラルがnullであるかを判定する|(is-null? x)|
|is-hash?|与えられたリテラルがhashであるかを判定する|(is-hash? x)|
|transpile|与えられた文字列をChickenClispの内部表現にトランスパイルする|(transpile "(+ 1 2)")|
  
  
### ネットワークプログラミング用の関数(libcurlのラッパー)
|関数名|説明|使用例|
|:-----|:---|:-----|
|curl-download|第1引数に与えられた文字列のURLを，<br>第2引数で与えられたパスにダウンロードする|(curl-download "https://example.com" "download\_test")|
|curl-upload|第1引数に与えられたパスのファイルを，<br>第2引数で与えられたURLにアップロードする|(curl-upload "download\_test" "https://example.com")|
|curl-get|引数に与えられたURLにGETリクエストをする(戻り値はバイト列)|(curl-get "https://httpbin.org/get")|
|curl-get|引数に与えられたURLにGETリクエストをする(戻り値は文字列)|(curl-get-string "https://httpbin.org/get")|
|curl-post|第1引数に与えられたURLに，第2引数に与えられたバイト列をペイロードとしてPOSTリクエストをする．(戻り値はバイト列)|(curl-post "https://httpbin.org/post"<br>&nbsp; (curl-get "https://httpbin.org/get"))|
|curl-post-string|第1引数に与えられたURLに，第2引数に与えられたバイト列をペイロードとしてPOSTリクエストをする．(戻り値は文字列)|(curl-post-string "https://httpbin.org/post" (curl-get "https://httpbin.org/get"))|
  
  
### URLエンコードのための関数
|関数名|説明|使用例|
|:-----|:---|:-----|
|url-encode-component|引数に与えられた文字列をURLエンコードする|(url-encode-component "あいう")|
  
  
### UUIDについての関数
|関数名|説明|使用例|
|:-----|:---|:-----|
|random-uuid|ランダムなUUID文字列を生成する|(random-uuid)|
  
  
### 時刻処理についての関数
|関数名|説明|使用例|
|:-----|:---|:-----|
|get-current-unixtime|現在時刻のUNIXTIMEを取得する|(get-current-unixtime)|
  
  
### ハッシュダイジェストについての関数
|関数名|説明|使用例|
|:-----|:---|:-----|
|hmac-sha1|第2引数に与えられた文字列を，第1引数に与えられた文字列でhmac-sha1を計算する|(hmac-sha1 "key" "base")|
  
  
### デバッグのための関数
|関数名|説明|使用例|
|:-----|:---|:-----|
|dump-variables|スコープ内の全ての関数(それまでに使われたものだけ)/変数(定義されたもの)をダンプする|(dump-variables)|
|peek-closure|引数に与えられたクロージャについての情報を取得する)|(peek-closure peek-closure)|
|call-closure|引数に与えられたクロージャをデバッグ情報付きで実行する|(call-closure println "a")|
|toggle-ge-dbg|スタックトレースの表示をトグルする|(toggle-ge-dbg)|
  
  
### オブジェクト指向プログラミングにおけるクラスに関する関数
|関数名|説明|使用例|
|:-----|:---|:-----|
|class|classを定義するための関数|(class TestClass<br>&nbsp;&nbsp;(def-var x 10)<br>&nbsp;&nbsp;(def constructor (k) (set-p x k))<br>&nbsp;&nbsp;(def memberFunc () (println "memberFunc is called!"))<br>&nbsp;&nbsp;(def add (x y) (+ x y)))|
|new|クラスのインスタンスを生成する|(begin<br>&nbsp;&nbsp;(def-var tc (new TestClass 200))<br>&nbsp;&nbsp;(tc memberFunc)<br>&nbsp;&nbsp;(println (tc add 1 3))<br>&nbsp;&nbsp;(println (tc x))<br>&nbsp;&nbsp;(println ((new TestClass 400) x)))|
  
  
### ファイルパスについての関数
|関数名|説明|使用例|
|:-----|:---|:-----|
|path-exists|与えられたファイルパスが存在するかを返す|(path-exists "foo")|
|path-is-dir|与えられたパスがディレクトリであるかを返す|(path-exists "foo")|
|path-is-file|与えられたパスがファイルであるかを返す|(path-is-file "foo")|
  
  
### ファイル操作のための関数
|関数名|説明|使用例|
|:-----|:---|:-----|
|remove-file|与えられたパスのファイルを削除する|(remove-file "foo")|
|remove-dir|与えられたパスのディレクトリを削除する|(remove-dir "foo")|
|get-cwd|カレントディレクトリのパスを返す|(get-cwd)|
|get-size|与えられたパスのファイルのサイズを返す|(get-size)|
  
  
### 標準入力に関数る関数
|関数名|説明|使用例|
|:-----|:---|:-----|
|readln|標準入力から1行読み込む|(readln)|
|stdin-by-line|標準入力からEOFに到達するまで読み込む|(stdin-by-line)|
|stdin-eof|EOFを表す定数を返す|(stdin-eof)|
  
  
### 乱数についての関数
|関数名|説明|使用例|
|:-----|:---|:-----|
|random-uniform|第1引数と第2引数で与えられた範囲内の乱数を返す(乱数生成アルゴリズムはMT19937)|(random-uniform 0 10)|
  
  
### なにもしないことを表す関数
|関数名|説明|使用例|
|:-----|:---|:-----|
|nop|なにもしないことを表す関数(プレースホルダとして用いる)| (def fun () (nop)) |
  
  
### Cのsystem関数ラッパー
|関数名|説明|使用例|
|:-----|:---|:-----|
|system|引数に与えられた文字列をシェルで実行する|(system "echo foo")|
  
  
### 標準ライブラリで提供されるクラス
|関数名|説明|メンバ関数|
|:-----|:---|:-----|
|FileClass|ファイル操作についてのクラス|コンストラクタ:(new FileClass "ファイルパス" "モード(w,r,wb,rbのどれか)")<br> raw-read: バイト列としてファイルを読み込む<br>raw-write: バイト列をファイルに書き込む<br>write: 引数に与えられたリテラルをファイルに書き込む<br>writeln: 引数に与えられたリテラルをファイルに書き込み，末尾で改行する<br>readln: ファイルから1行読み込む<br>readall: ファイルの内容をすべて読み込む|
|Regex|正規表現についてのクラス|コンストラクタ: (new Regex "正規表現のパターン")<br>reset:引数に与えられたパターンをインスタンスに再設定する<br>与えられた文字列のなかでパターンにマッチするものを返す<br>match-all: 与えられた文字列のなかでパターンにマッチするものを全て返す<br>show-ptn: コンストラクタ/resetで渡された正規表現のパターンを返す|
  
  
### 便利性のためのalias
|alias|alias先|
|:----|:------|
|not|!|
|and|&&|
|or|&#124;&#124;|
|begin|step|

## ChickenClispのサンプルプログラム
`sample.d`と`samples`以下にサンプルコードを収録したが，以下にその中でも抜粋したソースコードを記載し，サンプルプログラムとする．  

samplesディレクトリに収録したサンプルコードの説明を以下の表で行う．  

|ファイル名|概要|
|:---------|:---|
|base64.ore|Base64エンコーダの実装|
|base64\_sample.ore|base64.oreを用いて実際にBase64エンコードをする例|
|fizzbuzz.ore|fizzbuzzの実装|
|tak.ore|竹内関数の実装(ベンチマーク用)|
|nqueen.ore|N-queenソルバーの実装|
|nqueen.scm|N-queenソルバーのSchemeによる実装(ChickenClispとのコードの比較用)|
|twitter.ore|標準ライブラリのネットワークプログラミング用の関数を用いたTwitter APIラッパーライブラリ|
|twitter\_sample.ore|twitter.oreを用いて実際にTwitterのAPIを使用するサンプル|
|befunge.ore|befungeという言語のインタプリタ|
  

以下にサンプルコードを記載する:

### [1から10までの和]
#### 手続き型的な実装:
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

#### 高階関数を用いた関数型的な実装
```scheme
; seq(n) creates a sequence of '(0 1 2 ... n)
(println (fold + 0 (seq 11)))
```

### [map関数を用いた(foreach関数でも可)1から10までをそれぞれ平方する]
```scheme
(def square (x) (* x x))
(println (map square (cdr (seq 11))))
```
  
上でも述べたが，このサンプルコードから分かるように，ChickenClispでは関数は第1級オブジェクトである．  
また，関数を定義しなくてもラムダ式で以下のようにも書ける．  
  
```scheme
(println (map (lambda (x) (* x x)) (cdr (seq 11))))
```
  
  
### [Fibonacci数列]
```scheme
(def fib (n)
  (step
    (if (= n 0) 0
      (if (= n 1) 1
        (+ (fib (- n 1)) (fib (- n 2)))))))
```
  
#### 末尾呼び出しにしたもの
  
```scheme
(def fib (n)
  (step
    (def fib-iter (n a b)
      (if (= n 0)
        a
        (fib-iter (- n 1) b (+ a b))))
    (fib-iter n 0 1)))
```
  
上のように定義したあとで，下のように書くことで，n=0~9までのfib(n)の列が得られる．  
  
```scheme
(println (map fib (seq 10)))
```

## 前提環境
ChickenClispはLinux，BSD，macOS，Windowsでの動作を確認している．また，動作を確認したコンパイラとパッケージ管理システムのバージョンは  

* dmd v2.070
* dub 1.0.0

である．  
  
  
## インストール
gitが使える状態で，以下のコマンドをシェルで入力することでインストールができる．  

```zsh:
$ git clone https://github.com/alphaKAI/ChickenClisp
$ cd ChickenClisp
$ dub build
```
  
  
## ライセンス
ChickenClispはMITライセンスのもとで公開しています．  
ライセンスについての詳細については同梱の`LICENSE`ファイルを見てください．  
  
Copyright (C) 2016-2018 Akihiro Shoji
