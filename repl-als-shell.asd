(asdf:defsystem :repl-als-shell
  :description "Een klein programmaatje om POSIX sh-commando's in een Lisp-repl uit te voeren, geïnspireerd door A Lisp REPL as my main shell van Pierre Neidhardt"
  :version "1.0"
  :author "Joeke de Graaf"
  :components ((:file "package")
	       (:file "main" :depends-on ("package"))))
