#include <stdio.h>

// void rotate(int** matrix, int matrixSize){
// 	int c=0;
// 	int n=matrixSize-1;
// 	for( c=0 ; c <= n ; c++, n--) {
// 		for( int i=c, j=n ; i<n; i++, j--) {
// 		   	int tmp = matrix[c][j];
// 			matrix[c][j] = matrix[i][c];
// 			matrix[i][c] = matrix[n][i];
// 			matrix[n][i] = matrix[j][n];
// 			matrix[j][n] = tmp;
//      	}
// 	}
// }
void rotate(int **matrix, int matrixSize){
    int n=matrixSize-1;
    for( int c=0 ; c <= n ; c++, n--) {
        for( int i=c, j=n ; i<n; i++, j--) {
            int tmp = *((int *)matrix +c * matrixSize + j );
            *((int *)matrix + c * matrixSize + j )= *((int *)matrix + i * matrixSize + c );
            *((int *)matrix + i * matrixSize + c )= *((int *)matrix + n * matrixSize + i );
            *((int *)matrix + n * matrixSize + i )= *((int *)matrix + j * matrixSize + n );
            *((int *)matrix + j * matrixSize + n )= tmp;
        }
    }
}

int main() {
    // int matrix[9] = {1,2,3,4,5,6,7,8,9};
    // int n=3;
    // rotate(matrix,n);
    // for (int i=0;i<9;i++){
    //     if (i%3 == 0){
    //         printf("\n");
    //     }
    //     printf("%d ",matrix[i]);
    // }
    int matrix[3][3] = {{1,2,3},{4,5,6},{7,8,9}};
    // int matrix[5][5] = {{1,2,3,4,5},{6,7,8,9,10},{11,12,13,14,15},{16,17,18,19,20},{21,22,23,24,25}};
    int n = sizeof(matrix)/sizeof(matrix[0]);
    for(int i=0;i<n;i++){
        for(int j=0;j<n;j++){
            printf("%d ",matrix[i][j]);
        }
        printf("\n");
    }
    printf("\n");
    rotate(matrix,n);
    for(int i=0;i<n;i++){
        for(int j=0;j<n;j++){
            printf("%d ",matrix[i][j]);
        }
        printf("\n");
    }
}