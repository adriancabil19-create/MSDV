# PostgreSQL Migration Guide

## Overview
The MSDV Reporting System has been migrated from MySQL/MariaDB to PostgreSQL. This document explains the changes and how to use the system with PostgreSQL.

## Key Changes

### Database Type Conversion
- **MySQL** → **PostgreSQL**
- Schema converted in `/db/mcc_discipline_system.sql`

### Configuration File Updates

#### config/database.php
Now supports both MySQL and PostgreSQL via environment variable `DB_TYPE`:
- `DB_TYPE=mysql` for MySQL connections
- `DB_TYPE=pgsql` for PostgreSQL connections

**New Environment Variables:**
```bash
DB_TYPE=pgsql          # Database type (mysql or pgsql)
DB_HOST=postgres       # Database host
DB_PORT=5432          # Database port (5432 for PostgreSQL, 3306 for MySQL)
DB_USER=msdv_user     # Database user
DB_PASS=msdv_password # Database password
DB_NAME=mcc_discipline_system  # Database name
```

### Docker Changes

#### docker-compose.yml
- Replaced MySQL service with PostgreSQL 15 Alpine
- Automatic schema initialization via volume mount
- Added health checks for database readiness
- Updated environment variables

#### Dockerfile
- Added PostgreSQL development libraries
- Installed `pdo_pgsql` PHP extension alongside `pdo_mysql`
- Maintains backward compatibility with MySQL

### SQL Schema Changes

**Converted from MySQL to PostgreSQL syntax:**

1. **Data Types:**
   - `int(11)` → `INTEGER` or `SERIAL` for auto-increment
   - `varchar(XX)` → `VARCHAR(XX)` (unchanged)
   - `tinyint(1)` → `BOOLEAN`
   - `text` → `TEXT` (unchanged)

2. **Auto-Increment:**
   - `AUTO_INCREMENT PRIMARY KEY` → `SERIAL PRIMARY KEY`

3. **Timestamps:**
   - `DEFAULT current_timestamp()` → `DEFAULT CURRENT_TIMESTAMP`

4. **Enums:**
   - MySQL ENUM → PostgreSQL ENUM type
   - Created `user_role` enum type

5. **Constraints:**
   - Added explicit foreign key constraints
   - Added performance indexes

6. **Removed MySQL-specific syntax:**
   - `ENGINE=InnoDB`
   - `CHARSET=utf8mb4`
   - `COLLATE=utf8mb4_general_ci`

## Running with PostgreSQL

### Local Development

1. **Start with Docker Compose:**
   ```bash
   docker-compose up -d
   ```

2. **Access the application:**
   - URL: http://localhost
   - Database will auto-initialize with schema

3. **Connect to PostgreSQL directly:**
   ```bash
   docker-compose exec postgres psql -U msdv_user -d mcc_discipline_system
   ```

4. **View logs:**
   ```bash
   docker-compose logs -f postgres
   docker-compose logs -f web
   ```

### Production Deployment

#### Railway.app
1. Add PostgreSQL service from Railway marketplace
2. Set environment variables with PostgreSQL connection details
3. Database schema will be imported automatically

#### Render.com
1. Add PostgreSQL database instance
2. Set environment variables with PostgreSQL connection details
3. Use Render's PostgreSQL editor to import schema

#### Any PostgreSQL Host
1. Update environment variables to point to your PostgreSQL instance
2. Execute the schema from `/db/mcc_discipline_system.sql`
3. Verify tables and data are created

## File Structure

```
MSDV_reporting_system/
├── db/
│   └── mcc_discipline_system.sql    (PostgreSQL schema)
├── config/
│   └── database.php                  (Updated for MySQL & PostgreSQL support)
├── Dockerfile                         (Updated with pdo_pgsql extension)
├── docker-compose.yml                (Updated to use PostgreSQL)
├── .env.example                       (Updated with PostgreSQL settings)
├── DEPLOYMENT.md                      (Updated deployment guide)
└── POSTGRES_MIGRATION.md              (This file)
```

## Reverting to MySQL

If you need to switch back to MySQL:

1. Change environment variables:
   ```bash
   DB_TYPE=mysql
   DB_PORT=3306
   DB_HOST=localhost
   ```

2. Update docker-compose.yml to use MySQL service instead

3. Use original MySQL schema (if available)

Note: The PHP application code (`config/database.php`) now supports both databases, so no code changes are needed.

## PHP Database Functions

The application still uses MySQLi functions for backward compatibility when `DB_TYPE=mysql`. For PostgreSQL, consider migrating PHP code to use:

### For MySQLi style (existing code works):
```php
// Works with both MySQL and PostgreSQL through our abstraction
// See config/database.php for implementation
```

### For Production (recommended):
Consider using PDO for all database operations:
```php
$dsn = "pgsql:host={$host};port={$port};dbname={$db_name}";
$pdo = new PDO($dsn, $user, $pass);
```

## Performance Notes

PostgreSQL includes optimized indexes:
- `idx_students_student_id` - Fast student lookups
- `idx_students_fullname` - Fast name searches
- `idx_users_username` - Fast login queries
- `idx_violations_student_id` - Fast violation filtering
- `idx_violations_created_at` - Fast date range queries
- `idx_notifications_student_id` - Fast notification queries
- `idx_notifications_is_read` - Fast unread filtering

## Backup and Restore

### Backup PostgreSQL
```bash
pg_dump -U msdv_user -d mcc_discipline_system > backup.sql
```

### Restore PostgreSQL
```bash
psql -U msdv_user -d mcc_discipline_system < backup.sql
```

## Troubleshooting

### Cannot Connect to Database
- Verify PostgreSQL container is running: `docker-compose logs postgres`
- Check connection parameters in `.env` file
- Ensure DB_HOST is set to `postgres` for Docker environments

### Schema Not Initialized
- Check docker volume mounts in `docker-compose.yml`
- Manually run SQL initialization:
  ```bash
  docker-compose exec postgres psql -U msdv_user -d mcc_discipline_system < db/mcc_discipline_system.sql
  ```

### Connection Timeout
- Add health checks are enabled in `docker-compose.yml`
- Wait for PostgreSQL to be fully initialized before accessing the web app
- Check PostgreSQL logs: `docker-compose logs postgres`

## Support

For issues or questions about the PostgreSQL migration:
1. Check this migration guide
2. Review PostgreSQL documentation: https://www.postgresql.org/docs/
3. Check Django/PHP-PostgreSQL best practices
