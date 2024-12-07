(import-macros {: dbg} :dbg)
(local stringx (require :pl.stringx))
(local width 50)

(fn ProgressBar [size]
  {: size
   :progress 0
   :inc    (fn [self n]
             (tset self :progress (+ self.progress n))
             (self:redraw))
   :redraw (fn [self]
             (local fraction (/ self.progress self.size))
             (io.stderr:write (string.format "\r%3d%%|%s| %d/%d"
                                             (math.floor (* 100 fraction))
                                             (stringx.ljust (string.rep "#" (math.floor (* width fraction))) 
                                                            width
                                                            " ")
                                             self.progress
                                             self.size)))
   :close (fn [self]
            (io.stderr:write "\n"))})

{: ProgressBar}
