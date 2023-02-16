// Authors: Luigi Mello Rigato and Gabriel Medrano Silva

// returns a list with the number of times each digit appears in the string
object Main {
  def main(args: Array[String]) = {
      println(ex8("hs7888a9hd12031asdh")); // example
  }
 
  def isNum(c: Char): Boolean = {
    '0' <= c && c <= '9'
  }

  // adds 1 to the count of the digit, recursively finding its position in the list
  def addNum(num: Int, count: List[Int]): List[Int] = {
    if (num == 0) List.concat(List(count.head + 1), count.tail)
    else List.concat(List(count.head), addNum(num - 1, count.tail))
  }
 
  def ex8(str: String) = {
    val count = List(0,0,0,0,0,0,0,0,0,0);
    val onlyNum = str.filter(isNum(_));
    if (onlyNum.isEmpty) count
    else onlyNum.foldLeft (count) ((count, num) => addNum(num.asDigit, count))
  }
}