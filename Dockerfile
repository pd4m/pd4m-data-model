FROM linkml/linkml AS builder

ENV PATH="/root/.local/bin:$PATH"

WORKDIR /app

COPY schema/ schema/
COPY md-templates/ md-templates/
COPY mkdocs.yml .

RUN pip install --no-cache-dir mkdocs linkml[mkdocs] mkdocs-material pymdown-extensions mkdocs-mermaid2-plugin
RUN gen-doc \
    --template-directory md-templates \
    --hierarchical-class-view \
    --include-top-level-diagram \
    --diagram-type mermaid_class_diagram \
    -d docs \
    schema/nuclei.yaml
RUN python3 -m mkdocs build

FROM nginx:alpine AS runtime
COPY --from=builder /app/site/ /usr/share/nginx/html/
