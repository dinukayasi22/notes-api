# 📝 Notes API — Full DevOps Pipeline on AWS EC2

A production-ready REST API for managing notes, built with **Node.js + Express + Supabase**, fully containerized with **Docker**, provisioned with **Terraform**, automated with **Bash scripts**, and deployed via a **Jenkins CI/CD pipeline** on AWS EC2.

> Built as a hands-on DevOps project covering the full software delivery lifecycle — from code to cloud.

---

## 🏗️ Architecture

```
Developer pushes code
        ↓
┌───────────────────┐
│      GitHub       │
└────────┬──────────┘
         │ triggers
┌────────▼──────────┐
│     Jenkins       │  ← Running on AWS EC2
│   CI/CD Pipeline  │
└────────┬──────────┘
         │ deploys
┌────────▼──────────┐
│   Docker Container│  ← Notes API
│   Node.js/Express │
└────────┬──────────┘
         │ connects
┌────────▼──────────┐
│     Supabase      │  ← PostgreSQL Database
└───────────────────┘

Infrastructure provisioned by Terraform
Server configured by Bash scripts
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Runtime | Node.js + Express |
| Database | Supabase (PostgreSQL) |
| Containerization | Docker + Docker Compose |
| Infrastructure | Terraform + AWS EC2 |
| CI/CD | Jenkins |
| Automation | Bash Scripts |
| Source Control | GitHub |

---

## ✨ Features

- ✅ Full CRUD for notes (Create, Read, Update, Delete)
- ✅ Health check endpoint for monitoring
- ✅ Dockerized with health checks
- ✅ Infrastructure as Code with Terraform
- ✅ Automated server setup with Bash
- ✅ Jenkins pipeline with 7 stages
- ✅ Auto-deploy on every GitHub push

---

## 📁 Project Structure

```
notes-api/
├── index.js                  # App entrypoint
├── routes/
│   └── notes.js              # CRUD endpoints
├── db/
│   └── supabase.js           # Supabase client
├── schema.sql                # DB schema, triggers, RLS, seed data
├── Dockerfile                # Container build
├── docker-compose.yml        # Service definition
├── Jenkinsfile               # CI/CD pipeline (7 stages)
├── scripts/
│   ├── setup.sh              # Bootstrap fresh Ubuntu server
│   ├── deploy.sh             # Pull & redeploy containers
│   └── healthcheck.sh        # API health check with retries
├── terraform/
│   ├── main.tf               # EC2, security group, key pair
│   ├── variables.tf          # Configurable variables
│   ├── outputs.tf            # IP, SSH command, API URL
│   └── terraform.tfvars.example
├── package.json
└── .env.example
```

---

## 🚀 Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/) v18+
- [Docker](https://docs.docker.com/get-docker/) + Docker Compose
- [Terraform](https://developer.hashicorp.com/terraform/install) v5+
- [Supabase](https://supabase.com) account
- AWS account with CLI configured

---

### 1. Clone the Repository

```bash
git clone https://github.com/dinukayasi22/notes-api.git
cd notes-api
```

---

### 2. Set Up Environment Variables

```bash
cp .env.example .env
```

```env
SUPABASE_URL=your_supabase_project_url
SUPABASE_KEY=your_supabase_anon_key
CORS_ORIGIN=*
PORT=5000
```

> ⚠️ Never commit `.env` to GitHub.

---

### 3. Set Up the Database

Run `schema.sql` in your **Supabase SQL Editor** to create the `notes` table, triggers, RLS policies, and seed data.

---

### 4. Run Locally

```bash
npm install
npm run dev
```

---

### 5. Run with Docker

```bash
docker compose up --build -d
```

Visit: `http://localhost:5000/api/health`

---

## ☁️ Infrastructure Setup with Terraform

Provision the entire AWS infrastructure with one command:

```bash
cd terraform

# Generate SSH key
ssh-keygen -t rsa -b 4096 -f ~/.ssh/notes-api-key

# Copy example vars
cp terraform.tfvars.example terraform.tfvars

# Initialize Terraform
terraform init

# Preview infrastructure
terraform plan

# Provision EC2, security group, key pair
terraform apply
```

Terraform will output:
```
instance_public_ip = "x.x.x.x"
ssh_command        = "ssh -i ~/.ssh/notes-api-key ubuntu@x.x.x.x"
api_url            = "http://x.x.x.x:5000/api/notes"
```

> ⚠️ Run `terraform destroy` when done to avoid AWS charges.

---

## 🤖 Jenkins CI/CD Pipeline

The `Jenkinsfile` defines a 7-stage pipeline:

```
✅ Checkout          → Pull latest code from GitHub
✅ Verify Tools      → Confirm Docker is available
✅ Build             → Build Docker image
✅ Stop Old          → Remove existing containers
✅ Deploy            → Start new containers
✅ Health Check      → Verify API is responding
✅ Cleanup           → Prune unused Docker images
```

Every `git push` to `main` triggers an automatic deployment.

---

## 🔧 Bash Scripts

### `setup.sh` — Bootstrap a fresh server
```bash
sudo bash scripts/setup.sh
```
Installs Docker, Docker Compose, Git and configures the server.

### `deploy.sh` — Deploy latest code
```bash
bash scripts/deploy.sh
```
Pulls latest code, rebuilds and restarts containers, prunes old images.

### `healthcheck.sh` — Verify the API is running
```bash
bash scripts/healthcheck.sh
```
Hits `/api/health` with retries and prints container status, memory and disk usage.

---

## 🔌 API Endpoints

| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/health` | Health check |
| GET | `/api/notes` | Get all notes |
| GET | `/api/notes/:id` | Get a single note |
| POST | `/api/notes` | Create a note |
| PUT | `/api/notes/:id` | Update a note |
| DELETE | `/api/notes/:id` | Delete a note |

---

## 📋 Example cURL Commands

```bash
# Health check
curl http://localhost:5000/api/health

# Get all notes
curl http://localhost:5000/api/notes

# Create a note
curl -X POST http://localhost:5000/api/notes \
  -H "Content-Type: application/json" \
  -d '{"title":"Learn Terraform","content":"Infrastructure as code"}'

# Update a note
curl -X PUT http://localhost:5000/api/notes/<id> \
  -H "Content-Type: application/json" \
  -d '{"title":"Updated title","content":"Updated content"}'

# Delete a note
curl -X DELETE http://localhost:5000/api/notes/<id>
```

---

## 🔐 Environment Variables

| Variable | Required | Description |
|---|---|---|
| `SUPABASE_URL` | ✅ | Supabase project URL |
| `SUPABASE_KEY` | ✅ | Supabase anon key |
| `CORS_ORIGIN` | ❌ | Allowed origin (default: `*`) |
| `PORT` | ❌ | Server port (default: `5000`) |

---

## 🗺️ What I Learned

- Writing production `Dockerfile`s with health checks
- Orchestrating services with Docker Compose
- Provisioning AWS infrastructure as code with Terraform
- Automating server setup and deployments with Bash
- Building a full Jenkins CI/CD pipeline from scratch
- Managing secrets and environment variables securely

---

## 🔮 Future Improvements

- [ ] Add GitHub Actions as an alternative CI/CD pipeline
- [ ] Add authentication with JWT or Supabase Auth
- [ ] Add request validation with Joi or Zod
- [ ] Add unit and integration tests
- [ ] Add monitoring with Prometheus + Grafana
- [ ] Migrate to Kubernetes with Minikube
- [ ] Add HTTPS with Let's Encrypt SSL

---

## 👨‍💻 Author

**Dinuka Yasi** — [GitHub](https://github.com/dinukayasi22)

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).