#!/bin/bash

COOKIE_TMP_FILE=".tmp_cookie"

USER_EMAIL="foo@example.com"
USER_PASSWORD="123"

CLIENT_ID="51818c716de284419bf7f88a"
CLIENT_SECRET="abc123"
REDIRECT_URI="http://localhost:3333"

# Remove tmp cookies
rm -rf "$COOKIE_TMP_FILE"

echo "LOGGING IN ....."
LOGIN=$(curl -b $COOKIE_TMP_FILE "http://localhost:3333/api/login?email=$USER_EMAIL&password=$USER_PASSWORD&client_id=$CLIENT_ID&response_type=token&redirect_uri=$REDIRECT_URI")
echo "LOGIN == $LOGIN"
ACCESS_TOKEN=$(echo $LOGIN | sed 's/.*access_token=\([^& ]*\)*.*/\1/')
echo "ACCESS_TOKEN == $ACCESS_TOKEN"

# Get protected resource
echo $(curl -b $COOKIE_TMP_FILE -H "Authorization: Bearer $ACCESS_TOKEN" -v "http://localhost:3333/api/info")

# Logout
echo "QUITTING ....."
echo $(curl http://localhost:3333/api/logout -b $COOKIE_TMP_FILE -d "")
