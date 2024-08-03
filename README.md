# DevOps-Technical-Assignment



Introduction
Hi, I’m Karim. This README outlines how I approached and solved the DevOps technical assignment provided by 34ML. The assignment aimed to evaluate my skills across various DevOps practices, including CI/CD pipeline setup, bash scripting, Terraform infrastructure provisioning, and NGINX hosting. This document provides a comprehensive overview of the tasks and implementations.

Table of Contents


Version Control and CI/CD Setup
Pipeline Stages
Failure Handling
Parallelization
Caching
Bash Scripting
Terraform
Hosting
Submission Guidelines
Version Control and CI/CD Setup
Pipeline Stages
Build


Objective: Set up the environment and install dependencies.
Implementation:
bash
Copy code
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
Test

Objective: Run unit tests to ensure code quality.
Implementation:
bash
Copy code
pytest --maxfail=1 --disable-warnings -q
Dockerize

Objective: Create Dockerfile and docker-compose.yml to containerize the application.

Implementation:

Dockerfile:

Dockerfile
Copy code
FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY . .

CMD ["flask", "run", "--host=0.0.0.0"]
docker-compose.yml:

yaml
Copy code
version: '3.8'

services:
  app:
    build: .
    ports:
      - "5000:5000"
Deploy

Objective: Simulate the deployment process using Docker.
Implementation:
bash
Copy code
docker-compose build
docker-compose up
Failure Handling
Objective: Handle failures gracefully within the CI pipeline.
Implementation:
Rollback Strategies: Added scripts to revert to the last successful build.
Alerts: Integrated with Slack for failure notifications.
Parallelization
Objective: Optimize the pipeline by running tasks in parallel.
Implementation: Configured the CI tool to execute tasks like build and test concurrently.
Caching
Objective: Utilize caching to speed up the build process.
Implementation: Enabled caching for dependencies in the CI tool.
Bash Scripting
Objective
Create a bash script named backup.sh to automate the backup of a MySQL database.

Implementation
backup.sh:

bash
Copy code
#!/bin/bash

# Configuration
DB_USER="username"
DB_PASSWORD="password"
DB_NAME="database_name"
BACKUP_DIR="/path/to/backup/directory"
DATE=$(date +'%Y%m%d%H%M%S')

# Create a backup
mysqldump -u $DB_USER -p$DB_PASSWORD $DB_NAME > $BACKUP_DIR/db_backup_$DATE.sql

# Log the backup
echo "Backup completed on $DATE" >> $BACKUP_DIR/backup_log.txt
Terraform
Objective
Use Terraform to define and provision AWS infrastructure for hosting the Flask application.

Implementation
Terraform Configuration:

hcl
Copy code
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "app_instance" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  tags = {
    Name = "FlaskAppInstance"
  }
}

resource "aws_db_instance" "db_instance" {
  allocated_storage = 20
  engine            = "mysql"
  instance_class    = "db.t2.micro"
  name              = "flaskappdb"
  username          = "admin"
  password          = "password"
  skip_final_snapshot = true
}
Hosting
Objective
Install and configure NGINX to host the Flask application.

Implementation
Install NGINX:

bash
Copy code
sudo apt update
sudo apt install nginx
Configure NGINX:

NGINX Configuration:

nginx
Copy code
server {
    listen 80;

    server_name example.com;

    location / {
        proxy_pass http://localhost:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
