#/bin/zsh

echo -e  "Get a list of topics \x1B[94m"
curl "http://localhost:29080/topics"
echo -e "\x1B[39m"

