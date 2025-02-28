BEGIN {
    FS = " "
    OFS = ","
    paragraphCount = 0
    outputFile = "step4.txt"
}

# First pass: Read the top 10 words
PASS == 1 {
    topWords[NR] = $1
    next
}

# Second pass: Process the cleaned text file
PASS == 2 {
    # Start of a new paragraph
    if (NF == 0 && length(paragraph) > 0) {
        processParagraph()
        delete wordCount
        paragraph = ""
        paragraphCount++
    } else {
        paragraph = paragraph " " $0
        for (i = 1; i <= NF; i++) {
            wordCount[$i]++
        }
    }
}

END {
    # Process the last paragraph if it exists
    if (length(paragraph) > 0) {
        processParagraph()
    }
    
    # Print the header (top 10 words)
    printf "" > outputFile  # Clear the file
    for (i = 1; i <= 10; i++) {
        printf "%s%s", topWords[i], (i < 10 ? OFS : ORS) >> outputFile
    }
    
    # Print the word counts for each paragraph
    for (p = 1; p <= paragraphCount; p++) {
        for (i = 1; i <= 10; i++) {
            printf "%d%s", (results[p, topWords[i]] ? results[p, topWords[i]] : 0), (i < 10 ? OFS : ORS) >> outputFile
        }
    }
}

function processParagraph() {
    for (word in wordCount) {
        for (i = 1; i <= 10; i++) {
            if (word == topWords[i]) {
                results[paragraphCount + 1, word] = wordCount[word]
                break
            }
        }
    }
}
