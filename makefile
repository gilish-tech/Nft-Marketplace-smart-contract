deploy:
	forge script script/GilishMarketPlace.s.sol 
deploy-ganache:
	forge script script/GilishMarketPlace.s.sol --rpc-url ${GANACHE_RPC_URL} --broadcast 
deploy-sep:
	forge script script/GilishMarketPlace.s.sol --rpc-url $(SEPOLIA_RPC_URL) --broadcast
deploy-main:
	forge script script/GilishMarketPlace.s.sol --rpc-url $(Mainet_RPC_URL) --broadcast