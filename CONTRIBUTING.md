# Contributing to Sam's Dotfiles

Thank you for your interest in contributing to this dotfiles repository! While this is primarily a personal configuration repository, contributions that improve code quality, documentation, or add useful features are welcome.

## Getting Started

1. Fork the repository
2. Clone your fork locally
3. Set up the development environment:
   ```bash
   make install
   ```

## Development Workflow

### Before Making Changes

1. **Install development dependencies:**
   ```bash
   make install
   ```

2. **Set up git hooks:**
   ```bash
   make setup-hooks
   ```

3. **Check current state:**
   ```bash
   make check-deps
   make validate
   ```

### Making Changes

1. **Create a new branch:**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes following these guidelines:**
   - Keep changes minimal and focused
   - Follow existing code style and patterns
   - Add comments for complex configurations
   - Test changes locally before committing

3. **Run quality checks:**
   ```bash
   make lint
   make test
   ```

4. **Commit your changes:**
   ```bash
   git add .
   git commit -m "feat: your descriptive commit message"
   ```

## Code Quality Standards

### Shell Scripts
- Use `#!/usr/bin/env bash` or `#!/bin/bash` for shebangs
- Add `set -e` for error handling
- Use proper quoting for variables
- Follow shellcheck recommendations
- Avoid hardcoded paths when possible

### Configuration Files
- Use consistent indentation (see `.editorconfig`)
- Validate syntax before committing
- Add comments explaining complex configurations
- Keep secrets out of configuration files

### Python Scripts
- Follow PEP 8 style guidelines
- Use type hints where appropriate
- Add docstrings for functions and classes

## Testing

Run the test suite before submitting changes:

```bash
make test
```

This will:
- Lint all code
- Validate configuration files
- Check for common issues
- Run security scans

## Commit Message Format

Use conventional commit format:

- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation changes
- `style:` for formatting changes
- `refactor:` for code refactoring
- `test:` for adding tests
- `chore:` for maintenance tasks

Examples:
- `feat: add new wallpaper switching script`
- `fix: resolve hardcoded path in backup script`
- `docs: update installation instructions`

## Pull Request Process

1. **Ensure your PR:**
   - Has a clear title and description
   - Passes all quality checks
   - Includes relevant documentation updates
   - Follows the coding standards

2. **PR Description should include:**
   - What changes were made and why
   - How to test the changes
   - Any breaking changes or migration notes

3. **After submitting:**
   - Respond to review feedback promptly
   - Keep your branch up to date with main
   - Squash commits if requested

## Security Considerations

- Never commit sensitive information (passwords, API keys, etc.)
- Use environment variables for sensitive configuration
- Run security scans: `make security`
- Report security issues privately via GitHub security advisories

## Documentation

- Update README.md for significant changes
- Add inline comments for complex configurations
- Update tool documentation in the main README
- Consider adding usage examples

## Questions and Support

- Open an issue for questions about the codebase
- Use discussions for general questions about dotfiles setups
- Check existing issues before creating new ones

## Recognition

Contributors will be recognized in the repository. Thank you for helping improve this project!

---

By contributing, you agree that your contributions will be licensed under the same license as this project (MIT License).