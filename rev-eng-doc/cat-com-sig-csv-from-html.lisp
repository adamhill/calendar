#!/opt/local/bin/sbcl --script

; FILE #p"cat-com-sig-csv-from-html.lisp"

;0000000011111111112222222222333333333344444444445555555555666666666677777777778
;2345678901234567890123456789012345678901234567890123456789012345678901234567890
;----;-----------------------------------------------;------------------;------;

"https://www.quicklisp.org/beta"
; The following lines added by ql:add-to-init-file:
      #-quicklisp
      (let
          ((quicklisp-init
             (merge-pathnames
               "quicklisp/setup.lisp"
               (user-homedir-pathname))))
        (when (probe-file quicklisp-init)
         (load quicklisp-init)))

;     (ql:quickload '(cl-csv plump plump-sexp)
      (require :cl-csv)
      (require :plump)
      (require :plump-sexp)



      (defun
          main
          ()
""
          (declare
            (optimize (speed 0) (safety 3)
                      (debug 3)))
          'end-of-doc-string-and-declarations
        (let (acc)
          (with-open-file
             (in #p"cat-com-sig.xml"
              :direction :input
              :element-type 'character
              :external-format :utf-8)
           (let (tmp)
             (loop
              do
              (setf tmp (read-line in nil nil))
              (if tmp
                  (destructuring-bind
                        (_root
                          (_li ((_a _href
                                    arg-str)
                                name)))
                      (plump-sexp:serialize
                        (plump:parse
                          (string-trim
                            #(#\Space #\Tab)
                            tmp)))
                    (declare
                      (ignore _root _li _a _href))
                    (push
                      `(:id
                         ,(parse-integer
                            arg-str
                            :start
                              (1+ (position
                                    #\=
                                    arg-str
                                    :start 0)))
                         :name ,name)
                      acc))
                  (return
                    (setf acc
                          (reverse acc)))))))
        (with-open-file
            (out #p"cat-com-sig.csv"
             :direction :output
             :if-exists :supersede
             :element-type 'character
             :external-format :utf-8)
          (cl-csv:write-csv
; p"../tests/Fixture/CategoriesFixture.php"
            `(("id" "name" "created" "modified")
              ,@(mapcar (lambda (row)
                          (destructuring-bind
                                (&key id name)
                              row
                            `(,id ,name
                                  "" #|created|#
                                  "" #|modified|#)))
                        acc))
            :stream out
            :separator #\,
            :quote #\"
            :always-quote t))))

      (main)

; END OF FILE #p"cat-com-sig-csv-from-html.lisp"
