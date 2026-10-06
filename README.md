# streamlit
Dockerize streamlit with uv.

## Local development
```bash
uv sync
uv run streamlit run src/streamlit_app/app.py
```

## Build & run
```bash
docker compose up -d
docker compose down -d
```

## Source
Based on [Streamlining Your Streamlit App Deployment with Docker Yasha kavaya](https://medium.com/@yash.kavaiya3/streamlining-your-streamlit-app-deployment-with-docker-0f6aff7bce48?source=user_profile_page---------5-------------a4128315a540---------------)
