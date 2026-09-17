## Assignment 3, September 17, Ambika Elangovan

### Task 1
$ cd SUPERCOMPUTING/ 
$ cd assignments/assignment_03 

$ nano README.md 
$ mkdir data

---
### Task 2
*(downloaded wget from https://gist.github.com/evanwill/0207876c3243bbb6863e65ec5dc3f058 (totally should have done this for the last assignment). also had to use 7-zip to extract the application)*
*checking it downloaded porperly and i put it in the right place:*
$ wget --version 

*(still in SUPERCOMPUTING/assignments/assignment_03/data):*
$ wget https://gzahn.github.io/data/GCF_000001735.4_TAIR10.1_genomic.fna.gz 
$ gunzip GCF_000001735.4_TAIR10.1_genomic.fna.gz 

*(what assignment_03 looks like right now, in  ~/SUPERCOMPUTING/assignments/assignment_03 ):*
$ tree
*(output)*:
.
|-- README.md
-- data
    `-- GCF_000001735.4_TAIR10.1_genomic.fna

1 directory, 2 files

---
### Task 3: 
*(inside ~/SUPERCOMPUTING/assignments/assignment_03/data)*
*(before starting, i looked inside the file with nano just to see the structure of it. seems similar to class where each new sequence starts with ">TITLE")*
1. $ grep "^>" GCF_000001735.4_TAIR10.1_genomic.fna | wc -l
	- getting every line that starts with ">", and then counting how many lines are there
2. $ grep -v "^>" GCF_000001735.4_TAIR10.1_genomic.fna | tr -d '\n\r' | wc -m
	- had to look up what a nucleotide looks like in these sequences
		- seems to be each individual letter (ATCG) (no idea if the uppercase and lowercase is relevant- seems to be the same things)
	- step by step:
		- -v flag for grep is the invert flag: gets everything that DOES NOT include what is specified (starting with >, i.e. all the headers)
		- -d flag for tr is delete: deletes the specified thigns (newlines and carriage returns)
		- lastly, counting the characters after those things are basically pruned out
3. $ wc -l GCF_000001735.4_TAIR10.1_genomic.fna
	- just counting how many lines there are in the whole file
4. $ grep "mitochondrion" GCF_000001735.4_TAIR10.1_genomic.fna | wc -l
	- finding any line with "mitochondrion", counting how many lines we get
5. $ grep "chromosome" GCF_000001735.4_TAIR10.1_genomic.fna | wc -l
6.  multiple parts:
	1. $ head -2 GCF_000001735.4_TAIR10.1_genomic.fna | tail -1 | tr -d '\n\r' | wc -m
	2. $ head -4 GCF_000001735.4_TAIR10.1_genomic.fna | tail -1 | tr -d '\n\r' | wc -m
	3. $ head -6 GCF_000001735.4_TAIR10.1_genomic.fna | tail -1 | tr -d '\n\r' | wc -m
	- these all follow the same pipeline that is dependent on which line numbers the sequences are in
		- head -n keeps the first n lines (first 2 for the first chomosome, first 4 for the second one, first 6 for the third one)
		- tail -1 keeps the last line of that, which should be the sequence of interest
	- this was probably a really convoluted way to do this oops...
7. $ head -10 GCF_000001735.4_TAIR10.1_genomic.fna | tail -1 | tr -d '\n\r' | wc -m
	- same concept as #6, i just used -10 because chromosome 5 would be lines 9 (title) and 10 (actual sequence)
8. $ grep "AAAAAAAAAAAAAAAA" GCF_000001735.4_TAIR10.1_genomic.fna | wc -l
9. $ grep "^>" GCF_000001735.4_TAIR10.1_genomic.fna | sort | head -1
	- had to look up how things are sorted with the "sort" command but it was automatically alphabetic so yay!
10.  multiple steps:
		1. $ grep "^>" GCF_000001735.4_TAIR10.1_genomic.fna > titles.txt
		2. $ grep -v "^>" GCF_000001735.4_TAIR10.1_genomic.fna > sequences.txt
		3. $ paste titles.txt sequences.txt > tab-separated_sequences.tsv
		- started by separating the titles from the actual sequences
		- grepped (haha) the titles like before and wrote them to titles.txt
		- inverse grepped the sequences (using -v flag from beffore) and wrote them to sequences.txt
		- used paste command to automatically put them together as (default) tab separated into tab-separated_sequences.tsv




---
git add
git commit -m "individual files for question 10 (tab separated file) and README.md"
git push origin main 

---
### Task 5: Reflection

My approach was probably the most time consuming way of doing this, but it ended up being a lot of trial and error and seeing what worked. I admit this would not have been nearly as successful if we were not given the expected outputs for each question. doing this, though, I was definitely able to learn to use the commands a little more intuitively, and also be more familiar about how the stdout becomes the stdin for the next command (a little hard for me understand in class). One thing I learned is that the grep command is my best friend. And then I quickly re-learned it is an enemy. It is on thin ice...
I think the most helpful thing for me was to look up the flag options for commands (specifically grep, head/tail, and tr) and have them next to me for reference. I think those are the parts I'm going to have to get the most used to through practice.

The head and tail commands actually frustrated me a lot, but I was totally operating with the wrong mindset and was stuck in the idea of how python indexes funkily. Once I realized that the -n flag actually meant the number it specified things made a lot more sense. Going back to grep, I can understand how useful it is but it was also turning out to be a very double edged sword for me. A lot of times, it would be the reason that wc would output a big fat 0. Combining it (re: combining it *properly*) with the head and tail commands was pretty frustrating, and I think it was mostly because I couldnt actually visualize what was happening through each point in the pipeline. Having an output at each step would have been really beneficial for me I think.

I think it is obviously really important to have a grasp of these commands in computation work. Using them cuts down on manual searching exponentially, and using them intuitively could be as easy as ctr+f on a page.
