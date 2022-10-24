#curBranch := $(shell git branch --show-current)
curBranch := $(shell git rev-parse --abbrev-ref HEAD)
export curBranch
	
list:
	ls -l
install:
	echo Your current branch is: ${curBranch}	
	git checkout utilities -- frameworks.zip lib.zip
	cp frameworks.zip /tmp/
	cp lib.zip /tmp/
	git checkout ${curBranch}
	unzip /tmp/frameworks.zip -d .
	unzip /tmp/lib.zip -d .
unit_tests:
	ant -lib lib/saxon*.jar unit_tests