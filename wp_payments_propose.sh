#!/bin/bash

PROPOSER=mryeateshere
PAYER=eosdacthedac
URL=https://eu.eosdac.io
CLEOS="cleos -u $URL"
PREFIX="wppayment"
INPUT=wp.csv

get_wp_name (){
	for x in {1..5}
	do
		for y in {1..5}
		do
			for z in {1..5}
			do
				prop="$PREFIX$x$y$z"
				cmd="$CLEOS get table eosio.msig $PROPOSER proposal -L $prop | jq '.rows | length'"
				rows=$(eval $cmd)
				
				if [[ "$rows" == "0" ]];then
					eval "$1='$prop'"
					return 0
				fi
			done
		done
	done

	return 1
}


echo "" > output.txt

OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read account amount memo comment
do

	echo "Account : $account"
	echo "Amount : $amount"
	echo "Memo : $memo"
	echo "Comment : $comment"
	echo "----------------"

	AMOUNT=$(printf "%.4f" $amount)

	echo "{\"from\": \"$PAYER\", \"to\": \"$account\", \"quantity\": \"$AMOUNT EOS\", \"memo\": \"$comment\"}" > trx.json
	
	prop_name=''
	get_wp_name prop_name

	echo "$CLEOS multisig propose $prop_name ./reqperms.json ./trxperm.json eosio.token transfer ./trx.json $PROPOSER 24"
	cmd="$CLEOS multisig propose $prop_name ./reqperms.json ./trxperm.json eosio.token transfer ./trx.json $PROPOSER 24"
	res=$(eval $cmd)

	echo "----------------"
	
	echo "$PROPOSER,$prop_name,$account,$amount,$comment" >> output.txt

	rm -f trx.json

	sleep 1

done < $INPUT
IFS=$OLDIFS
