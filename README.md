# Local WordPress Environment

README is in progress...

## Quick Start

Follow these four simple steps to get started:

1. **Install Docker and Docker Compose:**

   [Follow the instructions](https://github.com/kostiantyn-petlia/ubuntu-dev-env-setup?tab=readme-ov-file#docker) to install `docker` & `docker compose`.

2. **Download Project Files:**

   Download the required files to your project directory.

3. **Setup Environment Variables:**

   Copy `.env.sample` to `.env`  and update the file with actual values.

4. **Start the Docker Environment:**

   Navigate to the `local-env` directory and run the following command in your terminal:

```
docker compose up -d
docker compose down  # Use it to stop
```

### Access Services

- WordPress site: http://localhost:8000/
- phpMyAdmin: http://localhost:8001/ 

## To be continued...

