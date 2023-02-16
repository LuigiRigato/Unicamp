-- the function "isAvl" receives a Tree and returns True if it is an AVL tree and False otherwise

import Data.Maybe

data Tree a = Empty | Node a (Tree a) (Tree a)

-- checks that the heights of the left and right trees are not different by at most 1
closeHeights alt1 alt2 = abs (fromJust(alt1) - fromJust(alt2)) < 2

-- if it is an empty tree it is AVL
-- otherwise, use recursion to find (bottom to top, from the leaves to the root) the heights of each node
-- if a node is balanced, it sends its height upwards like a Just in a Maybe; otherwise it sends a Nothing
-- if any node is Nothing, all higher nodes will check this and return Nothing to the root

isAvl_aux Empty = Just 0
isAvl_aux (Node _ ae ad)
    | isJust(searchLeft) && isJust(searchRight) && closeHeights searchLeft searchRight = Just (1 + (max (fromJust(searchLeft)) (fromJust(searchRight))))
    | otherwise = Nothing
        where
            searchLeft = isAvl_aux ae
            searchRight = isAvl_aux ad


isAvl tree = isJust $ isAvl_aux tree
