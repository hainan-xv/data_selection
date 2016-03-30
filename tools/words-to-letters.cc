#include <iostream>
using namespace std;

int main() {
  char ch;
  while (cin.get(ch)) {
    if (ch == ' ') {
      cout << "SPACE ";
    }
    else if (ch == '\n') {
      cout << endl;
    }
    else {
      cout << ch << " ";
    }
  }
}
