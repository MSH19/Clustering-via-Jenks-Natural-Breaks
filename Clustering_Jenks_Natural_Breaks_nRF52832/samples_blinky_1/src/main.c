/*
 * Copyright (c) 2016 Intel Corporation
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <zephyr/zephyr.h>
#include <zephyr/drivers/gpio.h>
#include <sys/printk.h>
#include <arch/cpu.h>  // For k_cycle_get_32()

/* 1000 msec = 1 sec */
#define SLEEP_TIME_MS   1000

/* The devicetree node identifier for the "led0" alias. */
#define LED0_NODE DT_ALIAS(led0)

/*
 * A build error on this line means your board is unsupported.
 * See the sample documentation for information on how to fix this.
 */
static const struct gpio_dt_spec led = GPIO_DT_SPEC_GET(LED0_NODE, gpios);

////////////////////////////////////////////// get the index and value of maximum value in an array 
void get_max(float myArray[], int len, float * max_value, int * max_index)
{
  float value =0;
  int index = 0;
  for (int u=0; u<len; u++)
  {
    if (myArray[u] > value)
    {
      value = myArray[u];
      index = u;
    }// end if 
  }// end for

   // return
   *max_value = value;
   *max_index = index; 
}// end function

////////////////////////////////////////////// calculate the average of an array
// Input: (float array, int length)
// Output: float average  
float get_average(float myArray[], int len)
{
  float mean_array =0;
  float sum_array = 0;

  for (int u=0; u<len; u++)
  {
    sum_array = sum_array + myArray[u];
  }// end for 

  mean_array = sum_array / len;

  return mean_array;
}// end function

/////////////////////////////////////// calculate sum of squared deviations (SDAM)
// Input: (float array, int length)
// Output: float SDAM  
float get_sum_deviations(float myArray[], int len)
{
  // 1- calculate the mean of the array
  float avg = get_average(myArray, len);  
 
  // 2- get the sum of deviations
  float sum_dev_squared = 0;
  for (int i=0; i<len; i++)
  {
    float dev = myArray[i] - avg;

    double dev_squared = dev * dev;

    sum_dev_squared = sum_dev_squared + dev_squared;
  }//end for

  return sum_dev_squared;
}// end function


////////////////////////////////////////////////////// main 
void main(void)
{
	
	int ret;

	if (!device_is_ready(led.port)) { return; }

	ret = gpio_pin_configure_dt(&led, GPIO_OUTPUT_ACTIVE); if (ret < 0)  { return; }

	// define one-dimensional array of samples (could be constructed from sensor measurements)
	// 12-value signal 
	float samples_vec[] = {657,638,637,665,632,637,615,609,603,600,596,611};
	// 24-value signal
	// float samples_vec[] = {855,768,728,787,723,671,757,706,637,665,632,637,615,609,639,600,596,611,542,554,565,506,489,73};
	// 36-value signal
	// float samples_vec[] = {721,674,632,640,603,607,855,768,728,787,723,671,757,706,637,665,632,637,615,609,639,600,596,611,542,554,565,506,489,73,17,14,14,20,18,24};
	// 48-value signal 
	// float samples_vec[] = {900,750,702,744,710,676,721,674,632,640,603,607,855,768,728,787,723,671,757,706,637,665,632,637,615,609,639,600,596,611,542,554,565,506,489,73,17,14,14,20,18,24,11,10,16,14,16,18};

	while (1) 
	{
		ret = gpio_pin_toggle_dt(&led);
		if (ret < 0) { return; }

		// print a message indicating the start of the process 
		// printk("Start \n\r");
		
		// number of elements in the samples array
		int elementsCount = sizeof(samples_vec) / sizeof(float);

		// size of arrays to store the scores
		int score_len = elementsCount - 1;

		// get the end time
    	// uint32_t start_time = k_uptime_get();
		// start cycle count
    	uint32_t start_cycles = k_cycle_get_32();
		
		// step 1: calculate the sum of the Squared Deviations from the Array Mean (SDAM)
		float SDAM = get_sum_deviations(samples_vec, elementsCount);

  		// step 2: for every possible combination, get the SDCM
  		float SDCM_all[score_len];
  		float GVF_all[score_len];    
  
  		for (int i=0; i<score_len; i++)
  		{
    		// get sum of deviations for first possible array
    		int len1 = i+1;
    		float array_1 [len1];
    
			for (int k=0; k<=i; k++)
    		{
      			array_1[k] = samples_vec[k];
    		}// end for 
    
			float s1 = get_sum_deviations(array_1,len1);

    		// get sum of deviations for second possible array
    		int len2 = elementsCount - len1;
    		float array_2 [len2];
    		int c = 0;
    
			for (int j=i+1; j<=score_len; j++)
    		{
      			array_2[c] = samples_vec[j];
      			c = c + 1;
    		}//end for 
    	
			float s2 = get_sum_deviations(array_2,len2);
    		SDCM_all[i] = s1 + s2;
    		GVF_all[i] = ((SDAM - SDCM_all[i]) / SDAM);
  		}// end for 

  		// get the interface separating the two classes
  		float max_GF_value = 0;
  		int max_GF_index = 0; 
  		get_max(GVF_all, score_len, &max_GF_value, &max_GF_index);

		// get the end time
    	// uint32_t end_time = k_uptime_get();
		// end cycle count
		// uint32_t elapsed_time = end_time - start_time;
    	uint32_t end_cycles = k_cycle_get_32();

		// calculate the elapsed cycles
    	uint32_t elapsed_cycles = end_cycles - start_cycles;
		// convert cycles to microseconds
    	uint32_t cycles_per_sec = sys_clock_hw_cycles_per_sec();
    	uint32_t elapsed_time_us = (elapsed_cycles * 1000000) / cycles_per_sec;

		// print selected changepoint and its GVF value 
		// enable to print the overall results
		printk("Segmentation index: %d\n", max_GF_index);
		int integer_part = (int)max_GF_value;
    	int fractional_part = (int)((max_GF_value - integer_part) * 10000);
		printk("Segmentation index GVF: %d.%04d\n", integer_part, fractional_part);
		// print the algotiyhm time in milliseconds
    	printk("Selection algorithm time: %u us\n", elapsed_time_us);
		printk("End \n\r");

		// print selected changepoint and its GVF value
		// print the algorithm time in milliseconds
    	// printk("Algorithm runtime in micro seconds: %u \n\r", elapsed_time_us);
		
		// delay 1 second 
		k_msleep(SLEEP_TIME_MS);

	}//end while
  
}//end main 
