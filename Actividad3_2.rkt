;;; Joshua Ruben Amaya Camilo A01025258
;;; Andrea Yela González A01025250
;;; Código de un DFA para leer los componentes de una fórmula

#lang racket

(provide arithmetic-lexer)

; when comment is detected, continue untill empty or newline
(define (commentMarch lst construct cash)
    (cond
        [(empty? lst) (disectFormula lst (append construct (list (list cash 'Comentario))))]
        [(char=? (car lst) #\newline) (disectFormula lst (append construct (list (list cash 'Comentario))))]
        [else (commentMarch (cdr lst) construct (append cash (list (car lst))))]
    )
)

; In case of sientific notation, add E and +/- and continue float to make sure no extra . is added
(define (sientificMatch lst construct intContstruct)
    (floatMatch (cdr (cdr lst)) construct (append (append intContstruct (list (car lst))) (list (car (cdr lst)))))
)

; this is a float, it iterates on numbers untill it reaches something else
(define (floatMatch lst construct floatConstruct)
    (cond
        [(empty? lst) (disectFormula lst (append construct (list (list floatConstruct 'Real))))]
        [(char=? (car lst) #\E) (sientificMatch lst construct floatConstruct)] ; go to scientific
        [(char-numeric? (car lst)) (floatMatch (cdr lst) construct (append floatConstruct (list (car lst))))] ; go to float
        [else (disectFormula lst (append construct (list (list floatConstruct 'Real))))]
    )
)

; this is an int, it iterates on numbers untill it finds it is actually a float and changes or something else
(define (intMatch lst construct intContstruct)
    (cond
        [(empty? lst) (disectFormula lst (append construct (list (list intContstruct 'Entero))))]
        [(char=? (car lst) #\E) (sientificMatch lst construct intContstruct)] ; go to scientific
        [(char=? (car lst) #\.) (floatMatch (cdr lst) construct (append intContstruct (list (car lst))))] ; go to float
        [(char-numeric? (car lst)) (intMatch (cdr lst) construct (append intContstruct (list (car lst))))] ; go to int
        [else (disectFormula lst (append construct (list (list intContstruct 'Entero))))]
    )
)


; make sure that an operator gets used correctly. Accounts for comments and negatives
(define (operatorMatch lst construct)
    (cond
        [(char=? (car lst) '#\+) (disectFormula (cdr lst) (append construct (list (list (car lst) 'Suma))))]
        [(char=? (car lst) '#\-) (begin
            (if (char-numeric? (car (cdr lst)))
                (intMatch (cdr lst) construct (list '#\-)) ; send to int
                (disectFormula (cdr lst) (append construct (list (list (car lst) 'Resta))))
            )
        )]
        [(char=? (car lst) '#\*) (disectFormula (cdr lst) (append construct (list (list (car lst) 'Multiplicacion))))]
        [(char=? (car lst) '#\/) (if (char=? (car (cdr lst)) '#\/)
            (commentMarch lst construct '())
            (disectFormula (cdr lst) (append construct (list (list (car lst) 'Division))))
        )]
        [(char=? (car lst) '#\^) (disectFormula (cdr lst) (append construct (list (list (car lst) 'Exponente))))]
    )
)

; just simple check 
(define (isoperator? charSearch)
    (cond
        [(char=? charSearch '#\+) #t]
        [(char=? charSearch '#\-) #t]
        [(char=? charSearch '#\*) #t]
        [(char=? charSearch '#\/) #t]
        [(char=? charSearch '#\^) #t]
        [else #f]
    )
)
; main loop. It iterates over formula, and tries to disect formula deviding on what is needed
(define (disectFormula lst construct)
    (cond
        [(empty? lst) construct]
        [(char-whitespace? (car lst)) (disectFormula (cdr lst) construct)]
        [(char-numeric? (car lst)) (intMatch lst construct (list))] ; call for int type
        [(isoperator? (car lst)) (operatorMatch lst construct)] ; operator func
        [(char=? (car lst) '#\( ) (disectFormula (cdr lst) (append construct (list (list (car lst) "Parentesis que abre"))))] ; start func
        [(char=? (car lst) '#\) ) (disectFormula (cdr lst) (append construct (list (list (car lst) "Parentesis que cierra"))))] ; end func
        [(char=? (car lst) '#\= ) (disectFormula (cdr lst) (append construct (list (list (car lst) 'Asignacion))))] ; equals
        [else (disectFormula (cdr lst) (append construct (list (list (car lst) 'Variable))))] ; variables bish
    )
)

(define (arithmetic-lexer input-str)
    (disectFormula (string->list input-str) '())
)
