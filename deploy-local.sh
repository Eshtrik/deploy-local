#!/bin/bash

################################################################################
# UNIVERSAL LOCAL DEPLOYMENT SCRIPT
# Works for: Flask, Django, FastAPI, Node.js, React, Vue, Angular, etc.
# Usage: bash deploy-local.sh
################################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_header() {
    echo -e "\n${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Get current directory
PROJECT_DIR="$(pwd)"
PROJECT_NAME="$(basename "$PROJECT_DIR")"

print_header "LOCAL DEPLOYMENT SETUP - $PROJECT_NAME"

# ============================================================================
# STEP 1: DETECT PROJECT TYPE
# ============================================================================

print_header "STEP 1: Detecting Project Type"

PROJECT_TYPE="unknown"

if [ -f "requirements.txt" ] && [ -f "app.py" ]; then
    PROJECT_TYPE="flask"
    print_success "Detected: Flask (Python)"
elif [ -f "requirements.txt" ] && [ -f "manage.py" ]; then
    PROJECT_TYPE="django"
    print_success "Detected: Django (Python)"
elif [ -f "requirements.txt" ] && [ -f "main.py" ]; then
    PROJECT_TYPE="fastapi"
    print_success "Detected: FastAPI (Python)"
elif [ -f "package.json" ] && [ -f "server.js" ]; then
    PROJECT_TYPE="nodejs"
    print_success "Detected: Node.js"
elif [ -f "package.json" ] && grep -q '"react"' package.json; then
    PROJECT_TYPE="react"
    print_success "Detected: React"
elif [ -f "package.json" ] && grep -q '"next"' package.json; then
    PROJECT_TYPE="nextjs"
    print_success "Detected: Next.js"
elif [ -f "package.json" ] && grep -q '"vue"' package.json; then
    PROJECT_TYPE="vue"
    print_success "Detected: Vue.js"
elif [ -f "package.json" ] && grep -q '"@angular"' package.json; then
    PROJECT_TYPE="angular"
    print_success "Detected: Angular"
elif [ -f "package.json" ]; then
    PROJECT_TYPE="nodejs"
    print_success "Detected: Node.js (Generic)"
else
    print_warning "Could not auto-detect project type. Please specify:"
    echo "1) flask"
    echo "2) django"
    echo "3) fastapi"
    echo "4) nodejs"
    echo "5) react"
    echo "6) nextjs"
    echo "7) vue"
    echo "8) angular"
    read -p "Enter project type (1-8): " choice
    
    case $choice in
        1) PROJECT_TYPE="flask" ;;
        2) PROJECT_TYPE="django" ;;
        3) PROJECT_TYPE="fastapi" ;;
        4) PROJECT_TYPE="nodejs" ;;
        5) PROJECT_TYPE="react" ;;
        6) PROJECT_TYPE="nextjs" ;;
        7) PROJECT_TYPE="vue" ;;
        8) PROJECT_TYPE="angular" ;;
        *) print_error "Invalid choice"; exit 1 ;;
    esac
fi

# ============================================================================
# STEP 2: INSTALL DEPENDENCIES
# ============================================================================

print_header "STEP 2: Installing Dependencies"

if [[ "$PROJECT_TYPE" == "flask" ]] || [[ "$PROJECT_TYPE" == "django" ]] || [[ "$PROJECT_TYPE" == "fastapi" ]]; then
    
    # Python projects
    if ! command -v python3 &> /dev/null; then
        print_error "Python3 is not installed"
        exit 1
    fi
    
    print_info "Creating Python virtual environment..."
    python3 -m venv venv
    source venv/bin/activate
    
    print_info "Upgrading pip..."
    pip install --upgrade pip
    
    print_info "Installing dependencies from requirements.txt..."
    if [ -f "requirements.txt" ]; then
        pip install -r requirements.txt
        print_success "Dependencies installed"
    else
        print_warning "requirements.txt not found"
    fi
    
    # Create .env file if it doesn't exist
    if [ ! -f ".env" ]; then
        print_info "Creating .env file..."
        if [ -f ".env.example" ]; then
            cp .env.example .env
            print_success ".env created from .env.example"
        else
            cat > .env << EOF
FLASK_ENV=development
FLASK_DEBUG=True
SECRET_KEY=$(python3 -c 'import secrets; print(secrets.token_hex(32))')
DATABASE_URL=sqlite:///app.db
EOF
            print_success ".env created with defaults"
        fi
    fi

