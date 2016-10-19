; 盤面の表示
(define (print-board board)
    ;
    (define (print-line q size)
        (display "| ")
        (let loop ((x 0))
            (when (< x size)
                (if (= x q)
                    (display "Q ")
                    (display ". "))
                (loop (+ x 1))))
        (display "|\n"))
    ;
    (define (print-waku size)
        (display "*-")
        (let loop ((x 0))
            (when (< x size)
                (display "--")
                (loop (+ x 1))))
        (display "*\n"))
    ;
    (let ((size (length board)))
        (print-waku size)
        (let loop ((ls board))
            (when (pair? ls)
                (print-line (car ls) size)
                (loop (cdr ls))))
        (print-waku size)
        (newline)))

(define (conflict? column line board)
  (let loop ((x (- column 1)) (ls board))
    (begin
    (cond ((null? ls) #f)
      ((or (= (- column line) (- x (car ls)))
           (= (+ column line) (+ x (car ls))))
       #t)
      (else
        (loop (- x 1) (cdr ls)))))))

(define (safe? line board)
  (cond ((null? board) true)
    ((conflict? (length board) line board) false)
    (else (safe? (car board) (cdr board)))))

(define (queen ls board)
  (cond ((null? ls)
    (if (safe? (car board) (cdr board))
    (print-board board)))
    (else
      (for-each
        (lambda (n)
                (queen (remove (lambda (x) (= x n)) ls)
                       (cons n board)))
        ls))))

; 高速版
(define (queen-fast ls board)
    (if (null? ls)
        (print-board board)
        (for-each
            (lambda (n)
                (if (not (conflict? (length board) n board))
                    (queen-fast
                        (remove (lambda (x) (= x n)) ls)
                        (cons n board))))
            ls)))

(queen-fast '(0 1 2 3 4 5 6 7) '())
