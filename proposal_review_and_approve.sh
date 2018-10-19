#!/bin/bash
# NOTE: Requires https://stedolan.github.io/jq/

PROPOSER=lukeeosproxy
APPROVER=mryeateshere
URL=https://eu.eosdac.io
CLEOS="cleos -u $URL"
#CLEOS="/Users/lukestokes/Documents/workspace/eosDAC/chains/mainnet/cleos.sh"

if [[ "$1" == "" ]]; then
    echo "Usage : ./proposal_review_and_approve.sh [ proposal name ]"
    exit 1
fi

$CLEOS multisig review $PROPOSER $1 | jq '.transaction.actions[].data'

read -p "Do you want to approve proposal $1 (Y/N)?" -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "========= The proposal $1 was NOT approved. ========="
    exit 1
fi

DATA="{\"actor\":\"$APPROVER\",\"permission\":\"active\"}"

$CLEOS multisig approve $PROPOSER $1 $DATA -p $APPROVER@active
