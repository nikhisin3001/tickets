# FastAPI Ticket Management System

## Overview
A backend API for user authentication and ticket management, built with FastAPI, SQLAlchemy, and PostgreSQL. Features modular code, JWT authentication, and CRUD operations for support tickets.

---

## Features
- **User Authentication**: Register and log in users with JWT-based authentication.
- **Ticket Management**: Create, read, update, and delete support tickets.
- **PostgreSQL Database**: All data is persisted in a PostgreSQL database using SQLAlchemy ORM.
- **Modular Structure**: Organized codebase with separate modules for authentication, data models, routers, and service objects.

---

## Project Structure
```
fastApiProject/
├── main.py                # FastAPI app entry point
├── requirements.txt       # Python dependencies
├── app/
│   ├── auth/              # Authentication logic
│   ├── daoLayer/          # Database models, mappers, and service objects
│   ├── v1/routers/        # API routers (e.g., tickets)
│   ├── apiSchemas.py      # Pydantic schemas
│   └── crud.py            # CRUD operations
└── ...
```

---

## Setup Instructions

### 1. Clone the Repository
```bash
git clone <your-repo-url>
cd fastApiProject
```

### 2. Create and Activate a Virtual Environment
```bash
python3 -m venv venv
source venv/bin/activate
```

### 3. Install Dependencies
```bash
pip install -r requirements.txt
```

### 4. Configure the Database
- Ensure you have a PostgreSQL database running.
- Update the `DATABASE_URL` in `app/daoLayer/database.py` to match your database credentials:
  ```python
  DATABASE_URL = "postgresql://<user>:<password>@<host>:<port>/<dbname>"
  ```
- Example:
  ```python
  DATABASE_URL = "postgresql://postgres:yourpassword@localhost:5432/fastapi_db"
  ```
- Create the database in PostgreSQL if it does not exist:
  ```bash
  createdb fastapi_db
  ```

