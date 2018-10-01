#!/bin/bash
# NOTE: Requires https://stedolan.github.io/jq/

PROPOSER=mryeateshere
URL=https://eu.eosdac.io
CLEOS="cleos -u $URL"

$CLEOS multisig review $PROPOSER $1 | jq '.transaction.actions[].data'
