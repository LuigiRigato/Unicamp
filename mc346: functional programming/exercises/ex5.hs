-- Authors: Luigi Mello Rigato and Gabriel Medrano Silva

-- function "benford" returns the relative count of the first digit of each word in the text
-- in order to compare it with the Benford's law

import Data.List
import qualified Data.Map.Strict as Map

-- sum 1 in the number count. For example, if 3 was found 5 times, the freqList [...(3,5)...] becomes [...(3,6)...]
sum1 freqList ch = Map.insertWith (+) ch 1 freqList

benford txt = relativeCount $ sort $ Map.toList $ foldl sum1 freqIni numbers
    where
        -- the text is mapped to only identify the first letter of each word and then to filter those that are digits
        numbers = filter (`elem` ['1'..'9']) $ map head $ words txt

        -- outputs freqList, the frequency list, with all counts at zero initially
        freqIni = Map.fromList $ map (\ch -> (ch,0)) ['1'..'9']
        
        -- turns absolute counts into relative counts by dividing them by the total count: the sumFreq of all counts
        relativeCount freqList = map (\(ch,amount) -> (ch,(fromInteger amount) / sumFreq freqList)) freqList
            where sumFreq freqList = fromInteger $ sum $ map snd freqList