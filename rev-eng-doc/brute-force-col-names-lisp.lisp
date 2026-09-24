#!/opt/local/bin/sbcl --script

; FILE #p"brute-force-col-names-lisp.lisp"

;0000000011111111112222222222333333333344444444445555555555666666666677777777778
;2345678901234567890123456789012345678901234567890123456789012345678901234567890
;----;-----------------------------------------------;------------------;------;

      (require :uiop)

      (defparameter
          controller-file-pn
          #p"controller-data-table-columns.csv")

      (defparameter
          controler-file-column-count
          6)

      (defparameter
          controler-file-column-key-names
          '(|INNO_TABLE_NAME|
            |WEBSERVER_CONTROLLER_PN|
            |OTHER_PN|
            |OTHER_PN_TYPE|
            |SEED_PN|
            |TABLE_PN|))

      (defparameter
          controller-file-header-parser
          #'intern)

      (defparameter
          controller-file-row-parsers
          `(,#'identity #|keeps it a string|#
            ,#'uiop:parse-native-namestring
            ,#'uiop:parse-native-namestring
            ,#'intern
            ,#'uiop:parse-native-namestring
            ,#'uiop:parse-native-namestring))


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

;     (ql:quickload '(cl-csv yason)
      (require :cl-csv)
      (require :yason)

;     (read-controller-table! controller-file-pn)
      (declaim (inline read-controller-table!))
      (defun
          read-controller-table!
          (pn)
""
          (declare
            (optimize (speed 0) (safety 3)
                      (debug 3)))
          'end-of-doc-string-and-declarations
        (let
            (raw-csv-list raw-header raw-data-rows
                          header
             (len 0))
          (setf raw-csv-list
                (with-open-file
                    (in pn
                     :direction :input
                     :element-type 'character
                     :external-format :utf-8)
                  (cl-csv:read-csv
                    in
                    :separator #\,
                    :quote #\")))
          (setf raw-header (first raw-csv-list)
                raw-data-rows (rest raw-csv-list))
; Double-check number of columns
          (assert
            (= controler-file-column-count
               (length raw-header)))
          (setf len (length raw-data-rows))
          (setf header
                (mapcar controller-file-header-parser
                        raw-header))
          (values
            (mapcar (lambda (rrow)
                      (pairlis
                        header
                        (mapcar
                          #'funcall
                          controller-file-row-parsers
                          rrow)))
                    raw-data-rows)
            len)))
      (declaim
        (notinline read-controller-table!)
        #+sbcl(sb-ext:maybe-inline
                read-controller-table!))

      (declaim (inline inno-db-controller-record-p))
      (defun
          inno-db-controller-record-p
          (crec)
""
          (declare
            (optimize (speed 0) (safety 3)
                      (debug 3)))
          'end-of-doc-string-and-declarations
        (and (listp crec)
             (eq '|INNODB_COLUMNS|
                 (cdr (assoc '|OTHER_PN_TYPE|
                             crec)))))
      (declaim
        (notinline inno-db-controller-record-p)
        #+sbcl(sb-ext:maybe-inline
                inno-db-controller-record-p))

      (declaim (inline select-inno-db-recs))
      (defun
          select-inno-db-recs
          (csv-table)
""
          (declare
            (optimize (speed 0) (safety 3)
                      (debug 3)))
          'end-of-doc-string-and-declarations
        (remove-if-not #'inno-db-controller-record-p
                       csv-table))
      (declaim
        (notinline select-inno-db-recs)
        #+sbcl(sb-ext:maybe-inline
                select-inno-db-recs))

      (declaim (inline inno-db-fixture-key))
      (defun
          inno-db-fixture-key
          (inno-rec)
        (and (inno-db-controller-record-p inno-rec)
             (cdr (assoc '|OTHER_PN| inno-rec))))
      (declaim
        (notinline inno-db-fixture-key)
        #+sbcl(sb-ext:maybe-inline
                inno-db-fixture-key))

      (declaim (inline inno-db-sql-table-name-key))
      (defun
          inno-db-sql-table-name-key
          (inno-rec)
        (and (inno-db-controller-record-p inno-rec)
             (cdr (assoc '|INNO_TABLE_NAME|
                   inno-rec))))
      (declaim
        (notinline inno-db-sql-table-name-key)
        #+sbcl(sb-ext:maybe-inline
                inno-db-sql-table-name-key))


      (declaim (inline select-inno-db-fixture-pns))
      (defun
          select-inno-db-fixture-pns
          (csv-recs)
        (let (acc tmp)
          (loop for rec in csv-recs
                do
                (setf tmp (inno-db-fixture-key rec))
                (when tmp
                  (push tmp acc)))
          (nreverse acc)))
      (declaim
        (notinline select-inno-db-fixture-pns)
        #+sbcl(sb-ext:maybe-inline
                select-inno-db-fixture-pns))

      (declaim (inline select-inno-db-table-names))
      (defun
          select-inno-db-table-names
          (csv-recs)
        (let (acc tmp)
          (loop for rec in csv-recs
                do
                (setf tmp (inno-db-fixture-key rec))
                (when tmp
                  (push tmp acc)))
          (nreverse acc)))
      (declaim
        (notinline select-inno-db-table-names)
        #+sbcl(sb-ext:maybe-inline
                select-inno-db-table-names))


      (declaim (inline list-of-lines-from-file!))
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
      (declaim
        (notinline list-of-lines-from-file!)
        #+sbcl(sb-ext:maybe-inline
                list-of-lines-from-file!))



      (declaim (inline list-of-col-php-arr-lines))
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
      (declaim
        (notinline list-of-col-php-arr-lines)
        #+sbcl(sb-ext:maybe-inline
                list-of-col-php-arr-lines))



      (defun
          sconc
          (list-of-strings)
""
          ()
          'end-of-doc-string-and-declarations
        (reduce (lambda (a b)
                  (concatenate 'string a b))
                list-of-strings))


      (declaim (inline brute-force-string-replace))
      (defun
          brute-force-string-replace
          (concat-strings)
""
          (declare
            (optimize (speed 0) (safety 3)
                      (debug 3)))
          'end-of-doc-string-and-declarations
        (with-output-to-string (out)
          (declare
            (optimize (speed 0) (safety 3)
                      (debug 3)))
          (with-input-from-string (in concat-strings)
            (declare
              (optimize (speed 0) (safety 3)
                        (debug 3)))
            (prog ((c #\Nul))
              (declare
                (optimize (speed 0) (safety 3)
                          (debug 3)))
 nxtc
              (setf c (read-char in nil #\Nul))
              (case c
                (#\Nul (return))
                (#\[ (write-char #\( out))
                (#\] (write-char #\) out))
                (#\' (write-char #\" out))
                ((#\= #\>) (write-char c out))
                ((#\,) #|skip|#)
                (otherwise (write-char c out)))
              (go nxtc)))))
      (declaim
        (notinline brute-force-string-replace)
        #+sbcl(sb-ext:maybe-inline
                brute-force-string-replace))



      (declaim (inline brute-force-nested-=>-parse))
      (defun
          brute-force-nested-=>-parse
          (=>-list)
""
          (declare
            (optimize (speed 0) (safety 3)
                      (debug 3)))
          'end-of-doc-string-and-declarations
        (prog (acc a b c)
 chk
          (unless =>-list
            (return (nreverse acc)))
 trpl
          (setf a (pop =>-list)
                b (pop =>-list)
                c (pop =>-list))
; Assertion fails on the single-element array-list
; -- not association-list -- under
; foo["_constraints"]["columns"] == ["id"].
; Array-lists do not use "=>", whereas
; association-lists do.
;         (assert (eq b '=>))

; Silence stupid warning by technically reading B.
          (aref (string b) 0)
          (when (and (listp c)
                     (not (null c)))
            (setf c
                  (brute-force-nested-=>-parse c)))
;         (push (cons a c) acc)
; YASON really craps the bed over alists.
          (push (list a c) acc)
          (go chk)))
      (declaim
        (notinline brute-force-nested-=>-parse)
        #+sbcl(sb-ext:maybe-inline
                brute-force-nested-=>-parse))



      (declaim (inline brute-force-inno-db-col))
      (defun
          brute-force-inno-db-col
          (table-name fixture-pn)
"Returns an alist.  Important for encoding to JSON
in script #p\"json-from-lisp-data.lisp\", because
YASON messes this up."
          (declare
            (optimize (speed 0) (safety 3)
                      (debug 3)))
          'end-of-doc-string-and-declarations
; YASON hates alist `(cons a . b) cells.
        `((table-name ,table-name)
          (fixture-pn ,fixture-pn)
          ,@(brute-force-nested-=>-parse
              (read-from-string
                (brute-force-string-replace
                  (sconc
                    `("["
                      ,@(rest
                          (list-of-col-php-arr-lines
                            (list-of-lines-from-file!
                              fixture-pn))))))))))
      (declaim
        (notinline brute-force-inno-db-col)
        #+sbcl(sb-ext:maybe-inline
                brute-force-inno-db-col))



      (declaim (inline main))
      (defun
          main
          ()
""
          (declare
            (optimize (speed 0) (safety 3)
                      (debug 3)))
          'end-of-doc-string-and-declarations
        (let
            (controllers-alists inno-recs
             #|fixture-pns|#)
          (setf controllers-alists
               (read-controller-table!
                 controller-file-pn))
          (setf inno-recs
                (select-inno-db-recs
                  controllers-alists))
;         (setf fixture-pns
;               (select-inno-db-fixture-pns
;                 inno-recs))

; Print a sequence of alists to a file for
; processing with YASON in script
; #p"json-from-lisp-data.lisp".
;
; gron(1) really hates this and cuts out early.
          (pprint
            (mapcar
              (lambda (inno-rec)
                (brute-force-inno-db-col
                  (inno-db-sql-table-name-key inno-rec)
                  (inno-db-fixture-key inno-rec)))
              inno-recs))))
      (declaim (notinline main)
        #+sbcl(sb-ext:maybe-inline main))

      (main)

;U001 #u"https://stackoverflow.com/questions
;    +   /10210338/json-encode-escaping
;    +   -forward-slashes"
;
;     PHP escapes *forward* slashes in function
;     json_encode() to avoid unescaped "</script>"
;     tags from poisoning HTML.  This is decidedly
;     *not* the problem in this case.

; END OF FILE #p"brute-force-col-names-lisp.lisp"
