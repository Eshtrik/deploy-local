#!/usr/bin/env python3

"""
UNIVERSAL LOCAL DEPLOYMENT SCRIPT
Works for: Flask, Django, FastAPI, Node.js, React, Vue, Angular, etc.
Usage: python deploy-local.py
"""

import os
import sys
import subprocess
import json
from pathlib import Path
from typing import Optional

# Colors for terminal output
class Colors:
    RED = '\033[0;31m'
    GREEN = '\033[0;32m'
    YELLOW = '\033[1;33m'
    BLUE = '\033[0;34m'
    NC = '\033[0m'

def print_header(text: str):
    """Print a formatted header"""
    print(f"\n{Colors.BLUE}{'='*60}{Colors.NC}")
    print(f"{Colors.BLUE}{text:^60}{Colors.NC}")
    print(f"{Colors.BLUE}{'='*60}{Colors.NC}\n")

def print_success(text: str):
    """Print success message"""
    print(f"{Colors.GREEN}✓ {text}{Colors.NC}")

def print_error(text: str):
    """Print error message"""
    print(f"{Colors.RED}✗ {text}{Colors.NC}")

def print_warning(text: str):
    """Print warning message"""
    print(f"{Colors.YELLOW}⚠ {text}{Colors.NC}")

def print_info(text: str):
    """Print info message"""
    print(f"{Colors.BLUE}ℹ {text}{Colors.NC}")

def run_command(cmd: list, check: bool = True) -> tuple[bool, str]:
    """Run a shell command and return (success, output)"""
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, check=False)
        return result.returncode == 0, result.stdout + result.stderr
    except Exception as e:
        return False, str(e)

def detect_project_type() -> str:
    """Auto-detect the project type"""
    print_header("STEP 1: Detecting Project Type")
    
    # Check for Python projects
    if Path("requirements.txt").exists() and Path("app.py").exists():
        print_success("Detected: Flask (Python)")
        return "flask"
    
    if Path("requirements.txt").exists() and Path("manage.py").exists():
        print_success("Detected: Django (Python)")
        return "django"
    
    if Path("requirements.txt").exists() and Path("main.py").exists():
        print_success("Detected: FastAPI (Python)")
        return "fastapi"
    
    # Check for Node.js projects
    if Path("package.json").exists():
        try:
            with open("package.json") as f:
                pkg = json.load(f)
            
            deps = {**pkg.get("dependencies", {}), **pkg.get("devDependencies", {})}
            
            if "react" in deps:
                print_success("Detected: React")
                return "react"
            
            if "next" in deps:
                print_success("Detected: Next.js")
                return "nextjs"
            
            if "vue" in deps:
                print_success("Detected: Vue.js")
                return "vue"
            
            if "@angular/core" in deps:
                print_success("Detected: Angular")
                return "angular"
            
            if Path("server.js").exists():
                print_success("Detected: Node.js")
                return "nodejs"
            
            print_success("Detected: Node.js (Generic)")
            return "nodejs"
        except:
            pass
    
    # Ask user if not detected
    print_warning("Could not auto-detect project type")
    print("1) Flask\n2) Django\n3) FastAPI")
    print("4) Node.js\n5) React\n6) Next.js")
    print("7) Vue.js\n8) Angular")
    
    choice = input("Enter project type (1-8): ").strip()
    
    choices = {
        "1": "flask", "2": "django", "3": "fastapi",
        "4": "nodejs", "5": "react", "6": "nextjs",
        "7": "vue", "8": "angular"
    }
    
    return choices.get(choice, "flask")

def install_python_deps():
    """Install Python dependencies"""
    print_header("STEP 2: Installing Python Dependencies")
    
    # Check Python
    success, _ = run_command(["python3", "--version"])
    if not success:
        print_error("Python3 is not installed")
        sys.exit(1)
    
    # Create virtual environment
    print_info("Creating virtual environment...")
    run_command(["python3", "-m", "venv", "venv"])
    
    # Determine activation command
    activate_cmd = "source venv/bin/activate" if os.name != 'nt' else "venv\\Scripts\\activate.bat"
    
    print_info("Upgrading pip...")
    venv_python = "venv/bin/python3" if os.name != 'nt' else "venv\\Scripts\\python.exe"
    run_command([venv_python, "-m", "pip", "install", "--upgrade", "pip"])
    
    # Install requirements
    if Path("requirements.txt").exists():
        print_info("Installing dependencies from requirements.txt...")
        run_command([venv_python, "-m", "pip", "install", "-r", "requirements.txt"])
        print_success("Dependencies installed")
    else:
        print_warning("requirements.txt not found")
    
    # Create .env
    create_env_file()

