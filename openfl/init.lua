local path = (...):gsub('%.init$', '') .. "."

require (path .. ".geom.Rectangle")