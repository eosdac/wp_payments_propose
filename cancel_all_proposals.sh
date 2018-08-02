#!/bin/bash

PROPOSER=[account name of the proposer]
EXECUTOR=$PROPOSER
URL=https://eu.eosdac.io
CLEOS="cleos -u $URL"

data=$($CLEOS get table eosio.msig $PROPOSER proposal -l 50)
for row in $(echo "${data}" | jq -r '.rows[] | @base64'); do
	_jq() {
		echo ${row} | base64 --decode | jq -r ${1}
	}

	prop=$(_jq '.proposal_name')

	echo "Cancelling $prop"

	cmd="$CLEOS multisig cancel $PROPOSER $prop $EXECUTOR"
	echo $cmd
	res=$(eval $cmd)
done
