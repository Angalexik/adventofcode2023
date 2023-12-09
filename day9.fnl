(import-macros {: dbg} :dbg)
(local advent (require :advent))
(local tablex (require :pl.tablex))
(local f (require :fun))

(fn differences [seq]
  (local diffs [])
  (for [i 1 (- (length seq) 1)]
    (table.insert diffs (- (. seq (+ i 1))
                           (. seq i))))
  diffs)

(fn predict-next [seq]
  (local history [seq])
  (var new-seq seq)
  (while (not (f.all #(= $1 0) new-seq))
    (set new-seq (differences new-seq))
    (table.insert history new-seq))
  (while (not= (length history) 1)
    (local thing (table.remove history))
    (local next (. history (length history)))
    (table.insert next (+ (. next (length next)) (. thing (length thing)))))
  (. (. history 1) (length (. history 1))))

(fn predict-start [seq]
  (local history [seq])
  (var new-seq seq)
  (while (not (f.all #(= $1 0) new-seq))
    (set new-seq (differences new-seq))
    (table.insert history new-seq))
  (while (not= (length history) 1)
    (local thing (table.remove history))
    (local next (. history (length history)))
    (table.insert next 1
                  (- (. next 1)
                     (. thing 1))))
  (. (. history 1) 1))

(fn part1 [input]
  (f.sum (f.map #(predict-next $1) input)))

(fn part2 [input]
  (f.sum (f.map #(predict-start $1) input)))

(local input (tablex.imap advent.parse-numbers (advent.lines "day9_testinput.txt")))
(print "Part 1:")
(print (part1 (tablex.deepcopy input)))
(print "Part 2:")
(print (part2 input))
