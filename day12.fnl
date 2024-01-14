(import-macros {: dbg} :dbg)
(import-macros {: inc} :macros)
(local advent (require :advent))
(local utils (require :pl.utils))
(local f (require :fun))

(fn parse [file]
  (icollect [_ line (ipairs (advent.lines file))]
    (let [[record lengths] (utils.split line " ")]
      {: record
       :lengths (advent.parse-numbers lengths ",")})))

(fn valid-record [record]
  (local blocks (icollect [_ v (ipairs (utils.split record.record "%."))]
                  (if (not= v "") (length v))))

  (if (= (length blocks) (length record.lengths))
    (f.all #(= $1 $2)
           (f.zip blocks record.lengths))
    false))

(fn fix-record [record mask]
  (local list (advent.strtolist record.record))
  (var mask-idx 0)
  (each [i v (ipairs list)]
    (when (= v "?")
      (local masked-bit (band mask (lshift 1 mask-idx)))
      (tset list i (if (= masked-bit 0) "." "#"))
      (inc mask-idx)))
  {:record (table.concat list "")
   :lengths record.lengths})

; https://gist.github.com/davidm/2065267#file-hamming_weight_test-lua-L133
(local m1 0x55555555)
(local m2 0xC30C30C3)
(fn count-ones [number]
  (var x (- number (band (rshift number 1) m1)))
  (set x (+ (band x m2) (band (rshift x 2) m2) (band (rshift x 4) m2)))
  (set x (+ x (rshift x 6)))
  (band (+ x (rshift x 12) (rshift x 24)) 0x3F))

; (fn count-ones [number]
;   (var x number)
;   (var count 0)
;   (while (> x 0)
;     (set count (+ count (band x 1)))
;     (set x (rshift x 1)))
;   count)

(fn possibilities [record]
  (local unknowns (f.length (f.filter #(= $ "?") record.record)))
  (local total (- (f.sum record.lengths) 
                  (f.length (f.filter #(= $ "#") record.record))))
  (var solutions 0)
  (for [i 0 (- (^ 2 unknowns) 1)]
    (when (= (count-ones i) total)
      (local fixed (fix-record record i))
      (when (valid-record fixed)
        ; (dbg (= (dbg (count-ones i)) (dbg total)))
        (inc solutions))))
  solutions)

(fn part1 [input]
  (f.sum (icollect [i record (ipairs input)]
           (do
             (if (= (% i 1) 0) (print "Progress:" i))
             (possibilities record)))))

(fn expand [input]
  (icollect [_ record (ipairs input)]
    {:record (table.concat (f.totable (f.take_n 5 (f.cycle [record.record]))) "?")
     :lengths (f.totable (f.take_n (* 5 (length record.lengths)) 
                                   (f.cycle record.lengths)))}))

(fn part2 [input]
  (part1 (expand input)))

(local input (parse "day12_testinput.txt"))
(dbg (f.max (f.map #(f.length (f.filter #(= $ "?") $.record)) input)))
(print "Part 1:")
(dbg (possibilities (. input 6)))
(print (part1 input))
(print "Part 2:")
(print (part2 input))
