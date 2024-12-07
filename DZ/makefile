asm: dz.asm
	fasm dz.asm
c: asm dz_c.c
	gcc dz_c.c dz.o -o prog
run: c prog
	./prog
clean:
	rm -f *.o