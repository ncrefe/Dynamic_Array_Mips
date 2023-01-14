
# Dynamic Array Implementation MIPS
A MIPS building guide that allows you to create a simple list of songs. You must use dynamic arrays and implement the specified methods correctly. Program users should be able to:


• Add songs to the list by specifying name and length

• Remove a song from the list by typing its name

• List all songs

Implementations must satisfy the following constraints:

• 12 bytes of dynamic memory should be used as a dynamic array to store the songs. The first 4 bytes are the dynamic array capacity, the next 4 bytes are the dynamic array size, and the last 4 bytes are the element address.

• 8 bytes of memory must be allocated for each song. The first 4 bytes are the address of the song name (the name itself is 64 bytes) and the last 4 bytes are the length of the song. • In the initDynamicArray subroutine, you must create an array of size 2 and store the address in the address of the element part of the dynamic array.

• If the user decides to add a new song, it should be created on the heap using the syscall with sbrk code 9 in the createSong subroutine. We need to insert the address of this song into the song using the putElement subroutine. The putElement subroutine should increase the size of the element array and put the address of the newly added element into the element array.

• If the user wants to remove a song, you should use the findSong subroutine to find the song, get the name of the song from the user, and remove its address from the song using removeElement. The findSong subroutine should call another subroutine called CompareString to check the name of the song.

• If an element is removed from a dynamic array, any other elements following the removed element must be moved to the previous free space (in a 5-element dynamic array, the 3rd element is , the 4th and 5th items are moved to the following locations). squares 3 and 4).

• Whenever the size of the dynamic array reaches its capacity, the capacity must be doubled from the old one and the elements of the elemental array must be copied to the newly allocated elemental array. Array elements that do not already point to a valid song should be assigned the value zero as their address. All these operations should be implemented in the putElement subroutine. • If the dynamic array size decreases to capacity/2 - 1, reduce the capacity by a factor of 2 and allocate space for that capacity. Copies the values of an element array to a newly allocated element array, unless the size is 2. All these operations should be implemented in the removeElement subroutine.

• When listing songs, you must use the listElements subroutine to list the songs. In the listElement subroutine. This subroutine should call another subroutine called printElement. The printElement subroutine should be used as a transition to call the printSong subroutine.



![image](https://user-images.githubusercontent.com/61871610/212169415-da27220c-3a9e-4aa4-936e-e71c4ceff314.png)
