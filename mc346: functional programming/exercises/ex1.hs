-- function "trocatodos" that replaces all occurrences of a given value in a list with another value
changeall old new [] = []

changeall old new (x:xs)
     | x == old = new : change all old new xs
     | otherwise = x : change all old new xs

-------------------------------------------------- ----------

-- function altsum that operates the elements of a list, alternating between addition and subtraction
altsum_aux_[] = 0
altsum_aux added (x:xs)
     | added == False = (altsum_aux True xs) + x
     | otherwise = (altsum_aux False xs) - x

altsum(x:xs) = x + altsum_aux False xs