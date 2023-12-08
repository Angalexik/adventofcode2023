(import-macros {: dbg} :dbg)
(local advent (require :advent))
(local utils (require :pl.utils))
(local stringx (require :pl.stringx))
(local f (require :fun))

(fn extract [line]
  (f.totable (f.map tonumber (utils.split (stringx.strip (. (utils.split line ":") 2)) "%s+"))))

(fn parse-input [[time distance]]
  (f.totable (f.map #{:time $1 :distance $2}
                    (f.zip (extract time) (extract distance)))))

(fn part1 [input]
  (f.product (f.map #(let [sqrt-thing (math.sqrt (- (^ (. $1 :time) 2) (* 4 (. $1 :distance)))) ; sqrt(time^2 - 4distance)
                           lower-bound (* 0.5 (- (. $1 :time) sqrt-thing)) ; 0.5 * (time - sqrt(time^2 - 4distance))
                           upper-bound (* 0.5 (+ (. $1 :time) sqrt-thing))] ; 0.5 * (time + sqrt(time^2 - 4distance))
                        (- (math.ceil upper-bound) (math.floor lower-bound) 1))
                    input)))

(fn part2 [[time distance]]
  (local time-string (string.gsub (. (utils.split time ":") 2) "%s+" ""))
  (local t (tonumber time-string)) ; 🤷
  (local distance-string (string.gsub (. (utils.split distance ":") 2) "%s+" ""))
  (local d (tonumber distance-string)) ; 🤷
  (let [sqrt-thing (math.sqrt (- (^ t 2) (* 4 d))) ; sqrt(time^2 - 4distance)
        lower-bound (* 0.5 (- t sqrt-thing)) ; 0.5 * (time - sqrt(time^2 - 4distance))
        upper-bound (* 0.5 (+ t sqrt-thing))] ; 0.5 * (time + sqrt(time^2 - 4distance))
    (- (math.ceil upper-bound) (math.floor lower-bound) 1)))

(local lines (advent.lines "day6_testinput.txt"))
(print "Part 1:")
(print (part1 (parse-input lines)))
(print "Part 2:")
(print (part2 lines))
