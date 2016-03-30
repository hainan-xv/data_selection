#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>
#include <string>

using namespace std;

int main(int argc, char **argv) {
  if (argc != 3) {
    cout << argv[0] << " line_file text_file # lines are 0-based" << endl;
    return -1;
  }
  ifstream lines_file(argv[1]);
  ifstream text_file(argv[2]);

  vector<int> lines;
  int line;
  while (lines_file >> line) {
    lines.push_back(line);
  }

  sort(lines.begin(), lines.end());

  int cur_line_in_text = 0;

  string sent;
  getline(text_file, sent);

  bool not_done;
  for (int i = 0; i < lines.size(); i++) {
    while (cur_line_in_text != lines[i]) {
      cout << sent << endl;
      cur_line_in_text++;
      getline(text_file, sent);
    }
    cur_line_in_text++;
    not_done = getline(text_file, sent);
  }

  while (not_done) {
    cout << sent << endl;
    not_done = getline(text_file, sent);
  }
  
}
