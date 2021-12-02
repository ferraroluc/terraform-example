# terraform-example
## Database
1. Create the database. We will use a MySQL server
```bash
docker run --name db-example -e MYSQL_ROOT_PASSWORD=example -e MYSQL_DATABASE=example -e MYSQL_USER=example -e MYSQL_PASSWORD=example -p 3306:3306 -d mysql
```
## Backend
1. Create and select a new virtual environment
```bash
python3 -m venv .venv
source .venv/bin/activate
```
2. Install the needed packages
```bash
pip install -r requirements.txt
```
The following packages are included in the requirements:
- Flask
- flask_sqlalchemy
- flask_script
- flask_migrate
3. Add the environment variables
```bash
export FLASK_APP=application.py
export APP_SETTINGS="config.Config"
export SQLALCHEMY_DATABASE_URI="mysql://example:example@127.0.0.1/example"
```
4. Select the .venv as Pyhton interpreter
5. Migrate the database
```bash
sudo apt install -y python3-mysqldb libmysqlclient-dev
pip install mysqlclient
flask db init
# To re-migrate the database, we could need the next command:
# flask db stamp head
flask db migrate
flask db upgrade
```
6. Run the server
```bash
flask run
```
## REST API
The endpoints are detailed in `terraform-example.postman_collection.json`

## Environment Variables
The following environment variables must be set in the Gitlab repository:
```
# Terraform remote-state
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=

# AWS
TF_VAR_secret_key=
TF_VAR_access_key=

# Flask
TF_VAR_FLASK_APP=application.py
TF_VAR_APP_SETTINGS=config.Config

# Database
TF_VAR_dbName=prodExampleDb
TF_VAR_dbUser=prodExampleDb
TF_VAR_dbPass=prodExampleDb
```
