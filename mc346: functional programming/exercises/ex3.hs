-- Authors: Luigi Mello Rigato and Gabriel Medrano Silva

import Data.Char(isDigit)

--function "digitcounter" receives a string and returns a list of how many times each digit appears in the string

chartoint ch
     | ch == '0' = 0
     | ch == '1' = 1
     | ch == '2' = 2
     | ch == '3' = 3
     | ch == '4' = 4
     | ch == '5' = 5
     | ch == '6' = 6
     | ch == '7' = 7
     | ch == '8' = 8
     | ch == '9' = 9
     | otherwise = -1

digitcounter [] = [0,0,0,0,0,0,0,0,0,0]
digitcounter string = digitcounter' [0,0,0,0,0,0,0,0,0,0] 0 $ map chartoint $ filter isDigit string
-- passes the already filtered and mapped string
-- counts how many 0s in the string, then how many 1s, how many 2s... until it counts how many 9s
     where
         digitcounter' [] _ _ = []
         digitcounter' (x:xs) digit string = digitamount : digitcounter' xs (digit + 1) string
             where
                 digitamount = foldr (\ch -> (+) 1) 0 digits
                 digits = filter (== digit) string