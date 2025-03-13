module utils.fs;

struct EmbeddedFile
{
    string fileName;
    string fileData;
}

static EmbeddedFile[5] EmbeddedFiles = [
    EmbeddedFile("src/main.lisp", `(in-package :cl-user)

(defpackage {%project-name%}
  (:use :cl)
  (:export :main))
(in-package :{%project-name%})

(defun main ()
  (princ "Hello from {%project-name%}"))
`),
    EmbeddedFile(".gitignore", `*.abcl
*.fasl
*.dx32fsl
*.dx64fsl
*.lx32fsl
*.lx64fsl
*.x86f
*~
.#*
`), EmbeddedFile("README.md",
            `# {%project-name%} - {%project-description%}

## Usage

## Installation

## License

Licensed under the {%project-license%} License.
`),
    EmbeddedFile("default.asd",
            `(in-package :asdf-user)

(defsystem "{%project-name%}"
  :version "{%project-version%}"
  :author "{%project-author%}"
  :license "{%project-license%}"
  :depends-on ()
  :components ((:module "src"
				;; :serial t
                :components
                (;; (:file "file-name")
				 (:file "main"))))
  :description "{%project-description%}"
  :build-operation "program-op" ;; leave as is
  :build-pathname "{%project-name%}"
  ;; entry-point: main is an exported symbol. Otherwise, use "{%project-name%}::main" instead.
  :entry-point "{%project-name%}:main")

;;;; sbcl executable compression
;;#+sb-core-compression
;;(defmethod asdf:perform ((o asdf:image-op) (c asdf:system))
;;  (uiop:dump-image (asdf:output-file o c)
;;                   :executable t
;;                   :compression t))
`), EmbeddedFile("Makefile", `LISP?=sbcl
run: FORCE
	@$(LISP) --load {%project-name%}.asd \
			 --eval '(ql:quickload :{%project-name%})' \
			 --eval '(in-package :{%project-name%})' \
			 --eval '(main)'

build: FORCE
	@$(LISP) --load {%project-name%}.asd \
			   --eval '(ql:quickload :{%project-name%})' \
			   --eval '(asdf:make :{%project-name%})' \
			   --eval '(quit)'

FORCE:
`),
];

static EmbeddedFile embeddedCompose = EmbeddedFile(
        `src/{%project-compose%}.lisp`, `(in-package :cl-user)

(defpackage {%project-name%}.{%project-compose%}
  (:use :cl)
  (:export :{%project-compose%}))
(in-package :{%project-name%}.{%project-compose%})

(defun {%project-compose%} ()
  (princ "Hello from {%project-name%}.{%project-compose%}"))
`);
