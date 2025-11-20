FROM linkml/linkml AS builder

ENV PATH="/root/.local/bin:$PATH"

WORKDIR /app

# Copy only what we need to build docs
COPY schema/ schema/
COPY md-templates/ md-templates/
COPY mkdocs.yml .

# Build docs into /app/docs
RUN pip install --no-cache-dir mkdocs linkml[mkdocs] mkdocs-material pymdown-extensions
RUN gen-doc \
    --template-directory md-templates \
    -d docs \
    schema/nuclei.yaml
RUN python3 -m mkdocs build

# Stage 2: minimal static web server
FROM nginx:alpine AS runtime

# Copy generated HTML into nginx web root
COPY --from=builder /app/site/ /usr/share/nginx/html/

# nginx will serve /usr/share/nginx/html by default

