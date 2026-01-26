# Game Haven v2 - Simplified Self-Hosted Stack

The v2 stack uses Node.js/Express instead of Supabase microservices. **One command** to install.

## Quick Start

```bash
curl -fsSL https://get.docker.com | sh && \
git clone https://github.com/ThaneWinters/GameTavern.git && \
cd GameTavern/deploy/standalone && \
chmod +x install.sh scripts/*.sh && \
./install.sh --v2
```

**That's it!** The installer handles everything:
- Prompts for site name and admin credentials
- Generates secure secrets automatically
- Starts all services
- Creates database and runs migrations
- Creates your admin user

Access your site at `http://your-server-ip:3000`

---

## Architecture

```
┌───────────────────────────────────────────────┐
│              Your Server                       │
│  ┌─────────┐  ┌─────────┐  ┌──────────────┐  │
│  │ Frontend│──│   API   │──│  PostgreSQL  │  │
│  │  :3000  │  │  :3001  │  │    :5432     │  │
│  └─────────┘  └─────────┘  └──────────────┘  │
└───────────────────────────────────────────────┘
```

Only **3 containers** vs 7+ in v1.

---

## What the Installer Does

1. **Collects settings** - Site name, admin email/password
2. **Generates secrets** - JWT key, database password (cryptographically secure)
3. **Starts containers** - Frontend, API, PostgreSQL
4. **Initializes database** - Schema created automatically on first boot
5. **Creates admin** - Your admin account ready to use
6. **Optional SSL** - Nginx + Let's Encrypt setup

---

## Commands

```bash
# Start
docker compose -f docker-compose-v2.yml up -d

# Stop  
docker compose -f docker-compose-v2.yml down

# Logs
docker compose -f docker-compose-v2.yml logs -f

# Restart
docker compose -f docker-compose-v2.yml restart
```

---

## Configuration

All settings are configured during install. To change later, edit `.env`:

```bash
nano .env
docker compose -f docker-compose-v2.yml restart
```

### Available Settings

| Variable | Description |
|----------|-------------|
| `SITE_NAME` | Your site name |
| `SITE_URL` | Public URL |
| `JWT_SECRET` | Auth secret (auto-generated) |
| `AI_PROVIDER` | `openai` or `gemini` (optional) |
| `AI_API_KEY` | Your AI API key (optional) |
| `FEATURE_*` | Toggle features on/off |

---

## Administration

### Create Additional Admins

```bash
./scripts/create-admin-v2.sh
```

### Backup

```bash
./scripts/backup.sh
```

### Restore

```bash
./scripts/restore.sh ./backups/gamehaven_YYYYMMDD.sql.gz
```

---

## SSL Setup

```bash
./scripts/setup-nginx.sh
```

---

## Troubleshooting

### Check status
```bash
docker compose -f docker-compose-v2.yml ps
curl http://localhost:3001/health
```

### View logs
```bash
docker compose -f docker-compose-v2.yml logs api
```

### Reset everything
```bash
docker compose -f docker-compose-v2.yml down -v
./install.sh --v2
```

---

## Uninstall

```bash
docker compose -f docker-compose-v2.yml down -v
cd ~ && rm -rf ~/GameTavern
```
