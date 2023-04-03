---
layout: post
title: leetcode每日题3
subtitle: leetcode每日题3
date: 2023-4-3
author: nightmare-man
tags: 数据结构与算法
---
# 0x00

![](/assets/img/QQ截图20230403090446.png)

思路，要求的是两个数组的交集，考虑暴力解法，我们将两个数组都排序，然后用双指针来比较，如果相同，则i++ j++ 如果nums1[i]<nums2[j] 则i++依次类推。这样输出的是有序的交集。

优化，考虑题目给的特殊条件，不需要有序，因此可以用hashmap来记录数组1的每个元素出现的次数，然后查找数组二当中的每一个元素，出现一个，即加入交集，同时记录次数减一，代码如下：

```c++
class Solution {
public:
    vector<int> intersect(vector<int>& nums1, vector<int>& nums2) {
        unordered_map<int,int> map{};
        for(auto x:nums1){
            if(map.find(x)!=map.end())map[x]++;
            else map[x]=1;
        }
        vector<int> ret{};
        for(auto x:nums2){
            if(map.find(x)!=map.end()){
                ret.push_back(x);
                map[x]--;
                if(map[x]==0) map.erase(x);
            }
        }
        return ret;
    }
};
```

