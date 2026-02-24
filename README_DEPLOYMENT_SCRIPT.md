# Universal Local Deployment Script 🚀

<div align="center">

![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge)
![Python](https://img.shields.io/badge/python-3.6+-blue.svg?style=for-the-badge&logo=python)
![Bash](https://img.shields.io/badge/bash-5.0+-green.svg?style=for-the-badge&logo=gnubash)
![Status](https://img.shields.io/badge/status-Active-brightgreen.svg?style=for-the-badge)

**Automated local development setup for ANY project type** — Flask, Django, FastAPI, React, Vue, Angular, Next.js, Node.js and more!

[Features](#-features) • [Quick Start](#-quick-start) • [Supported Projects](#-supported-projects) • [Documentation](#-documentation) • [Contributing](#-contributing)

</div>

---

## 📋 Overview

**Universal Local Deployment Script** is a zero-configuration solution that automatically:

- 🎯 **Auto-detects** your project type (Flask? React? Django?)
- 📦 **Installs** all dependencies (pip or npm)
- ⚙️ **Configures** environment variables
- 🗄️ **Initializes** database (migrations, seeds)
- 🚀 **Creates** startup scripts
- 🐳 **Optional** Docker setup
- 📝 **Generates** quick start guide

**One command. That's it.** ✨

```bash
bash deploy-local.sh
# Your project is ready to go! 🎉
```

---

## ✨ Features

### 🎯 Core Features
- ✅ **Auto Project Detection** - Identifies Flask, Django, FastAPI, React, Vue, Angular, Next.js, Node.js
- ✅ **Smart Dependency Installation** - Python venv + pip or Node.js + npm
- ✅ **Environment Setup** - Creates `.env` file with sensible defaults
- ✅ **Database Configuration** - Handles migrations automatically
- ✅ **Startup Scripts** - Both Bash and Batch (Windows) versions
- ✅ **Docker Ready** - Optional Docker and Docker Compose setup
- ✅ **Git Integration** - Generates comprehensive `.gitignore`
- ✅ **Documentation** - Auto-creates `START-HERE.md` guide

### 🛠️ No Configuration Needed
- Zero setup - works out of the box
- Detects your project automatically
- Creates everything you need
- Works on Windows, Mac, and Linux
- Both Bash and Python versions

### 🚀 Production Ready
- Professional-grade setup
- Best practices included
- Security considerations built-in
- Scalable structure
- Deployment ready

---

## 🎬 Demo

### Before (Manual Setup)
```bash
# ❌ Lots of typing...
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
# ... more configuration ...
# ... database setup ...
# ... creating startup scripts ...
```

### After (With This Script)
```bash
# ✅ One command!
bash deploy-local.sh

# Your project is ready! 🎉
bash start-dev.sh
```

---

## 📦 Supported Projects

| Framework | Detection | Status |
|-----------|-----------|--------|
| **Flask** | `app.py` + `requirements.txt` | ✅ Full Support |
| **Django** | `manage.py` + `requirements.txt` | ✅ Full Support |
| **FastAPI** | `main.py` + `requirements.txt` | ✅ Full Support |
| **React** | `package.json` + React dependency | ✅ Full Support |
| **Vue.js** | `package.json` + Vue dependency | ✅ Full Support |
| **Angular** | `package.json` + Angular dependency | ✅ Full Support |
| **Next.js** | `package.json` + Next.js dependency | ✅ Full Support |
| **Node.js** | `package.json` or `server.js` | ✅ Full Support |

**Not listed?** The script can prompt you to select your project type manually!

---

## 🚀 Quick Start

### Option 1: Bash Script (Recommended)

```bash
# Navigate to your project
cd your-project

# Download the script
curl -O https://raw.githubusercontent.com/yourusername/deploy-local/main/deploy-local.sh

# Run setup
bash deploy-local.sh

# Start developing
bash start-dev.sh
```

### Option 2: Python Script

```bash
# Download the script
curl -O https://raw.githubusercontent.com/yourusername/deploy-local/main/deploy-local.py

# Run setup
python3 deploy-local.py

# Start developing
bash start-dev.sh
```

### That's it! 🎉

The script will:
1. Detect your project type
2. Install dependencies
3. Create environment file
4. Setup database (if needed)
5. Create startup scripts
6. Generate documentation

---

## 📖 Usage Examples

### Example 1: New Flask Project

```bash
# Create project directory
mkdir my-flask-app
cd my-flask-app

# Create basic Flask app
cat > app.py << 'EOF'
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello World!'

if __name__ == '__main__':
    app.run()
EOF

# Create requirements file
echo "flask==2.3.0" > requirements.txt

# Copy deployment script
curl -O https://raw.githubusercontent.com/yourusername/deploy-local/main/deploy-local.sh

# Run setup
bash deploy-local.sh

# Output:
# ✓ Detected: Flask (Python)
# ✓ Created virtual environment
# ✓ Installed dependencies
# ✓ Created .env file
# ✓ Created startup scripts
# ✓ Created .gitignore
# ✓ Created START-HERE.md

# Start development
bash start-dev.sh

# Visit: http://localhost:5000 ✅
```

### Example 2: Existing React Project

```bash
# Navigate to React project
cd my-react-app

# Copy script
curl -O https://raw.githubusercontent.com/yourusername/deploy-local/main/deploy-local.sh

# Run setup
bash deploy-local.sh

# Output:
# ✓ Detected: React
# ✓ Installed dependencies (npm install)
# ✓ Created .env.local file
# ✓ Created startup scripts

# Start development
bash start-dev.sh

# Visit: http://localhost:3000 ✅
```

### Example 3: Django Project with Database

```bash
cd my-django-app
curl -O https://raw.githubusercontent.com/yourusername/deploy-local/main/deploy-local.sh
bash deploy-local.sh

# The script will:
# ✓ Create virtual environment
# ✓ Install dependencies
# ✓ Run migrations
# ✓ Ask to create superuser
# ✓ Create startup scripts

bash start-dev.sh

# Visit: http://localhost:8000
# Admin: http://localhost:8000/admin ✅
```

---

## 📂 What Gets Created

```
your-project/
├── venv/                    # Python virtual environment
├── node_modules/            # Node packages (if applicable)
│
├── .env                     # Environment variables
├── .env.local               # Alternative env file (Node projects)
├── .gitignore               # Git ignore rules
│
├── start-dev.sh             # Startup script (Bash)
├── start-dev.bat            # Startup script (Windows)
│
├── START-HERE.md            # Quick start guide
│
├── Dockerfile               # Docker config (optional)
├── docker-compose.yml       # Docker Compose (optional)
└── .dockerignore            # Docker ignore (optional)
```

---

## ⚙️ Configuration

### Environment Variables

The script creates a `.env` file with defaults:

```env
# Flask/Django
FLASK_ENV=development
DEBUG=True
DATABASE_URL=sqlite:///app.db

# Security
SECRET_KEY=auto-generated-random-key

# Node.js
NODE_ENV=development

# API
API_URL=http://localhost:3000
API_PORT=5000
```

**Customize as needed** for your project!

### Custom Project Type

If the script can't detect your project:

```bash
bash deploy-local.sh

# When prompted:
# Could not auto-detect project type
# 1) Flask
# 2) Django
# 3) FastAPI
# 4) Node.js
# 5) React
# 6) Next.js
# 7) Vue.js
# 8) Angular

# Enter: 1-8
```

---

## 🐳 Docker Support

The script can optionally create Docker configuration:

```bash
bash deploy-local.sh

# When prompted:
# Create Docker configuration? (y/n) y

# Creates:
# ✓ Dockerfile
# ✓ docker-compose.yml
# ✓ .dockerignore
```

### Using Docker

```bash
# Start containers
docker-compose up

# Stop containers
docker-compose down

# View logs
docker-compose logs -f

# Run migrations
docker-compose exec app python migrate.py
```

---

## 🔧 Manual Setup (If Needed)

If the script fails for any reason, you can follow the generated `START-HERE.md` or:

### Python Projects
```bash
python3 -m venv venv
source venv/bin/activate  # Linux/Mac
venv\Scripts\activate     # Windows

pip install -r requirements.txt
cp .env.example .env

python app.py  # Flask
python manage.py runserver  # Django
```

### Node.js Projects
```bash
npm install
cp .env.example .env.local

npm start
```

---

## 📚 Documentation

- **[QUICK_START.md](docs/QUICK_START.md)** - Getting started guide
- **[DEPLOYMENT_SCRIPT_GUIDE.md](docs/DEPLOYMENT_SCRIPT_GUIDE.md)** - Complete documentation
- **[TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)** - Common issues and fixes
- **[FAQ.md](docs/FAQ.md)** - Frequently asked questions

---

## 🐛 Troubleshooting

### Port Already in Use

```bash
# Linux/Mac
lsof -i :5000  # or :3000, :8000

# Windows
netstat -ano | findstr :5000

# Kill the process
kill -9 <PID>  # Linux/Mac
taskkill /PID <PID> /F  # Windows
```

### Dependencies Not Installing

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

### Database Errors

```bash
# Delete old database
rm db.sqlite3
rm app.db

# Recreate
python manage.py migrate  # Django
python app.py  # Flask
```

### Permission Denied (Bash)

```bash
chmod +x deploy-local.sh
bash deploy-local.sh
```

More issues? Check [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)

---

## 🛠️ Technology Stack

### Supported Frameworks

**Backend:**
- Flask 2.3+
- Django 4.0+
- FastAPI 0.100+
- Express.js
- Custom Node.js

**Frontend:**
- React 18+
- Vue.js 3+
- Angular 14+
- Next.js 13+

**Databases:**
- PostgreSQL
- SQLite
- MySQL
- MongoDB

**DevOps:**
- Docker
- Docker Compose
- GitHub Actions
- Heroku

---

## 📈 Performance

| Metric | Time |
|--------|------|
| Auto-detection | ~100ms |
| Dependency installation | 1-5 minutes (varies by project size) |
| Database setup | <1 minute |
| Total setup time | 2-10 minutes |

---

## 🔐 Security

### Built-in Security Features

- ✅ Environment file (.env) in .gitignore
- ✅ Auto-generated SECRET_KEY
- ✅ No sensitive data in code
- ✅ Secure defaults
- ✅ Best practices included

### Best Practices

1. **Never commit .env** - Already in .gitignore
2. **Use strong passwords** - Change defaults
3. **Rotate secrets** - Update SECRET_KEY periodically
4. **Secure your database** - Use strong database passwords
5. **Use HTTPS in production** - This is for development only

---

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Ways to Contribute

1. **Report bugs** - Found an issue? [Create an issue](https://github.com/yourusername/deploy-local/issues)
2. **Suggest features** - Have an idea? [Suggest it](https://github.com/yourusername/deploy-local/discussions)
3. **Submit PR** - Want to help? [Submit a pull request](https://github.com/yourusername/deploy-local/pulls)
4. **Improve docs** - Fix typos? [Edit documentation](https://github.com/yourusername/deploy-local/edit/main/README.md)

---

## 📝 License

This project is licensed under the **MIT License** - see [LICENSE](LICENSE) file for details.

---

## 📊 Project Stats

- ⭐ **Stars**: [Star on GitHub](https://github.com/yourusername/deploy-local)
- 🔀 **Forks**: [Fork on GitHub](https://github.com/yourusername/deploy-local/fork)
- 💬 **Issues**: [View Issues](https://github.com/yourusername/deploy-local/issues)
- 📥 **Downloads**: Available via curl or direct download

---

## 🚀 Roadmap

### v1.0 (Current)
- ✅ Core deployment script
- ✅ Auto-detection system
- ✅ Multiple framework support
- ✅ Docker support

### v1.1 (Planned)
- [ ] Cloud deployment (Heroku, Render)
- [ ] Database backup automation
- [ ] CI/CD pipeline templates
- [ ] Performance monitoring

### v2.0 (Future)
- [ ] Web GUI for setup
- [ ] Multi-project management
- [ ] Team collaboration features
- [ ] Advanced debugging tools

[See full roadmap →](docs/ROADMAP.md)

---

## 💡 Tips & Tricks

### Tip 1: Use with Version Control
```bash
# Create git repo
git init
git add .
git commit -m "Initial commit"
```

### Tip 2: Share with Team
```bash
# Everyone just runs:
bash deploy-local.sh

# Consistent setup across team!
```

### Tip 3: Save for Future Projects
```bash
# Create scripts folder
mkdir ~/scripts
cp deploy-local.sh ~/scripts/

# Use it for all future projects!
```

### Tip 4: Automate Everything
```bash
# Use with CI/CD
# Use with Docker
# Use with cloud deployment
```

---

## 📚 Additional Resources

- [Flask Documentation](https://flask.palletsprojects.com)
- [Django Documentation](https://docs.djangoproject.com)
- [React Documentation](https://react.dev)
- [Docker Documentation](https://docs.docker.com)
- [GitHub Guides](https://guides.github.com)

---

## ❓ FAQ

**Q: Do I need to know bash?**
A: No! The script does everything automatically.

**Q: Works with my framework?**
A: If it's Flask, Django, FastAPI, React, Vue, Angular, Next.js, or Node.js - yes!

**Q: Can I customize the setup?**
A: Yes! Edit the generated `.env` file and startup scripts.

**Q: Is it safe?**
A: Yes! It follows best practices and creates secure configurations.

**Q: Can I use it in production?**
A: It's designed for development. Use appropriate deploy scripts for production.

**Q: What if it fails?**
A: Check [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) or create an issue.

[See more FAQs →](docs/FAQ.md)

---

## 📧 Support

- 💬 [GitHub Discussions](https://github.com/yourusername/deploy-local/discussions)
- 🐛 [Report Issues](https://github.com/yourusername/deploy-local/issues)
- 📧 [Email Support](mailto:support@example.com)
- 🐦 [Twitter](https://twitter.com/yourusername)

---

## 👏 Acknowledgments

Special thanks to:
- [Bash Documentation](https://www.gnu.org/software/bash/manual/)
- [Python Community](https://www.python.org)
- [Node.js Community](https://nodejs.org)
- All [contributors](https://github.com/yourusername/deploy-local/graphs/contributors)

---

<div align="center">

**[⬆ back to top](#universal-local-deployment-script-)**

Made with ❤️ by [Your Name](https://github.com/yourusername)

[GitHub](https://github.com/yourusername/deploy-local) • [Twitter](https://twitter.com/yourusername) • [Email](mailto:email@example.com)

**Star us on GitHub!** ⭐

</div>
