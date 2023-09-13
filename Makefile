.PHONY: all clean test deploy
cmd    := forge
all    :; @$(cmd) build
clean  :; @$(cmd) clean
test   :; @$(cmd) test
deploy :; @$(cmd) script script/BasicVerifier.s.sol:BasicVerifierScript --rpc-url http://192.168.132.159:9944 --legacy --broadcast

