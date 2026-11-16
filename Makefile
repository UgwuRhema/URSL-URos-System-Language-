C := cc
CFLAGS := -Wall -Wextra -O2 -g -march=native
FLX := flex
BIS := bison

LEX := src/lexer.l
LEX_OUT := src/lexer.c

PAR := src/parser.y
PAR_OUT := src/parser.c

OUT := ./urslc

# for now!
all:
	$(MAKE) flex
	$(MAKE) bison
	$(C) $(CFLAGS) -o $(OUT) $(LEX_OUT) $(PAR_OUT) -lfl

flex: $(LEX)
	$(FLX) -o $(LEX_OUT) $(LEX)

bison: $(PAR)
	$(BIS) -d -o $(PAR_OUT) $(PAR)

run:
	$(OUT)

clean:
	rm -rf *.o $(OUT)

.PHONY: all clean run
