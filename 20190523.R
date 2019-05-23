# write.table unimplemented type 'list' in 'encodeelement'
# content is list
# use fwrite instead of write.table
# fwrite not yet implemented in fwrite
# fwrite works with NA
# so modify NULL to NA

library(data.table)
tmp = list(NULL, "abc", "defg")
tmp[sapply(tmp, is.null)] = NA
fwrite(tmp, "D:/test.csv")
