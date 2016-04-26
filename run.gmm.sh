cat ~/corpus/europarl/freq.en.sorted.txt | awk '{print $1}' | grep -v [^a-zA-ZàâäèéêëîïôœùûüÿçÀÂÄÈÉÊËÎÏÔŒÙÛÜŸÇ] | head
cat ~/corpus/europarl/freq.fr.sorted.txt | awk '{print $1}' | grep -v [^a-zA-ZàâäèéêëîïôœùûüÿçÀÂÄÈÉÊËÎÏÔŒÙÛÜŸÇ] | head
