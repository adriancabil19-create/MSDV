# MSDV Reporting System - Deployment Guide

## Local Development with Docker

### Prerequisites
- Docker and Docker Compose installed

### Running Locally

1. **Start the application:**
   ```bash
   docker-compose up -d
   ```

2. **Access the application:**
   - URL: `http://localhost`
   - Login page: `http://localhost/auth/login.php`

3. **Stop the application:**
   ```bash
   docker-compose down
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

3. **Add MySQL Service:**
   - In Railway dashboard, click "Add Service"
   - Select "Database" → "MySQL"
   - Configure version 8.0

4. **Set Environment Variables:**
   - In Railway dashboard, go to Variables
   - Add the following:
     ```
     DB_HOST=mysql (Railway will auto-populate this)
     DB_USER=msdv_user
     DB_PASS=msdv_password
     DB_NAME=mcc_discipline_system
     ```

5. **Deploy:**
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

3. **Add MySQL Database:**
   - Create a new MySQL database in Render
   - Note the connection details

4. **Set Environment Variables:**
   - In Service settings, add:
     ```
     DB_HOST=your-mysql-host
     DB_USER=msdv_user
     DB_PASS=your-secure-password
     DB_NAME=mcc_discipline_system
     ```

5. **Deploy:**
   - Render will automatically build and deploy

## Database Initialization

After deployment, you'll need to import your database schema:

1. Export from local database:
   ```bash
   mysqldump -u root mcc_discipline_system > backup.sql
   ```

2. Import on production database using your platform's tools or phpMyAdmin

## Troubleshooting

- **Connection refused:** Check that DB_HOST, DB_USER, and DB_PASS are correctly set
- **Files not found:** Ensure all files are committed to git and pushed
- **Permission denied:** Check file permissions in the container

## Docker Commands

```bash
# Build image
docker build -t msdv-app .

# Run container
docker run -p 80:80 msdv-app

# View logs
docker-compose logs -f

# Execute command in container
docker-compose exec web bash
```
