(require "DEFINITIONS" "definitions.lisp")
(require "GRAMMAR1" "grammar1.lisp")
(require "GRAMMAR2" "grammar2.lisp")
(require "MAILTO" "mailto.lisp")
(require "NEWS" "news.lisp")
(require "TEL" "tel.lisp")

(provide "SCHEME")


(defun scheme-recognize (l)
  (cond ((stringp l) (scheme-recognize (coerce l 'list)))
        ((listp l) (scheme-accept 'q0 l))
  )
)

(defun scheme-accept (q l &optional (acc NIL))
  (cond ((null q) NIL)
        ((null l) NIL)
        ((char= (car l) #\:) 
         (if  (scheme-final q)                   
             (cond ((and (null (cdr l))
                        (not (string= (string-upcase 
                                       (coerce acc 'string)) 
                                       "ZOS"))) 
                   (list acc NIL NIL NIL NIL NIL NIL))

                   ((string= (string-upcase 
                              (coerce acc 'string)) "MAILTO")
                    (let ((mailto (mailto-recognize (cdr l))))
                      (if (= (length mailto) 6) 
                          (append (list acc) mailto))))

                   ((or (string= (string-upcase 
                                  (coerce acc 'string)) "TEL")
                        (string= (string-upcase 
                                  (coerce acc 'string)) "FAX"))
                    (let ((tel (tel-recognize (cdr l))))
                      (if (= (length tel) 6) 
                          (append (list acc) tel))))

                   ((string= (string-upcase 
                              (coerce acc 'string)) "NEWS")
                    (let ((news (news-recognize (cdr l))))
                      (if (= (length news) 6) 
                          (append (list acc) news))))

                   ((string= (string-upcase 
                              (coerce acc 'string)) "ZOS")
                    (let ((gram1 (recognize-1 (cdr l) T))) 
                      (if (= (length gram1) 6) 
                          (if (null (fourth gram1)) NIL
                            (append (list acc) gram1))
                        (let ((gram2 (recognize-2 (cdr l) T)))
                          (if (= (length gram2) 6) 
                              (if (null (fourth gram2)) NIL
                            (append (list acc) gram2)))))))
                                       
                   (T (let ((gram1 (recognize-1 (cdr l)))) 
                      (if (= (length gram1) 6) 
                          (append (list acc) gram1)
                        (append (list acc) (recognize-2 (cdr l))))))
                                         
                   )))
                                 
        (T (scheme-accept (scheme-delta q (car l))
                          (cdr l)
                          (append acc (cons (car l) NIL))
           
           )
         )
  )
)

(defun scheme-final (q)
  (if (eql q 'q1) T NIL)
  )

(defun scheme-delta (q x)
  (cond ((identifier x) (cond ((eql q 'q0) 'q1)
                              ((eql q 'q1) 'q1)
                              ))
        )
  )
