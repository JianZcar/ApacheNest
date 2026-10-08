# ApacheNest

ApacheNest is a shell-based utility for setting up and managing a lightweight
Apache + PHP environment using Nix Portable. It installs and controls Apache,
PHP-FPM, MySQL and MailHog, making local development and testing quick and
simple.

### Dev note
ApacheNest is still in its early phase but is now usable.

## Features

- One-command setup of Apache, PHP-FPM, MySQL and MailHog via Nix Portable.
- Manage multiple PHP versions.
- Customizable Apache, PHP and MySQL configurations.
- Interactive menus for starting, stopping, restarting and inspecting services.
- Test email capture out of the box via MailHog.
- Self-contained installation in the user's home directory.

## Installation

### Homebrew

```sh
brew install JianZcar/packages/apachenest
```

### Git Clone

To install ApacheNest, clone this repository and execute the `bin/apachenest` script:

```bash
git clone https://github.com/JianZcar/ApacheNest.git
cd ApacheNest
./bin/apachenest
```

The first run downloads Nix Portable and the service packages, which can take a
few minutes. Everything else is installed under `~/Documents/.apachenest`.

## Usage

Once installed, ApacheNest provides an interactive menu to manage services:

```bash
./bin/apachenest
```

### Main Menu

- **All**: Manage every service together.
- **Apache**: Start, stop, restart and inspect logs.
- **PHP**: Start, stop, restart, switch versions, inspect info, extensions and logs.
- **MySQL**: Start, stop, restart, change/reset the password, reset data.
- **Mail**: Start, stop, restart, open the MailHog UI, send a test email.
- **Settings**: Reset ApacheNest back to a fresh initial setup.
- **About**: Show install paths, endpoints and the active PHP version.
- **Exit**: Quit.

### Service Management

- **Start All**: Starts whichever services are not already running.
- **Stop All**: Stops all four services.
- **Restart All**: Restarts all four services.

Status is read from each daemon's own pid file rather than by scanning the
process table, so it stays accurate even while the menu is running.

### Ports

| Service | Address |
| --- | --- |
| Apache | <http://localhost:8080> |
| PHP-FPM | `127.0.0.1:9000` (internal, not for direct requests) |
| MySQL | `127.0.0.1:3306`, socket in `mysql/mysql.sock` |
| MailHog SMTP | `localhost:1025` |
| MailHog web UI | <http://localhost:8025> |

Apache serves your project from `~/Documents/.apachenest/www`, with
`index.php` as the default index.

### PHP Version Management

Switch versions under **PHP > Change Version**. Only versions available in the
bundled Nix Portable channel are listed (currently `php80` through `php83`) —
each one is a large first-time build. PHP-FPM is restarted automatically if it
was running.

PHP-FPM is started with `-c` pointing at ApacheNest's config directory, so
edits to `php.ini` take effect on restart.

## Configuration

ApacheNest stores its configuration files in:

```plaintext
$HOME/Documents/.apachenest/conf
```

- `httpd.conf`: Apache configuration.
- `php-fpm.conf`: PHP-FPM configuration.
- `php.ini`: PHP settings, loaded by PHP-FPM. Edit under **PHP > Configuration**,
  then restart PHP-FPM.
- `php-version.conf`: Selected PHP version.
- `../mysql/my.cnf`: MySQL configuration, rewritten on every start.

Use **Settings > Reset All** to delete the generated config files, local state
and logs, then rebuild the initial setup. Your selected PHP version is preserved.
Nix Portable itself is kept, so a reset does not re-download it.

### MySQL

The root password defaults to `root`, and is set automatically on first
initialisation. Change it under **MySQL > Change Password**, or recover it with
**MySQL > Reset Password**.

Note that the `mysql` package from Nixpkgs is MariaDB. Its installer gives
`root@localhost` socket-based authentication, which cannot work unless your OS
user is also named `root`; ApacheNest converts the account to password
authentication during first initialisation so the default password applies.

### Mail

PHP's `mail()` is pointed at MailHog via a `sendmail_path` wrapper, so mail sent
from your code is captured in the web UI instead of being delivered. Configure it
under **Mail > Configure PHP**, then restart PHP-FPM.

## Command Line

Report status without opening the menus:

```bash
apachenest --status all        # apache | php | mysql | mail
```

## Logs

| Log | Path (under `~/Documents/.apachenest/`) |
| --- | --- |
| Apache error / access | `apache/logs/error_log`, `apache/logs/access_log` |
| PHP-FPM | `php-fpm.log` |
| PHP-FPM startup errors | `php-fpm-stderr.log` |
| PHP script errors | `php-error.log` |
| MySQL | `mysql/mysql.log` |
| MailHog | `mailhog/mailhog.log` |
| Package installs | `nix.log` |
| `mysql` client output | `mysql-cli.log` |

The menu's preview pane shows the last 20 lines of the relevant log.

## Requirements

Required:

- `bash`
- `curl`
- `jq`
- `fzf` (for interactive menus)

Optional, used when present:

- `ss` (falls back to a `/dev/tcp` probe) — used to report which process holds a port
- `nc` — fallback path for sending a test email
- `nano` / `vim` / `less` — editing and viewing config and logs; `$EDITOR` is honoured
- `xdg-open` or `open` — opening the MailHog UI and `phpinfo()`

## Troubleshooting

**Database locks.** If a Nix operation was interrupted, a stale lock can block
the next one. ApacheNest detects and removes it automatically at startup and
when entering a menu; otherwise select **Refresh**.

**"Address already in use" on port 9000.** A PHP-FPM worker from a previous run
still owns the socket. ApacheNest reclaims it automatically on the next start. If
the port is held by a process that is not PHP-FPM, it is reported rather than
killed.

**A PHP version will not start.** Only versions present in the bundled channel
can be built; the menu only lists those. `php-fpm-stderr.log` and `nix.log`
hold the details.

**Connection refused in the browser.** Check you are using port 8080, not 8000.

## Uninstallation

Stop the services first (**All > Stop**, or select **Exit** from the main menu),
then delete the installation directory:

```bash
rm -rf $HOME/Documents/.apachenest
```

## Contributing

Contributions are welcome! Please open an issue or submit a pull request to suggest improvements or report bugs.

## License

This project is licensed under the [License here](LICENSE).

---

🎉 Happy coding with ApacheNest!