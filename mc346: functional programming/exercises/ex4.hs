import Data.List (words)

-- function "countWordsLetters" receives a string
-- and returns a tuple with the number of words and the number of letters in the string

countWordsLetters str = (words, letters)
    where
        wordsList = words str
        words = foldr (\word -> (+) 1) 0 wordsList
        letters = foldr (\word -> (+) (foldr (\letter -> (+) 1) 0 word)) 0 wordsList 
