# Assignment 01 README:

*(checking what the directory looks like right now)*:\
$ cd SUPERCOMPUTING/\
$ cd assignments/\
$ cd assignment_01\
$ tree\

*(README.md was already created in class, just going to touch it to make sure it is there):*\
$ touch README.md\


## making the folders with placeholder files
$ mkdir data\
$ cd data\
$ mkdir raw_data\
$ mkdir clean_data\

*(Checking to see if the directories look how I want them to):*\
	&emsp; *(have to go back to "assignments" directory from "data" directory (took me a couple tries to actually navigate back, whoops!))*\
	&emsp; $ cd . .\
	&emsp; $ cd .\
	&emsp; $ cd . .\
$ tree\
*("clean_data" and "raw_data" under the "data" folder, which is under the "assignment_01" folder)*\


*(creating text files inside the two data directories):*\
$ cd assignment_01\
$ cd data\
$ cd clean_data\
$ touch clean_data.txt\
$ cd . .\
$ cd raw_data/\
$ touch raw_data.txt\

*(another sanity check of what it is looking like from "SUPERCOMPUTING" directory):*\
$ cd ~\
$ cd SUPERCOMPUTING/\
$ tree\

*(Also, here is where I realized (and looked up) i didnt have to "git add" and "git commit" for each individual file/folder, but can just do it for the whole "assignment_01" folder at once!)*\

*(making the rest of the folders with blank files in them, kind of formulaic at this point):*\
$ cd assignments/assignment_01\
$ mkdir scripts\
$ cd scripts/\
$ touch scripts.sh\
$ cd . .\

$ mkdir results\
$ cd results\
$ touch results.txt\
$ cd . .\

$ mkdir docs\
$ cd docs/\
$ touch docs.docx\
$ cd . .\

$ mkdir config\
$ cd config/\
$ touch config.txt\
$ cd . .\

*(at this point i went and checked what it looked like with "tree" again, and i think the folders are organized alphabetically, wondering if this is important or if we can do custom sorting...)*\

$ mkdir logs\
$ cd logs/\
$ touch logfile.log\
$ cd . .\



## creating the essay and README files
*(in "assignment_01" directory at this point):*\
$ touch assignment_1_essay.md\
$ nano assignment_1_essay.md\
*(in the nano editor, the paragraphs were formatting a little weird after pasting from a word document, so I justified the essay)*\

$ nano README.md\
