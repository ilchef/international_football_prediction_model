normalise_neutral_prediction <- function(prediction,prediction_inverse){
  #home vs away should be same as away vs home for neutral prediction
  data.table(awaywin = c(mean(c(prediction$awaywin,prediction_inverse$homewin)))
             ,homewin = c(mean(c(prediction$homewin,prediction_inverse$awaywin)))
             ,tie = c(mean(c(prediction$tie,prediction_inverse$tie)))
  )
}