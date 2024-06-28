def find_max(nums):
    masx_num = float("-inf")
    for num in nums:
        if num > masx_num:
            masx_num += 1
            print(masx_num)
    return(masx_num)