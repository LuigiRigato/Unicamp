{- function "compress" returns a list of tuples
where the first element of the tuple is the element of the original list
and the second element is the number of times that element appears in the original list-}
compress :: (Eq a) => [a] -> [(a, Int)]

compress_aux [] acc last = [(last, acc)]
compress_aux (x:xs) acc last
     | x == last = compress_aux xs (acc + 1) x
     | otherwise = (last, acc) : compress_aux xs 1 x

compress(x:xs) = compress_aux(x:xs) 0 x

------------------------------------------------------------
--function "decompress" that decompresses a list of tuples as returned by the function "compress"
decompress :: (Eq a) => [(a, Int)] -> [a]

decompress_aux [] _ = []

decompress_aux(x:xs) acc
     | acc == snd x = fst x : decompress_aux xs 1
     | otherwise = fst x : decompress_aux (x:xs) (acc + 1)

decompress (x:xs) = decompress_aux (x:xs) 1
