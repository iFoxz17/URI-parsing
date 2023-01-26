(require "SCHEME" "scheme.lisp")
(provide "URI-STRUCT")
 
(defstruct uri scheme userinfo host port path query fragment)

(defun convert (l &optional (port-flag NIL))
  (if port-flag (if (null l) 80
                    (parse-integer (coerce l 'string)))
    (if (null l) NIL (coerce l 'string)))
)

(defun uri-build (s)
  (if (stringp s) (let ((uri_list (scheme-recognize s))) 
                    (if (= (length uri_list) 7) 
                        (make-uri :scheme (convert (car uri_list))
                                  :userinfo (convert (second uri_list))
                                  :host (convert (third uri_list))
                                  :port (convert (fourth uri_list) T)
                                  :path (convert (fifth uri_list))
                                  :query (convert (sixth uri_list))
                                  :fragment (convert (seventh uri_list))
                                  )) 
                    ))
  )


(defun uri-format (u &optional (stream T))
  (cond ((uri-p u) (format stream "Scheme:    ~S~@
                                Userinfo:  ~S~@
                                Host:      ~S~@
                                Port:      ~D~@
                                Path:      ~S~@
                                Query:     ~S~@
                                Fragment:  ~S~%" 
                           (uri-scheme u)
                           (uri-userinfo u)
                           (uri-host u) 
                           (uri-port u)
                           (uri-path u) 
                           (uri-query u)
                           (uri-fragment u)
                           ))
        ((stringp u) (uri-format (uri-parse u) stream))
        )
  )

