(import-macros {: dbg} :dbg)
(local advent (require :advent))
(local utils (require :pl.utils))
(local stringx (require :pl.stringx))
(local tablex (require :pl.tablex))
(local f (require :fun))

(fn parse-input [lines]
  (local instructions (table.remove lines 1))
  (table.remove lines 1)
  {:steps instructions
   :nodes (collect [_ line (ipairs lines)]
            (values (string.match line "(%w+) =") {:L (string.match line "(%w+),")
                                                   :R (string.match line ", (%w+)")}))})

(fn part1 [input start]
  (var finished false)
  (var distance 0)
  (var node start)
  (each [_ step (f.cycle input.steps) &until finished]
    (if (not= node "ZZZ")
        (do
          (set node (. (. input.nodes node) step))
          (set distance (+ distance 1)))
        (set finished true)))
  distance)

(fn gcd [x y]
  (if (= y 0)
      x
      (gcd y (math.fmod x y))))

(fn lcm [x y]
  (/ (* x y) (gcd x y)))

(fn lcm-more [numbers]
  (f.foldl lcm 1 numbers))

(fn things-and-stuff [input start]
  (var finished false)
  (var distance 0)
  (var node start)
  (each [_ step (f.cycle input.steps) &until finished]
    (if (not= (stringx.at node 3) "Z")
        (do
          (set node (. (. input.nodes node) step))
          (set distance (+ distance 1)))
        (set finished true)))
  distance)

(fn part2 [input]
  (var finished false)
  (var distance 0)
  (var current-nodes (f.totable (f.filter #(= (stringx.at $1 3) "A")
                                          input.nodes)))
  (local lengths (f.map #(things-and-stuff (tablex.copy input) $1) current-nodes))
  ; There's no reason this should work, but it does.
  (lcm-more lengths))

(local lines (advent.lines "day8_input.txt"))
(print "Part 1:")
(print (part1 (parse-input lines) "AAA"))
(print "Part 2:")
(print (part2 (parse-input lines)))
