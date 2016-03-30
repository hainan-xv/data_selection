#include <iostream>
#include <vector>
#include <fstream>
#include <unordered_map>
using namespace std;

int main(int argc, char **argv) {
  char ch;
  unordered_map<char, int> counts;
  if (string(argv[1]) == "-") {
    while (cin >> ch) {
      counts[ch]++;
    }
  } else {
    ifstream ifile(argv[1]);
    while (ifile >> ch) {
      counts[ch]++;
    }
  }

  for (unordered_map<char, int>::iterator iter = counts.begin();
                                          iter != counts.end();
                                          iter++) {
    cout << iter->first << " " << iter->second << endl;
  }
}
