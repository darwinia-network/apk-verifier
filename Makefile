.PHONY: all clean test deploy-basic deploy-packed
cmd    := forge
all    :; @$(cmd) build
clean  :; @$(cmd) clean
test   :; @$(cmd) test

deploy-basic  :; @$(cmd) script script/Basic.s.sol:BasicScript --rpc-url http://192.168.132.159:9944 --legacy --broadcast
deploy-packed :; @$(cmd) script script/Packed.s.sol:PackedScript --rpc-url http://192.168.132.159:9944 --legacy --broadcast

