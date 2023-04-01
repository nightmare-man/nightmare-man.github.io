---
layout: post
title: leetcode每日题1
subtitle: leetcode每日题1
date: 2023-4-1
author: nightmare-man
tags: 数据结构与算法
---

# 0x00

![](/assets/img/2asdasdas.png)

思路，暴力解法就是两个for循环双指针。

优化考虑，凡是n^2的考虑用分治，将分为左边和右边，因此s=max(s左，s右,s跨越左右 )

而s跨越左右则用双指针，从中间往两头扫描，扫描一次就能拿到。最终nlogn。

进一步发现，如果已知s左小于0，那说明s跨肯定小于s右。

那进一步优化，我们可以将左端为1，右端为n-1 因此能先求出s左。后面递归的求s右，最终我们发现这是一个线性扫描的过程，因此变为n。代码如下：

```c++
class Solution {
public:
    int maxSubArray(vector<int>& nums) {
        vector<int> sum(nums.size(),-99999);
        sum[0]=nums[0];
        int max=nums[0];
        for(int i=1;i<nums.size();i++){
            if(sum[i-1]>0) sum[i]=sum[i-1]+nums[i];
            else sum[i]=nums[i];
            if(sum[i]>max) max=sum[i];
        }
        
        return max;
    }
};
```

