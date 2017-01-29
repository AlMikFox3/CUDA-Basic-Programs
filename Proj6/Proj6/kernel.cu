
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include<cuda.h>

#include <stdio.h>

__global__ void addKernel(int * dev_a, int* x)
{
	int i = threadIdx.x;
	if (dev_a[i] < *x)
		dev_a[i] = 0;
	else
		dev_a[i] = 1;
}

int main()
{
	const int size = 6;
	int a[size][size];
	int b[size][size] = { 0 };
	int i = 0, j = 0, x;
	for (i = 0; i < size; i++)
		for (j = 0; j < size; j++)
			scanf("%d", &a[i][j]);

	scanf("%d", &x);

	int *dev_a, *dev_x;
	int t = size*size*sizeof(int);
	cudaMalloc((void**)&dev_a, t);
	cudaMalloc((void**)&dev_x, sizeof(int));
	cudaMemcpy(dev_a, a, t, cudaMemcpyHostToDevice);
	cudaMemcpy(dev_x, &x, sizeof(int), cudaMemcpyHostToDevice);
	addKernel << <1, size*size >> >(dev_a, dev_x);
	cudaMemcpy(b, dev_a, t, cudaMemcpyDeviceToHost);
	printf("-----OUTPUT-----\n");
	for (i = 0; i < size; i++){
		for (j = 0; j < size; j++){
			printf("%d ", b[i][j]);
		}
		printf("\n");
	}

	return 0;
}



