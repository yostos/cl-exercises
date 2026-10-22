OCICL_RUNTIME := $(HOME)/.local/share/ocicl/ocicl-runtime.lisp
SBCL := sbcl --noinform --no-userinit --non-interactive \
	--load $(OCICL_RUNTIME) \
	--eval '(setf *compile-verbose* nil)' \
	--eval '(asdf:initialize-source-registry (list :source-registry (list :directory(uiop:getcwd)) :inherit-configuration))'

.PHONY: setup build test

setup:
	brew bundle
	ocicl setup
	ocicl install

build:
	$(if $(EX),,$(error EX を指定してください（例: make build EX=hello）))
	@$(SBCL) --eval '(asdf:make "$(EX)")'

test:
	$(if $(EX),,$(error EXを指定してください (例: make test EX=hello)))
	@$(SBCL) --eval '(asdf:test-system "$(EX)")'