elif [[ "$PROJECT_TYPE" == "nodejs" ]] || [[ "$PROJECT_TYPE" == "react" ]] || [[ "$PROJECT_TYPE" == "nextjs" ]] || [[ "$PROJECT_TYPE" == "vue" ]] || [[ "$PROJECT_TYPE" == "angular" ]]; then
    
    # Node.js projects
    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed"
        print_info "Install from: https://nodejs.org"
        exit 1
    fi
    
    if ! command -v npm &> /dev/null; then
        print_error "npm is not installed"
        exit 1
    fi
    
    print_info "Node.js version: $(node --version)"
    print_info "npm version: $(npm --version)"
    
    print_info "Installing dependencies..."
    npm install
    print_success "Dependencies installed"
    
    # Create .env file if it doesn't exist
    if [ ! -f ".env" ] && [ ! -f ".env.local" ]; then
        print_info "Creating .env file..."
        if [ -f ".env.example" ]; then
            cp .env.example .env.local
            print_success ".env.local created from .env.example"
        else
            cat > .env.local << EOF
REACT_APP_API_URL=http://localhost:3000
NEXT_PUBLIC_API_URL=http://localhost:3000
VUE_APP_API_URL=http://localhost:3000
EOF
            print_success ".env.local created with defaults"
        fi
    fi
fi

# ============================================================================
# STEP 3: DATABASE SETUP
# ============================================================================

print_header "STEP 3: Database Setup"

if [[ "$PROJECT_TYPE" == "django" ]]; then
    print_info "Running Django migrations..."
    source venv/bin/activate
    python manage.py migrate
    print_success "Migrations applied"
    
    # Create superuser
    read -p "Create Django superuser? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        python manage.py createsuperuser
    fi
    
elif [[ "$PROJECT_TYPE" == "flask" ]]; then
    if [ -f "migrate.py" ]; then
        print_info "Running Flask migrations..."
        source venv/bin/activate
        python migrate.py
        print_success "Migrations applied"
    elif [ -f "app.py" ]; then
        print_info "Initializing Flask database..."
        source venv/bin/activate
        python -c "from app import app, db; app.app_context().push(); db.create_all()" 2>/dev/null || true
        print_success "Database initialized"
    fi
fi

# ============================================================================
# STEP 4: CREATE STARTUP SCRIPTS
# ============================================================================

print_header "STEP 4: Creating Startup Scripts"

# Linux/Mac start script
if [[ "$PROJECT_TYPE" == "flask" ]] || [[ "$PROJECT_TYPE" == "django" ]] || [[ "$PROJECT_TYPE" == "fastapi" ]]; then
    
    cat > start-dev.sh << 'EOF'
#!/bin/bash
source venv/bin/activate

if [ -f ".env" ]; then
    export $(cat .env | grep -v '#' | xargs)
fi

if [ "$1" = "flask" ] || [ "$1" = "" ]; then
    echo "Starting Flask development server..."
    python app.py
elif [ "$1" = "django" ]; then
    echo "Starting Django development server..."
    python manage.py runserver
elif [ "$1" = "fastapi" ]; then
    echo "Starting FastAPI development server..."
    uvicorn main:app --reload
fi
EOF
    chmod +x start-dev.sh
    print_success "Created: start-dev.sh"
    
    # Windows batch file
    cat > start-dev.bat << 'EOF'
@echo off
call venv\Scripts\activate.bat

if exist .env (
    for /f "delims=" %%a in (.env) do set "%%a"
)

if "%1"=="flask" goto flask
if "%1"=="" goto flask
if "%1"=="django" goto django
if "%1"=="fastapi" goto fastapi

:flask
echo Starting Flask development server...
python app.py
goto end

:django
echo Starting Django development server...
python manage.py runserver
goto end

:fastapi
echo Starting FastAPI development server...
uvicorn main:app --reload
goto end

:end
EOF
    print_success "Created: start-dev.bat"
    
elif [[ "$PROJECT_TYPE" == "react" ]] || [[ "$PROJECT_TYPE" == "vue" ]] || [[ "$PROJECT_TYPE" == "angular" ]]; then
    
    cat > start-dev.sh << 'EOF'
#!/bin/bash

if [ -f ".env.local" ]; then
    export $(cat .env.local | grep -v '#' | xargs)
fi

