#!/bin/bash

PROPOSER=mryeateshere
APPROVER=lukeeosproxy
URL=https://eu.eosdac.io
CLEOS="cleos -u $URL"

DATA="{\"actor\":\"$APPROVER\",\"permission\":\"active\"}"

$CLEOS multisig approve $PROPOSER $1 $DATA -p $APPROVER@active
