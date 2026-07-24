(use-modules (guix graph)
             (guix scripts graph)
             (guix profiles)
             (guix store)
             (guix monads)
             (gnu packages base)
             (ice-9 getopt-long)
             (ice-9 format)
             (srfi srfi-13))

(define option-spec
  '((host    (single-char #\H) (value #t))
    (type    (single-char #\t) (value #t))
    (backend (single-char #\b) (value #t))))

(define options (getopt-long (command-line) option-spec))

(define host (option-ref options 'host #f))
(define type-name (option-ref options 'type "package"))
(define backend-name (option-ref options 'backend "graphviz"))

(unless host
  (format (current-error-port)
          "error: --host is required, e.g. --host=x86_64-linux-gnu\n")
  (exit 1))

(define (type-name->node-type name)
  (cond
   ((string=? name "package")          %package-node-type)
   ((string=? name "reverse-package")  %reverse-package-node-type)
   ((string=? name "bag")              %bag-node-type)
   ((string=? name "bag-emerged")      %bag-emerged-node-type)
   ((string=? name "bag-with-origins") %bag-with-origins-node-type)
   ((string=? name "reverse-bag")      %reverse-bag-node-type)
   (else
    (format (current-error-port)
            "error: unknown --type '~a'\nvalid types: package, reverse-package, bag, bag-emerged, bag-with-origins, reverse-bag\n"
            name)
    (exit 1))))

(define (backend-name->backend name)
  (or (lookup-backend name)
      (begin
        (format (current-error-port)
                "error: unknown --backend '~a'\nvalid backends on this Guix: ~a\n"
                name
                (string-join (map graph-backend-name %graph-backends) ", "))
        (exit 1))))

(define (backend-name->extension name)
  (cond
   ((string=? name "cyclonedx-json") "json")
   ((string=? name "graphml")        "graphml")
   ((string=? name "d3js")           "html")
   ((string=? name "cypher")         "cypher")
   (else                             "dot")))

(define node-type (type-name->node-type type-name))
(define backend (backend-name->backend backend-name))

(setenv "HOST" host)

(define manifest (load "bitcoin/contrib/guix/manifest_build.scm"))

(define output-file
  (string-append "manifest_" host "_" type-name "_" backend-name "."
                 (backend-name->extension backend-name)))

(call-with-output-file output-file
  (lambda (port)
    (with-store store
      (run-with-store store
        (export-graph (map manifest-entry-item (manifest-entries manifest))
                       port
                       #:node-type node-type
                       #:backend backend)))))

(format #t "wrote ~a\n" output-file)