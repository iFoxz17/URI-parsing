(defparameter passed 0)  ; test passati
(defparameter failed 0)  ; test falliti
(defparameter tot 0)     ; test totali

(defmacro test (s r)
  `(let* ((u (uri-parse ,s)) (v (if (not (null u)) 
				    (list (uri-scheme u) (uri-userinfo u) (uri-host u) (uri-port u) (uri-path u) (uri-query u) (uri-fragment u)))))
     (if (equal v ,r)
	 (setf passed (1+ passed))
       (and (setf failed (1+ failed))
	    (format t "test parse 1 failed:~%Expected: ~A~%Found: ~A~%~%" ,r v)))
     (setf tot (1+ tot))))

(defmacro test-error (s)
  `(let* ((v (ignore-errors (uri-parse ,s))))
     (if (null v)
	 (setf passed (1+ passed))
       (and (setf failed (1+ failed))
	    (format t "test parse 1 failed:~%Expected: ERROR~%Found: ~A~%~%" v)))
     (setf tot (1+ tot))))


;; scheme 
(format t "~%TEST:SCHEME --- ~%~%")
(test "s:" '("s" NIL NIL 80 NIL NIL NIL)) ; ALPHA
(test "ss:" '("ss" NIL NIL 80 NIL NIL NIL))  ; ALPHA ALPHA
(test "s1:" '("s1" NIL NIL 80 NIL NIL NIL)) ; ALPHA DIGIT
(test "s+:" '("s+" NIL NIL 80 NIL NIL NIL)) ; ALPHA "+"
(test "s-:" '("s-" NIL NIL 80 NIL NIL NIL)) ; ALPHA "-"
(test "s.:" '("s." NIL NIL 80 NIL NIL NIL)) ; ALPHA "."
(test-error "s/:") ; Carattere non valido
(test-error "s?:") ; Carattere non valido
(test-error "s#:") ; Carattere non valido
(test-error "s@:") ; Carattere non valido
(test-error "s::") ; Carattere non valido
;(test-error "1:") ; Non inizia per ALPHA
;(test-error "+:") ; Non inizia per ALPHA
(test-error ":")  ; SCHEME Vuoto


;; host
(format t "~%TEST:HOST --- ~%~%")
(test "s://host" '("s" NIL "host" 80 NIL NIL NIL))
(test-error "s://host.")
(test "s://host.com" '("s" NIL "host.com" 80 NIL NIL NIL))
(test "s://host.com:123" '("s" NIL "host.com" 123 NIL NIL NIL))
(test-error "s://host..com") 
(test-error "s://ho?st")
(test-error "s://ho#st")
(test-error "s://ho:st") 
(test-error "s://") ; Empty host
(test "s://userinfo@host.com:110" '("s" "userinfo" "host.com" 110 NIL NIL NIL))

;; ipaddress
(format t "~%TEST:IP --- ~%~%")
(test "s://192.168.224.123" '("s" NIL "192.168.224.123" 80 NIL NIL NIL)) ; Inutile con host.
(test "s://255.255.255.255" '("s" NIL "255.255.255.255" 80 NIL NIL NIL))

;; userinfo
(format t "~%TEST:USERINFO --- ~%~%")
(test "s://ui@host" '("s" "ui" "host" 80 NIL NIL NIL))
(test "s://u%20i@host" '("s" "u%20i" "host" 80 NIL NIL NIL))
(test "s://u-@host" '("s" "u-" "host" 80 NIL NIL NIL))
(test "s://us@host" '("s" "us" "host" 80 NIL NIL NIL))
(test-error "s://@host")   ; Empty userinfo
(test-error "s://userinfo@") ; Empty host
;(test-error "s://userinfo.@host")
(test-error "s://u/i@host")
(test-error "s://u?i@host")
(test-error "s://u#i@host")
(test-error "s://u@i@host")
(test-error "s://u:i@host")

;; port
(format t "~%TEST:PORT --- ~%~%")
(test "s://host:110" '("s" NIL "host" 110 NIL NIL NIL))
(test-error "s://:110") 
(test-error "s://host:a") ; Port isnt a number
(test-error "s://host:")

;; authPath
(format t "~%TEST:AUTHPATH --- ~%~%")
(test "s://host.com/path1/path2" '("s" NIL "host.com" 80 "path1/path2" NIL NIL))
(test "s://host.com/" '("s" NIL "host.com" 80 NIL NIL NIL))
(test-error "s://host.com.") 
(test-error "s://host.com//") 
(test-error "s://host.com/p/") ; Path deve avere qualcosa dopo "/"
(test "s://host.com/p/p" '("s" NIL "host.com" 80 "p/p" NIL NIL))
(test "s://host.com/path./path1/path2?query?#fragm" '("s" NIL "host.com" 80 "path./path1/path2" "query?" "fragm"))

;; path
(format t "~%TEST:PATH --- ~%~%")
(test "c:/path./path1/path2" '("c" NIL NIL 80 "path./path1/path2" NIL NIL))
(test-error "c:path./path1/path2")
(test "c:/path." '("c" NIL NIL 80 "path." NIL NIL))
(test-error "c:/host.com//") 
(test-error "c:/host.com/p/") ; Path deve avere qualcosa dopo "/"
(test "c:/p/p" '("c" NIL NIL 80 "p/p" NIL NIL))
(test "s:/" '("s" NIL NIL 80 NIL NIL NIL))
(test "c:/path./path1/path2?query?#fragm" '("c" NIL NIL 80 "path./path1/path2" "query?" "fragm"))
(test "c:/?query?#fragm" '("c" NIL NIL 80 NIL "query?" "fragm"))
(test "c:/?query?" '("c" NIL NIL 80 NIL "query?" NIL))
(test "c:/#fragm" '("c" NIL NIL 80 NIL NIL "fragm"))
(test "c:/path./path1/path2#fragm" '("c" NIL NIL 80 "path./path1/path2" NIL "fragm"))
(test-error "c:?query?#fragm")

;; mailto
(format t "~%TEST:MAILTO --- ~%~%")
(test "mailto:userinfo" '("mailto" "userinfo" NIL 80 NIL NIL NIL))
(test "mailto:userinfo@host.com" '("mailto" "userinfo" "host.com" 80 NIL NIL NIL))
(test "mailto:" '("mailto" NIL NIL 80 NIL NIL NIL))
(test-error "mailto:userinfo@")
(test "mailto:host.com" '("mailto" "host.com" NIL 80 NIL NIL NIL))

;; news
(format t "~%TEST:NEWS --- ~%~%")
(test "news:host" '("news" NIL "host" 80 NIL NIL NIL))
(test "news:host.com" '("news" NIL "host.com" 80 NIL NIL NIL))
(test "news:" '("news" NIL NIL 80 NIL NIL NIL))
(test-error "news:ui@host")

;; telfax
(format t "~%TEST:TELFAX --- ~%~%")
(test "tel:userinfo" '("tel" "userinfo" NIL 80 NIL NIL NIL))
(test "fax:userinfo" '("fax" "userinfo" NIL 80 NIL NIL NIL))
(test "tel:" '("tel" NIL NIL 80 NIL NIL NIL))
(test "fax:" '("fax" NIL NIL 80 NIL NIL NIL))

;; zosAuth
(format t "~%TEST:ZOSAUTH --- ~%~%")
(test "zos://me@hercules.disco.unimib.it:3270/myproj.linalg.fortran(svd)?submit=FORTXC" '("zos" "me" "hercules.disco.unimib.it" 3270 "myproj.linalg.fortran(svd)" "submit=FORTXC" NIL))
(test "zos://me@hercules.disco.unimib.it:3270/myproj.linalg.fortran?submit=FORTXC" '("zos" "me" "hercules.disco.unimib.it" 3270 "myproj.linalg.fortran" "submit=FORTXC" NIL))
(test-error "zos://me@hercules.disco.unimib.it:3270/myproj.linalg.fortran()?submit=FORTXC") 
(test-error "zos://me@hercules.disco.unimib.it:3270/myproj.linalg.fortran(?submit=FORTXC") 
(test-error "zos://me@hercules.disco.unimib.it:3270/myproj.linalg.fortran)?submit=FORTXC") 
(test-error "zos://me@hercules.disco.unimib.it:3270/") ; PATH deve contenere almeno 1 carattere
(test-error "zos://me@hercules.disco.unimib.it:3270/myproj.linalg.fortran(a23456789)") ; TOO MANY id8 chars (9)
(test-error "zos://me@hercules.disco.unimib.it:3270/a234567890a234567890a234567890a23456789012345") ; TOO MANY id44 chars (45)
(test-error "zos://me@hercules.disco.unimib.it:3270/1") ; id44 non inizia per ALPHA
(test-error "zos://me@hercules.disco.unimib.it:3270/a(1)") ; id8 non inizia per ALPHA
(test-error "zos://me@hercules.disco.unimib.it:3270/a.") ; id44 non puï¿ï¿ terminare con un punto
(test-error "zos://me@hercules.disco.unimib.it:3270")

;; sZos
(format t "~%TEST:SZOS --- ~%~%")
(test "zos:/myproj.linalg.fortran(svd)?submit=FORTXC" '("zos" NIL NIL 80 "myproj.linalg.fortran(svd)" "submit=FORTXC" NIL))
(test "zos:/myproj.linalg.fortran?submit=FORTXC" '("zos" NIL NIL 80 "myproj.linalg.fortran" "submit=FORTXC" NIL))
(test-error "zos:/myproj.linalg.fortran()?submit=FORTXC") 
(test-error "zos:/myproj.linalg.fortran(?submit=FORTXC") 
(test-error "zos:/myproj.linalg.fortran)?submit=FORTXC") 
(test-error "zos:/") ; PATH deve contenere almeno 1 carattere
(test-error "zos:/myproj.linalg.fortran(a23456789)") ; TOO MANY id8 chars (9)
(test-error "zos:/a234567890a234567890a234567890a23456789012345") ; TOO MANY id44 chars (45)
(test-error "zos:/1") ; id44 non inizia per ALPHA
(test-error "zos:/a(1)") ; id8 non inizia per ALPHA
(test-error "zos:/a.") ; id44 non puï¿ï¿ terminare con un punto
(test-error "zos:")
(test-error "zos:myproj.linalg.fortran(svd)?submit=FORTXC")
(test-error "zos:myproj.linalg.fortran?submit=FORTXC")


(if (= passed tot)
  (format t "~%All tests passed!")
  (format t "~%Run ~D tests: passed ~D, failed ~D" tot passed failed))
