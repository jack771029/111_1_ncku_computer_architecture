#include<stdio.h>
#include<stdlib.h>
int *getRow(int ,int*);

int main(){

	int *ans = NULL;
	int ans_size ;
	int i;

	int rowIndex = 0;
	ans = getRow(rowIndex, &ans_size);
    printf("%d\n",ans_size);
    for(i=0;i<ans_size;i++){
		printf("%d ",ans[i]);
	}
	printf("\n");

	rowIndex = 3;
	ans = getRow(rowIndex, &ans_size);
    printf("%d\n",ans_size);
    for(i=0;i<ans_size;i++){
		printf("%d ",ans[i]);
	}
	printf("\n");

	rowIndex = 5;
	ans = getRow(rowIndex, &ans_size);
    printf("%d\n",ans_size);
    for(i=0;i<ans_size;i++){
		printf("%d ",ans[i]);
	}
	printf("\n");

	return 0;
}

int* getRow(int rowIndex, int* returnSize){

	int *ret_arr =  malloc(sizeof(int)* (rowIndex + 1));
    *returnSize = (rowIndex + 1);
    ret_arr[0]=1;    //initialize the first line

    int a = 0;      //create two temporary variables
    int b = 1;
    for(int i = 0; i<=rowIndex; i++){       //for each row
        a = 0;
        b = 1;
        for(int id = 0; id < i; id++){      //iterate over the row
            ret_arr[id] = a+b;
            a=b;
            b=ret_arr[id+1];
        }
        ret_arr[i] = 1;                      //add a final one in the row
    }

    return ret_arr;

}