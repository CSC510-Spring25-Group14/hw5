BEGIN {
  # For a dictionary for the stop words
  split("is the in but can a the is in of to a that it for on with as this was at by an be from or are", stop_words)
  for (i in stop_words) {
    stop_word_dict[stop_words[i]] = 1
  }
}
{
  # Iterate through each line the input file
  for (i = 1; i <= NF; i++) {
    # If the current word is not a stop word, then print it
    if (!($i in stop_word_dict))
    {
      printf "%s ", $i
    }
  }
  printf "\n"
}