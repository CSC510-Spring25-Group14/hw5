# ZZZ.awk - Generate word frequency table per paragraph

BEGIN {
    pass = 0;
    
    # Parse command-line arguments for PASS value
    for (i = 1; i < ARGC; i++) {
        if (ARGV[i] ~ /^PASS=[12]$/) {
            split(ARGV[i], arr, "=");
            pass = arr[2]; 
            ARGV[i] = "";  # Remove from argument list to avoid file read issues
        }
    }
}

# First pass: Read top words into an array
(pass == 1) {
    top_words[$1] = 1;
    next;
}

# Second pass: Process paragraphs and count word frequencies
(pass == 2) {
    delete freq;
    paragraph = "";

    while (getline > 0) {
        if ($0 ~ /^[ \t]*$/) {
            # If a blank line is found, process the paragraph
            if (length(paragraph) > 0) {
                process_paragraph(paragraph);
                paragraph = "";
            }
        } else {
            paragraph = paragraph " " $0;
        }
    }

    # Process the last paragraph if it exists
    if (length(paragraph) > 0) {
        process_paragraph(paragraph);
    }
}

# Function to process a paragraph and count word frequencies
function process_paragraph(text) {
    split(text, words, " ");  # Tokenize paragraph into words

    for (i in words) {
        word = words[i];
        if (word in top_words) {
            freq[word]++;
        }
    }

    # Print the frequency table for the paragraph
    output = "";
    for (word in top_words) {
        output = output (freq[word] ? freq[word] : 0) " ";
    }
    print output;
}
