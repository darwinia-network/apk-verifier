.PHONY: all clean test doc tools foundry
.PHONY: deploy-basic deploy-packed
.PHONY: test-basic test-packed
cmd    := forge
all    :; @$(cmd) build
clean  :; @$(cmd) clean
test   :; @$(cmd) test

tools  :  foundry
foundry:; curl -L https://foundry.paradigm.xyz | bash

doc    :; @bash ./bin/doc.sh

deploy-basic  :; @$(cmd) script script/Basic.s.sol:BasicScript --rpc-url http://127.0.0.1:9944 --legacy --broadcast --private-key 0x5fb92d6e98884f76de468fa3f6278f8807c48bebc13595d45af5bdc4da702133
deploy-packed :; @$(cmd) script script/Packed.s.sol:PackedScript --rpc-url http://127.0.0.1:9944 --legacy --broadcast --private-key 0x5fb92d6e98884f76de468fa3f6278f8807c48bebc13595d45af5bdc4da702133

test-basic :; @bash ./bin/test-basic.sh ${ADDR}
test-packed :; @bash ./bin/test-packed.sh ${ADDR}
