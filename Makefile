.PHONY: all clean test deploy
cmd    := forge
all    :; @$(cmd) build
clean  :; @$(cmd) clean
test   :; @$(cmd) test
deploy :; @$(cmd) create Verifier
