# Game Haven - Deployment

This directory contains deployment configurations for different hosting options.

## Deployment Options

| Option | Best For | Includes Database? |
|--------|----------|-------------------|
| **[Standalone](./standalone/)** | Full self-hosting on any Linux server | ✅ Yes - complete stack |
| **[Cloudron](./cloudron/)** | Cloudron platform users | ❌ No - connect external |
| **[Self-Hosting Guide](./SELF-HOSTING.md)** | Manual setup with external Supabase | ❌ No - connect external |

---

## Quick Start - Standalone (Recommended)

The standalone deployment includes everything: the app, PostgreSQL, authentication, and API gateway.

```bash
cd deploy/standalone

# Run interactive installer
chmod +x install.sh
./install.sh

# Start the stack
docker compose up -d

# Create admin user
./scripts/create-admin.sh
```

The installer lets you customize:
- **Site name, description, author**
- **Domain and ports**
- **Feature flags** (Play Logs, Wishlist, For Sale, Messaging, etc.)
- **Email/SMTP settings**
- **Admin Studio** (optional database UI)

See [standalone/README.md](./standalone/README.md) for full documentation.

---

## Quick Start - Cloudron

For Cloudron users who want to connect to an external Supabase instance:

```bash
# Build and push to your registry
docker build -t registry.yourdomain.com/gamehaven:1.0.0 -f deploy/cloudron/Dockerfile ../..
docker push registry.yourdomain.com/gamehaven:1.0.0

# Install on Cloudron
cd deploy/cloudron
cloudron install --image registry.yourdomain.com/gamehaven:1.0.0
```

Set `SUPABASE_URL` and `SUPABASE_ANON_KEY` in Cloudron environment variables.

See [cloudron/README.md](./cloudron/README.md) for details.

---

## Architecture

### Standalone (All-in-One)

```
┌─────────────────────────────────────────────────────────────┐
│                     Your Linux Server                        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │ Game Haven  │  │    Kong     │  │      PostgreSQL     │  │
│  │  Frontend   │──│  API Gateway│──│   + Auth + REST     │  │
│  │   :3000     │  │    :8000    │  │   + Realtime        │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### Cloudron + External Database

```
┌─────────────────────┐      ┌─────────────────────┐
│   Cloudron Server   │      │  Supabase Cloud or  │
│   (Game Haven UI)   │─────▶│  Self-hosted Supa.  │
│   games.domain.com  │      │   db.domain.com     │
└─────────────────────┘      └─────────────────────┘
```

---

## Requirements

### Standalone
- Docker 20.10+
- Docker Compose 2.0+
- 4GB RAM minimum (8GB recommended)
- 20GB disk space

### Cloudron
- Cloudron server
- External Supabase project (cloud or self-hosted)
