
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include<cuda.h>

#include <stdio.h>

__global__ void addKernel(int * dev_a, int* dev_b ,int* dev_size)
{
	int i = threadIdx.x;
	int j,p;
	for (j = 0; j < (*dev_size); j++)
	{
		p = *dev_size*i + j;
		dev_b[i] += dev_a[p];
		//printf("%d %d\n", i, p);
	}
}

int main()
{
	const int size = 3;
	int s = size;
	int a[size][size];
	int b[size] = { 0 };
	int i = 0, j = 0;
	for (i = 0; i < size; i++)
		for (j = 0; j < size; j++)
			scanf("%d", &a[i][j]);

	int *dev_a, *dev_b, *dev_size;
	int t = size*size*sizeof(int);
	int t1 = size*sizeof(int);
	cudaMalloc((void**)&dev_a, t);
	cudaMalloc((void**)&dev_b, t);
	cudaMalloc((void**)&dev_size, sizeof(int));
	cudaMemcpy(dev_a, a, t, cudaMemcpyHostToDevice);
	cudaMemcpy(dev_b, b, t1, cudaMemcpyHostToDevice);
	cudaMemcpy(dev_size, &s, sizeof(int), cudaMemcpyHostToDevice);
	addKernel << <1, size >> >(dev_a, dev_b, dev_size);
	cudaMemcpy(b, dev_b, t1, cudaMemcpyDeviceToHost);
	printf("-----OUTPUT-----\n");
	int p = 0;
	for (i = 0; i < size; i++){
			//printf("%d ", b[i]);
			p += b[i];
		//printf("\n");
	}
	printf("%d", p);
	cudaFree(dev_a);
	cudaFree(dev_b);
	return 0;
}



