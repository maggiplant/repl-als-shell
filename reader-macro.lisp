;; Dit werkt al, zolang de syntaxis !"commando" gebruikt wordt. Beter
;; is als de aanhalingstekens weggelaten kunnen worden. ambrevar deed
;; dit geloof ik door een eigen (read-until)-functie te gebruiken in
;; de command-reader macro.

(defun command-reader (stream char)
  (declare (ignore char))
  (list (quote values) (list (quote uiop:run-program) (string (read stream t nil t)) :output :string)))

(set-macro-character #\! (function command-reader))
