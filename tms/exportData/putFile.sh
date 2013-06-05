sftp superftp@10.3.32.148:/home/hsexport/data <<EOF
put $1
exit
EOF

echo "put $1 finsih"

