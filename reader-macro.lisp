;; Dit is een reader macro om sh-commando's uit te voeren vanuit een
;; Common Lisp REPL. In de functie command-reader wordt van een stream
;; die als argument binnenkomt, een form gemaakt:
;; (values (uiop:run-program (string stream) :output :string))
;; Deze functie wordt uitgevoerd nadat de reader een uitroepteken (!)
;; voorbij komt. Alles wat op dezelfde regel na het uitroepteken staat
;; wordt stream in command-reader en daarmee een sh-commando dat
;; uitgevoerd wordt met uiop:run-program.

;; TODO: Daadwerkelijk de hele regel na het uitroepteken de stream
;; laten worden zolang de stream niet begint met "("
;; Nu wordt alleen datgene dat direct na het uitroepteken staat het
;; stream-argument van command-reader.



(defun list-in-stream-p (stream)
  (if (equal (read-char stream) #\()
      (progn
	(unread-char #\( stream)
	T)
      (progn
	(unread-char #\( stream)
	'nil)))

(defun command-reader (stream char)
  (declare (ignore char))
  (if (list-in-stream-p stream) ;; Als er een lijst in de stream zit
      (setf (readtable-case *readtable*) :upcase) ;; de stream inlezen als hoofdletters
      (setf (readtable-case *readtable*) :preserve)) ;; anders de stream behouden zoals die binnenkwam
  (let ((orig-rtable-case (readtable-case *readtable*))
	(read-stream (read stream t nil t)))
    (return-from command-reader (list (quote values) (list (quote uiop:run-program) (string
										     (if (equal (readtable-case *readtable*) :upcase) ;; Op basis van de vorige check (list-in-stream-p) 
												(eval read-stream) ;; ofwel de ingelezen stream uitvoeren als die met een lijst begint
												read-stream)) ;; of de ingelezen stream zo gebruiken
										     :output :string)))
      (setf (readtable-case *readtable*) orig-rtable-case)))


(set-macro-character #\! (function command-reader))
