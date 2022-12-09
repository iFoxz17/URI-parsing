(require "AUTHORITHY" "authorithy.lisp")

(provide "GRAMMAR1")

(defun recognize-1 (l &optional (zos-flag NIL))
  (cond ((stringp l) (recognize-1 (coerce l 'list) zos-flag))
        ((listp l) (authorithy-recognize l zos-flag))
        )
  )
