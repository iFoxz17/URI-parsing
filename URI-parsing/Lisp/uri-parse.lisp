(require "URI-STRUCT" "uri-struct.lisp")

(defun uri-parse (s)
  (uri-build s)
)

(defun uri-display (uri &optional (stream T))
  (if (not (uri-format uri stream)) T T)
  )