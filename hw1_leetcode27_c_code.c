#include <stdio.h>
/*
computer architecture homework1
Given an integer array nums and an integer val, remove all occurrences of val in nums.
*/
int removeElement(int *, int, int);
void print(int *, int, int);
int main() {
    int nums1[] = {1,2,3,4,5,6,7,8,9};
    int nums2[] = {1,2,3,4,5,6,7,8,4};
    int nums3[] = {4,2,3,4,4,6,7,8,9};
    int val = 4;
    int write_index;
    int numsSize;

    numsSize = sizeof(nums1)/sizeof(int);
    write_index = removeElement(nums1, numsSize, val);
    print(nums1, numsSize, write_index);

    numsSize = sizeof(nums1)/sizeof(int);
    write_index = removeElement(nums2, numsSize, val);
    print(nums2, numsSize, write_index);

    numsSize = sizeof(nums3)/sizeof(int);
    write_index = removeElement(nums3, numsSize, val);
    print(nums3, numsSize, write_index);
    return 0;
}

int removeElement(int* nums, int numsSize, int val){
    int read_index = 0;
    int write_index = 0;
    while (read_index < numsSize) {
        if (nums[read_index++] != val) {
            nums[write_index++] = nums[read_index-1];
        }
    }
    return write_index;
}

void print(int *nums, int numsSize, int write_index) {
    printf("%d, nums = [",write_index);
    for (int i = 0; i < numsSize; i++) {
        if (i < write_index) {
            printf("%d,",nums[i]);
        } else {
            printf("_,");
        }
    }
    printf("\b]\n");
}