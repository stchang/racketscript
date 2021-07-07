##   mmmmm                  m
##   #   "#  mmm   mmmm   mm#mm  m   m   m mm   mmm
##   #mmmm" "   #  #" "#    #    #   #   #"  " #"  #
##   #   "m m"""#  #   #    #    #   #   #     #""""
##   #    " "mm"#  ##m#"    "mm  "mm"#   #     "#mm"
##               #
##               "

.PHONY: build setup setup-extra clean
.PHONY: test unit-test integration-test test
.PHONY: coverage coverage-unit-test
.PHONY: eslint eslint-fix
.PHONY: docs

ESLINT=node_modules/eslint/bin/eslint.js

## Compile recipes

build:
	@echo "     RACKETSCRIPT BUILD      "
	@echo "++++++++++++++++++++++++++++++"
	@echo
	@echo "NOTE: Make sure NodeJS and NPM are installed and"
	@echo "      exists in PATH. See \`make setup\`"
	@echo
	raco make -v racketscript-compiler/racketscript/compiler/main.rkt
	raco make -v tests/fixture.rkt

setup:
	raco pkg install --auto -t dir racketscript-compiler/ || \
		raco pkg update --link racketscript-compiler/
	raco pkg install --auto -t dir racketscript-extras/ || \
		raco pkg update --link racketscript-extras/

setup-extra:
	npm install -g js-beautify
	raco pkg install --auto cover

clean:
	raco pkg remove racketscript-extras
	raco pkg remove racketscript-compiler

## Coverage recipes

coverage-unit-test:
	@echo " RACKETSCRIPT COVERAGE UNIT-TEST    "
	@echo "++++++++++++++++++++++++++++++++++"
	raco cover -d ./coverage/unit racketscript-compiler/racketscript/

coverage:
	@echo "    RACKETSCRIPT COVERAGE    "
	@echo "++++++++++++++++++++++++"
	COVERAGE_MODE=1 raco cover -d ./coverage/all -b racketscript-compiler \
		tests/fixture.rkt

## JavaScript

eslint: | node_modules
	@echo "    RACKETSCRIPT RUNTIME LINT    "
	@echo "++++++++++++++++++++++++++++"
	$(ESLINT) ./racketscript-compiler/racketscript/compiler/runtime/

eslint-fix: | node_modules
	$(ESLINT) --fix ./racketscript-compiler/racketscript/compiler/runtime/

node_modules: package.json
	npm install

## Test recipes

test: unit-test integration-test

unit-test:
	@echo "    RACKETSCRIPT UNIT-TEST   "
	@echo "++++++++++++++++++++++++"
	raco test -t racketscript-compiler/

integration-test:
	@echo "    RACKETSCRIPT INTEGRATION TEST    "
	@echo "++++++++++++++++++++++++++++++++"
	raco test -t tests/fixture.rkt

docs:
	scribble --htmls +m --redirect-main https://docs.racket-lang.org --dest . --dest-name docs racketscript-doc/racketscript/scribblings/racketscript.scrbl
