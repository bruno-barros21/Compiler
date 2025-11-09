FLEX    = flex
BISON   = bison
CC      = gcc
CFLAGS  =
TARGET  = mini_ada

BISON_SRC = mini_ada.y
FLEX_SRC  = mini_ada.l
SRCS      = ast.c

all: $(TARGET)

$(TARGET): $(BISON_SRC) $(FLEX_SRC) $(SRCS)
	$(FLEX) $(FLEX_SRC)
	$(BISON) -d $(BISON_SRC)
	$(CC) mini_ada.tab.c lex.yy.c $(SRCS) -o $(TARGET) $(CFLAGS)

clean:
	rm -f $(TARGET) mini_ada.tab.c mini_ada.tab.h lex.yy.c

run: $(TARGET)
	./$(TARGET) $(ARGS)

.PHONY: all clean run
