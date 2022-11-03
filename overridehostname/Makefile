PROJECT := overridehostname

SOURCE := $(PROJECT).c
TARGET := lib$(PROJECT).so.1

CC := gcc
BINDIR := bin

all: $(TARGET)

$(TARGET): $(SOURCE)
	$(CC) -fPIC -g -Wall -shared -Wl,-soname,$@ -Wl,--no-undefined -o $(BINDIR)/$@ $< -ldl

install: $(TARGET)
	cp $(BINDIR)/$(TARGET) /usr/local/lib/


# compile: gcc -fPIC -g -Wall -shared -Wl,-soname,liboverridehostname.so.1 -Wl,--no-undefined -o liboverridehostname.so.1 overridehostname.c -ldl
