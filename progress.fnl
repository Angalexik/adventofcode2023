(macro peach [params ...]
  (local ins (require :inspect))
  (var len nil)
  (each [i v (ipairs params) &until (not= nil len)]
    (print (ins v))
    (when (= v (sym :&length))
      (table.remove params i)
      (set len (table.remove params i))))
  `(let [bar# ((. (require :progressbar) :ProgressBar) ,len)]
     (each ,params
       ,...
       (: bar# :inc))
     (: bar# :close)))

(macrodebug (peach [k v (ipairs [1 2]) &until (not= table nil) &length (length [1 2])]
                   (print v)
                   (print k)))

; {: peach}
