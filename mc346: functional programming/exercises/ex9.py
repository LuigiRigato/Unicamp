def funcao(str1, str2):
    '''Iterates through str1, cheking if the substring [from that point until the end of str1] matches the substring
    from the beginning of str2. The substring of str1 needs to be less than or equal to str2, in order to 
    compare the substrings in the two.'''
    size1 = len(str1)
    size2 = len(str2)
    subStr = 0
    for i in range(size1):
        if size1 - i <= size2 and str1[i:] == str2[:size1 - i]:
            subStr = size1 - i
            break
    return str2[:subStr]

solution = funcao("abcxxxxa", "xxaabcd")
print(f"\"{solution}\"")
