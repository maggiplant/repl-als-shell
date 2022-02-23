;; Dit werkt al, zolang de syntaxis !"commando" gebruikt wordt. Beter
;; is als de aanhalingstekens weggelaten kunnen worden. ambrevar deed
;; dit geloof ik door een eigen (read-until)-functie te gebruiken in
;; de command-reader macro.

;; Nog een verbeterpunt is de onnodige output-info zoals de NIL en
;; objectinformatie (of zo) die altijd hetzelfde is:
;; 0 (0 bits, #x0, #o0, #b0)

(defun command-reader (stream char)
  (declare (ignore char))
  (list (quote uiop:run-program) (string (read stream t nil t)) :output :string))

(set-macro-character #\! (function command-reader))
