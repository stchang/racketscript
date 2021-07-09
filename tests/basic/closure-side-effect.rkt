#lang racketscript/base

(define (foobar-int n)
  (define a (+ n 10))
  (define f (lambda (a)
              (+ n a)))
  (set! a 20)
  f)
(displayln ((foobar-int 10) 5))
(displayln ((foobar-int 14) 5))

(define (foobar-lst)
  (define l '(1 2))
  (define f (lambda (a)
              (cons a l)))
  (set! l '(3 4))
  f)
(displayln ((foobar-lst) 6))

(define (foobar-deep)
  (define l '(1 2))
  (define f (lambda (a)
              (define r (cons a l))
              (set! l '(8 9))
              r))
  (set! l '(3 4))
  f)
(define f (foobar-deep))
(displayln (f 6))
(displayln (f 7))