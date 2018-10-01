## Scripts to generate proposals for payments from a multisig account

Edit the wp_payments_propose.sh file and change the payment variables at the top.

Modify reqperms.json and trxperm.json to suit your needs.

Create a file called wp.csv with csv rows in the format account,amount,memo,comment.  The amount should be in EOS.

Run wp_payments_propose.sh, the output.txt file will contain all of the proposals created.  These will have to be reviewed later and approved by the accounts listed in reqperms.json.
