(import-macros {: dbg} :dbg)
(local advent (require :advent))
(local utils (require :pl.utils))
(local f (require :fun))

(fn extract-values [lines]
  (table.remove lines 1)
  (local stuff [])
  (each [_ v (ipairs lines)]
    (local vs (f.totable (f.map tonumber (utils.split v))))
    (table.insert stuff {:destination (. vs 1)
                         :source (. vs 2)
                         :length (. vs 3)}))
  stuff)

(fn parse-input [input]
  (local maps {:seeds []
               :seed-soil []
               :soil-fertilizer []
               :fertilizer-water []
               :water-light []
               :light-temperature []
               :temperature-humidity []
               :humidity-location []})
  (each [_ v (ipairs (utils.split input "\n\n"))]
    (local lines (utils.split v "\n"))
    (case (. lines 1)
      "seed-to-soil map:" (tset maps :seed-soil (extract-values lines))
      "soil-to-fertilizer map:" (tset maps :soil-fertilizer (extract-values lines))
      "fertilizer-to-water map:" (tset maps :fertilizer-water (extract-values lines))
      "water-to-light map:" (tset maps :water-light (extract-values lines))
      "light-to-temperature map:" (tset maps :light-temperature (extract-values lines))
      "temperature-to-humidity map:" (tset maps :temperature-humidity (extract-values lines))
      "humidity-to-location map:" (tset maps :humidity-location (extract-values lines))
      l (tset maps :seeds (f.totable (f.map tonumber (utils.split (string.sub l 8)))))))
  maps)

(fn convert [thing maps]
  (var ret nil)
  (each [_ v (ipairs maps) &until (not= ret nil)]
    (if (and (>= thing v.source) (< thing (+ v.source v.length)))
      (set ret (+ v.destination (- thing v.source)))))
  (or ret thing))

(fn reverse-convert [thing maps]
  (var ret nil)
  (each [_ v (ipairs maps) &until (not= ret nil)]
    (if (and (>= thing v.destination) (< thing (+ v.destination v.length)))
      (set ret (+ v.source (- thing v.destination)))))
  (or ret thing))

(fn part1 [input]
  (f.min (f.map #(do
                   (local soil (convert $1 input.seed-soil))
                   (local fertilizer (convert soil input.soil-fertilizer))
                   (local water (convert fertilizer input.fertilizer-water))
                   (local light (convert water input.water-light))
                   (local temperature (convert light input.light-temperature))
                   (local humidity (convert temperature input.temperature-humidity))
                   (convert humidity input.humidity-location))
                input.seeds)))

(fn parse-seeds-as-ranges [seeds]
  (local ranges [])
  (while (not= (length seeds) 0)
    (local start (table.remove seeds 1))
    (local l (table.remove seeds 1))
    (table.insert ranges {:start start :end (+ start (- l 1))}))
  ranges)

; Takes ~20 seconds to finish on real input
(fn part2 [input]
  (local seeds (parse-seeds-as-ranges input.seeds))
  (tset input :seeds nil)
  (local upper-bound (f.max (f.map #(f.max (f.map #(+ (. $1 :destination) (. $1 :length))
                                                  $2))
                                   input)))
  (var lowest nil)
  (each [location (f.range 0 upper-bound) &until (not= lowest nil)]
    (local humidity (reverse-convert location input.humidity-location))
    (local temperature (reverse-convert humidity input.temperature-humidity))
    (local light (reverse-convert temperature input.light-temperature))
    (local water (reverse-convert light input.water-light))
    (local fertilizer (reverse-convert water input.fertilizer-water))
    (local soil (reverse-convert fertilizer input.soil-fertilizer))
    (local seed (reverse-convert soil input.seed-soil))
    (if (f.any #(and (>= seed (. $1 :start))
                     (< seed (. $1 :end)))
               seeds)
        (set lowest location)))
  lowest)

(local input (parse-input (advent.read "day5_testinput.txt")))
(print "Part 1:")
(print (part1 input))
(print "Part 2:")
(print (part2 input))
