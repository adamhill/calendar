#!/opt/local/bin/sbcl --script

; FILE #p"brute-force-col-names-json.lisp"

;0000000011111111112222222222333333333344444444445555555555666666666677777777778
;2345678901234567890123456789012345678901234567890123456789012345678901234567890
;----;-----------------------------------------------;------------------;------;

; EXTERNAL DEPENDENCIES: php8.5(1) a.k.a. php85(1)

      (require :uiop)

      (defparameter
          files
   '(#p"../tests/Fixture/CategoriesEventsFixture.php"
     #p"../tests/Fixture/CategoriesFixture.php"
     #p"../tests/Fixture/CommitteesFixture.php"
     #p"../tests/Fixture/ConfigFixture.php"
     #p"../tests/Fixture/ConfigurationsFixture.php"
     #p"../tests/Fixture/ContactsFixture.php"
     #p"../tests/Fixture/EventsFixture.php"
     #p"../tests/Fixture/EventsToolsFixture.php"
     #p"../tests/Fixture/FilesFixture.php"
     #p"../tests/Fixture/HonorariaFixture.php"
     #p"../tests/Fixture/PrerequisitesFixture.php"
     #p"../tests/Fixture/RegistrationsFixture.php"
     #p"../tests/Fixture/RoomsFixture.php"
     #p"../tests/Fixture/ToolsFixture.php"
     #p"../tests/Fixture/W9sFixture.php"))

      (defun
          list-of-lines-from-file!
          (pn)
""
          (declare
            (optimize (speed 0) (safety 3)
                      (debug 3)))
          'end-of-doc-string-and-declarations
        (with-open-file
            (in pn
             :direction :input
             :element-type 'character
             :external-format :utf-8)
          (let (lines-acc)
            (loop
              do
              (push (read-line in nil nil)
                    lines-acc)
              (when (eq nil (first lines-acc))
                (return
                  (reverse (rest lines-acc))))))))

      (defun
          list-of-col-php-arr-lines
          (list-of-lines)
""
          (declare
            (optimize (speed 0) (safety 3)
                      (debug 3)))
          'end-of-doc-string-and-declarations
        (let*
            ((start
               (position "    public $fields = ["
                         list-of-lines
                         :test #'string=
                         :start 0))
             (end
               (1+ (position (coerce #(#\Tab #\] #\;)
                                     'string)
                             list-of-lines
                             :test #'string=
                             :start start))))
          (subseq list-of-lines start end)))

      (defun
          sconc
          (list-of-strings)
""
          ()
          'end-of-doc-string-and-declarations
        (reduce (lambda (a b)
                  (concatenate 'string a b))
                list-of-strings))

      (defun
          json-from-php-arr-lines!
          (pn list-of-arr-lines)
"See [U001] in source file."
          (declare
            (optimize (speed 0) (safety 3)
                      (debug 3)))
          'end-of-doc-string-and-declarations
        (uiop:run-program
          `("php8.5"
            "-r"
            ,(sconc `("$fields=["
                      ,(let (*print-readably*)
                         (format
                           nil
                           "~S => ["
                           (uiop:native-namestring
                             pn)))
                      ,@(rest
                          (butlast
                            list-of-arr-lines))
                      "]];"
                      "print json_encode($fields, "
                        "JSON_unescaped_slashes);"))
            "--")
          :output '(:string :stripped t)
          :error-output '(:lines)))


      (defun
          main
          ()
""
          (declare
            (optimize (speed 0) (safety 3)
                      (debug 3)))
          'end-of-doc-string-and-declarations
        (format
          *standard-output*
          "{\"fixtures\": [~{~A~^,  ~}]}"
          (mapcar
; Returns an alist.
            (lambda (pn)
              (json-from-php-arr-lines!
                pn
                (list-of-col-php-arr-lines
                  (list-of-lines-from-file!
                    pn))))
            files)))

      (main)

;U001 #u"https://stackoverflow.com/questions
;    +   /10210338/json-encode-escaping
;    +   -forward-slashes"
;
;     PHP escapes *forward* slashes in function
;     json_encode() to avoid unescaped "</script>"
;     tags from poisoning HTML.  This is decidedly
;     *not* the problem in this case.

; END OF FILE #p"brute-force-col-names-json.lisp"
