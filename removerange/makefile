CC=gcc
NASM=nasm
CFLAGS=-m32
NASMFLAGS=-f elf32
OBJDIR=dist
OBJS=$(OBJDIR)/func.o $(OBJDIR)/main.o

$(shell mkdir -p $(OBJDIR))

$(OBJDIR)/%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJDIR)/%.o: %.asm
	$(NASM) $(NASMFLAGS) $< -o $@

main: $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o main

clean:
	rm -f $(OBJDIR)/*.o main
