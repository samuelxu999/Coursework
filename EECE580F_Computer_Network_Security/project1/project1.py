#!/usr/bin/python

'''
Created on Jan 30, 2017

@author: Xu Ronghua
@Email:  rxu22@binghamton.edu
@TaskDescription: 
1) Print on the screen total number of words and sentences in the text.
2) Give a number of occurrences of each word and the frequency for each word
3) Give me the number of sentences and the frequency in the novel
4) Find the most frequent two word combination in the text
5) Print results of tasks 3 and 4 on the screen
'''

import re

'''
Function:read text contents from sample file
         create {words:count} dictionary, sum of words
@arguments: 
(input)  filepath:    test file path
(out)    out_count:   return with sored {word count} list array
(out)    out_sum:   return with sum of words
(out)    out_words:   return with string  list of words
(out)    dict_count:   return with diction list of words:count
'''
def readWords(filepath):

    #define file handle to open select file
    fname = open(filepath, 'r')    
    #read text from open file to tmp_string
    tmp_string=fname.read()
    #close file
    fname.close()
    
    #transfer to lowercase
    tmp_lower=tmp_string.lower()
    
    ''''
    extract words for text.
    1) handle symbol "'". eg,"don't" is defined as a word
    2) Hyphens in composite words will be used as split words, 
    eg:state-of-the-art will be split as four words
    '''    
    regex = r'([a-zA-z]+[\']*[a-zA-z]+)'
    ls_words= re.findall(regex, tmp_lower, re.M)
    
    #define variable to count words as dictionary list { word:count } 
    tmp_wordcount={}
    out_sum=len(ls_words)
    # for each words in the file to count words sum
    for tmp_word in ls_words:#.split():
        #first appear, set default value=1
        if tmp_word not in tmp_wordcount:
            tmp_wordcount[tmp_word] = 1
        #for tmp_wordcount words, add 1 for each appear
        else:
            tmp_wordcount[tmp_word] += 1     
    
    #sord list by value field
    out_count=sorted(tmp_wordcount.items(), key=lambda d: d[1],reverse=True)
    out_words=ls_words
   
    #return {word:count} list
    return out_count,out_sum,out_words


'''
Function:Find the most frequent word pairs in the text
@arguments: 
(input)  ls_words:        words list for calculate words combination frequency
(input)  ls_wordscount:   sorded words dictionary for construct regex words combination
'''
def collectWordpair(ls_words,ls_wordscount):
    ''''
    calculate most frequent two word combination in the text.
    '''     
    #aggregate words as whole string str_words
    str_words=""
    for tmp_word in ls_words:
        #use space as split mark        
        str_words+=tmp_word
        str_words+=" "
    
    '''
    define variable to save most frequenct words data: 
    #@max_combine: save maximum frequent words pairs 
    #@max_freq: save maximum frequenct value  
    #@dict_freq: save dictionary list :{combination frequency}
    '''   
    max_freq=0
    max_combine=""    
    dict_freq={}
    
    '''
    For each two words combination to get the most frequency couple.         
    '''   
    for t_key_a,t_value_a in ls_wordscount:
        for t_key_b,t_value_b in ls_wordscount:          
            #if max frequency is greater than current words frequency
            if ((max_freq>t_value_a) or (max_freq>t_value_b)):
                #skip to next pair
                break
            
            #regulation expression by using two words combination, eg: r'war and'
            regex_freq=t_key_a+" "+t_key_b 
            
            #get the sum of wordpair:"regex_freq" in words string
            combine_sum=len(re.findall(regex_freq, str_words, re.M))
            
            #update the maximum data
            if (max_freq<combine_sum): 
                max_freq=combine_sum
                max_combine=regex_freq
                dict_freq[regex_freq] = combine_sum
    #get sorted frequent word pairs list.
    dict_freq=sorted(dict_freq.items(), key=lambda d: d[1],reverse=True)        
    print("Most frequent words pair is:\"%s\", frequent is:%s" %(max_combine, max_freq)) 
    #print(dict_freq)  
    
