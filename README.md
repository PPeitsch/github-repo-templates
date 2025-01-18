# GitHub Repository Templates 📚

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](.github/CODE_OF_CONDUCT.md)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/PPeitsch/github-repository-templates/graphs/commit-activity)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](/.github/CONTRIBUTING.md)

A comprehensive collection of standardized GitHub repository templates and community health files. Ready-to-use templates for documentation, issues, pull requests, and project maintenance.

## 🚀 Features

- **Complete Template Set**: Full suite of GitHub community health files
- **Customizable**: Easy variable replacement for project-specific content
- **Best Practices**: Following GitHub's recommended standards
- **Well Documented**: Clear instructions and examples for all templates

## 📋 Included Templates

- `.github/`
  - `ISSUE_TEMPLATE/`
    - `bug.yml` - Bug report template
    - `config.yml` - Issue template configuration
    - `feature.yml` - Feature request template
  - `CODE_OF_CONDUCT.md` - Community behavior guidelines
  - `CONTRIBUTING.md` - Contribution guidelines
  - `PULL_REQUEST_TEMPLATE.md` - PR template
  - `SECURITY.md` - Security policy
  - `SUPPORT.md` - Support guidelines
- `README.md` - Project README template
- `CHANGELOG.md` - Change tracking template

## 🛠️ Usage

1. Clone this repository:
```bash
git clone https://github.com/PPeitsch/github-repository-templates.git
```

2. Copy the templates to your project:
```bash
cp -r github-repository-templates/.github/ your-project/
```

3. Configure the variables file (see [Configuration](#-configuration))

4. Use the provided script to replace variables:
```bash
./setup-templates.sh your-project/
```

## ⚙️ Configuration

Create a `template-config.yml` file with your project-specific variables:

```yaml
project:
  name: "Your Project Name"
  description: "Project description"
  owner: "Your Name"
  email: "your.email@example.com"
  security_email: "security@example.com"
  repo_url: "https://github.com/username/repository"
  documentation_url: "https://docs.example.com"
  license: "MIT"
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](.github/CONTRIBUTING.md).

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 💡 Support

Need help? Check out our [Support Guide](.github/SUPPORT.md).

## 🔒 Security

Found a security issue? Please check our [Security Policy](.github/SECURITY.md).
