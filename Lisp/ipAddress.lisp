(require "DEFINITIONS" "definitions.lisp")
(require "PORT" "port.lisp")
(require "OPTIONAL" "optional.lisp")

(provide "IPADDRESS")


(defun ipAddress-recognize (l &optional (authMode NIL) (zos-flag NIL))
  (cond ((stringp l) 
         (ipAddress-recognize (coerce l 'list) authMode zos-flag))
        ((listp l) (ipAddress-accept 'q0 l authMode zos-flag))
  )
)

(defun sublist-append (l x index)
  (cond ((= index 0) (list (append (car l) (list x)) 
                           (second l) 
                           (third l) 
                           (fourth l)))
        ((= index 1) (list (car l) 
                           (append (second l) (list x)) 
                           (third l) 
                           (fourth l)))
        ((= index 2) (list (car l) 
                           (second l) 
                           (append (third l) (list x)) 
                           (fourth l)))
        ((= index 3) (list (car l) 
                           (second l) 
                           (third l) 
                           (append (fourth l) (list x))))
  )
)

(defun ip-check (l) 
  (cond ((null l) NIL) 
        ((and (<= (parse-integer (coerce (car l) 'string)) 255)
              (<= (parse-integer (coerce (second l) 'string)) 255)
              (<= (parse-integer (coerce (third l) 'string)) 255)
              (<= (parse-integer (coerce (fourth l) 'string)) 255)
              ) l)
        )
  )

(defun ipAddress-accept (q l authMode zos-flag 
                           &optional (acc (list NIL NIL NIL NIL)) 
                                          (index 0))
  (cond ((null q) NIL)
        ((null l) (if (and (ipAddress-final q) 
                           (ip-check acc)) 
                      (list acc (if authMode (list #\8 #\0) NIL) 
                            NIL NIL NIL)
                    NIL))

        ((and authMode (char= (car l) #\:)) 
         (if (and (ipAddress-final q) (ip-check acc)) 
             (append (list acc) 
                     (port-recognize (cdr l) zos-flag)) 
           NIL))
				
        ((and authMode 
              (char= (car l) #\/)) 
         (if (and (ipAddress-final q) 
                  (ip-check acc)) 
             (append (list acc) 
                     (list (list #\8 #\0))
                     (optional-recognize (cdr l) zos-flag)) 
           NIL))
						
        ((or (eql q 'q3)
             (eql q 'q7)
             (eql q 'q11))
         (ipAddress-accept (ipAddress-delta q (car l))
                           (cdr l)
                           authMode
                           zos-flag
                           acc
                           (+ index 1)))
        (T (ipAddress-accept (ipAddress-delta q (car l))
                             (cdr l)
                             authMode
                             zos-flag
                             (sublist-append acc (car l) index)
                             index
                             ))
        )
  )


(defun ipAddress-final (q)
  (if (eql q 'q15) T NIL)
  )

(defun ipAddress-delta (q x)
  (cond ((digit x) (cond ((eql q 'q0) 'q1)
                         ((eql q 'q1) 'q2)
                         ((eql q 'q2) 'q3)
                         ((eql q 'q4) 'q5)
                         ((eql q 'q5) 'q6)
                         ((eql q 'q6) 'q7)
                         ((eql q 'q8) 'q9)
                         ((eql q 'q9) 'q10)
                         ((eql q 'q10) 'q11)
                         ((eql q 'q12) 'q13)
                         ((eql q 'q13) 'q14)
                         ((eql q 'q14) 'q15)
                    ))
        ((char= x #\.) (cond ((eql q 'q3) 'q4)
                             ((eql q 'q7) 'q8)
                             ((eql q 'q11) 'q12)
                       ))
  )
)