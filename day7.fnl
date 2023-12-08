(import-macros {: dbg} :dbg)
(local advent (require :advent))
(local utils (require :pl.utils))
(local tablex (require :pl.tablex))
(local f (require :fun))

(fn parse-cards [cards]
  (local multiset {})
  (f.each #(if (= (. multiset $1) nil)
             (tset multiset $1 1)
             (tset multiset $1 (+ (. multiset $1) 1))) 
          cards)
  multiset)

(fn parse-input [lines]
  (icollect [_ line (ipairs lines)]
    (let [split (utils.split line)
          cards (. split 1)
          bid (tonumber (. split 2))]
      {:bid bid
       :cards-set (parse-cards cards)
       :cards cards})))

(fn evaluate [cards]
  (if (f.any #(= 5 $2) cards) ; Five of a kind
      6
      (f.any #(= 4 $2) cards) ; Four of a kind
      5
      (and (f.any #(= 3 $2) cards) ; Full house
           (f.any #(= 2 $2) cards))
      4
      (f.any #(= 3 $2) cards) ; Three of a kind
      3
      (= (f.length (f.filter #(= 2 $2) cards)) 2) ; Two pairs
      2
      (f.any #(= 2 $2) cards) ; One pair
      1
      0)) ; High card

(local scores1 {:2 0
                :3 1
                :4 2
                :5 3
                :6 4
                :7 5
                :8 6
                :9 7
                :T 8
                :J 9
                :Q 10
                :K 11
                :A 12})

(local scores2 {:2 0
                :3 1
                :4 2
                :5 3
                :6 4
                :7 5
                :8 6
                :9 7
                :T 8
                :J -1
                :Q 10
                :K 11
                :A 12})

(fn complicated-stuff [a b]
  (var result nil)
  (each [_ x y (f.zip (f.map #(. scores1 $1) a)
                      (f.map #(. scores1 $1) b))
         &until (not= nil result)]
    (if (< x y)
        (set result true)
        (> x y)
        (set result false)))
  result)

(fn complicated-stuff2 [a b]
  (var result nil)
  (each [_ x y (f.zip (f.map #(. scores2 $1) a)
                      (f.map #(. scores2 $1) b))
         &until (not= nil result)]
    (if (< x y)
        (set result true)
        (> x y)
        (set result false)))
  result)

(local card-options ["2" "3" "4" "5" "6" "7" "8" "9" "T" "Q" "K" "A"])
(fn evaluate2 [cards]
  (if (= cards.J nil)
      (evaluate cards)
      (do
        (local jokers cards.J)
        (local new-new-cards (tablex.copy cards))
        (tset new-new-cards :J nil)
        (accumulate [max 0
                     _ card (ipairs card-options)]
          (do
            (local new-cards (tablex.copy new-new-cards))
            (local thing (. cards card))
            (if (= thing nil)
                (do
                  (tset new-cards card jokers)
                  (math.max max (evaluate new-cards)))
                (do
                  (tset new-cards card (+ thing jokers))
                  (math.max max (evaluate new-cards)))))))))
  

(fn part1 [input]
  (local sorted (tablex.sortv input #(let [a (evaluate (. $1 :cards-set))
                                           b (evaluate (. $2 :cards-set))]
                                       (if (= a b)
                                           (complicated-stuff (. $1 :cards) (. $2 :cards))
                                           (< a b)))))
  (f.sum (f.map #(* $1 (. $2 :bid)) (f.enumerate sorted))))

(fn part2 [input]
  (local sorted (tablex.sortv input #(let [a (evaluate2 (. $1 :cards-set))
                                           b (evaluate2 (. $2 :cards-set))]
                                       (if (= a b)
                                           (complicated-stuff2 (. $1 :cards) (. $2 :cards))
                                           (< a b)))))
  (f.sum (f.map #(* $1 (. $2 :bid)) (f.enumerate sorted))))

(local lines (advent.lines "day7_testinput2.txt"))
(print "Part 1:")
(print (part1 (parse-input lines)))
(print "Part 2:")
(print (part2 (parse-input lines)))
