minesweeper: minesweeper.o
	gcc -m32 -o minesweeper minesweeper.o `pkg-config --cflags --libs gtk+-3.0`

minesweeper.o: minesweeper.asm
	nasm -f elf minesweeper.asm
