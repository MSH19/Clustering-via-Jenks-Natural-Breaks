// This code shows how to cluster a one-dimensional array
// into two classes based on Jenks Natural Breaks optimization method 
// The method is unsupervised and depends on statistical similarites between samples

// input: one-dimensional data array 
// output: 
//        - array 1: elements belonging to class 1 
//        - array 2: elements belonging to class 2 

///////////////////////////////////////    Setup    /////////////////////////////  
void setup() 
{
  // initialize serial communication at 9600 bits per second
  Serial.begin(9600);
  delay(100);
}

///////////////////////////////////////    Loop    /////////////////////////////  
void loop() 
{

  // define one-dimensional array of samples (could be constructed from sensor measurements) 
  float samples_vec[] = {900,750,702,744,710,676,721,674,632,640,603,607,855,768,728,787,723,671,757,706,637,665,632,637,615,609,639,600,596,611,542,554,565,506,489,73,17,14,14,20,18,24,11,10,16,14,16,18};

  // number of elements in the samples array
  int elementsCount = sizeof(samples_vec) / sizeof(float);
  
  // size of arrays to store the scores 
  int score_len = elementsCount - 1;
  
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
  
  Serial.print("index of interface between classes:");
  Serial.println(max_GF_index);
  Serial.print("Goodness of variance fit of selected interface:");
  Serial.println(max_GF_value);

  String class1_message ="";
  String class2_message ="";
  
  for (int k=0; k<elementsCount; k++)
  {
    if (k<=max_GF_index)
    {
      class1_message += samples_vec[k];
      class1_message += ','; 
    }
    else
    {
      class2_message += samples_vec[k];
      class2_message += ','; 
    }  
  }//end for 

  Serial.println("Elements of class 1:");
  Serial.println(class1_message);

  Serial.println("Elements of class 2:");
  Serial.println(class2_message);
  
  Serial.println("");
  delay(3000);
}// end loop

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
    double dev_squared = pow(dev, 2);
    sum_dev_squared = sum_dev_squared + dev_squared;
  }//end for

  return sum_dev_squared;
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
