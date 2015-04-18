# The following function used to generate the 20 files of prediction of the cases on 
# test set

pml_write_files = function(x){
  n = length(x)
  for(i in 1:n){
    filename = paste0("problem_id_",i,".txt")
    write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
  }
}

# set the answers to the prediction vector from the Writeup project.

answers = PredTest20

# generate the 20 files of answers

pml_write_files(answers)