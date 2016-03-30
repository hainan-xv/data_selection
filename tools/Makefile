CC=g++
CFLAGS = -Wall -c $(DEBUG) -std=c++11
LFLAGS = -Wall $(DEBUG) -std=c++11

all: get-lines delete-lines get-rand-index words-to-letters collect-letter-counts

get-lines: get-lines.o
	$(CC) $(LFLAGS) get-lines.o -O2 -o get-lines
delete-lines: delete-lines.o
	$(CC) $(LFLAGS) delete-lines.o -O2 -o delete-lines
get-rand-index: get-rand-index.o
	$(CC) $(LFLAGS) get-rand-index.o -O2 -o get-rand-index
words-to-letters: words-to-letters.o
	$(CC) $(LFLAGS) words-to-letters.o -O2 -o words-to-letters
collect-letter-counts: collect-letter-counts.o
	$(CC) $(LFLAGS) collect-letter-counts.o -g -o collect-letter-counts
#	$(CC) collect-letter-counts.o -g -O2 -o collect-letter-counts

get-lines.o: get-lines.cc
	$(CC) $(CFLAGS) -c get-lines.cc

delete-lines.o: delete-lines.cc
	$(CC) $(CFLAGS) -c delete-lines.cc

get-rand-index.o: get-rand-index.cc
	$(CC) $(CFLAGS) -c get-rand-index.cc

words-to-letters.o: words-to-letters.cc
	$(CC) $(CFLAGS) -c words-to-letters.cc

collect-letter-counts.o: collect-letter-counts.cc
	$(CC) $(CFLAGS) -g -c collect-letter-counts.cc


clean:
	rm *.o get-lines delete-lines get-rand-index words-to-letters collect-letter-counts
