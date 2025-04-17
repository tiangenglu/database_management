library(aws.s3)
library(rstudioapi) #askForSecret
library(rjson)
library(knitr) # opts_knit$set(root.dir = "~/path") set directory for the entire workbook
library(dplyr)
# read in credential file
aws_credential <- fromJSON(file='aws_credential.txt')
# set environment variable that connects to s3 bucket
Sys.setenv("AWS_ACCESS_KEY_ID" = aws_credential$access_key,
           "AWS_SECRET_ACCESS_KEY" = aws_credential$secret_key,
           "AWS_DEFAULT_REGION" = "us-east-2")
# get bucket info after a connection is established
bucket_info <- get_bucket(aws_credential$bucket, region = 'us-east-2')
names(bucket_info$Contents)
length(bucket_info)
key_list <- vector(mode = 'character',length(bucket_info))
modify_time_list <- vector(mode = 'character',length(bucket_info))
size_list <- vector(mode = 'character', length(bucket_info))
# the following loop extracts object information from a list with length=number of objects in the bucket
for (i in 1:length(bucket_info))
{
  key_list[i] <- bucket_info[[i]]$Key
  modify_time_list[i] <- bucket_info[[i]]$LastModified
  size_list[i] <- round(bucket_info[[i]]$Size / 1024)
}
# the following is a data catalog
bucket_items <- data.frame(key = key_list, last_modify = modify_time_list, size_KB = size_list)
# subset catalog from specific locations
subset_criteria <- grepl(pattern = 'visa_scraped/', x = bucket_items$key, ignore.case = TRUE)
bucket_items[subset_criteria,]
df_items <- bucket_items |>
  filter(grepl('output', key) & size_KB > 0 & grepl('.csv', key))
df_items

# read csv from s3 bucket
df_iv <- s3read_using(read.csv, 
                      object = paste("s3://",aws_credential$bucket,"/visa_output/df_iv.csv",sep=""))
# read .txt files, note header should be FALSE, can be adjusted later
country <- s3read_using(FUN=read.delim, 
                        object = paste("s3://",aws_credential$bucket,"/",key_list[grep('country_list.txt', key_list)],sep=""))
tail(country)