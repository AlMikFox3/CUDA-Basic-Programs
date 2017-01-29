
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include<cuda.h>

#include <stdio.h>

__global__ void addKernel(int * dev_a)
{
    int i = threadIdx.x;
	dev_a[i] = dev_a[i] + 15;
}

int main()
{
	const int size = 6;
	int a[size][size];
	int b[size][size] = {0};
	int i = 0, j = 0;
	for (i = 0; i < size; i++)
		for (j = 0; j < size; j++)
			scanf("%d", &a[i][j]);

	int *dev_a;
	int t = size*size*sizeof(int);
	cudaMalloc((void**)&dev_a, t);
	cudaMemcpy(dev_a, a, t, cudaMemcpyHostToDevice);
	addKernel << <1, size*size >> >(dev_a);
	cudaMemcpy(b, dev_a, t, cudaMemcpyDeviceToHost);
	for (i = 0; i < size; i++){
		for (j = 0; j < size; j++){
			printf("%d ", b[i][j]);
		}
		printf("\n");
	}

    return 0;
}



