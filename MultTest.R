
multTest <- function(id = 1,
                     tz = "UTC", #OlsonNames(),  Sys.timezone()
                     show_table = FALSE, 
                     save_result = TRUE, 
                     seed = NULL) {
  
  #Load Packages
  using<-function(...) {
    libs<-unlist(list(...))
    req<-unlist(lapply(libs,require,character.only=TRUE))
    need<-libs[req==FALSE]
    
    if(length(need)>0){ 
      install.packages(need)
      lapply(need,require,character.only=TRUE)
    }
  }
  
  using("beepr","cowsay","praise", "plyr", "ggplot2", "lubridate")
  
  
  #Function to take integer input only
  int_input <- function() {
    oldw <- getOption("warn")
    options(warn = -1)
    
    int_val <- FALSE
    while (int_val == FALSE) {
      input <- as.integer(readline())
      if (is.na(input) == FALSE) {int_val <- TRUE}
    }
    options(warn = oldw)
    return(input)
  }

  #Instructions and Inputs 
  cat("Specify the size of the multiplication table by providing an integer value",
    " and pressing enter. \n",
      "E.g., 12 = 12 x 12\n\n", sep = "")
  
  max_val = int_input() #Table Size
  
  cat("A ", max_val, " x ", max_val, " multiplication table will be tested.\n\n",
      sep = "")
  
  for (i in 5:1) {
    cat("The test will begin in ", i, " . . . \n\n", sep = "")
    Sys.sleep(1)
  }
  
  N  <- max_val * max_val #Total number of questions
  
  mistakes = 0 # Mistake counter
  
  #Dataframe of question values
  vals <- data.frame(
    nums_L = rep(1:max_val, each = max_val),
    nums_R = rep(1:max_val, max_val)
  )
  
  set.seed(seed)
  vals <- vals[sample(1:nrow(vals)), ] #Shuffle questions
  
  #Reaction Time
  startRT <- vector()
  stopRT <- vector()

  #Begin Test
  for (i in 1:N){
    trialEnd <- FALSE
    
    #Trial (single question)
    while (trialEnd == FALSE) {
      #Question
      quest <- cat(vals$nums_L[i], " x ", vals$nums_R[i], " = ?\n", sep = "")
  
      #Answer
      startRT <- c(startRT, Sys.time())
      answer <- int_input()
      stopRT <- c(stopRT, Sys.time())
      
      #Eval
      correct <- vals$nums_L[i] * vals$nums_R[i] == answer
      if (correct == FALSE) {mistakes <- mistakes + 1} 
      
      if (correct == TRUE) {
        trialEnd <- TRUE
      } else if (show_table == TRUE) {
        print(1:max_val %*% t(1:max_val))
        cat("\n")
      }
    }
  } # End of Test
  
  #Results
  diff = stopRT - startRT
    
  start_time_UNIX <- startRT[1]
  start_time = as_datetime(startRT[1], tz = tz)
  dur <- sum(diff)
  end_time_UNIX <- startRT[1] + dur
  end_time <- as_datetime(end_time_UNIX, tz = tz)
  
  #Results DF
  results <- data.frame(
    id = id,
    date = format(end_time, format = "%m-%d-%Y"),
    start_time = format(start_time, format = "%H:%M:%S"),
    start_UNIX = start_time_UNIX,
    end_time = format(end_time, format = "%H:%M:%S"),
    end_UNIX = end_time_UNIX,
    size = max_val,
    quest_total = N,
    duration = dur,
    mistakes = mistakes,
    resp_rate = N / dur
  )
  

  
  if (save_result == TRUE) {
    oldw <- getOption("warn")
    options(warn = -1)
    dir.create("Data")
    options(warn = oldw)
    
    write.csv(results, 
              paste("Data/multTestData", round(as.numeric(end_time)), ".csv", 
                    sep = ""),
              row.names = FALSE,
              fileEncoding = "UTF-8")
    
    
    #Pull All Results
    path = paste(getwd(), "/Data", sep = "")
    files <- list.files(path = path, pattern = "*", full.names = TRUE)
    compl_df <- data.frame()
    if (length(files) > 0) {
      compl_df <- ldply(files, read.csv)
    }
    
    #Make Column with Date and Time
    compl_df$date_time <- paste(compl_df$date, compl_df$start_time,
                                    sep = " ")
    
    compl_df$date_time <- as.POSIXct(compl_df$date_time, 
                                         format = "%m-%d-%Y %H:%M:%S")
    
    #Table Dimension Column
    compl_df$table_size <- paste(compl_df$size, " x ", compl_df$size, sep = "")
    
    p1 <- ggplot(compl_df, aes(x = date_time, y = duration, 
                          colour = table_size, shape = table_size)) +
      facet_wrap(~ id, scales = "free") +
      geom_line() +
      geom_point() +
      scale_x_datetime() +
      xlab("Date and Time") + ylab("Duration (sec)") +
      ggtitle("Multiplication Test Results") +
      labs(colour = "Table Size",
           shape = "Table Size")
    
    ggsave("MultTestPlot.pdf", plot = p1)
    #print(p1)
    
  } #End Save Function
  
  #Conclusion
  say(what = paste("That took you ", round(dur, 2), " seconds! ", 
                   praise(), sep = ""), by = "random")
  beep(3)

  
} # End of Function


#multTest(tz = "America/Edmonton")
