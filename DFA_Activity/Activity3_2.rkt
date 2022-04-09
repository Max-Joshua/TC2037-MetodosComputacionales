;;; Joshua Ruben Amaya Camilo A01025258
;;; Andrea Yela González A01025250
;;; Código de un DFA para leer los componentes de una fórmula

#lang racket

(provide arithmetic-lexer)

(define (validate-string input-string dfa)
    " Determine if the input string is accepted by the dfa "

    (let loop
        (
            [lst (string->list input-string)]
            [transition (car dfa)]
            [state (cadr dfa)]
            [item-list empty]
            [token-list empty]
        )

        (if (empty? lst)
            (if (member state (caddr dfa))
                (if (equal? state 'blank-after-var)
                    token-list
                    (append token-list (list (list (process item-list) state)))
                )
            #f
            )

            (let-values
                ([(state token-type item) (transition state (car lst))])
                (loop
                    (cdr lst)
                    transition
                    state
                    (if (char-blank? item)
                        empty
                        (if token-type
                            (list item)
                            (append item-list (list item))
                        )
                    )

                    (if token-type
                        (append token-list (list (list (process item-list) token-type)))
                        token-list
                    )
                )
            )
        )
    )
)

(define (accept-simple-arithmetic-with-type state symbol)
    " Transition function that accepts arithmetic
    expressions with decimal point. Acceptance states:
        * 'int
        * 'float
        * 'space
        * 'variable
        * 'parenthesis"

    (let
        (
            [operator (list #\+ #\- #\* #\/ #\^ #\=)]
            [parenthesis (list #\( #\) )]
        )

        (cond
            [(eq? state 'q0) (cond ; Initial char
                [(char-numeric? symbol) (values 'int #f symbol)]
                [(char-blank? symbol) (values 'q0 #f symbol)]
                [(eq? symbol #\-) (values 'int #f symbol)]
                [(char-alphabetic? symbol) (values 'variable #f symbol)]
                [(member symbol parenthesis) (values 'parenthesis #f symbol)]
                [else (values 'invalid #f symbol)]
            )]

            [(eq? state 'parenthesis) (cond ; Initial char 
                [(char-numeric? symbol) (values 'int 'parenthesis symbol)]
                [(char-blank? symbol) (values 'space 'parenthesis symbol)]
                [(eq? symbol #\-) (values 'int #f symbol)]
                [(char-alphabetic? symbol) (values 'variable 'parenthesis symbol)]
                [(member symbol parenthesis) (values 'parenthesis 'parenthesis symbol)]
                [else (values 'invalid #f symbol)]
            )]

            [(eq? state 'int) (cond ; Int input
                [(char-numeric? symbol) (values 'int #f symbol)]
                [(char-blank? symbol) (values 'blank-after-var 'int symbol)]
                [(member symbol operator) (values 'operator 'int symbol)]
                [(eq? symbol #\.) (values 'float #f symbol)]
                [(member symbol parenthesis) (values 'parenthesis 'int symbol)]
                [else (values 'invalid #f symbol)]
            )]

            [(eq? state 'float) (cond ; Number after point
                [(char-numeric? symbol) (values 'float #f symbol)]
                [(char-blank? symbol) (values 'blank-after-var 'float symbol)]
                [(member symbol operator) (values 'operator 'float symbol)]
                [(eq? symbol #\.) (values 'invalid 'float symbol)]
                [(member symbol parenthesis) (values 'parenthesis 'float symbol)]
                [else (values 'invalid #f symbol)]
            )]

            [(eq? state 'space) (cond ; Space
                [(char-blank? symbol) (values 'space #f symbol)]
                [(member symbol operator) (values 'operator #f symbol)]
                [(eq? symbol #\.) (values 'invalid #f symbol)]
                [(char-numeric? symbol) (values 'int #f symbol)]
                [(char-alphabetic? symbol) (values 'variable #f symbol)]
                [(member symbol parenthesis) (values 'parenthesis #f symbol)]
                [else (values 'invalid #f symbol)]
            )]

            [(eq? state 'operator) (cond ; Symbol
                [(char-blank? symbol) (values 'blank-after-symbol 'operator symbol)]
                [(char-numeric? symbol) (values 'int 'operator symbol)]
                [(member symbol operator) (values 'invalid 'operator symbol)]
                [(eq? symbol #\.) (values 'invalid 'operator symbol)]
                [(char-alphabetic? symbol) (values 'variable 'operator symbol)]
                [(member symbol parenthesis) (values 'parenthesis 'operator symbol)]
                [else (values 'invalid #f symbol)]
            )]

            [(eq? state 'blank-after-symbol) (cond
                [(char-blank? symbol) (values 'blank-after-symbol #f symbol)]
                [(member symbol operator) (values 'invalid #f symbol)]
                [(eq? symbol #\.) (values 'invalid #f symbol)]
                [(char-numeric? symbol) (values 'int #f symbol)]
                [(char-alphabetic? symbol) (values 'variable #f symbol)]
                [(member symbol parenthesis) (values 'parenthesis #f symbol)]
                [else (values 'invalid #f)]
            )]

            [(eq? state 'blank-after-var) (cond
                [(char-blank? symbol) (values 'blank-after-var #f symbol)]
                [(member symbol operator) (values 'operator #f symbol)]
                [(member symbol parenthesis) (values 'parenthesis #f symbol)]
                [else (values 'invalid #f symbol)]
            )]

            [(eq? state 'variable) (cond
                [(char-numeric? symbol) (values 'variable #f symbol)]
                [(char-alphabetic? symbol) (values 'variable #f symbol)]
                [(eq? symbol #\_) (values 'variable #f symbol)]
                [(member symbol operator) (values 'operator 'variable symbol)]
                [(char-blank? symbol) (values 'blank-after-var 'variable symbol)]
                [(member symbol parenthesis) (values 'parenthesis 'variable symbol)]
                [else (values 'invalid #f symbol)]
            )]

            [(eq? state 'invalid) (values 'invalid #f symbol)]
        )
    )
)

(define (arithmetic-lexer str)
    (validate-string str (list accept-simple-arithmetic-with-type 'q0 (list
        'int
        'float
        'space
        'variable
        'parenthesis
        'blank-after-var
    )))
)

(define (process lst)
    (apply string-append
        (map (lambda (e)
            (if (char? e)
                (string e)
                (number->string e)
            ))
        lst
        )
    )
)

(arithmetic-lexer "723")
(arithmetic-lexer "345 + 1")
(arithmetic-lexer "56.3 / 2")
(arithmetic-lexer "49 ^ 4")