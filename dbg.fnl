(fn dbg [expr]
  `(let [dump# (require :inspect)
         result# ,expr]
     (io.stderr:write (string.format "[%s:%d] %s = %s\n"
                                     ,(or expr.filename "<unknown>")
                                     ,(or expr.line 0)
                                     ,(tostring expr)
                                     (dump# result#)))
     result#))

{: dbg}
