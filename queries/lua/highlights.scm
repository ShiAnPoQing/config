;; extends

;; ERROR / FIXME / DEPRECATED  →  @comment.error
((comment) @comment.error
 (#match? @comment.error "ERROR|FIXME|DEPRECATED")
 (#set! priority 130)
 )

;; WARNING / FIX / HACK  →  @comment.warning
((comment) @comment.warning
 (#match? @comment.warning "WARNING|FIX|HACK")
 (#set! priority 130)
 )

;; TODO / WIP  →  @comment.todo
((comment) @comment.todo
 (#match? @comment.todo "TODO|WIP")
 (#set! priority 130)
 )

;; NOTE / INFO / XXX  →  @comment.note
((comment) @comment.note
 (#match? @comment.note "NOTE|INFO|XXX")
 (#set! priority 130)
 )
