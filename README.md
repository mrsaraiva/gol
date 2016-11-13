John Conway's Game of Life

This implementation uses Corona SDK to run

There are two species, A and B, and they follow the rules below:

A
	1. Any alive cell with less than two alive neighbors dies of loneliness
	2. Any alive cell with more than three alive neighbors dies of overpopulation
	3. Any grid space with exactly three alive neighbors becomes an alive cell
	4. Any cell with two alive neighbors keeps the current state until the next iteration

	
B
	1. Any alive cell with less than four alive neighbors dies of loneliness
	2. Any alive cell with more than six alive neighbors dies of overpopulation
	3. Any grid space with exactly four alive neighbors becomes an alive cell
	4. Any cell with two or three alive neighbors keeps the current state until the next iteration
	
Usage:

- Click with the left mouse button on any cell to spawn an cell of species A
- Click with the right mouse button on any cell to spawn an cell of species B
- Click with the middle mouse button on any cell to clear it

Run - Iterates over the grid each second using the rules described above
Pause - Interrupts the iteration
Step - Iterates over the grid one time using the rules described above
Clear - Empties the whole grid
Debug - Prints the grid's content to the Corona Simulator Output console