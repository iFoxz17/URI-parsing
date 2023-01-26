(require "DEFINITIONS" "definitions.lisp")
(require "HOST" "host.lisp")


(provide "MAILTO")
            
(defun mailto-recognize (l)
  (cond ((stringp l) (mailto-recognize (coerce l 'list)))
        ((listp l) (mailto-accept 'q0 l))
  )
)


(defun mailto-accept (q l &optional (acc NIL))
  (cond ((null q) NIL)
        ((null l) (if (mailto-final q) 
                      (list acc NIL NIL NIL NIL NIL) 
                    NIL))
        ((and (mailto-final q) (char= (car l) #\@)) 
         (append (list acc) (host-recognize (cdr l))))

        (T (mailto-accept (mailto-delta q (car l))
                        (cdr l)
                        (append acc (cons (car l) NIL))
                        ))
        )
)

(defun mailto-final (q)
  (cond ((eql q 'q1) T))
)

(defun mailto-delta (q x)
  (cond ((eql q 'q0) (if (identifier x) 'q1 NIL))
        ((eql q 'q1) (if (identifier x) 'q1 NIL))
  )
)