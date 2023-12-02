(local advent (require :advent))
(local utils (require :pl.utils))
(local stringx (require :pl.stringx))
(local tablex (require :pl.tablex))
(local func (require :pl.func))
(local f (require :fun))

(local digits {:one 1
               :two 2
               :three 3
               :four 4
               :five 5
               :six 6
               :seven 7
               :eight 8
               :nine 9})

(fn replace-in-string [str]
  (fn min [f a b]
    (if (< (or (f a) math.maxinteger)
           (or (f b) math.maxinteger))
        a
        b))
  (fn max [f a b]
    (if (> (or (f a) math.mininteger)
           (or (f b) math.mininteger))
        a
        b))
  (let [start (f.min_by #(min (func.bind1 stringx.lfind str)
                              $1 $2)
                        (tablex.keys digits))
        end (f.max_by #(max (func.bind1 stringx.rfind str)
                            $1 $2)
                      (tablex.keys digits))
        start-idx (stringx.lfind str start)
        end-idx (stringx.rfind str end)]
    (if (and start-idx end-idx) 
        (.. (string.sub str 1 (- start-idx 1))
            (. digits start)
            (string.sub str start-idx (+ end-idx (length end) -1))
            (. digits end)
            (string.sub str (+ end-idx (length end) -1) -1))
        str)))

(fn part1 [lines]
  (f.sum (f.map #(tonumber
                   (let [cleaned (string.gsub $1 "%a" "")]
                        (.. (stringx.at cleaned 1)
                            (stringx.at cleaned -1))))
                lines)))

(fn part2 [lines]
  (print (replace-in-string "zoneight234"))
  (part1 (f.map replace-in-string lines)))


(local lines1 (advent.lines "day1_testinput.txt"))
(local lines2 (advent.lines "day1_testinput2.txt"))

(print "Part 1:")
(print (part1 lines1))
(print "Part 2:")
(print (part2 lines2))
