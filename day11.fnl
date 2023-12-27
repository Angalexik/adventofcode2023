(import-macros {: dbg} :dbg)
(import-macros {: inc} :macros)
(local advent (require :advent))
(local tablex (require :pl.tablex))
(local f (require :fun))

(fn print-grid [grid]
  (each [_ row (ipairs grid)]
    (print (table.concat row "")))
  grid)

(fn combinations [things n]
  (local result [])
  (local len (length things))
  (each [i x (ipairs things)]
    (each [j y (ipairs things)]
      ; < is used to avoid duplicates and enforce a specific order
      (when (< x.id y.id)
        (table.insert result [x y]))))
  result)

(fn transpose [grid]
  (local rows (length grid))
  (local cols (length (. grid 1)))
  (local transposed [])
  (for [i 1 cols]
    (tset transposed i [])
    (for [j 1 rows]
      (tset transposed i j (. (. grid j) i))))
  transposed)

(fn row-empty [grid y]
  (f.all #(= $1 ".") (. grid y)))

(fn col-empty [grid x]
  (f.all #(= $1 ".") (f.map #(. $1 x) grid)))

(fn preprocess [grid]
  (local preprocessed [])
  (each [y row (ipairs grid)]
    (table.insert preprocessed (tablex.copy row))
    (when (row-empty grid y)
      (table.insert preprocessed (tablex.copy row))))
  preprocessed)

(fn preprocess3 [grid]
  (local preprocessed (tablex.deepcopy grid))
  (var dest-offset 0)
  (each [y row (ipairs grid)]
    (when (row-empty grid y)
      (table.insert preprocessed (+ y dest-offset) (tablex.new (length row) "."))
      (inc dest-offset)))
  preprocessed)

(fn distance [[{:x x1 :y y1 :id i1} {:x x2 :y y2 :id i2}]]
  (+ (math.abs (- x1 x2)) (math.abs (- y1 y2))))

(fn part1 [grid]
  (local processed (transpose
                     (preprocess
                       (transpose
                         (preprocess grid)))))
  (local galaxies [])
  (var id 1)
  (each [y row (ipairs processed)]
    (each [x point (ipairs row)]
      (when (= point "#")
        (table.insert galaxies {: x : y : id})
        (inc id))))
  (f.sum (f.map distance (combinations galaxies))))

(fn part2 [grid]
  (local rate (- 1000000 1))
  (local galaxies [])
  (var id 1)
  (each [y row (ipairs grid)]
    (each [x point (ipairs row)]
      (when (= point "#")
        (table.insert galaxies {: x : y : id})
        (inc id))))
  (var y 1)
  (each [i row (ipairs grid)]
    (when (row-empty grid i)
      (each [_ galaxy (ipairs galaxies)]
        (when (> galaxy.y y)
          (set galaxy.y (+ galaxy.y rate))))
      (set y (+ y rate)))
    (set y (+ y 1)))
  (var x 1)
  (local transposed (transpose grid))
  (each [i col (ipairs transposed)]
    (when (row-empty transposed i)
      (each [_ galaxy (ipairs galaxies)]
        (when (> galaxy.x x)
          (set galaxy.x (+ galaxy.x rate))))
      (set x (+ x rate)))
    (set x (+ x 1)))
  (f.sum (f.map distance (combinations galaxies))))

(local input (advent.map2d "day11_testinput.txt"))
(print "Part 1:")
(print (part1 input))
(print "Part 2:")
(print (part2 input))
