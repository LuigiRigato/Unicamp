-- Authors: Luigi Mello Rigato and Gabriel Medrano Silva
-- Simplified Dijsktra's algorithm

import Data.List

-- if two strings are equal
isEqual str1 str2 = isSubsequenceOf str1 str2 && isSubsequenceOf str2 str1 

-- creates forward direction adjacent list (from A to B)
adjList1 [] (nodeA, nodeB, dist) = [(nodeA, [(nodeB, dist)])]
adjList1 ((vertex, neighbs):xs) (nodeA, nodeB, dist)
    | isEqual vertex nodeA = ((vertex, ((nodeB, dist) : neighbs)) : xs)
    | otherwise = (vertex, neighbs) : adjList1 xs (nodeA, nodeB, dist)

-- creates backward direction adjacent list (from B to A)
adjList2 [] (nodeA, nodeB, dist) = [(nodeB, [(nodeA, dist)])]
adjList2 ((vertex, neighbs):xs) (nodeA, nodeB, dist) 
    | isEqual vertex nodeB = ((vertex, ((nodeA, dist) : neighbs)) : xs)
    | otherwise = (vertex, neighbs) : adjList2 xs (nodeA, nodeB, dist)

-- returns the shorter tuple of two tuples
shorter (a1, dist) (a2, dist2) = if (dist < dist2) then (a1, dist) else (a2, dist2)

-- returns the tuple with the shortest distance in a list of tuples
shortest = foldl1 shorter

-- creates the initial distance list from the origin node
-- in which, initially, all nodes have distance infinity except the origin node itself
cr8DistList origNodeId = map (\(nodeId, conn) -> if isEqual nodeId origNodeId then (nodeId, 0) else (nodeId, 1/0))

-- iterates through the list of connections of the shortest node
iter8Graph :: Float -> [([Char], Float)] -> ([Char], Float) -> ([Char], Float)
iter8Graph _ [] neighbAnalyzed = neighbAnalyzed
iter8Graph lastShrtstDist ((idNeighb, neighbWeight):xs) neighbAnalyzed = if(isEqual idNeighb (fst neighbAnalyzed))
  then ((fst neighbAnalyzed), min (snd neighbAnalyzed) (neighbWeight + lastShrtstDist))
  else iter8Graph lastShrtstDist xs neighbAnalyzed

-- updates the distance to the nodes that are connected to the last-shortest-distance node
-- returns distList updated
upd8 :: Float -> [([Char], Float)] -> [([Char], Float)] -> [([Char], Float)]
upd8 _ _ [] = []
upd8 lastShrtstDist connShrtstList (neighbAnalyzed:ys) = (iter8Graph lastShrtstDist connShrtstList neighbAnalyzed):(upd8 lastShrtstDist connShrtstList ys)

-- returns distList without the shortest node
delShrtst shrtstNode distList = filter (\(nodeId, dist) -> (nodeId, dist) /= shrtstNode) distList

-- returns the nodes connected to the shortest node
connShrtst shrtstNode distList adjList = snd $ head $ filter (\(nodeId, conn) -> isEqual nodeId (fst shrtstNode)) adjList

-- if the shortest node is already the destination node, returns the distance to it
-- else, updates the list of distances recursevely until the destination is reached
dijkstra adjList distList origNodeId destNodeId
  |isEqual (fst shrtstNode) destNodeId = snd shrtstNode
  |otherwise = dijkstra adjList (upd8 (snd shrtstNode) (connShrtst shrtstNode distList adjList) (delShrtst shrtstNode distList)) origNodeId destNodeId
    where shrtstNode = shortest distList

-- creates the adjacent list from the graph input data
-- creates the distance list (distList) from the adjacent list
-- calls dijkstra
ex7 graph origNodeId destNodeId = dijkstra adjList distList origNodeId destNodeId
  where adjList = foldl adjList2 (foldl adjList1 [] graph) graph
        distList = cr8DistList origNodeId adjList

-- example
main = do
  print (ex7 [("1", "2", 7),("1", "3", 9),("1", "6", 14),("2", "3", 10),("2", "4", 15),("3", "4", 11),("3", "6", 2),("4", "5", 6),("5", "6", 9)] "1" "5")