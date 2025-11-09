
BISON = bison
FLEX  = flex
CC    = gcc
CFLAGS = -lm

TARGET = calc
BISON_SRC = parser.y
FLEX_SRC  = lexer.x
SRCS = main.c

all: $(TARGET)

$(TARGET): $(BISON_SRC) $(FLEX_SRC) $(SRCS)
	$(BISON) -d $(BISON_SRC)
	$(FLEX) $(FLEX_SRC)
	$(CC) -o $(TARGET) parser.tab.c lex.yy.c $(SRCS) $(CFLAGS)

clean:
	rm -f $(TARGET) parser.tab.c parser.tab.h lex.yy.c

.PHONY: all clean
