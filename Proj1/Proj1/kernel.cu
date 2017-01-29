#include <stdio.h>
#include <device_launch_parameters.h>
#include <cuda_runtime.h>
#include <cuda.h>

__global__ void addKernel(int *c, int *a, int *b);

int main()
{
    const int arraySize = 5;
	int a[arraySize];
	 int b[arraySize];
	 int c[arraySize] = { 0 };
	int *dev_c, *dev_a, *dev_b;
	int i;
	for (i = 0; i < arraySize; i++)
		scanf("%d", &a[i]);
	for (i = 0; i < arraySize; i++)
		scanf("%d", &b[i]);

	cudaMalloc((void**)&dev_c, arraySize*sizeof(int));
	cudaMalloc((void**)&dev_a, arraySize*sizeof(int));
	cudaMalloc((void**)&dev_b, arraySize*sizeof(int));
	cudaMemcpy(dev_a, a, arraySize*sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dev_b, b, arraySize*sizeof(int), cudaMemcpyHostToDevice);
	addKernel<<<1, arraySize >>>(dev_c,dev_a,dev_b);
	cudaMemcpy(&c, dev_c, arraySize*sizeof(int), cudaMemcpyDeviceToHost);

    printf("{%d,%d,%d,%d,%d}\n",
        c[0], c[1], c[2], c[3], c[4]);

   
    
    return 0;
}
__global__ void addKernel(int *c, int *a,int *b)
{
	int i = threadIdx.x;
	c[i] = a[i] + b[i];
	//printf("%d", c[i]);
}