npm start
EOF
    chmod +x start-dev.sh
    print_success "Created: start-dev.sh"
    
    cat > start-dev.bat << 'EOF'
@echo off

if exist .env.local (
    for /f "delims=" %%a in (.env.local) do set "%%a"
)

npm start
EOF
    print_success "Created: start-dev.bat"
    
elif [[ "$PROJECT_TYPE" == "nextjs" ]]; then
    
    cat > start-dev.sh << 'EOF'
#!/bin/bash

if [ -f ".env.local" ]; then
    export $(cat .env.local | grep -v '#' | xargs)
fi

npm run dev
EOF
    chmod +x start-dev.sh
    print_success "Created: start-dev.sh"
    
    cat > start-dev.bat << 'EOF'
@echo off

if exist .env.local (
    for /f "delims=" %%a in (.env.local) do set "%%a"
)

npm run dev
EOF
    print_success "Created: start-dev.bat"
    
elif [[ "$PROJECT_TYPE" == "nodejs" ]]; then
    
    cat > start-dev.sh << 'EOF'
#!/bin/bash

if [ -f ".env" ]; then
    export $(cat .env | grep -v '#' | xargs)
fi

npm start
EOF
    chmod +x start-dev.sh
    print_success "Created: start-dev.sh"
    
    cat > start-dev.bat << 'EOF'
@echo off

if exist .env (
    for /f "delims=" %%a in (.env) do set "%%a"
)

npm start
EOF
    print_success "Created: start-dev.bat"
fi

# ============================================================================
# STEP 5: CREATE DOCKER SETUP (Optional)
# ============================================================================

print_header "STEP 5: Docker Setup"

read -p "Create Docker configuration? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    
    if [[ "$PROJECT_TYPE" == "flask" ]]; then
        cat > Dockerfile << 'EOF'
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENV FLASK_APP=app.py
ENV FLASK_ENV=production

EXPOSE 5000

CMD ["python", "app.py"]
EOF
        print_success "Created: Dockerfile"
        
        cat > docker-compose.yml << 'EOF'
version: '3.8'
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
EOF
        print_success "Created: docker-compose.yml"
        
    elif [[ "$PROJECT_TYPE" == "nodejs" ]] || [[ "$PROJECT_TYPE" == "react" ]]; then
        cat > Dockerfile << 'EOF'
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
EOF
        print_success "Created: Dockerfile"
        
        cat > docker-compose.yml << 'EOF'
version: '3.8'
services:
  app:
    build: .
    ports:
      - "3000:3000"
    volumes:
      - .:/app
EOF
        print_success "Created: docker-compose.yml"
    fi
    
    cat > .dockerignore << 'EOF'
node_modules
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
EOF
    print_success "Created: .dockerignore"
fi

# ============================================================================
# STEP 6: CREATE .gitignore
# ============================================================================

print_header "STEP 6: Setting up Git"

if [ ! -f ".gitignore" ]; then
    cat > .gitignore << 'EOF'
# Environment variables
.env
.env.local
.env.*.local

# Python
venv/
env/
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Node/npm
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
*~
.DS_Store

# Logs
logs/
*.log

# Database
*.db
*.sqlite
*.sqlite3

# OS
.DS_Store
Thumbs.db

# Testing
.pytest_cache/
.coverage
htmlcov/
EOF
    print_success "Created: .gitignore"
fi

# ============================================================================
# STEP 7: QUICK START GUIDE
# ============================================================================

print_header "STEP 7: Quick Start Guide"

cat > START-HERE.md << EOF
# $PROJECT_NAME - Quick Start Guide

## ✅ Installation Complete!

### Start Development Server

