ass_light: ass_light.o
	gcc -o ass_light ass_light.o -lwiringPi

ass_light.o: ass_light.s
	as -o ass_light.o ass_light.s

clean:
	rm *.o ass_light