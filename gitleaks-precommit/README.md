## Gitleaks Pre-Commit Hook Installation

This script automates the installation of Gitleaks and sets it up as a pre-commit hook in your Git repository. The pre-commit hook helps you prevent committing sensitive data by scanning your changes for potential leaks before they are committed. The script is intended to work on Linux, macOS, and Windows (via WSL) systems.

### Prerequisites
- Git: Ensure that Git is installed on your system and accessible from the command line.
- Make: Make is required to build Gitleaks from source. Make sure it is installed on your system.
- Go (Golang) is required to build the Gitleaks binary. Make sure Go is installed on your system. You can download and install Go from the official Go website (https://golang.org/dl/).


### Installation Instructions


The script will download Gitleaks from the GitHub repository and build it. It will then install Gitleaks and set it up as a pre-commit hook in your local Git repository.

```bash
sudo curl -fSL https://raw.githubusercontent.com/ibra86/kbot/main/gitleaks-precommit/install.sh | sh
```
### Verification
To verify the installation and configuration of Gitleaks:

1. Navigate to your Git repository's root directory.
2. Make changes to your code and stage them for committing.
3. Attempt to commit the changes.
4. Gitleaks will automatically scan your changes for potential leaks before allowing the commit to proceed.
5. If any leaks are detected, Gitleaks will block the commit and display information about the detected leaks.

### Uninstallation
To remove the Gitleaks Pre-Commit Hook from your Git repository:

1. Navigate to your repository's root directory.
2. Delete the pre-commit hook file:
   ```bash
   rm .git/hooks/pre-commit
   ```

3. Remove Gitleaks from your system (if desired).
