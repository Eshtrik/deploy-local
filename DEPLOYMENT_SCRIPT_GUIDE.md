# Universal Local Deployment Script - Complete Guide

## Overview

This script automatically sets up **any project** (Flask, Django, FastAPI, React, Vue, Node.js, etc.) for local development with a **single command**.

---

## 🚀 Quick Start

### Option 1: Bash Script (Recommended)
```bash
bash deploy-local.sh
```

### Option 2: Python Script
```bash
python3 deploy-local.py
```

That's it! The script will:
- ✅ Auto-detect your project type
- ✅ Install all dependencies
- ✅ Setup database (if needed)
- ✅ Create startup scripts
- ✅ Configure Docker (optional)
- ✅ Create .gitignore
- ✅ Generate quick start guide

---

## 📋 What the Script Does

### 1. **Auto-Detection**
Automatically detects:
- **Flask** - Looks for `app.py` + `requirements.txt`
- **Django** - Looks for `manage.py` + `requirements.txt`
- **FastAPI** - Looks for `main.py` + `requirements.txt`
- **React** - Looks for `package.json` with React dependency
- **Vue.js** - Looks for `package.json` with Vue dependency
- **Angular** - Looks for `package.json` with Angular dependency
- **Next.js** - Looks for `package.json` with Next.js dependency
- **Node.js** - Fallback for any Node.js project

### 2. **Dependency Installation**
- **Python projects:**
  - Creates virtual environment (`venv/`)
  - Installs from `requirements.txt`
  - Upgrades pip

- **Node.js projects:**
  - Installs from `package.json`
  - Uses npm

### 3. **Environment Setup**
Creates `.env` file with sensible defaults:
```
FLASK_ENV=development
DEBUG=True
DATABASE_URL=sqlite:///app.db
SECRET_KEY=auto-generated
```

### 4. **Database Setup**
- **Django:** Runs migrations + optionally creates superuser
- **Flask:** Initializes database if needed

### 5. **Startup Scripts**
Creates both **bash** and **batch** scripts:
```bash
# Linux/Mac
bash start-dev.sh

# Windows
start-dev.bat
```

### 6. **Docker Configuration** (Optional)
Optionally creates:
- `Dockerfile` - Container configuration
- `docker-compose.yml` - Multi-container setup
- `.dockerignore` - Files to exclude

### 7. **Git Setup**
Creates comprehensive `.gitignore` with:
- Environment files
- Virtual environments
- Node modules
- Build artifacts
- IDE files
- OS files
- Database files

### 8. **Quick Start Guide**
Creates `START-HERE.md` with:
- How to start the dev server
- Local URLs
- Environment variables
- Docker commands
- Troubleshooting tips

---

## 📂 File Structure Created

```
your-project/
├── deploy-local.sh          # Main script (bash)
├── deploy-local.py          # Alternative script (python)
├── start-dev.sh             # Development server starter (bash)
├── start-dev.bat            # Development server starter (windows)
├── .env                     # Environment variables
├── .gitignore               # Git ignore file
├── START-HERE.md            # Quick start guide
├── Dockerfile               # Docker config (optional)
├── docker-compose.yml       # Docker compose (optional)
│
├── venv/                    # Python virtual environment
├── node_modules/            # Node packages
├── requirements.txt         # Python dependencies
├── package.json             # Node dependencies
│
└── app.py                   # Your application
```

---

## 🎯 Usage Examples

### Example 1: New Flask Project

```bash
# Project directory
mkdir my-flask-app
cd my-flask-app

# Copy script
cp deploy-local.sh .

# Run setup
bash deploy-local.sh

# Output should say: "Detected: Flask (Python)"
# Then creates venv, installs dependencies, etc.

# Start development
bash start-dev.sh

# Visit http://localhost:5000
```

### Example 2: Existing React Project

```bash
# Go to your React project
cd my-react-app

# Copy script
cp deploy-local.sh .

# Run setup
bash deploy-local.sh

# Output should say: "Detected: React"
# Then installs npm dependencies

# Start development
bash start-dev.sh

# Visit http://localhost:3000
```

### Example 3: Django Project

```bash
cd my-django-app
cp deploy-local.sh .
bash deploy-local.sh

# You'll be asked to create a superuser
# Then:
bash start-dev.sh

# Visit http://localhost:8000
# Admin: http://localhost:8000/admin
```

---

## 🔧 Manual Setup (If Script Fails)

### Python Project
```bash
# Create virtual environment
python3 -m venv venv

# Activate it
source venv/bin/activate  # Linux/Mac
venv\Scripts\activate     # Windows

# Install dependencies
pip install -r requirements.txt

# Create .env file
cp .env.example .env  # or create manually

# Run migrations (Django)
python manage.py migrate

# Start development
python app.py  # Flask
python manage.py runserver  # Django
uvicorn main:app --reload  # FastAPI
```

### Node.js Project
```bash
# Install dependencies
npm install

# Create .env.local
cp .env.example .env.local  # or create manually

# Start development
npm start  # React, Vue, Angular
npm run dev  # Next.js
node server.js  # Custom Node
```

---

## 🐳 Using Docker

