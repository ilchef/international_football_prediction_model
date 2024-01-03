normalise_neutral_prediction <- function(prediction,prediction_inverse){
  #home vs away should be same as away vs home for neutral prediction
  data.frame(away.win = c(mean(c(prediction$away.win,prediction_inverse$home.win)))
             ,home.win = c(mean(c(prediction$home.win,prediction_inverse$away.win)))
             ,tie = c(mean(c(prediction$tie,prediction_inverse$tie)))
  )
}