(import-macros {: dbg} :dbg)
(local advent (require :advent))
(local Set (require :pl.Set))
(local stringx (require :pl.stringx))
(local tablex (require :pl.tablex))
(local utils (require :pl.utils))
(local f (require :fun))

(fn extract-numbers [str]
  (Set (f.totable (f.map tonumber (utils.split str "%s+")))))

(fn parse-card [card]
  (local parsed (utils.split (string.sub card (stringx.lfind card ":"))
                             " | "
                             true))
  {:id (tonumber (string.match card "Card%s+(%d+):"))
   :winning (extract-numbers (. parsed 1))
   :mine (extract-numbers (. parsed 2))})

(fn part1 [cards]
  (f.sum (f.map #(let [winning (. $1 :winning)
                       mine (. $1 :mine)
                       matches (tablex.size (* winning mine))]
                   (if (= matches 0)
                     0
                     (^ 2 (- matches 1))))
                cards)))

(fn part2 [cards]
  (local pile (collect [_ v (ipairs cards)]
                (values v.id 1)))
  (each [icard card (ipairs cards)]
    (local wins (tablex.size (* card.winning card.mine)))
    (for [ipile (+ card.id 1) (+ card.id wins)]
      (tset pile ipile (+ (. pile ipile)
                          (. pile icard)))))
  (accumulate [sum 0
               _ n (pairs pile)]
    (+ sum n)))

(local cards (f.totable (f.map parse-card (advent.lines "day4_testinput.txt"))))
(print "Part 1:")
(print (part1 cards))
(print "Part 2:")
(print (part2 cards))
