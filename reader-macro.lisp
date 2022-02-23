;; Dit is een reader macro om sh-commando's uit te voeren vanuit een
;; Common Lisp REPL. In de functie command-reader wordt van een stream
;; die als argument binnenkomt, een form gemaakt:
;; (values (uiop:run-program (string stream) :output :string))
;; Deze functie wordt uitgevoerd nadat de reader een uitroepteken (!)
;; voorbij komt. Alles wat op dezelfde regel na het uitroepteken staat
;; wordt stream in command-reader en daarmee een sh-commando dat
;; uitgevoerd wordt met uiop:run-program.

;; TODO: Daadwerkelijk de hele regel na het uitroepteken de stream
;; laten worden. Nu wordt alleen datgene dat direct na het
;; uitroepteken staat het stream-argument van command-reader.



(defun command-reader (stream char)
  (declare (ignore char))
  (let ((orig-rtable-case (readtable-case *readtable*))
	(read-stream (read stream t nil t)))
    (setf (readtable-case *readtable*) :preserve)
    (return-from command-reader (list (quote values) (list (quote uiop:run-program) (string
										     (if (equal (type-of read-stream 'cons))
												(eval read-stream)
												read-stream))
							   :output :string)))
    (setf (readtable-case *readtable*) orig-rtable-case)))

(set-macro-character #\! (function command-reader))