'''
Function:read text contents from sample file
         create {sentences:count} dictionary, sum of sentences
@arguments: 
(input)  filepath:        test file path used for reading data
(out)    tmp_count:       return with sored {sentence count} list array
(out)    tmp_sum:         return with sum of all sentences
(out)    search_count:    return with sored {sentence count} search list array
(out)    search_sum:      return with sum of search sentences
'''
def readSentences(filepath):
    #define file handle to open select file
    fname = open(filepath, 'r')    
    #read text from open file to tmp_string
    tmp_string=fname.read()
    #close file
    fname.close()    
   
    #remove special character, such as spaces (" ")from string
    tmp_string=tmp_string.replace('"' , "")
    tmp_string=tmp_string.replace('\r' , "")
    tmp_string=tmp_string.replace('\n' , " ")
    
    ''''
    extract all sentences starting with letter, end with ".!?:"
    1) nested sentences will be devied: eg: General said: "Brace yourself! Winter is coming!"
    will be devied as three sentences: General said:| Brace yourself! | Winter is coming!
    '''
    #Define regular expressions to parse sentences
    regex = r'([a-zA-Z][^\.!?:]*[\.!?:])'    
    #find all sentences and saved as string list "tmp_sentences"
    tmp_sentences= re.findall(regex, tmp_string, re.M)  
      
    #define variable to count words as hashtable as{ snetence:count } 
    tmp_count={}
    #define variable to count sum of sentences
    tmp_sum=len(tmp_sentences) 
    
    #define variable to count sentences starting with The or the
    search_sum=0
    search_count={}
    #define reg expression to search sentences starting with The or the
    regex_search = r'([T|t]he\b)'
        
    # for each sentence in the tmp_sentences to count sum
    for tmp_sentence in tmp_sentences:
        #first appear, set default value=1
        if tmp_sentence not in tmp_count:
            tmp_count[tmp_sentence] = 1
        #for tmp_wordcount words, add 1 for each appear
        else:
            tmp_count[tmp_sentence] += 1   
        
        #count sentences matching condition
        isMatch=re.match(regex_search, tmp_sentence, re.M)
        if isMatch:
            search_sum+=1
            if tmp_sentence not in search_count:                
                search_count[tmp_sentence] = 1
            else:
                search_count[tmp_sentence] += 1
            
    #sord list by value field
    tmp_count=sorted(tmp_count.items(), key=lambda d: d[1],reverse=True)
    search_count=sorted(search_count.items(), key=lambda d: d[1],reverse=True)    
    
    return tmp_count,tmp_sum,search_count,search_sum
   

'''
Function:print word list statistics data
@arguments: 
(input)  ls_words:    {words:count} list
(input)  ls_total:    sum of words
'''
def printWordcount(ls_words,ls_total):
    #print words sum data
    print("Words sum is:%s, distinct words are:%s, statistics data is saved in result.csv" 
          %(ls_total,len(ls_words)))   
    #write words statistics data to result.csv
    writefile(ls_words,ls_total,"result.csv")   

'''
Function:print sentences list statistics data
@arguments: 
(input)  ls_sentences:      {sentences:count} list
(input)  ls_sum:            sum of words
(input)  ls_searchcount:    return with sored {sentence count} search list array
(input)  ls_searchsum:      return with sum of search sentences
'''
def print_Sentencecount(ls_sentences,ls_sum,ls_searchcount,ls_searchsum):
    #print snetences sum data
    print("Sentences sum is:%s." %(ls_sum))   
    #print search sentences data: those start with "The" or "the"
    print("Sentences sum which start with 'The' or 'the' is:%s, frequency is:%s." 
          %(ls_searchsum,(ls_searchsum*1.0/ls_sum)))
        
    #write sentences statistics data to *.csv
    writefile(ls_sentences,ls_sum,"result_all_sentence.csv")
    writefile(ls_searchcount,ls_searchsum,"result_search_sentence.csv")

'''
Function:write list statistics data to *.csv
@arguments: 
(input)  ls_sentences:    {sentences:count} list
(input)  ls_total:        sum of sentences
(input)  filename:        file name for saving data
'''
def writefile(ls_sentences,ls_total, filename):
    tmp_file = open(filename, "w") 
    #write format head    
    tmp_file.write("Object, Count, Frequency\n")    
    #for each sentence and list count and calculate frequency
    for t_key,t_value in ls_sentences:
        tmp_frequency=(t_value*1.0/ls_total)
        #print ("%s, %s, %.8f" %(t_key,t_value,tmp_frequency))
        tmp_file.write("%s, %s, %.8f\n" %(t_key,t_value,tmp_frequency))
    tmp_file.close()  


'''
Function: used as main for executing function and export test result
@arguments: NULL
'''
def main(): 
    #define filename to load test data
    #filename=sys.argv[1]
    filename="text.txt"
    
    #========================== print words statistics data ==========================================
    #Get {words count} list and sum words
    (ls_wordcount,ls_sum,ls_string)=readWords(filename)
    
    #print turple {word count frequency } data, for test.
    printWordcount(ls_wordcount,ls_sum)
    
    #========================== print sentences statistics data ======================================
    #Get {sentences count} list and sum sentences
    (ls_sentencecount,ls_sentencesum,ls_searchcount,ls_serchsum)=readSentences(filename)
    
    #print turple {word count frequency } data, for test
    print_Sentencecount(ls_sentencecount,ls_sentencesum,ls_searchcount,ls_serchsum)
    
    #Find and print the most frequent two word combination in the text
    collectWordpair(ls_string,ls_wordcount)
    
    return 0
  
  
#Call main function   
if __name__ == "__main__":
    main()

    
    

    