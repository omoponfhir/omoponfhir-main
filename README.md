OMOPonFHIR Implementation version 1
=
- Supports OMOP v5
- Supports STU3
- [WIP] Supports DSTU2 -- currently work in progress. omoponfhir-dstu2-server/ is just copy of omoponfhir-stu3-server. When it's completed, pom and dockerfile will include this directory.

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

Application URLs
-
- UI - http://<my_host>:8080/omoponfhir-stu3/tester/
- API -  	http://<my_host>:8080/omoponfhir-stu3/fhir
- SMART on FHIR - http://<my_host>:8080/omoponfhir-stu3/smart/

Additional Information
-
Status: Details available in http://omoponfhir.org/

Contributors:
- Lead: Myung Choi
- DevOp/Deployment: Eric Soto
- Docker/VM Management: Michael Riley
 
Please use Issues to report any problems. If you are willing to contribute, please fork this repository and do the pull requests.
