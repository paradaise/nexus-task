NEXUS_URL="someone url"
NEXUS_USER="admin"
NEXUS_PASSWORD="admin-pass"
REPO_NAME="test-raw-hosted"
USER_NAME="test-user"
USER_PASS="test-pass"
ROLE_NAME="test-raw-hosted-role"



# Create (hosted репозиторий типа raw test-raw-hosted)
curl -u "$NEXUS_USER:$NEXUS_PASSWORD" -X POST -i -v \
  "$NEXUS_URL/service/rest/v1/repositories/raw/hosted" \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "'"$REPO_NAME"'",
  "online": true,
  "storage": {
    "blobStoreName": "default",
    "strictContentTypeValidation": true,
    "writePolicy": "allow_once"
  },
  "raw": {
    "contentDisposition": "ATTACHMENT"
  }
}'


#Create (роль test-raw-hosted-role, которая предоставляет гранулированный доступ к репозиторию на чтение и загрузку арте>
#Необходимо использовать привилегии типа nx-repository-view)
curl -u "$NEXUS_USER:$NEXUS_PASSWORD" -X POST -i -v \
  "$NEXUS_URL/service/rest/v1/security/roles" \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "id": "'"$ROLE_NAME"'",
  "name": "'"$ROLE_NAME"'",
  "description": "blank description",
  "readOnly": true,
  "privileges": [
    "nx-repository-view-raw-test-raw-hosted-add",
    "nx-repository-view-raw-test-raw-hosted-read",
    "nx-repository-view-raw-test-raw-hosted-edit"
  ]
}'

#Create (пользователя test-user с паролем 12345)
curl -u admin:Paradaise13371718 -X POST -i -v \
  "http://10.131.0.62:8081/service/rest/v1/security/users" \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "userId": "metrics",
  "firstName": "Ann",
  "lastName": "Blank",
  "emailAddress": "metrics@mail.ru",
  "password": "metrics",
  "status": "active",
  "roles": [
    "metrics"
  ]
}'

#push file from host to repo
curl -u "$USER_NAME:$USER_PASS" -X 'POST' -i -v \
  "$NEXUS_URL/service/rest/v1/components?repository=$REPO_NAME" \
  -H 'accept: application/json' \
  -H 'Content-Type: multipart/form-data' \
  -F 'raw.directory=/' \
  -F "raw.asset1=@${FILE_PATH};type=text/plain" \
  -F "raw.asset1.filename=test.txt" 