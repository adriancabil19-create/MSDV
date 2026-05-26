# MSDV Reporting System - Deployment Guide

## Local Development with Docker

### Prerequisites
- Docker and Docker Compose installed

### Running Locally

1. **Start the application:**
   ```bash
   docker-compose up -d
   ```
   This will start both the PHP/Apache web server and PostgreSQL database.

2. **Access the application:**
   - URL: `http://localhost`
   - Login page: `http://localhost/auth/login.php`
   - Default credentials: admin / (check users table)

3. **Stop the application:**
   ```bash
   docker-compose down
   ```

4. **View logs:**
   ```bash
   docker-compose logs -f web
   docker-compose logs -f postgres
   ```

## Database Configuration

**Database Type:** PostgreSQL (converted from MySQL)

Environment variables:
```bash
DB_TYPE=pgsql
DB_HOST=postgres
DB_PORT=5432
DB_USER=msdv_user
DB_PASS=msdv_password
DB_NAME=mcc_discipline_system
```

## Deployment on Railway

### Prerequisites
- Railway account (railway.app)
- GitHub account with repository

### Deployment Steps

1. **Go to Railway Dashboard:**
   - Visit https://railway.app
   - Click "New Project"
   - Select "Deploy from GitHub repo"

2. **Connect Repository:**
   - Select the MSDV_reporting_system repository
   - Railway will automatically detect the Dockerfile

3. **Add PostgreSQL Service:**
   - In Railway dashboard, click "Add Service"
   - Select "Database" → "PostgreSQL"
   - Configure latest version

4. **Set Environment Variables:**
   - In Railway dashboard, go to Variables
   - Add the following:
     ```
     DB_TYPE=pgsql
     DB_HOST=postgres.railway.internal
     DB_PORT=5432
     DB_USER=msdv_user
     DB_PASS=your-secure-password
     DB_NAME=mcc_discipline_system
     ```

5. **Initialize Database:**
   - SSH into the container or use Railway's console
   - Import the SQL schema: `/db/mcc_discipline_system.sql`

6. **Deploy:**
   - Railway will automatically build and deploy
   - Your app will be available at the Railway-provided URL

## Deployment on Render

### Prerequisites
- Render account (render.com)
- GitHub account with repository

### Deployment Steps

1. **Create Web Service:**
   - Go to https://dashboard.render.com
   - Click "New+" → "Web Service"
   - Connect GitHub repository

2. **Configure:**
   - Build Command: (leave empty, uses Dockerfile)
   - Start Command: `apache2-foreground`
   - Instance Type: Free tier

3. **Add PostgreSQL Database:**
   - Create a new PostgreSQL database in Render
   - Note the connection details

4. **Set Environment Variables:**
   - In Service settings, add:
     ```
     DB_TYPE=pgsql
     DB_HOST=your-postgres-host
     DB_PORT=5432
     DB_USER=msdv_user
     DB_PASS=your-secure-password
     DB_NAME=mcc_discipline_system
     ```

5. **Initialize Database:**
   - Use Render's PostgreSQL console or SQL editor
   - Execute the SQL from `/db/mcc_discipline_system.sql`

6. **Deploy:**
   - Render will automatically build and deploy

## Database Schema Notes

The database has been converted from MySQL to PostgreSQL with the following changes:
- ENUM types are now PostgreSQL ENUM type
- AUTO_INCREMENT converted to SERIAL PRIMARY KEY
- Timestamp defaults properly formatted for PostgreSQL
- Foreign key constraints and indexes added for performance

## Troubleshooting

- **Connection refused:** Check that DB_HOST, DB_USER, and DB_PASS are correctly set
- **Files not found:** Ensure all files are committed to git and pushed
- **Database initialization failed:** Verify the SQL schema file exists and is properly formatted
- **Permission denied:** Check file permissions in the container

## Docker Commands

```bash
# Build image
docker build -t msdv-app .

# Run container with docker-compose
docker-compose up -d

# View logs
docker-compose logs -f

# Execute command in container
docker-compose exec web bash

# Access PostgreSQL database
docker-compose exec postgres psql -U msdv_user -d mcc_discipline_system
```

## Backup and Restore

### Backup PostgreSQL Database
```bash
docker-compose exec postgres pg_dump -U msdv_user -d mcc_discipline_system > backup.sql
```

### Restore PostgreSQL Database
```bash
cat backup.sql | docker-compose exec -T postgres psql -U msdv_user -d mcc_discipline_system
```
