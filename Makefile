#curBranch := $(shell git branch --show-current)
curBranch := $(shell git rev-parse --abbrev-ref HEAD)
# Number of file under .git repo (to test if the git repo was already cloned)
gitRepoFiles :=  $(shell ls -l transform/model2owl/.git >/dev/null 2>&1 | wc -l )

# download saxon library 	
get-saxon:
	mkdir -p transform
	cd transform &&	curl -L -o saxon.zip "https://kumisystems.dl.sourceforge.net/project/saxon/Saxon-HE/10/Java/SaxonHE10-6J.zip" && unzip saxon.zip && rm -rf saxon.zip

# Clone model2owl if the directory model2owl does not exist
get-model2owl-repo:	
	@mkdir -p transform
	@cd transform && git clone https://.:${{ secrets.GITHUB_TOKEN }}@github.com/OP-TED/model2owl.git
	
# download xspec framework to run unit tests
get-xspec: 
	cd transform && rm -rf xspec && curl -L -o xspec.zip https://github.com/xspec/xspec/archive/refs/tags/v2.2.4.zip && unzip xspec.zip -d model2owl && rm -rf xspec.zip && cd model2owl && ln -s xspec-* xspec
	
# Initialize the project, download model2owl repo, install saxon and dependencies
init:  get-saxon get-model2owl-repo get-xspec

# Run unit_tests
unit_tests:
	cd transform/model2owl && ant -lib ../saxon-he-10.6.jar unit_tests
	
