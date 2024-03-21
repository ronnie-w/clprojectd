module utils.fs;

struct EmbeddedFile
{
    string fileName;
    string fileData;
}

static EmbeddedFile[4] EmbeddedFiles = [
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
    EmbeddedFile("default.asd", `(in-package :asdf-user)

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
`),
];
