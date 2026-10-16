; Правила Dart для оценки когнитивной и цикломатической сложности.
; Источник: treesitter_cyclomatic_complexity, коммит 7b216f2344d87a910e6c1ffbd974fe60950c15ce.
; Лицензия MIT находится рядом в LICENSE.
; Профиль Space дополнительно учитывает collection if/else/for и верхнеуровневые свойства.
; Подпись функции и её тело в этой грамматике — соседние узлы.
; Замыкания включаются в родительскую функцию; switch учитывается как одно решение.
; Логические цепочки учитываются по сериям операторов. Рекурсия по символам не определяется.

((function_signature) @function.signature
  .
  (function_body) @function.body)

((method_signature) @function.signature
  .
  (function_body) @function.body)

(function_expression
  body: (function_expression_body) @function.body)

(if_statement) @decision
(if_statement alternative: (_) @cognitive.flat)
(if_statement alternative: (if_statement) @chained)

(for_statement) @decision
(while_statement) @decision
(do_statement) @decision

(conditional_expression) @decision

(catch_clause) @decision
(try_statement ("on" . (type_identifier) . (block) @decision))

(switch_statement_case) @cyclomatic
(switch_statement) @cognitive

(switch_expression_case) @cyclomatic
(switch_expression) @cognitive

(logical_and_expression) @decision.flat
(logical_or_expression) @decision.flat
(if_null_expression) @decision.flat

(if_element) @decision
(if_element alternative: (_) @cognitive.flat)
(if_element alternative: (if_element) @chained)
(for_element) @decision
((getter_signature) @function.signature . (function_body) @function.body)
((setter_signature) @function.signature . (function_body) @function.body)
