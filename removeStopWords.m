function [modified_data] = removeStopWords(data)

stopWords = load('Dataset/stopWordsList');
stopWords = stopWords.stopWordsList';

modified_data = setdiff(data,stopWords,'stable');
