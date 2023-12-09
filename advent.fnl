(local utils (require :pl.utils))

(fn read [file]
  (utils.readfile file false))

(fn lines [file]
  (utils.split (utils.readfile file false) "\n"))

(fn strtolist [str]
  (icollect [c (str:gmatch ".")] c))

(fn map2d [file]
  (icollect [_ line (ipairs (lines file))]
    (strtolist line)))

(fn parse-numbers [str]
  (icollect [_ s (ipairs (utils.split str " "))]
    (tonumber s)))

{:lines lines :map2d map2d :read read :parse-numbers parse-numbers}
