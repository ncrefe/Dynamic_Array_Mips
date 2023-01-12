
## Dynamic Array Implementation MIPS
MIPS assembly instructions where you can create a simple song list. You should use dynamic arrays and implement given methods properly. The user of the program should be able to: 

• add a song to the list by providing its name and duration 

• delete a song from the list by providing its name 

• list all songs 

Your implementation should satisfy these constraints below: 

• You should use 12 bytes dynamic memory space as a dynamic array for storing songs. First 4 bytes are for capacity of the dynamic array, second 4 bytes are for size of the dynamic array, last 4 bytes are for address of the elements. 

• For each song you should allocate 8 bytes space where first 4 bytes are address of the song name (name itself will be 64 bytes) and last 4 bytes are for duration of the song. 

• In the subroutine initDynamicArray, you should create an array with size of 2 and store the address in the dynamic array’s address of the elements part. 

• When the user chooses to add a new song, you should create that song in the heap by using syscall with the sbrk code 9 in createSong subroutine. You should put this song address into the songs by using the putElement subroutine. In the putElement subroutine, you should increase the size of the elements array and put the newly added element’s address into the elements array. 

• When the user chooses to delete the song, you should find it by using findSong subroutine where you should take the name of the song from the user and use removeElement to remove its address from the songs. In the findSong subroutine you should call another subroutine called compareString to check the name of the songs. 

• If an element is removed from the dynamic array, other elements that follow the deleted element should be shifted to the previous empty space (in a dynamic array with 5 elements, if the 3rd element is removed, 4th and 5th elements should be shifted to the 3rd and 4th positions). 

• Whenever the size of the dynamic array reaches capacity, you should increase the capacity to 2 times the old one and copy the elements of the elements array into the new allocated elements array. You should assign the value zero as an address for array elements that haven’t pointed to any valid song yet. All these operations should be implemented in the putElement subroutine. 

• Whenever the size of the dynamic array drops down to capacity/2 - 1, reduce capacity by factor of 2 and allocate space for that capacity unless the size is 2, copy the values of the elements array to the newly allocated elements array. All these operations should be implemented in the removeElement subroutine. 

• While you list the songs you should use the listElements subroutine to list the songs. In the listElement subroutine. In this subroutine you should call another subroutine called printElement. You should use printElement subroutine as a transition where you call printSong subroutine. 



![image](https://user-images.githubusercontent.com/61871610/212169415-da27220c-3a9e-4aa4-936e-e71c4ceff314.png)
