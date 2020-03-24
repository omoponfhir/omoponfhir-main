OMOPonFHIR Implementation version 1
=
- Supports OMOP v5
- Supports STU3
- DSTU2: DSTU2 is available from https://github.com/omoponfhir/omoponfhir-main-dstu2/ 

Database Dependencies
-
This application requires an OMOP V5 database to work. You can use the database here: https://github.com/omoponfhir/omopv5fhir-pgsql/ 

Please follow the instruction in README. This database contains couple of sample synthetic patients.

How to install and run.
-
To download,
git clone --recurse https://github.com/omoponfhir/omoponfhir-main.git

Before running the application update the values of the JDBC_URL, JDBC_USERNAME, and JDBC_PASSWORD environment variables in the Dockerfile. They must contain the data necessary for your application to connect to an OMOP V5 database. After updating the ENV variables in the Dockerfile, you can do either

1. use docker compose to build and run
```
sudo docker-compose up --build -d
```

2. or use docker build and run
```
sudo docker build -t omoponfhir .
sudo docker run --name omoponfhir -p 8080:8080 -d omoponfhir:latest
```

NOTE: The OMOPonFHIR server is set to READ-ONLY. If you want to write to OMOPonFHIR, web.xml in WEB-INFO must have readOnly set to False.

## Environment Variables

Environment variables are required to be set in order for OMOPonFHIR server to run correctly. The follows are environment variables. If Docker is used, these can be specified in the Dockerfile. If rancher is used for the docker image, the rancher can set the environment variable. If running from Java application server, please refer to the application server setting to add the environment variables.

- JDBC_PASSWORD="dbpassword"
- JDBC_USERNAME="dbusername"
- JDBC_URL="jdbc:..."
- SMART_INTROSPECTURL="http://[your_omoponfhir_host]/smart/introspect"
- SMART_AUTHSERVERURL="http://[your_omoponfhir_host]/smart/authorize"
- SMART_TOKENSERVERURL="http://[your_omoponfhir_host]/smart/token"
- AUTH_BEARER="static bearer token that you want to use. this has full access scope *.* of smart on fhir"
- AUTH_BASIC="your_username:your_secret"
- FHIR_READONLY="True or False"
- SERVERBASE_URL="base URL if you are behind proxy. If this is not set then local hostname will be used"
- (optional) LOCAL_CODEMAPPING_FILE_PATH="if you want to load local code mapping to OMOP concept table. Put path to file here"
- MEDICATION_TYPE="Applied to MedicationRequest only. Set to 'local' if you want medication to be in contained. set to 'link' if you want to use Reference link to Medicaiton resource. Set this to empty string or do not include in env variable to use CodeableConcept"

Application URLs
-
- TestPage UI - http://<my_host>:8080/omoponfhir3/
- API - http://<my_host>:8080/omoponfhir3/fhir
- SMART on FHIR - http://<my_host>:8080/omoponfhir3/smart/

Additional Information
-
Status: Details available in http://omoponfhir.org/

Contributors:
- Lead: Myung Choi
- DevOp/Deployment: Eric Soto
- Docker/VM Management: Michael Riley
 
Please use Issues to report any problems. If you are willing to contribute, please fork this repository and do the pull requests.
