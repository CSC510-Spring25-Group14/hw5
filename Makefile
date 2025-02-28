# Define variables
INPUT = data.txt
CLEANED = cleaned.txt
STOPPED = stop.txt
TOKENS = tokens.txt
FREQS = word_counts.txt
TOP_WORDS = top.txt
TABLE = table.txt


# Run the full pipeline
all: $(TABLE)


# Step 1: Canonicalization (Kill punctuation, Lowercase, Remove Punctuation)
$(CLEANED): $(INPUT)
	sed 's/[^a-zA-Z ]//g' $< | tr 'A-Z' 'a-z' > $@


# Step 2: Remove stop words
# Stop words are (is|the|in|but|can|a|the|is|in|of|to|a|that|it|for|on|with|as|this|was|at|by|an|be|from|or|are)
$(STOPPED) : $(CLEANED)
	gawk -f killstopXXX.awk $< > $@


# Step 3: Report frequency of words
$(FREQS): $(STOPPED)
	cat $< | YYY | sort -nr > $@


# Step 4: Extract Top 10 most frequent words
$(TOP_WORDS): $(FREQS)
	gawk '$$2 && NR <=10 {print $$2}' $< > $@


# Step 5: Generate table of word frequencies per paragraph
$(TABLE): $(CLEANED) $(TOP_WORDS)
	gawk -f ZZZ.awk PASS=1 $(TOP_WORDS) PASS=2 $(CLEANED) > $@


# Cleanup
clean:
	rm -f $(CLEANED) $(TOKENS) $(FREQS) $(TOP_WORDS) $(TABLE)


step1:
	$(MAKE) clean $(CLEANED); head $(CLEANED)


step2:
	$(MAKE) clean $(STOPPED); head $(STOPPED)


step3:
	$(MAKE) clean $(TOP_WORDS); head $(TOP_WORDS)


step4:
	$(MAKE) clean $(TABLE); head $(TABLE) # | column -s, -t