#!/opt/local/bin/sbcl --script

; FILE #p"brute-force-col-names-json.lisp"

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

;     (ql:quickload '(yason)
      (require :yason)

      (defmethod
          yason:encode
          ((object pathname)
           &optional stream)
        (yason:encode
          (uiop:native-namestring object)
          stream))

      (defun
          main
          ()
"Expects a stream of alists on standard input,
because YASON gets confused between regular
lists and alists, otherwise."
          (declare
            (optimize (speed 0) (safety 3)
                      (debug 3)))
          'end-of-doc-string-and-declarations
        (let ((eos-gs (gensym (string 'eos-)))
              tmp
              (yason:*symbol-encoder*
                #'yason:encode-symbol-as-lowercase)
              (json-stdout
               (yason:make-json-output-stream
                 *standard-output*
                 :indent t)))
          (loop do
                (setf tmp
                      (read *standard-input*
                            nil
                            eos-gs))
                (when (eq tmp eos-gs)
                  (return))
                (let
                    ((yason:*symbol-key-encoder*
                       #'yason:encode-symbol-as-string))
;                 (yason:encode tmp json-stdout)
                  (yason:encode-alist
                   tmp
                   json-stdout)))))

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
