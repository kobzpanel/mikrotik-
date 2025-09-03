# Deploying Mikhmon v3 to Coolify

This guide explains how to deploy the Mikhmon v3 application to
[Coolify](https://coolify.io), a self‑hosted platform as a service.

## What’s included

- **Dockerfile** – builds a container based on `php:7.4‑apache`.
  The container bundles Apache and PHP together, so no separate web
  server is required. It copies the application into the default
  document root (`/var/www/html`) and exposes port `80`.

- **.dockerignore** – prevents unnecessary files from being included in
  the image build context.

## Steps to deploy

1. **Create a Git repository**

   Push the contents of the `mikhmonv3-coolify` folder to a Git
   repository. Include the `Dockerfile` and `.dockerignore` at the
   repository root.

2. **Connect your repository to Coolify**

   In the Coolify dashboard:

   - Create a new *Application*.
   - Under *Repository*, connect to the Git provider (GitHub, GitLab,
     etc.) that hosts your repository and select the repository.
   - For the *Build Pack*, choose **Dockerfile**. Coolify will use the
     `Dockerfile` in the root of your repository to build the image.
   - Leave the *Build Command* and *Start Command* empty; Coolify will
     infer them from the Dockerfile.

3. **Expose the correct port**

   Set the exposed port to **80**. This tells Coolify that your
   container listens on port `80` internally. If you prefer a
   different port on the host, you can specify a mapping (e.g.
   `8080:80`) in the Coolify UI.

4. **Deploy**

   Save the settings and click **Deploy**. Coolify will build the
   Docker image, start the container, and route traffic to it.

5. **Access the application**

   Once deployed, you can access Mikhmon through the URL provided by
   Coolify. If you assign a custom domain to your application, be sure
   to update your DNS records accordingly.

## Notes

- Mikhmon v3 communicates with a MikroTik router via the RouterOS API.
  The PHP library is included in the `lib/routeros_api.class.php` file.
  To connect to your router, configure the IP address and credentials
  through the Mikhmon UI after deployment.

- The provided `Dockerfile` installs MySQL extensions (`pdo_mysql` and
  `mysqli`) in case you want to extend the application or integrate it
  with a database. These extensions are optional; the core Mikhmon
  features do not require a database.

- If you require a different PHP version, modify the `FROM` line in
  `Dockerfile` (e.g. `php:8.1-apache`). Make sure your application is
  compatible with the chosen PHP version.

- The existing `docker-compose.yml` from the original repository
  orchestrates separate containers for PHP, Nginx, and a RouterOS
  emulator. It is still useful for local development and testing. On
  Coolify, using a single container with Apache and PHP simplifies
  deployment.