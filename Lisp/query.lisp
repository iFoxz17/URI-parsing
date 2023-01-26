(require "DEFINITIONS" "definitions.lisp")
(require "FRAGMENT" "fragment.lisp")

(provide "QUERY")

(defun query-recognize (l)
  (cond ((stringp l) (query-recognize (coerce l 'list)))
        ((listp l) (query-accept 'q0 l))
  )
)

(defun query-accept (q l &optional (acc NIL))
  (cond ((null q) NIL) 
        ((null l) (if (query-final q) (list acc NIL) NIL))
        ((char= (car l) #\#) 
         (if (query-final q) 
             (append (list acc) 
                     (fragment-recognize (cdr l)))
           NIL))
        (T (query-accept (query-delta q (car l))
                         (cdr l)
                         (append acc (cons (car l) NIL)))
           )
        )
  )

(defun query-final (q)
  (if (eql q 'q1) T NIL)
  )

(defun query-delta (q x)
  (if (query x)
      (cond ((eql q 'q0) 'q1)
            ((eql q 'q1) 'q1)
            )
    )
  )