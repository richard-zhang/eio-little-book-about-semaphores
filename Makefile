.PHONY: run
run:
	$(eval BASENAME := $(shell echo $(file) | sed 's/\.ml//'))
	@echo $(BASENAME)
	dune build $(BASENAME).exe && eio-trace run -- ./_build/default/$(BASENAME).exe