### 5. Run the Application
```bash
uvicorn main:app --reload
```
- The API will be available at: [http://127.0.0.1:8000](http://127.0.0.1:8000)
- Interactive API docs: [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs)

---

## API Endpoints
- **/auth/**: User registration and login
- **/tickets/**: CRUD operations for tickets (protected endpoints)

---

## How to run the service
- http://127.0.0.1:8000/tickets

---

## Database Schema Diagram

```mermaid
erDiagram
    users ||--o{ tickets : creates
    users {
        id UUID PK
        username VARCHAR
        email VARCHAR
        hashed_password VARCHAR
    }
    tickets {
        id UUID PK
        title VARCHAR
        description TEXT
        created_by VARCHAR
        created_at TIMESTAMP
        severity VARCHAR
        status VARCHAR
        comments TEXT
    }
```

---

## Database Connection

This project uses PostgreSQL as the database. The connection string is set in `app/daoLayer/database.py` as `DATABASE_URL`.

**Example connection string:**
```
DATABASE_URL = "postgresql://<user>:<password>@<host>:<port>/<dbname>"
```

**To connect to your database:**
1. Make sure your PostgreSQL server is running and accessible.
2. Update the `DATABASE_URL` variable in `app/daoLayer/database.py` with your actual credentials.
3. Example for AWS RDS or local Postgres:
   ```python
   DATABASE_URL = "postgresql://postgres:yourpassword@localhost:5432/fastapi_db"
   # or for AWS RDS
   DATABASE_URL = "postgresql://postgres:yourpassword@your-rds-endpoint:5432/yourdbname"
   ```
4. The app will use this connection string to create tables and perform all database operations.

**Tip:**
- You can use a tool like `psql`, DBeaver, or pgAdmin to connect to your database and verify connectivity.
- For `psql` (Homebrew on macOS):
  ```bash
  /opt/homebrew/opt/postgresql@14/bin/psql -h <host> -U <user> -d <dbname>
  # Example for AWS RDS:
  /opt/homebrew/opt/postgresql@14/bin/psql -h database-1.cqdw0cis8jds.us-east-1.rds.amazonaws.com -U postgres -d postgres
  ```
  Replace `<host>`, `<user>`, and `<dbname>` with your actual database host, username, and database name.

---

## Notes
- For schema changes, use a migration tool like Alembic.
- The app will auto-create tables on first run if they do not exist.
- For production, remove `--reload` and configure environment variables securely.

---

## License
MIT

---

## Infrastructure as Code (Terraform)

This project provides Terraform scripts to provision AWS resources for running the FastAPI app in production.

### AWS Resources Provisioned
- VPC, Subnet, and Internet Gateway
- Security Groups for DB and ECS
- RDS PostgreSQL database
- ECR repository for Docker images
- ECS Fargate cluster, task, and service
- IAM roles for ECS

### Setup Steps

1. **Configure AWS Credentials**
   - Make sure you have AWS CLI installed and configured with credentials that have permissions to create the above resources.
   - Example:
     ```bash
     aws configure
     ```

2. **Set Database Credentials**
   - Edit `infrastructure/variables.tf` or use a `terraform.tfvars` file to provide `db_username` and `db_password`.

3. **Initialize Terraform**
   ```bash
   bash build/terraform-init.sh
   ```

4. **Plan Infrastructure Changes**
   ```bash
   bash build/terraform-plan.sh
   ```

5. **Apply Infrastructure Changes**
   ```bash
   bash build/terraform-apply.sh
   ```

6. **Build and Push Docker Image to ECR**
   - Get the ECR repository URL from Terraform outputs or AWS Console.
   - Build and push:
     ```bash
     bash build/build.sh <ecr-repo-url>
     ```

7. **Deploy to ECS**
   ```bash
   bash build/deploy.sh
   ```

### 0. (Optional) Set Dummy AWS Credentials for Testing
If you want to test Terraform commands without real AWS credentials, you can set dummy credentials:
```bash
source build/set-dummy-aws-creds.sh
```
This allows you to run `terraform plan` for validation, but you cannot apply changes to AWS.

---

## Terraform Remote State Setup (S3 & DynamoDB)

This project uses a remote backend for Terraform state management, enabling safe collaboration and state locking.

### How It Works
- **S3 Bucket:** Stores the Terraform state file (`terraform.tfstate`).
- **DynamoDB Table:** Provides state locking to prevent concurrent modifications.

### Setup Steps
1. **S3 Bucket:**
   - Name: `terraform-bucket-state-tickets`
   - Region: `us-west-2`
2. **DynamoDB Table:**
   - Name: `terraform-lock-table`
   - Region: `us-west-2`
3. **Backend Configuration:** See `infrastructure/provider.tf` for the backend block.
4. **Initialize Backend:**
   ```bash
   cd infrastructure
   terraform init
   ```
   - Approve migration if prompted.
5. **Collaboration:** All team members with access to the S3 bucket and DynamoDB table will share the same Terraform state.

### Notes
- For exact plan/apply consistency, use:
  ```bash
  terraform plan -out=tfplan
  terraform apply tfplan
  ```
- The state file is not stored locally; it is managed in S3.
- State locking is handled automatically by DynamoDB.

---

## Prerequisites

- Install Terraform separately on your system. For macOS, use:
  ```bash
  brew tap hashicorp/tap
  brew install hashicorp/tap/terraform
  ```
- Verify installation:
  ```bash
  terraform version
  ```

---

### FAQ

**Q: Will Terraform automatically store state files when I run `terraform apply` for the first time? Where are they stored?**
- By default, Terraform stores state files locally in the `infrastructure/` directory as `terraform.tfstate`.
- If you want to store state remotely (e.g., in S3 for team use and safety), you must configure a backend in your Terraform files. This project currently uses local state by default.

---

## Improvements & Best Practices
- Use remote state (S3) for Terraform in production.
- Restrict security group ingress rules for better security.
- Use AWS Secrets Manager for DB credentials in production.
- Add CI/CD for automated deploys.
- Use environment variables for configuration.

---
