# GitHub Repository Templates 📚

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](.github/CODE_OF_CONDUCT.md)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/PPeitsch/github-repository-templates/graphs/commit-activity)

A comprehensive collection of standardized GitHub repository templates and community health files. Features a powerful variable system for easy customization.

## 🌟 Features

- 📋 Complete set of GitHub community health files
- 🔄 Variable system for easy customization
- 🚀 Automated setup script
- 💅 Beautiful, emoji-rich templates
- 📊 Comprehensive documentation templates

## 📁 Directory Structure

```
.
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug.yml
│   │   ├── config.yml
│   │   └── feature.yml
│   ├── CODE_OF_CONDUCT.md
│   ├── CONTRIBUTING.md
│   ├── PULL_REQUEST_TEMPLATE.md
│   ├── SECURITY.md
│   └── SUPPORT.md
├── template-config.yml
├── setup-templates.sh
└── README-template.md
```

## 🚀 Quick Start

1. Clone this repository:
```bash
git clone https://github.com/PPeitsch/github-repository-templates.git
```

2. Copy the template files to your project:
```bash
cp -r github-repository-templates/.github/ your-project/
cp github-repository-templates/README-template.md your-project/README.md
```

3. Create and customize your `template-config.yml`:
```bash
cp template-config.yml your-project/template-config.yml
```

4. Configure your variables in `template-config.yml`

5. Run the setup script:
```bash
./setup-templates.sh your-project/
```

## ⚙️ Configuration System

### Variable Structure

The `template-config.yml` file organizes variables in logical sections:

```yaml
project:
  name: "Your Project"
  version: "1.0.0"
  # ... more project info

contact:
  email: "contact@example.com"
  security_email: "security@example.com"
  # ... more contact info

urls:
  repo: "https://github.com/username/repo"
  docs: "https://docs.example.com"
  # ... more URLs
```

### Variable Usage

Variables in templates use the `{{VARIABLE_NAME}}` syntax:

```markdown
# {{PROJECT_NAME}}

Welcome to {{PROJECT_NAME}} version {{PROJECT_VERSION}}
```

## 🛠️ Setup Script

The `setup-templates.sh` script:
1. Reads your `template-config.yml`
2. Processes all template files recursively
3. Replaces all variables with their configured values
4. Maintains file permissions and structure

### Usage
```bash
./setup-templates.sh <project-directory>
```

### Features
- ✅ Handles nested YAML structures
- ✅ Preserves file formatting
- ✅ Processes all template files
- ✅ Provides detailed error messages
- ✅ Creates backups during processing

## 📋 Available Templates

- 📝 README.md - Project documentation
- 👥 CODE_OF_CONDUCT.md - Community guidelines
- 🤝 CONTRIBUTING.md - Contribution guidelines
- 🔒 SECURITY.md - Security policy
- 💬 SUPPORT.md - Support information
- 🎫 Issue templates
- 🔄 Pull request templates

## 🤝 Contributing

Contributions are welcome! Before contributing to this template repository, please note:

- We follow standard GitHub Flow for contributions
- Open issues for any bugs or improvements
- Submit PRs with clear descriptions
- Keep templates generic and widely applicable
- Test template changes with the setup script

For guidance on using these templates in your own projects, see the template versions of:
- [Contributing Guidelines Template](.github/CONTRIBUTING.md)
- [Code of Conduct Template](.github/CODE_OF_CONDUCT.md)

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.