(import-macros {: dbg} :dbg)
(import-macros {: inc} :macros)
(local advent (require :advent))
(local utils (require :pl.utils))
(local tablex (require :pl.tablex))
(local f (require :fun))

(fn transpose [grid]
  (local rows (length grid))
  (local cols (length (. grid 1)))
  (local transposed [])
  (for [i 1 cols]
    (tset transposed i [])
    (for [j 1 rows]
      (tset transposed i j (. (. grid j) i))))
  transposed)

(fn confirm-mirror [map y]
  (var count 1)
  (var result true)
  (if (> y (length map))
    (for [i 1 y -1 &until (not result)]
      (set result (tablex.compare (. map i) (. map (+ y count)) "=="))
      (inc count))
    (for [i y (length map) &until (not result)]
      (set result (tablex.compare (. map i) (. map (- y count)) "=="))
      (inc count)))
  result)

(fn horizontal-reflection [map]
  (var number nil)
  (each [i row (ipairs (dbg map)) &until number]
    (when (and (tablex.compare row (or (. map (- i 1)) []) "==") (confirm-mirror map i))
      (set number (- i 1))))
  number)

(fn vertical-reflection [map]
  (horizontal-reflection (transpose map)))

(fn part1 [maps]
  (+ (f.sum (f.map #(* (or (horizontal-reflection $) 0) 100) maps))
     (f.sum (f.map #(or (vertical-reflection $) 0) maps))))

(local input (icollect [_ stuff (ipairs (utils.split (advent.read "day13_input.txt") "\n\n"))]
               (icollect [_ line (ipairs (utils.split stuff "\n"))]
                 (advent.strtolist line))))
(dbg input)
(print "Part 1:")
(print (dbg (part1 input)))
; (print "Part 2:")
; (print (part2 input))
