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

# 0x01

![](/assets/img/QQ截图20230402123120.png)

​	要求在原数组上进行排序，如果是新数组那么双指针很简单，现在没有空间。实际上根据给的特殊条件，还是有的，因为我们可以在空出的位置进行排序。既然是末尾空出来了，那就从nums1 nums2中用双指针不断找最大的放在末尾就行了。(我做的时候是将前面空出来，不断找最小的，思路是一样的)。一个特殊情况就是，nums1和nums2有一方的指针会先到尽头，说明该方的元素全部有序了，只需要把剩下一方的全部复制到末尾即可

```c++
class Solution {
public:
    void merge(vector<int>& nums1, int m, vector<int>& nums2, int n) {
        for(int i=m-1;i>=0;i--)nums1[i+n]=nums1[i];
        int p1=n;
        int p2=0;
        int cnt=0;
        for(;p1<(m+n)&&p2<n;){
            if(nums1[p1]<nums2[p2]) nums1[cnt++]=nums1[p1++];
            else nums1[cnt++]=nums2[p2++];
        }
        if(p2!=n){
            for(;p2!=n;){
                nums1[cnt++]=nums2[p2++];
            }
        }
    }
};
```

