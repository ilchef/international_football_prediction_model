normalise_neutral_prediction <- function(prediction,prediction_inverse){
  #home vs away should be same as away vs home for neutral prediction
  data.table(awaywin = c(mean(c(prediction$away_win,prediction_inverse$home_win)))
             ,homewin = c(mean(c(prediction$home_win,prediction_inverse$away_win)))
             ,tie = c(mean(c(prediction$tie,prediction_inverse$tie)))
  )
}