def install_nodejs_deps():
    """Install Node.js dependencies"""
    print_header("STEP 2: Installing Node.js Dependencies")
    
    # Check Node.js
    success, output = run_command(["node", "--version"])
    if not success:
        print_error("Node.js is not installed")
        print_info("Install from: https://nodejs.org")
        sys.exit(1)
    
    print_info(f"Node.js version: {output.strip()}")
    
    # Install dependencies
    print_info("Installing dependencies...")
    run_command(["npm", "install"])
    print_success("Dependencies installed")
    
    # Create .env
    create_env_file()

def create_env_file():
    """Create environment file"""
    if Path(".env").exists() or Path(".env.local").exists():
        return
    
    print_info("Creating environment file...")
    
    env_content = """# Environment Configuration
FLASK_ENV=development
FLASK_DEBUG=True
DEBUG=True
NODE_ENV=development

# Database
DATABASE_URL=sqlite:///app.db

# API
API_URL=http://localhost:3000
API_PORT=5000

# Security
SECRET_KEY=your-secret-key-change-in-production

# Email (optional)
MAIL_SERVER=smtp.gmail.com
MAIL_PORT=587
MAIL_USE_TLS=True
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-password
"""
    
    env_file = ".env.local" if Path("package.json").exists() else ".env"
    
    with open(env_file, 'w') as f:
        f.write(env_content)
    
    print_success(f"Created: {env_file}")

def setup_database(project_type: str):
    """Setup database for the project"""
    print_header("STEP 3: Database Setup")
    
    if project_type == "django":
        print_info("Running Django migrations...")
        venv_python = "venv/bin/python3" if os.name != 'nt' else "venv\\Scripts\\python.exe"
        run_command([venv_python, "manage.py", "migrate"])
        print_success("Migrations applied")
        
        if input("Create Django superuser? (y/n): ").lower() == 'y':
            run_command([venv_python, "manage.py", "createsuperuser"])
    
    elif project_type == "flask":
        if Path("migrate.py").exists():
            print_info("Running Flask migrations...")
            venv_python = "venv/bin/python3" if os.name != 'nt' else "venv\\Scripts\\python.exe"
            run_command([venv_python, "migrate.py"])
            print_success("Migrations applied")

def create_startup_scripts(project_type: str):
    """Create startup scripts for the project"""
    print_header("STEP 4: Creating Startup Scripts")
    
    if project_type in ["flask", "django", "fastapi"]:
        create_python_startup_script(project_type)
    else:
        create_nodejs_startup_script(project_type)

def create_python_startup_script(project_type: str):
    """Create Python startup scripts"""
    
    # Bash script
    bash_script = f"""#!/bin/bash
source venv/bin/activate

if [ -f ".env" ]; then
    export $(cat .env | grep -v '#' | xargs)
fi

if [ "$1" = "{project_type}" ] || [ "$1" = "" ]; then
    echo "Starting {project_type.upper()} development server..."
    python app.py
fi
"""
    
    with open("start-dev.sh", 'w') as f:
        f.write(bash_script)
    os.chmod("start-dev.sh", 0o755)
    print_success("Created: start-dev.sh")
    
    # Batch script
    batch_script = f"""@echo off
call venv\\Scripts\\activate.bat

if exist .env (
    for /f "delims=" %%a in (.env) do set "%%a"
)

echo Starting {project_type.upper()} development server...
python app.py
"""
    
    with open("start-dev.bat", 'w') as f:
        f.write(batch_script)
    print_success("Created: start-dev.bat")

def create_nodejs_startup_script(project_type: str):
    """Create Node.js startup scripts"""
    
    # Bash script
    bash_script = """#!/bin/bash

if [ -f ".env.local" ]; then
    export $(cat .env.local | grep -v '#' | xargs)
fi

npm start
"""
    
    with open("start-dev.sh", 'w') as f:
        f.write(bash_script)
    os.chmod("start-dev.sh", 0o755)
    print_success("Created: start-dev.sh")
    
    # Batch script
    batch_script = """@echo off

if exist .env.local (
    for /f "delims=" %%a in (.env.local) do set "%%a"
)

npm start
"""
    
    with open("start-dev.bat", 'w') as f:
        f.write(batch_script)
    print_success("Created: start-dev.bat")

def create_docker_config(project_type: str):
    """Create Docker configuration"""
    print_header("STEP 5: Docker Setup")
    
    if input("Create Docker configuration? (y/n): ").lower() != 'y':
        return
    
    if project_type == "flask":
        dockerfile = """FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENV FLASK_APP=app.py
ENV FLASK_ENV=production

EXPOSE 5000

CMD ["python", "app.py"]
"""
        docker_compose = """version: '3.8'
services:
  app:
    build: .
    ports:
      - "5000:5000"
    environment:
      - FLASK_ENV=development
      - DATABASE_URL=sqlite:///app.db
    volumes:
      - .:/app
"""
    
    elif project_type in ["nodejs", "react"]:
        dockerfile = """FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
"""
        docker_compose = """version: '3.8'
services:
  app:
    build: .
    ports:
      - "3000:3000"
    volumes:
      - .:/app
"""
    
    else:
        return
    
    with open("Dockerfile", 'w') as f:
        f.write(dockerfile)
    print_success("Created: Dockerfile")
    
    with open("docker-compose.yml", 'w') as f:
        f.write(docker_compose)
    print_success("Created: docker-compose.yml")
    
    dockerignore = """node_modules
npm-debug.log
build
dist
.git
.env
.DS_Store
venv
__pycache__
*.pyc
.pytest_cache
"""
    
    with open(".dockerignore", 'w') as f:
        f.write(dockerignore)
    print_success("Created: .dockerignore")

