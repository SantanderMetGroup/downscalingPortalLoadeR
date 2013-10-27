loadDownscaling <- function(filename){
	text <- readLines(file.path(filename))
	headerEnd <- match('', text)
	columnsStart <- match('Columns', text) + 2
	if(is.na(headerEnd) || is.na(columnsStart)) stop("Unrecognized file format")
	l <- lapply(
		text[(headerEnd + 2) : length(text)], 
		function(line){
			dataStr <- unlist(strsplit(line, ","))
			res <- list(as.numeric(as.Date(dataStr[1])))
			return(c(res, as.list(as.numeric(dataStr[2:length(dataStr)]))))
		}
	)
	downscalingData <- data.frame(lapply(data.frame(t(sapply(l, `[`))), unlist))
	stations <- unlist(lapply(
		text[columnsStart : (headerEnd - 1)], 
		function(line){
			line <- gsub("^\\s+|\\s+$", "", line) # trim
			lineData <- unlist(strsplit(line, ","))
			return(lineData[2])
		}
	))
	downscalingData <- as.data.frame(downscalingData)
	names(downscalingData) <- c("Date", stations)
	downscalingData <- transform(downscalingData, Date = as.Date(Date, origin = "1970-01-01"))
	names(downscalingData) <- c("Date", stations)
	return(downscalingData)
}