If you created Docker files:

```bash
# Start containers
docker-compose up

# Stop containers
docker-compose down

# Rebuild images
docker-compose up --build

# View logs
docker-compose logs -f

# Run command in container
docker-compose exec app bash
```

---

## ⚙️ Customization

### Change Python Version
Edit `Dockerfile`:
```dockerfile
FROM python:3.10-slim  # Change version here
```

### Change Node Version
Edit `Dockerfile`:
```dockerfile
FROM node:20-alpine  # Change version here
```

### Customize Environment Variables
Edit `.env` file:
```
DEBUG=False  # Disable debug mode
PORT=8080    # Change port
DATABASE_URL=postgresql://...  # Use real database
```

### Add More Environment Variables
Edit `.env` and add:
```
API_KEY=your-key
STRIPE_KEY=your-stripe-key
AWS_ACCESS_KEY=your-aws-key
```

---

## 🆘 Troubleshooting

### Problem: "Python3 not found"
**Solution:**
```bash
# Install Python
brew install python3  # Mac
sudo apt install python3  # Ubuntu
# Or download from python.org
```

### Problem: "Port already in use"
**Solution:**
```bash
# Find process using port
lsof -i :5000  # Linux/Mac
netstat -ano | findstr :5000  # Windows

# Kill the process
kill -9 <PID>  # Linux/Mac
taskkill /PID <PID> /F  # Windows
```

### Problem: "Permission denied" on start-dev.sh
**Solution:**
```bash
chmod +x start-dev.sh
bash start-dev.sh
```

### Problem: "ModuleNotFoundError" or "npm ERR!"
**Solution:**
```bash
# Reinstall dependencies
# Python
rm -rf venv
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Node
rm -rf node_modules package-lock.json
npm install
```

### Problem: Database errors
**Solution:**
```bash
# Delete old database
rm db.sqlite3  # SQLite
rm app.db      # Flask default

# Recreate
# Flask
python -c "from app import app, db; app.app_context().push(); db.create_all()"

# Django
python manage.py migrate
```

### Problem: Script won't run
**Solution:**
```bash
# Make sure you're in the project directory
cd /path/to/your/project

# Run with Python instead
python3 deploy-local.py

# Or bash
bash deploy-local.sh
```

---

## 📊 Project Type Detection

The script checks for these files in order:

| Project Type | Detection Logic |
|---|---|
| Flask | `app.py` + `requirements.txt` |
| Django | `manage.py` + `requirements.txt` |
| FastAPI | `main.py` + `requirements.txt` |
| React | `package.json` with react dependency |
| Next.js | `package.json` with next dependency |
| Vue | `package.json` with vue dependency |
| Angular | `package.json` with @angular/core dependency |
| Node.js | `package.json` (generic) or `server.js` |

If not detected, you can manually select from the menu.

---

## 🔄 Workflow

```
1. Create new project directory
   ├── mkdir my-project
   └── cd my-project

2. Create your project structure
   ├── Create app.py (Flask)
   ├── Or create package.json (Node)
   └── Or clone existing repo

3. Run deployment script
   └── bash deploy-local.sh

4. Script auto-detects and sets up everything
   ├── Creates venv or installs npm packages
   ├── Creates .env file
   ├── Runs migrations
   ├── Creates startup scripts
   └── Creates documentation

5. Start development
   └── bash start-dev.sh

6. Your app is running!
   └── Visit http://localhost:3000 or 5000
```

---

## 🎓 Learning Resources

If you're new to development:

**Flask:**
- https://flask.palletsprojects.com

**Django:**
- https://docs.djangoproject.com

**FastAPI:**
- https://fastapi.tiangolo.com

**React:**
- https://react.dev

**Next.js:**
- https://nextjs.org

**Vue:**
- https://vuejs.org

**Angular:**
- https://angular.io

---

## 🚀 Production Deployment

Once your project works locally, see `DEPLOY_TO_PRODUCTION_SIMPLE.md` for:
- Heroku deployment
- DigitalOcean deployment
- AWS deployment
- Custom server deployment

---

## ✅ Checklist for New Project

- [ ] Create project directory
- [ ] Create basic files (app.py, package.json, etc.)
- [ ] Copy `deploy-local.sh` to project
- [ ] Run `bash deploy-local.sh`
- [ ] Follow the generated `START-HERE.md`
- [ ] Run `bash start-dev.sh`
- [ ] Visit localhost:3000 or 5000
- [ ] Start coding!

---

## 💡 Pro Tips

1. **Use the generated scripts** - Much faster than typing manually
2. **Keep .env.example** - For team members to reference
3. **Add to .gitignore** - Never commit .env files
4. **Use Docker** - For consistent environments across team
5. **Commit START-HERE.md** - Helps teammates get started

---

## 📧 Support

If you encounter issues:

1. Check `START-HERE.md` - Generated for your project
2. Check the Troubleshooting section above
3. Google the specific error message
4. Check the framework's documentation
5. Ask in the project's community/forum

---

## 🎉 You're Ready!

You now have a fully configured local development environment!

```bash
bash start-dev.sh
# Your app is running! 🚀
```

Happy coding! 💻
