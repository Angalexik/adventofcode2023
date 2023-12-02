(local utils (require :pl.utils))

(fn lines [file]
  (utils.split (utils.readfile file false) "\n"))

{:lines lines}
