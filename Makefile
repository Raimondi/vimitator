.PHONY: test
all: lib/vim/parser.rb

lib/vim/parser.rb: lib/vim/parser.racc
	racc -t -v -o lib/vim/parser.rb lib/vim/parser.racc

test: lib/vim/parser.rb
	@for t in test/*;\
		do\
		echo --------------------------------------;\
		echo "Test: $$t";\
		cat $$t;\
		echo --------------------------------------;\
		./viml < $$t || errors="$$errors $$t";\
	done;\
	echo "Tests with errors:$$errors"

test/%: lib/vim/parser.rb
	@echo --------------------------------------
	@echo "Test: $@"
	@cat $@
	@echo --------------------------------------
	./viml < $@
