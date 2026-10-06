# This sets up the container with Python 3.12 installed.
FROM python:3.12-slim

# Install uv (fast Python package manager)
COPY --from=ghcr.io/astral-sh/uv:0.11.3 /uv /uvx /bin/

# This sets the /app directory as the working directory for any RUN, CMD, ENTRYPOINT, or COPY instructions that follow.
WORKDIR /app

# Copy dependency files first for better layer caching.
COPY pyproject.toml uv.lock ./

# Install dependencies from the uv lockfile (without the project itself, for layer caching).
RUN uv sync --frozen --no-dev --no-install-project

# This copies everything in your current directory to the /app directory in the container.
COPY . /app

# Install the project package itself.
RUN uv sync --frozen --no-dev

# This tells Docker to listen on port 8501 at runtime (non-privileged).
EXPOSE 8501

# Add the uv virtualenv bin to PATH so the streamlit entrypoint resolves.
ENV PATH="/app/.venv/bin:$PATH"

# Create non-root user and switch to it.
RUN useradd --create-home --shell /bin/bash appuser && chown -R appuser:appuser /app
USER appuser

# This command creates a .streamlit directory in the home directory of the container.
RUN mkdir ~/.streamlit

# This copies your Streamlit configuration file into the .streamlit directory you just created.
RUN cp config.toml ~/.streamlit/config.toml

# This sets the default command for the container to run the app with Streamlit.
ENTRYPOINT ["streamlit", "run"]

# This command tells Streamlit to run your app.py script when the container starts.
CMD ["src/streamlit_app/app.py", "--server.port=8501", "--server.address=0.0.0.0"]
