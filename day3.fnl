(local advent (require :advent))
(local MultiMap (require :pl.MultiMap))
(local Set (require :pl.Set))
(local pretty (require :pl.pretty))
(local stringx (require :pl.stringx))
(local f (require :fun))

(fn find-in-neighbours [map val x y]
 (f.filter #(= val (?. map (. $1 2) (. $1 1)))
           [[(- x 1) (- y 1)] [x (- y 1)] [(+ x 1) (- y 1)]
            [(- x 1)       y]             [(+ x 1)       y]
            [(- x 1) (+ y 1)] [x (+ y 1)] [(+ x 1) (+ y 1)]]))

(fn neighbours [map x y]
  (f.filter #(not= $1 nil)
    (f.map #(?. map (. $1 2) (. $1 1))
           [[(- x 1) (- y 1)] [x (- y 1)] [(+ x 1) (- y 1)]
            [(- x 1)       y]             [(+ x 1)       y]
            [(- x 1) (+ y 1)] [x (+ y 1)] [(+ x 1) (+ y 1)]])))

(fn part1 [map]
  (var sum 0)
  (each [y row (ipairs map)]
    (var number "")
    (var is-part false)
    (each [x char (ipairs row)]
      (when (string.match char "%d")
        (set number (.. number char))
        (set is-part (or is-part
                         (f.any #(string.match $1 "[^%d.]")
                                (neighbours map x y))))
        (when (not (string.match (or (. row (+ x 1)) "") "%d"))
          (if is-part
            (do
              (set sum (+ sum (tonumber number)))))
              ; (print (tonumber number))))
          (set number "")
          (set is-part false)))))
  sum)

(fn part2 [map]
  (local gears (MultiMap))
  (each [y row (ipairs map)]
    (var number "")
    (var gear-neighbours nil)
    (each [x char (ipairs row)]
      (when (string.match char "%d")
        (set number (.. number char))
        (set gear-neighbours (if gear-neighbours
                                 (f.chain gear-neighbours (find-in-neighbours map "*" x y))
                                 (find-in-neighbours map "*" x y)))
        (when (not (string.match (or (. row (+ x 1)) "") "%d"))
          (f.each #(gears:set $1 (tonumber number))
                  (Set.values (Set (f.totable (f.map #(stringx.join "," $1)
                                                     gear-neighbours)))))
          (set number "")
          (set gear-neighbours nil)))))
  (f.sum (f.map #(* (. $1 1) (or (. $1 2) 0)) (MultiMap.values gears))))

(local input (advent.map2d "day3_testinput.txt"))
(print "Part 1:")
(print (part1 input))
(print "Part 2:")
(print (part2 input))
