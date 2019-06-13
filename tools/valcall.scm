(define file-names '(("make-index.scm" . "v-index")
		     ("tmac.scm" . "v-mac")
		     ("tpeak.scm" . "v-peak")
		     ("tvect.scm" . "v-vect")
		     ("teq.scm" . "v-eq")
		     ("tfft.scm" . "v-fft")
		     ("tref.scm" . "v-ref")
		     ("tauto.scm" . "v-auto")
		     ("s7test.scm" . "v-test")
		     ("tcopy.scm" . "v-cop")
		     ("lt.scm" . "v-lt")
		     ("tform.scm" . "v-form")
		     ("tread.scm" . "v-read")
		     ("tmap.scm" . "v-map")
		     ("tmat.scm" . "v-mat")
		     ("lg.scm" . "v-lg")
		     ("titer.scm" . "v-iter")
		     ("tsort.scm" . "v-sort")
		     ("tlet.scm" . "v-let")
		     ("thash.scm" . "v-hash")
		     ("tgen.scm" . "v-gen")
		     ("tall.scm" . "v-all")
		     ("snd-test.scm" . "v-call")
		     ("full-snd-test.scm" . "v-sg")
		     ("dup.scm" . "v-dup")
		     ("tset.scm" . "v-set")
		     ("trec.scm" . "v-rec")
		     ("tclo.scm" . "v-clo")
		     ("tbig.scm" . "v-big")
		     ("tshoot.scm" . "v-shoot")
		     ("fbench.scm" . "v-fb")
		     ("trclo.scm" . "v-rclo")
		     ("test-all.scm" . "v-b")
		     ))

(define (last-callg)
  (let ((name (system "ls callg*" #t)))
    (let ((len (length name)))
      (do ((i 0 (+ i 1)))
	  ((or (= i len)
	       (char-whitespace? (name i)))
	   (substring name 0 i))))))

(define (next-file f)
  (let ((name (system (format #f "ls -t ~A*" f) #t)))
    (let ((len (length name)))
      (do ((i 0 (+ i 1)))
	  ((or (= i len)
	       (and (char-numeric? (name i))
		    (char-numeric? (name (+ i 1)))))
	   (+ 1 (string->number (substring name i (+ i 2)))))))))

(define (call-valgrind)
  (for-each
   (lambda (caller+file)
     (system "rm callg*")
     (format *stderr* "~%~NC~%~NC ~A ~NC~%~NC~%" 40 #\- 16 #\- (cadr caller+file) 16 #\- 40 #\-)
     (system (format #f "valgrind --tool=callgrind ./~A ~A" (car caller+file) (cadr caller+file)))

     ;; valgrind 3.12 blathers endlessly -- I made this change:
     ;;   /home/bil/test/valgrind-3.12.0/coregrind/m_syswrap/syswrap-generic.c
     ;;   comment out lines 1333 to 1341

     (let ((outfile (cdr (assoc (cadr caller+file) file-names))))
       (let ((next (next-file outfile)))
	 (system (format #f "callgrind_annotate --auto=yes --threshold=100 ~A > ~A~D" (last-callg) outfile next))

	 ;; new callgrind blathers endlessly -- I made this change:
         ;;   (line 825) my $space = ' ' x ($CC_col_widths->[$i] - length($count));
         ;;              my $space = ' ' x max($CC_col_widths->[$i] - length($count), 0);

	 (format *stderr* "~NC ~A~D -> ~A~D: ~NC~%" 8 #\space outfile (- next 1) outfile next 8 #\space)
	 (system (format #f "./snd compare-calls.scm -e '(compare-calls \"~A~D\" \"~A~D\")'" outfile (- next 1) outfile next)))))

   (list (list "repl" "tpeak.scm")
	 (list "repl" "tmac.scm")
	 (list "repl" "tshoot.scm")
	 (list "repl" "tauto.scm")
	 (list "repl" "tref.scm")
	 (list "snd -noinit" "make-index.scm")
	 (list "repl" "teq.scm")
	 (list "repl" "s7test.scm")
	 (list "repl" "lt.scm")
	 (list "repl" "tcopy.scm")
	 (list "repl" "tread.scm")
	 (list "repl" "tform.scm")
	 (list "repl" "tvect.scm")
	 (list "repl" "trclo.scm")
	 (list "repl" "tfft.scm")
	 (list "repl" "tlet.scm")
	 (list "repl" "fbench.scm")
	 (list "repl" "dup.scm")
	 (list "repl" "tclo.scm")
	 (list "repl" "tmap.scm")
	 (list "repl" "tsort.scm")
	 (list "repl" "tset.scm")
	 (list "repl" "titer.scm")
	 (list "repl" "tmat.scm")
	 (list "repl" "trec.scm")
	 (list "repl" "thash.scm")
	 (list "snd -noinit" "tgen.scm")    ; repl here + cload sndlib was slower
	 (list "snd -noinit" "tall.scm")
	 (list "snd -l" "snd-test.scm")
	 (list "snd -l" "full-snd-test.scm")
	 (list "repl" "lg.scm")
	 (list "repl" "tbig.scm")
	 )))

(call-valgrind)

(when (file-exists? "test.table")
  (system "mv test.table old-test.table"))
(load "compare-calls.scm")
(combine-latest)

(exit)
