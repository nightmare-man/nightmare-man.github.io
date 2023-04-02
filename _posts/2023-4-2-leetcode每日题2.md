---
layout: post
title: leetcode每日题2
subtitle: leetcode每日题2
date: 2023-4-2
author: nightmare-man
tags: 数据结构与算法
---

# 0x00

![](/assets/img/QQ截图20230402115534.png)

​	同意暴力解法还是两个for循环。

​	考虑题目所给特殊条件：1必有唯一解 2元素不重复

​	对于该唯一解，假设下标分别为ij，i<j。我们先假定j已知，那么从0-j-1必然存在一个值=target-num[j]。这个值的下标即为i。如果找不到，那说明j是错误的，应该换一个j。

​	因此我们让j从1到num.size()-1，对于每一个j我们不需要遍历0-j-1 ，可以用hashmap来记录前面已经出现过的元素，j增加时只需多记录一个元素即可。 

```c++
class Solution {
public:
    vector<int> twoSum(vector<int>& nums, int target) {
        unordered_map<int,int> map{};
        vector<int> ret{};
        for(int i=0;i<nums.size();i++){
            int left=target-nums[i];
            if(map.find(left)!=map.end()){
                ret.push_back(map[left]);
                ret.push_back(i);
                return ret;
            }
            map[nums[i]]=i;
        } 
        return ret;
    }
};
```

