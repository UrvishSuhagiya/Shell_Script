#!/bin/bash

# TASK 1 COMMENT

# Task 2 Using echo command to display message
echo "It's Day 1 Of 7Daysofshellscripting."

#Task 3 Declare variable and assign values
name="Urvish"
greet="Hello"
echo "$greet , $name ! "

# Task 4 Takingg 2 no. as input & print Sum
num1=10
num2=20
sum=$((num1+num2))
echo "$num1 + $num2 = $sum"

#Task 5 using built in variables
echo "I AM $whoami ."
echo "The name of the script is $0"
echo "Currently I Am At $PWD Location."

#Task 6 Wildcards
echo "Listing all .sh file in this directory : "
ls *.sh

# make sure that before run this script run first below command :
# chmod +x Day_1_Solution.sh