def create_gitignore():
    """Create .gitignore file"""
    print_header("STEP 6: Setting up Git")
    
    if Path(".gitignore").exists():
        return
    
    gitignore = """# Environment
.env
.env.local
.env.*.local

# Python
venv/
env/
__pycache__/
*.py[cod]
*.egg-info/
.pytest_cache/

# Node
node_modules/
npm-debug.log
yarn-error.log
dist/
build/

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Database
*.db
*.sqlite
*.sqlite3

# Logs
logs/
*.log
"""
    
    with open(".gitignore", 'w') as f:
        f.write(gitignore)
    print_success("Created: .gitignore")

def create_start_guide(project_type: str):
    """Create START-HERE.md guide"""
    print_header("STEP 7: Quick Start Guide")
    
    guide = f"""# Quick Start Guide

## ✅ Installation Complete!

### Start Development Server

**On Linux/Mac:**
```bash
bash start-dev.sh
```

**On Windows:**
```batch
start-dev.bat
```

### Manual Start

**{project_type.upper()}:**
```bash
source venv/bin/activate  # Linux/Mac
venv\\Scripts\\activate     # Windows

python app.py  # Flask
python manage.py runserver  # Django
uvicorn main:app --reload  # FastAPI

npm start  # Node.js / React / etc
```

## 🔗 Local URLs

- Web: http://localhost:3000 (Frontend)
- API: http://localhost:5000 (Backend)
- Admin: http://localhost:8000/admin (Django)
- Docs: http://localhost:8000/docs (FastAPI)

## 📝 Environment Variables

Edit `.env` file to customize settings:
```bash
FLASK_ENV=development
DEBUG=True
DATABASE_URL=sqlite:///app.db
```

## 🐳 Using Docker

```bash
# Build and start
docker-compose up

# Stop
docker-compose down

# Rebuild
docker-compose up --build
```

## 🧪 Running Tests

```bash
# Python
pytest

# Node
npm test
```

## 🔄 Troubleshooting

**Port already in use?**
- Linux/Mac: `lsof -i :3000`
- Windows: `netstat -ano | findstr :3000`

**Clear dependencies and reinstall:**
```bash
# Python
rm -rf venv
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Node
rm -rf node_modules
npm install
```

Generated: {Path.cwd().name}
"""
    
    with open("START-HERE.md", 'w') as f:
        f.write(guide)
    print_success("Created: START-HERE.md")

def main():
    """Main setup function"""
    project_name = Path.cwd().name
    project_dir = Path.cwd()
    
    print_header(f"LOCAL DEPLOYMENT SETUP - {project_name}")
    
    # Step 1: Detect project type
    project_type = detect_project_type()
    
    # Step 2: Install dependencies
    if project_type in ["flask", "django", "fastapi"]:
        install_python_deps()
    else:
        install_nodejs_deps()
    
    # Step 3: Setup database
    setup_database(project_type)
    
    # Step 4: Create startup scripts
    create_startup_scripts(project_type)
    
    # Step 5: Docker configuration
    create_docker_config(project_type)
    
    # Step 6: Git setup
    create_gitignore()
    
    # Step 7: Create guide
    create_start_guide(project_type)
    
    # Summary
    print_header("SETUP COMPLETE!")
    print_success(f"Project: {Colors.YELLOW}{project_name}{Colors.NC}")
    print_success(f"Type: {Colors.YELLOW}{project_type.upper()}{Colors.NC}")
    print_success(f"Location: {Colors.YELLOW}{project_dir}{Colors.NC}")
    
    print(f"\n{Colors.GREEN}What was created:{Colors.NC}")
    print("  ✓ Dependencies installed")
    print("  ✓ Environment file (.env)")
    print("  ✓ Startup scripts")
    print("  ✓ Git configuration")
    print("  ✓ Quick start guide")
    
    print(f"\n{Colors.GREEN}Next Steps:{Colors.NC}")
    print(f"  1. Read: {Colors.YELLOW}START-HERE.md{Colors.NC}")
    print(f"  2. Run: {Colors.YELLOW}bash start-dev.sh{Colors.NC} (or start-dev.bat on Windows)")
    print(f"  3. Visit: http://localhost:3000")
    
    print_success("All done! Happy coding! 🚀\n")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print_error("\nSetup cancelled by user")
        sys.exit(1)
    except Exception as e:
        print_error(f"Setup failed: {e}")
        sys.exit(1)
