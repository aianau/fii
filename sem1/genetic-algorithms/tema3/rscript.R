
files <- dir(path="D:\\FII2\\genetic-algorithms\\tema3\\", pattern="*.result", full.names=TRUE, recursive=FALSE)

print(files)

for(i in 1:length(files)){
  print('============================')
  print('============================')
  print('============================')
  print(files[i])
  z <- scan(files[i], what = double(6)) # load file
  # apply function
  # out <- function(t)
  # write to file
  # write.table(out, file + ".stats", sep="\t", quote=FALSE, row.names=FALSE, col.names=TRUE)
 
  print("min") 
  print(min(z))
  
  print("mean") 
  print(mean(z))
  
  print("sd")
  print(sd(z))
  
  print("median")
  print(median(z))
}


