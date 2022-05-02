;; Dit is een reader macro om sh-commando's uit te voeren vanuit een
;; Common Lisp REPL. In de functie command-reader wordt van een stream
;; die als argument binnenkomt, een form gemaakt:
;; (values (uiop:run-program (string stream) :output :string))
;; Deze functie wordt uitgevoerd nadat de reader een uitroepteken (!)
;; voorbij komt. Alles wat op dezelfde regel na het uitroepteken staat
;; wordt stream in command-reader en daarmee een sh-commando dat
;; uitgevoerd wordt met uiop:run-program.
                     
;; TODO: Ook output met een foutmelding zou door moeten komen
                     

(defun list-in-stream-p (stream)
  (if (equal (read-char stream) #\()
      (progn
	(unread-char #\( stream)
	T)
      (progn
	(unread-char #\( stream)
	'nil)))


;; (defun read-entire-stream (stream &optional entire-stream)
;;   (let ((char-temp-storage (read-char stream 'nil :eof t)))
;;     (if (or (equal char-temp-storage #\newline) (equal char-temp-storage :eof))
;; 	;; read-from-string zorgt er in deze functie voor dat entire-stream,
;; 	;; die nog alles na het uitroepteken bevat, ingekort wordt tot de
;; 	;; eerste spatie, ondanks dat :eof als eof wordt meegegeven
;; 	(progn (print entire-stream) (with-input-from-string (returned-stream entire-stream)
;;                                        returned-stream              ))
;; 	(read-entire-stream stream (concatenate 'string entire-stream (string char-temp-storage))))))


(defun read-entire-stream (stream &optional stream-as-string)
  (let ((char (read-char stream 'nil :eof t)))
    (if (or (equal char #\newline)
	    (equal char :eof))
	(or stream-as-string "error 1")
	(read-entire-stream stream (concatenate 'string
						(or stream-as-string "")
						(string char))))))

(defun command-reader (stream char)
  (declare (ignore char))
  (if (list-in-stream-p stream) ;; Als er een lijst in de stream zit
      (setf (readtable-case *readtable*) :upcase) ;; de stream inlezen als hoofdletters
      (setf (readtable-case *readtable*) :preserve)) ;; anders de stream behouden zoals die binnenkwam
  (let ((orig-rtable-case (readtable-case *readtable*))
	(read-stream (read-entire-stream stream))) ;; "read-stream" als in "ingelezen stream"
    (print read-stream)
    (return-from command-reader (list (quote values) (list (quote uiop:run-program) (string
										     (if (equal (readtable-case *readtable*) :upcase) ;; Op basis van de vorige check (list-in-stream-p) 
											 (eval read-stream) ;; ofwel de ingelezen stream uitvoeren als die met een lijst begint
											 read-stream)) ;; of de ingelezen stream zo gebruiken
							   :output :string :ignore-error-status 'nil)))
    (setf (readtable-case *readtable*) orig-rtable-case)))


(set-macro-character #\! (function command-reader))
