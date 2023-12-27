(fn inc [x]
  `(set ,x (+ ,x 1)))

(fn dec [x]
  `(set ,x (- ,x 1)))

{: inc : dec}
