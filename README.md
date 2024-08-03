![image](https://github.com/user-attachments/assets/13187e04-6231-499a-8dfa-8c83a5726431)

# 🛠️ DevOps Technical Assignment

Hi, I’m Karim! This README outlines how I approached and solved the DevOps technical assignment provided by 34ML. This assignment evaluates my skills across various DevOps practices, including CI/CD pipeline setup, bash scripting, Terraform infrastructure provisioning, and NGINX hosting. Below is a comprehensive overview of the tasks and implementations.

## 📚 Table of Contents

- [Version Control and CI/CD Setup](#version-control-and-cicd-setup)
  - [Pipeline Stages](#pipeline-stages)
- [Failure Handling](#failure-handling)
- [Parallelization](#parallelization)
- [Caching](#caching)
- [Bash Scripting](#bash-scripting)
- [Terraform](#terraform)
- [Hosting](#hosting)
- [Submission Guidelines](#submission-guidelines)

## 🚀 Version Control and CI/CD Setup

### Pipeline Stages
![image](https://github.com/user-attachments/assets/643172e6-e39f-4b4e-9e48-bd9cf6d6525b)
![image](https://github.com/user-attachments/assets/08425a20-2dea-499b-a8c0-39b3735f4b9b)


**Build 🏗️**

- **Objective:** Set up the environment and install dependencies.
- **Implementation:**
    ```bash
    python -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
    ```

**Test 🧪**

- **Objective:** Run unit tests to ensure code quality.
- **Implementation:**
    ```bash
    pytest --maxfail=1 --disable-warnings -q
    ```
- **Implementation:**
    ```hcl
  name: CI/CD Pipeline

  on:
    push:
      branches:
        - main
    pull_request:
      branches:
        - main
  
  jobs:
    build:
      runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Set up Python
        uses: actions/setup-python@v2
        with:
          python-version: '3.11'

      - name: Install dependencies
        run: |
          python -m venv venv
          source venv/bin/activate
          pip install -r requirements.txt

      - name: Run unit tests
        run: |
          source venv/bin/activate
          pytest integration_tests/
        env:
          PYTHONPATH: .  # Ensure PYTHONPATH is set to the root directory

  dockerize:
    runs-on: ubuntu-latest
    needs: build

    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Build Docker image
        run: docker build -t flask-example .

      - name: Run Docker container
        run: |
          docker run -d -p 5000:5000 --name flask-example flask-example
          sleep 10  # Allow time for the container to start

  deploy:
    runs-on: ubuntu-latest
    needs: dockerize

    steps:
      - name: Simulate deployment
        run: echo "Simulating deployment..."

  cleanup:
    runs-on: ubuntu-latest
    needs: [dockerize, deploy]

    steps:
      - name: Cleanup Docker
        run: |
          docker stop flask-example || true
          docker rm flask-example || true

    ```
**Dockerize 🐳**

![image](https://github.com/user-attachments/assets/3c95e568-4da3-4b08-afb7-688d47711d2a)



- **Objective:** Create Dockerfile and docker-compose.yml to containerize the application.
- **Dockerfile:**
    ```Dockerfile
    FROM python:3.10-slim

    WORKDIR /app

    COPY requirements.txt requirements.txt
    RUN pip install -r requirements.txt

    COPY . .

    CMD ["flask", "run", "--host=0.0.0.0"]
    ```
- **docker-compose.yml:**
    ```yaml
    version: '3.8'

    services:
      app:
        build: .
        ports:
          - "5000:5000"
    ```

**Deploy 🚀**

- **Objective:** Simulate the deployment process using Docker.
- **Implementation:**
    ```bash
    docker-compose build
    docker-compose up
    ```

## ⚠️ Failure Handling

- **Objective:** Handle failures gracefully within the CI pipeline.
- **Implementation:**
  - **Rollback Strategies:** Added scripts to revert to the last successful build.
  - **Alerts:** Integrated with Slack for real-time failure notifications.

## 🔄 Parallelization

- **Objective:** Optimize the pipeline by running tasks in parallel.
- **Implementation:** Configured the CI tool to execute tasks like build and test concurrently to speed up the process.

## 🗃️ Caching

- **Objective:** Utilize caching to speed up the build process.
- **Implementation:** Enabled caching for dependencies in the CI tool to reduce build times.

## 🖥️ Bash Scripting

- **Objective:** Create a bash script named `backup.sh` to automate the backup of a MySQL database.
- **Implementation:**
    ```bash
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
    ```

## 🌐 Terraform

![image](https://github.com/user-attachments/assets/cc798d68-75fa-4d04-a2b1-9dd03828fe22)


- **Objective:** Use Terraform to define and provision AWS infrastructure for hosting the Flask application.

- ![image](https://github.com/user-attachments/assets/9e67abc5-487f-4602-8fba-54a86de5725c)

  

- **Implementation:**
    ```hcl
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
    ```


  ```hcl
    provider "aws" {
  region = "us-east-1"
  }
  
  # VPC Configuration
  resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
  }
  
  resource "aws_subnet" "subnet_a" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-east-1a"
  }
  
  resource "aws_subnet" "subnet_b" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = "10.0.2.0/24"
    availability_zone = "us-east-1b"
  }
  
  resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id
  }
  
  resource "aws_route_table" "main" {
    vpc_id = aws_vpc.main.id
  
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.main.id
    }
  }
  
  resource "aws_route_table_association" "a" {
    subnet_id      = aws_subnet.subnet_a.id
    route_table_id = aws_route_table.main.id
  }
  
  resource "aws_route_table_association" "b" {
    subnet_id      = aws_subnet.subnet_b.id
    route_table_id = aws_route_table.main.id
  }
  
  # EC2 Security Group
  resource "aws_security_group" "ec2_sg" {
    name        = "ec2_sg"
    description = "Allow HTTP and SSH traffic"
    vpc_id      = aws_vpc.main.id
  
    ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  
    ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  
    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  
  # EC2 Instance
  resource "aws_instance" "web" {
    ami                         = "ami-0ee486f3e0eb34133"
    instance_type               = "t2.micro"
    subnet_id                   = aws_subnet.subnet_a.id
    vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  
    tags = {
      Name = "FlaskAppInstance"
    }
  }
  
  # RDS Security Group
  resource "aws_security_group" "rds_sg" {
    name        = "rds_sg"
    description = "Allow database traffic"
    vpc_id      = aws_vpc.main.id
  
    ingress {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  
    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  
  # RDS Subnet Group
  resource "aws_db_subnet_group" "default" {
    name       = "main"
    subnet_ids = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  
    tags = {
      Name = "Main DB subnet group"
    }
  }
  
  # RDS Instance
  resource "aws_db_instance" "default" {
    allocated_storage    = 20
    storage_type         = "gp3" # Consider using gp3
    engine               = "mysql"
    engine_version       = "8.0"
    instance_class       = "db.t3.micro"
    db_name              = "mydb"
    username             = "username" # Consider using a secure method to handle this
    password             = "password" # Consider using a secure method to handle this
    parameter_group_name = "default.mysql8.0"
    backup_retention_period = 7      # Enable automated backups
    final_snapshot_identifier = "mydb-final-snapshot" # Ensure a final snapshot is created if deletion is required
    publicly_accessible  = false     # Set to false for improved security
  
    vpc_security_group_ids = [aws_security_group.rds_sg.id]
    db_subnet_group_name   = aws_db_subnet_group.default.name
  
    tags = {
      Name = "MyRDSInstance"
    }
  
    # Uncomment if using IAM authentication
    # iam_database_authentication_enabled = true
  }


    ```


## 🌍 Hosting

![image](https://github.com/user-attachments/assets/21afc40b-b693-4d81-8224-d027c758c032)


- **Objective:** Install and configure NGINX to host the Flask application.
- **Implementation:**
    - **Install NGINX:**
      ```bash
      sudo apt update
      sudo apt install nginx
      ```
    - **Configure NGINX:**
      ```nginx
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
      ```

![image](https://github.com/user-attachments/assets/6ac14711-d7ec-4b24-944a-3d8e4c6bab3f)
![image](https://github.com/user-attachments/assets/a0ce1d0e-90da-41cc-b769-4060808791e3)
![image](https://github.com/user-attachments/assets/62801edf-e2a7-4172-bef7-00ee74974f57)

