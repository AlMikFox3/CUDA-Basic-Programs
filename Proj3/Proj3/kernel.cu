
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include<cuda.h>

#include <stdio.h>

__global__ void addKernel(int * dev_a, int * dev_b, int * dev_c)
{
	int i = threadIdx.x;
	dev_c[i] = dev_a[i] + dev_b[i];
}

int main()
{
	const int size = 3;
	int a[size][size];
	int b[size][size];
	int c[size][size] = { 0 };
	int i = 0, j = 0;
	for (i = 0; i < size; i++)
		for (j = 0; j < size; j++)
			scanf("%d", &a[i][j]);
	for (i = 0; i < size; i++)
		for (j = 0; j < size; j++)
			scanf("%d", &b[i][j]);

	int *dev_a, *dev_b, *dev_c;
	int t = size*size*sizeof(int);
	cudaMalloc((void**)&dev_a, t);
	cudaMalloc((void**)&dev_b, t);
	cudaMalloc((void**)&dev_c, t);
	cudaMemcpy(dev_a, a, t, cudaMemcpyHostToDevice);
	cudaMemcpy(dev_b, b, t, cudaMemcpyHostToDevice);
	cudaMemcpy(dev_c, c, t, cudaMemcpyHostToDevice);
	addKernel << <1, size*size >> >(dev_a, dev_b, dev_c);
	cudaMemcpy(c, dev_c, t, cudaMemcpyDeviceToHost);
	printf("-----OUTPUT-----\n");
	for (i = 0; i < size; i++){
		for (j = 0; j < size; j++){
			printf("%d ", c[i][j]);
		}
		printf("\n");
	}
	cudaFree(dev_a);
	cudaFree(dev_b);
	cudaFree(dev_c);
	return 0;
}



