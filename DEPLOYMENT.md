# MSDV Reporting System - Deployment Guide

## Local Development with Docker

### Prerequisites
- Docker and Docker Compose installed

### Initial Setup

1. **Copy environment file:**
   ```bash
   cp .env.example .env
   ```
   The `.env` file is already configured for local Docker development.

2. **Start the application:**
   ```bash
   docker-compose up -d
   ```
   This will start both the PHP/Apache web server and PostgreSQL database.

3. **Access the application:**
   - URL: `http://localhost`
   - Login page: `http://localhost/auth/login.php`
   - Default credentials: admin / (check users table)

4. **Stop the application:**
   ```bash
   docker-compose down
   ```

5. **View logs:**
   ```bash
   docker-compose logs -f web
   docker-compose logs -f postgres
   ```

## Database Configuration

**Database Type:** PostgreSQL (converted from MySQL)

Environment variables (stored in `.env`):
```bash
DB_TYPE=pgsql
DB_HOST=postgres
DB_PORT=5432
DB_USER=msdv_user
DB_PASS=msdv_password
DB_NAME=mcc_discipline_system
APP_ENV=local
APP_URL=http://localhost
```

## Deployment on Railway + Supabase

### Prerequisites
- Railway account (railway.app)
- Supabase account (supabase.com)
- GitHub account with repository

### Step 1: Set Up Supabase Database

1. **Create Supabase Project:**
   - Go to https://supabase.com and sign up/login
   - Click "New Project"
   - Select your region and set a password
   - Wait for provisioning (5-10 minutes)

2. **Get Connection Details:**
   - Go to Project Settings → Database
   - Copy the connection string or note:
     - Host: `[project-id].supabase.co`
     - Port: `5432`
     - Username: `postgres`
     - Password: (the one you set)
     - Database: `postgres`

3. **Import Database Schema:**
   - In Supabase, go to SQL Editor
   - Create a new query and paste contents of `/db/mcc_discipline_system.sql`
   - Execute the query to create all tables

### Step 2: Deploy on Railway

1. **Go to Railway Dashboard:**
   - Visit https://railway.app
   - Click "New Project"
   - Select "Deploy from GitHub repo"

2. **Connect Repository:**
   - Select the MSDV_reporting_system repository
   - Railway will automatically detect the Dockerfile

3. **Set Environment Variables:**
   - In Railway dashboard, go to Variables
   - Add the following (from Supabase connection details):
     ```
     DB_TYPE=pgsql
     DB_HOST=your-project.supabase.co
     DB_PORT=5432
     DB_USER=postgres
     DB_PASS=your-supabase-password
     DB_NAME=postgres
     APP_ENV=production
     APP_URL=https://your-railway-url.railway.app
     APP_DEBUG=false
     ```

4. **Deploy:**
   - Railway will automatically build and deploy
   - Your app will be available at the Railway-provided URL

## Deployment on Render + Supabase

### Prerequisites
- Render account (render.com)
- Supabase account (supabase.com)
- GitHub account with repository

### Step 1: Set Up Supabase Database (same as Railway)

Follow the Supabase setup steps in the Railway section above.

### Step 2: Deploy on Render

1. **Create Web Service:**
   - Go to https://dashboard.render.com
   - Click "New+" → "Web Service"
   - Connect GitHub repository

2. **Configure:**
   - Build Command: (leave empty, uses Dockerfile)
   - Start Command: `apache2-foreground`
   - Instance Type: Starter tier or higher

3. **Set Environment Variables:**
   - In Service settings, add:
     ```
     DB_TYPE=pgsql
     DB_HOST=your-project.supabase.co
     DB_PORT=5432
     DB_USER=postgres
     DB_PASS=your-supabase-password
     DB_NAME=postgres
     APP_ENV=production
     APP_URL=https://your-render-url.onrender.com
     APP_DEBUG=false
     ```

4. **Deploy:**
   - Render will automatically build and deploy from GitHub

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