**On Linux/Mac:**
\`\`\`bash
bash start-dev.sh
\`\`\`

**On Windows (Command Prompt):**
\`\`\`batch
start-dev.bat
\`\`\`

**Manual Start:**
EOF

if [[ "$PROJECT_TYPE" == "flask" ]]; then
    cat >> START-HERE.md << 'EOF'

### Flask
```bash
source venv/bin/activate  # Linux/Mac
venv\Scripts\activate     # Windows
python app.py
```
Visit: http://localhost:5000
EOF

elif [[ "$PROJECT_TYPE" == "django" ]]; then
    cat >> START-HERE.md << 'EOF'

### Django
```bash
source venv/bin/activate  # Linux/Mac
venv\Scripts\activate     # Windows
python manage.py runserver
```
Visit: http://localhost:8000
Admin: http://localhost:8000/admin
EOF

elif [[ "$PROJECT_TYPE" == "fastapi" ]]; then
    cat >> START-HERE.md << 'EOF'

### FastAPI
```bash
source venv/bin/activate  # Linux/Mac
venv\Scripts\activate     # Windows
uvicorn main:app --reload
```
Visit: http://localhost:8000
Docs: http://localhost:8000/docs
EOF

elif [[ "$PROJECT_TYPE" == "react" ]] || [[ "$PROJECT_TYPE" == "vue" ]] || [[ "$PROJECT_TYPE" == "angular" ]]; then
    cat >> START-HERE.md << 'EOF'

### Frontend Framework
```bash
npm start
```
Visit: http://localhost:3000
EOF

elif [[ "$PROJECT_TYPE" == "nextjs" ]]; then
    cat >> START-HERE.md << 'EOF'

### Next.js
```bash
npm run dev
```
Visit: http://localhost:3000
EOF

elif [[ "$PROJECT_TYPE" == "nodejs" ]]; then
    cat >> START-HERE.md << 'EOF'

### Node.js
```bash
npm start
```
Visit: http://localhost:3000 (or your configured port)
EOF

fi

cat >> START-HERE.md << 'EOF'

---

## 📁 Project Structure
- `requirements.txt` or `package.json` - Dependencies
- `.env` - Environment variables (don't commit!)
- `start-dev.sh` / `start-dev.bat` - Quick start scripts
- `Dockerfile` - Docker configuration (if created)

## 🐳 Using Docker

If you created Docker files:

```bash
# Build and run
docker-compose up

# Stop
docker-compose down
```

## 🔄 Environment Variables

Copy `.env.example` to `.env` and customize:
```bash
cp .env.example .env
```

## 🧪 Testing

```bash
# Python
pytest

# Node/npm
npm test
```

## 📦 Deployment

See DEPLOY.md for production deployment instructions.

## 🐛 Troubleshooting

**Port already in use?**
```bash
# Linux/Mac
lsof -i :3000  # or :5000, :8000

# Windows
netstat -ano | findstr :3000
```

**Dependencies not installing?**
```bash
# Python
pip install --upgrade pip
pip install -r requirements.txt

# Node
npm install --force
npm audit fix
```

**Database errors?**
```bash
# Flask/Django - Delete old database
rm db.sqlite3 app.db
# Then re-run migrations
```

---

Generated: $(date)
EOF

    print_success "Created: START-HERE.md"

# ============================================================================
# STEP 8: SUMMARY & NEXT STEPS
# ============================================================================

print_header "DEPLOYMENT COMPLETE!"

echo -e "${GREEN}Successfully set up local development for:${NC}"
echo -e "  Project: ${YELLOW}$PROJECT_NAME${NC}"
echo -e "  Type: ${YELLOW}$PROJECT_TYPE${NC}"
echo -e "  Location: ${YELLOW}$PROJECT_DIR${NC}\n"

echo -e "${GREEN}What was created:${NC}"
echo "  ✓ Dependencies installed"
echo "  ✓ Environment file (.env)"
echo "  ✓ Start scripts (start-dev.sh, start-dev.bat)"
echo "  ✓ .gitignore file"
echo "  ✓ START-HERE.md guide"

if [ -f "Dockerfile" ]; then
    echo "  ✓ Docker configuration"
fi

echo -e "\n${GREEN}Next Steps:${NC}"
echo "  1. Read: ${YELLOW}START-HERE.md${NC}"
echo "  2. Customize: ${YELLOW}.env${NC} with your settings"
echo "  3. Run: ${YELLOW}bash start-dev.sh${NC} (or start-dev.bat on Windows)"

if [[ "$PROJECT_TYPE" == "django" ]]; then
    echo "  4. Visit: http://localhost:8000"
    echo "  5. Admin: http://localhost:8000/admin"
elif [[ "$PROJECT_TYPE" == "flask" ]]; then
    echo "  4. Visit: http://localhost:5000"
elif [[ "$PROJECT_TYPE" == "fastapi" ]]; then
    echo "  4. Visit: http://localhost:8000"
    echo "  5. API Docs: http://localhost:8000/docs"
else
    echo "  4. Visit: http://localhost:3000"
fi

echo -e "\n${BLUE}For help, check: START-HERE.md${NC}\n"

print_success "All done! Happy coding! 🚀"
