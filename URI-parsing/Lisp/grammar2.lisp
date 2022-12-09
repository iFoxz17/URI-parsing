(require "OPTIONAL" "optional.lisp")

(provide "GRAMMAR2")

(defun recognize-2 (l &optional (zos-flag NIL))
  (cond ((stringp l) (recognize-2 (coerce l 'list) zos-flag))
        ((listp l) (accept-2 l zos-flag))
        )
  )

(defun accept-2 (l zos-flag)
  (cond ((null l) (list NIL NIL NIL NIL NIL NIL))
        ((char= (car l) #\/) 
         (append (list NIL NIL NIL) 
                 (optional-recognize (cdr l) 
                                     zos-flag)))
					
        ;(T (append (list NIL NIL NIL) (optional-recognize l zos-flag)))
        )
  )
