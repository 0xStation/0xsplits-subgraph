DAPP_SRC="src/contracts" DAPP_OUT="abi" dapp build --extract \
	&& find abi/*.bin abi/*.bin-runtime abi/*.metadata abi/*.json | xargs rm \
	&& for f in abi/*.abi; do mv "$f" "${f%.abi}.json"; done
