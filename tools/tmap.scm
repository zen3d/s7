;;; sequence tests

(set! (*s7* 'heap-size) (* 4 1024000))

(define (less-than a b)
  (or (< a b) (> b a)))

(define (less-than-2 a b)
  (if (not (real? a)) (display "oops"))
  (cond ((< a b) #t) (#t #f)))

(define (char-less-than a b) 
  (cond ((char<? a b) #t) (else #f)))


(define (fv-tst len)
  (let ((fv (make-float-vector len)))
    (if (not (= (length fv) len))
	(format *stderr* "float-vector length ~A: ~A~%" fv (length fv)))
    (fill! fv 0.0)
    (let ((fv-orig (copy fv)))
      (do ((i 0 (+ i 1)))
	  ((= i len))
	(float-vector-set! fv i (- (random 1000.0) 500.0)))
      (do ((i 0 (+ i 1)))
	  ((= i len))
	(set! (fv i) (- (random 1000.0) 500.0)))
      (let ((fv-ran (copy fv))
	    (fv-ran1 (copy fv)))
	(sort! fv <)
	(do ((i 1 (+ i 1)))
	    ((= i len))
	  (if (> (float-vector-ref fv (- i 1)) (float-vector-ref fv i))
	      (display "oops")))
	(do ((i 1 (+ i 1)))
	    ((= i len))
	  (if (> (fv (- i 1)) (fv i))
	      (display "oops")))
	(sort! fv-ran (lambda (a b) (< a b)))
	(if (not (equivalent? fv fv-ran))
	    (format *stderr* "float-vector closure not equal~%"))
	(sort! fv-ran1 less-than)
	(if (not (equivalent? fv fv-ran1))
	    (format *stderr* "float-vector cond closure not equal~%")))

      (let ((fv-copy (copy fv)))
	(reverse! fv)
	(if (and (not (equivalent? fv-copy fv))
		 (equivalent? fv fv-orig))
	    (format *stderr* "float-vector reverse!: ~A ~A~%" fv fv-orig))
	(reverse! fv)
	(if (not (equivalent? fv-copy fv))
	    (format *stderr* "float-vector reverse! twice: ~A ~A~%" fv fv-copy))
	(let ((fv1 (apply float-vector (make-list len 1.0))))
	  (if (not (and (= (length fv1) len)
			(= (fv1 (- len 1)) 1.0)))
	      (format *stderr* "float-vector apply: ~A ~A~%" len (fv (- len 1)))))
	))))

(define (iv-tst len)
  (let ((fv (make-int-vector len)))
    (if (not (= (length fv) len))
	(format *stderr* "int-vector length ~A: ~A~%" fv (length fv)))
    (fill! fv 0)
    (let ((fv-orig (copy fv)))
      (do ((i 0 (+ i 1)))
	  ((= i len))
	(int-vector-set! fv i (- (random 1000000) 500000)))
      (do ((i 0 (+ i 1)))
	  ((= i len))
	(set! (fv i) (- (random 1000000) 500000)))
      (let ((fv-ran (copy fv))
	    (fv-ran1 (copy fv)))
	(sort! fv <)
	(do ((i 1 (+ i 1)))
	    ((= i len))
	  (if (> (int-vector-ref fv (- i 1)) (int-vector-ref fv i))
	      (display "oops")))
	(do ((i 1 (+ i 1)))
	    ((= i len))
	  (if (> (fv (- i 1)) (fv i))
	      (display "oops")))
	(sort! fv-ran (lambda (a b) (< a b)))
	(if (not (equal? fv fv-ran))
	    (format *stderr* "int-vector closure not equal~%"))
	(sort! fv-ran1 less-than)
	(if (not (equal? fv fv-ran1))
	    (format *stderr* "int-vector cond closure not equal~%")))
	
      (let ((fv-copy (copy fv)))
	(reverse! fv)
	(if (and (not (equal? fv-copy fv))
		 (equal? fv fv-orig))
	    (format *stderr* "int-vector reverse!: ~A ~A~%" fv fv-orig))
	(reverse! fv)
	(if (not (equal? fv-copy fv))
	    (format *stderr* "int-vector reverse! twice: ~A ~A~%" fv fv-copy))
	))))

(define (v-tst len)
  (let ((fv (make-vector len)))
    (if (not (= (length fv) len))
	(format *stderr* "vector length ~A: ~A~%" fv (length fv)))
    (fill! fv 0)
    (let ((fv-orig (copy fv)))
      (do ((i 0 (+ i 1)))
	  ((= i len))
	(vector-set! fv i (- (random 1000000) 500000)))
      (do ((i 0 (+ i 1)))
	  ((= i len))
	(set! (fv i) (- (random 1000000) 500000)))
      (let ((fv-ran (copy fv))
	    (fv-ran1 (copy fv)))
	(sort! fv <)
	(do ((i 1 (+ i 1)))
	    ((= i len))
	  (if (> (vector-ref fv (- i 1)) (vector-ref fv i))
	      (display "oops")))
	(do ((i 1 (+ i 1)))
	    ((= i len))
	  (if (> (fv (- i 1)) (fv i))
	      (display "oops")))
	(sort! fv-ran (lambda (a b) (< a b)))
	(if (not (equal? fv fv-ran))
	    (format *stderr* "vector closure not equal~%"))
	(sort! fv-ran1 less-than-2)
	(if (not (equal? fv fv-ran1))
	    (format *stderr* "vector cond closure not equal~%")))
	
      (let ((fv-copy (copy fv)))
	(reverse! fv)
	(if (and (not (equal? fv-copy fv))
		 (equal? fv fv-orig))
	    (format *stderr* "vector reverse!: ~A ~A~%" fv fv-orig))
	(reverse! fv)
	(if (not (equal? fv-copy fv))
	    (format *stderr* "vector reverse! twice: ~A ~A~%" fv fv-copy))
	(let ((fv1 (apply vector (make-list len 1))))
	  (if (not (and (= (length fv1) len)
			(= (fv1 (- len 1)) 1)))
	      (format *stderr* "vector apply: ~A ~A~%" len (fv (- len 1)))))
	))))

(define (s-tst len)
  (let ((fv (make-string len)))
    (if (not (= (length fv) len))
	(format *stderr* "string length ~A: ~A~%" fv (length fv)))
    (fill! fv #\a)
    (let ((fv-orig (copy fv)))
      (do ((i 0 (+ i 1)))
	  ((= i len))
	(string-set! fv i (integer->char (+ 20 (random 100)))))
      (do ((i 0 (+ i 1)))
	  ((= i len))
	(set! (fv i) (integer->char (+ 20 (random 100)))))
      (let ((fv-ran (copy fv))
	    (fv-ran1 (copy fv)))
	(sort! fv char<?)
	(do ((i 1 (+ i 1)))
	    ((= i len))
	  (if (char>? (string-ref fv (- i 1)) (string-ref fv i))
	      (display "oops")))
	(do ((i 1 (+ i 1)))
	    ((= i len))
	  (if (char>? (fv (- i 1)) (fv i))
	      (display "oops")))
	(sort! fv-ran (lambda (a b) (char<? a b)))
	(if (not (string=? fv fv-ran))
	    (format *stderr* "string closure not equal~%"))
	(sort! fv-ran1 char-less-than)
	(if (not (string=? fv fv-ran))
	    (format *stderr* "string cond closure not equal~%")))

      (let ((fv-copy (copy fv)))
	(reverse! fv)
	(if (and (not (string=? fv-copy fv))
		 (string=? fv fv-orig))
	    (format *stderr* "string reverse!: ~A ~A~%" fv fv-orig))
	(reverse! fv)
	(if (not (string=? fv-copy fv))
	    (format *stderr* "string reverse! twice: ~A ~A~%" fv fv-copy))
	(let ((fv1 (apply string (make-list len #\a))))
	  (if (not (and (= (length fv1) len)
			(char=? (fv1 (- len 1)) #\a)))
	      (format *stderr* "string apply: ~A ~A~%" len (fv (- len 1)))))
	))))

(define (p-tst len)
  (let ((fv (make-list len)))
    (if (not (= (length fv) len))
	(format *stderr* "list length ~A: ~A~%" fv (length fv)))
    (fill! fv 0)
    (let ((fv-orig (copy fv)))
      (do ((p fv (cdr p)))
	  ((null? p))
	(set-car! p (- (random 100000) 50000)))
      (let ((fv-ran (copy fv)))
	(set! fv (sort! fv <))
	(call-with-exit
	 (lambda (quit)
	   (let ((p0 (car fv)))
	     (for-each
	      (lambda (p1)
		(when (> p0 p1)
		  (format *stderr* "list: ~A > ~A~%" (car p0) (car p1))
		  (quit))
		(set! p0 p1))
	      (cdr fv)))))
	(set! fv-ran (sort! fv-ran (lambda (a b) (< a b))))
	(if (not (equal? fv fv-ran))
	    (format *stderr* "pair closure not equal~%")))
	
      (let ((fv-copy (copy fv)))
	(set! fv (reverse! fv))
	(if (and (not (equal? fv-copy fv))
		 (equal? fv fv-orig))
	    (format *stderr* "list reverse!: ~A ~A~%" fv fv-orig))
	(set! fv (reverse! fv))
	(if (not (equal? fv-copy fv))
	    (format *stderr* "list reverse! twice: ~A ~A~%" fv fv-copy))
	))))

(define (e-tst len)
  (let ((ht (make-hash-table len))
	(lst (make-list len)))
    (do ((i 0 (+ i 1)))
	((= i len))
      (list-set! lst i i))
    (do ((i 0 (+ i 1)))
	((= i len))
      (if (not (= (list-ref lst i) i)) (display "oops")))
    (do ((i 0 (+ i 1)))
	((= i len))
      (set! (lst i) i))
    (do ((i 0 (+ i 1)))
	((= i len))
      (if (not (= (lst i) i)) (display "oops")))
    (do ((i 0 (+ i 1)))
	((= i len))
      (hash-table-set! ht i i))
    (do ((i 0 (+ i 1)))
	((= i len))
      (if (not (= (hash-table-ref ht i) i)) (display "oops")))
    (do ((i 0 (+ i 1)))
	((= i len))
      (set! (ht i) i))
    (do ((i 0 (+ i 1)))
	((= i len))
      (if (not (= (ht i) i)) (display "oops")))))


(define (test-it)
  (for-each
   (lambda (b p)
     (do ((k 0 (+ k 1)))
	 ((= k 1000))
       (fv-tst b)
       (iv-tst b)
       (v-tst b)
       (s-tst b)
       (p-tst b)
       (e-tst b))
     (do ((i 0 (+ i 1)))
	 ((= i p))
       (format *stderr* "~D " (expt b i))
       (fv-tst (expt b i))
       (iv-tst (expt b i))
       (v-tst (expt b i))
       (s-tst (expt b i))
       (p-tst (expt b i))))
   '(2 3 4 7 10)
   '(12 4 3 6 6)))

(test-it)

(newline *stderr*)

(let ((size 1000000))
  (define (fe1 x) (if (not (char=? x #\1)) (display x)))
  (define (fe2) (for-each fe1 (make-string size #\1)))
  (define (fe20) (for-each char-upcase (make-string size #\1)))
  (fe2) (fe20)
  
  (define (fe3 x) (if (not (char=? x #\1)) (display x)))
  (define (fe4) (for-each fe3 (make-list size #\1)))
  (define (fe40) (for-each char? (make-list size #\1)))
  (fe4) (fe40)
  
  (define (fe5 x) (if (not (char=? x #\1)) (display x)))
  (define (fe6) (for-each fe5 (make-vector size #\1)))
  (define (fe60) (for-each char-alphabetic? (make-vector size #\1)))
  (fe6) (fe60)
  
  (define (fe7 x) (if (not (= x 1)) (display x)))
  (define (fe8) (for-each fe7 (make-int-vector size 1)))
  (define (fe80) (for-each abs (make-int-vector size 1)))
  (fe8) (fe80)
  
  (define (fe9 x) (if (not (= x 1.0)) (display x)))
  (define (fe10) (for-each fe9 (make-float-vector size 1.0)))
  (define (fe100) (for-each real? (make-float-vector size 1.0)))
  (fe10) (fe100)
  
  (define (fe11 p) (if (member 1 (make-list p 2) >) (display "oops")))
  (fe11 size)
  (fe11 1)
  (define (less a b) (> a b))
  (define (fe12 p) (if (member 1 (make-list p 2) less) (display "oops")))
  (fe12 size)
  (fe12 1)
  (define (fe13 p) (if (member 1 (make-list p 2) (lambda (a b) (cond ((> a b) #t) (#t #f)))) (display "oops")))
  (fe13 size)
  (fe13 1))


;;; this is a revision of some code posted in comp.lang.lisp by melzzzzz for euler project 512

#|
(define (make-boolean-vector n)
  (make-int-vector (ceiling (/ n 63))))

(define-expansion (boolean-vector-ref v n)
  `(logbit? (int-vector-ref ,v (quotient ,n 63)) (remainder ,n 63)))

(define-expansion (boolean-vector-set! v n)
  `(int-vector-set! ,v (quotient ,n 63)
		    (logior (int-vector-ref ,v (quotient ,n 63))
			    (ash 1 (remainder ,n 63)))))
|#
;;; this is slightly faster
(define (make-boolean-vector n) (make-vector n #f))
(define boolean-vector-ref vector-ref)
(define-expansion (boolean-vector-set! v j) `(vector-set! ,v ,j #t))


(define (odd-get n)
  (let* ((visited-range (+ (ash n -1) 1))
	 (visited (make-boolean-vector visited-range))
	 (sqrt-n (+ (floor (sqrt n)) 1)))
    (do ((i 3 (+ i 2)))
	((>= i sqrt-n))
      (unless (boolean-vector-ref visited (ash i -1))
	(do ((j (ash (* i i) -1) (+ j i)))
	    ((>= j visited-range))
	  (boolean-vector-set! visited j))))
    (let ((rc (make-int-vector (+ n 1)))
	  (rcp 0)
	  (lim (+ n 1)))
      (do ((i 3 (+ i 2)))
	  ((= i lim) (copy rc (make-int-vector rcp)))
	(unless (boolean-vector-ref visited (ash i -1))
	  (int-vector-set! rc rcp i)
	  (set! rcp (+ rcp 1)))))))

(define (getr n)
  (let* ((odd-bound (ash (+ n 1) -1))
	 (prime-list (odd-get n))
	 (result (make-int-vector odd-bound))
	 (n2 (/ n 2))) ; this optimization suggested by "Peter" (in comp.lang.lisp)
    (do ((i 0 (+ i 1)))
	((= i odd-bound))
      (int-vector-set! result i (+ (* 2 i) 1)))

    (for-each (lambda (prime)
		(do ((j (ash prime -1) (+ j prime)))
		    ((>= j n2))
		  (int-vector-set! result j (* (quotient (int-vector-ref result j) prime) (- prime 1)))))
	      prime-list)

   (let ((sum 0))
      (do ((i 0 (+ i 1)))
	  ((= i odd-bound) sum)
	(set! sum (+ sum (int-vector-ref result i)))))))

(let ((r (getr 100)))
  (unless (= r 2007)
    (display r)
    (newline)))

(let ((r (getr 500000)))
  (unless (= r 50660660193)
    (display r)
    (newline)))

;;; if heap 32M
;;; (getr 5000000)    5066059769259     .5
;;; (getr 50000000)   506605921933035    6
;;; (getr 500000000)  50660591862310323  89

(exit)

