#!/bin/bash

COOKIE_TMP_FILE=".tmp_cookie"

USER_EMAIL="foo@example.com"
USER_PASSWORD="123"

CLIENT_ID="51818c716de284419bf7f88a"
CLIENT_SECRET="abc123"
REDIRECT_URI="http://localhost:3333"

# Remove tmp cookies
rm -rf "$COOKIE_TMP_FILE"

# USER=$(curl http://localhost:3333/api/user -d "email=$USER_EMAIL")
# echo $USER

# LOGIN
echo "LOGIN ....."
LOGIN=$(curl http://localhost:3333/api/login -b $COOKIE_TMP_FILE -c $COOKIE_TMP_FILE -d "email=$USER_EMAIL&password=$USER_PASSWORD") #&client_id=$CLIENT_ID&response_type=code&redirect_uri=$REDIRECT_URI
echo "LOGIN == $LOGIN"

# AUTHORIZATION
echo "AUTHORIZING ....."
AUTHORIZATION=$(curl -b $COOKIE_TMP_FILE "http://localhost:3333/api/authorize/?client_id=$CLIENT_ID&response_type=code&redirect_uri=$REDIRECT_URI")
echo "AUTHORIZATION == $AUTHORIZATION"
TRANSACTION_ID=$(echo $AUTHORIZATION | sed 's/.*transactionID": "\([^ "]*\)*.*/\1/')
echo "TRANSACTION ID == $TRANSACTION_ID"

# Workaround to parse code
echo "DECISION ....."
WORKAROUND_CODE=$(curl http://localhost:3333/api/authorize/decision -b $COOKIE_TMP_FILE -d "transaction_id=$TRANSACTION_ID&client_id=$CLIENT_ID")
echo "WORKAROUND == $WORKAROUND_CODE"
CODE=$(echo $WORKAROUND_CODE | sed 's/.*code=\([^ ]*\)*.*/\1/')
echo "(( CODE )) == $CODE"
# Token
echo "TOKEN ....."
TOKEN=$(curl http://localhost:3333/api/token -d "code=$CODE&client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&redirect_uri=$REDIRECT_URI&grant_type=authorization_code")
echo "<<< token >>> == $TOKEN"
ACCESS_TOKEN=$(echo $TOKEN | sed 's/.*{"access_token":"\([^ "]*\)*.*/\1/')
echo "*** access token *** == $ACCESS_TOKEN"
# Get protected resource
echo "ACCESSING RESOURCE ....."
echo $(curl -b $COOKIE_TMP_FILE -H "Authorization: Bearer $ACCESS_TOKEN" -v "http://localhost:3333/api/info")

# Logout
echo "QUITTING ....."
echo $(curl http://localhost:3333/api/logout -b $COOKIE_TMP_FILE -d "")
