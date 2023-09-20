.PHONY: all clean test deploy-basic deploy-packed
cmd    := forge
all    :; @$(cmd) build
clean  :; @$(cmd) clean
test   :; @$(cmd) test

deploy-basic  :; @$(cmd) script script/BasicVerifier.s.sol:BasicVerifierScript --rpc-url http://192.168.132.159:9944 --legacy --broadcast
deploy-packed :; @$(cmd) script script/PackedVerifier.s.sol:PackedVerifierScript --rpc-url http://192.168.132.159:9944 --legacy --broadcast

