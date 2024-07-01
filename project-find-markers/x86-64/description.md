# Description

In this project I will search for marker 12. I am reading the file using C and then passing the file pointer to the assembly program which will use this pointer to read the correct information and find the markers. It will return an integer of the amount of markers found up to a max of 50 and return the coordinates.

## How did I test my work

To test my work I generated different files to test the following outcomes

-   _input.bmp_: Provided test file -> Find all the correct markers (2)
-   _test.bmp_: Self generated test file -> find the correct marker (1)
-   _resize_test.bmp_: Self generated test file with different size -> find the correct marker (1)
-   _input.jpg_: Provided test file but in JPG -> throw an error about the filetype

These test images can be found in the folder `tests`

## How to run

To run this program run the following command
`make && ./find_markers input.bmp`

This can also be changed to use different files by changing `input.bmp` to a different filename.
