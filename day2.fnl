(local advent (require :advent))
(local stringx (require :pl.stringx))
(local pretty (require :pl.pretty))
(local f (require :fun))

(fn possible [game]
  (and (<= (. game :red)   12)
       (<= (. game :green) 13)
       (<= (. game :blue)  14)))

(fn min_power [games]
  (let [red   (f.max (f.map #(. $1 :red) games))
        green (f.max (f.map #(. $1 :green) games))
        blue  (f.max (f.map #(. $1 :blue) games))]
    (* red green blue)))

(fn parse-line [line]
  {:id (tonumber (string.match line "%d+"))
   :games (icollect [_ v (ipairs (stringx.split (string.gsub line "Game %d: " "") "; "))]
            {:blue  (or (tonumber (string.match v "(%d+) blue")) 0)
             :red   (or (tonumber (string.match v "(%d+) red")) 0)
             :green (or (tonumber (string.match v "(%d+) green")) 0)})})

(fn part1 [lines]
  (f.sum (f.map #(. $1 :id)
                (f.filter #(f.all possible (. $1 :games))
                          (f.map parse-line lines)))))

(fn part2 [lines]
  (f.sum (f.map #(min_power (. (parse-line $1) :games)) lines)))

(local lines (advent.lines "day2_testinput.txt"))
(print (part1 lines))
(print (part2 lines))
