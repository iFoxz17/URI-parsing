(require "HOST" "host.lisp")
(provide "NEWS")

(defun news-recognize (l)
  (append (list NIL) (host-recognize l))
)