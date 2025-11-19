DOCS_DIR := docs
HTML_DIR := html
JSON_DIR := json
PY_DIR := python
SCHEMA := schema/nuclei.yaml

.PHONY: html docs

html: clean-html docs
	mkdir -p $(HTML_DIR)
	mkdocs build

docs: clean-docs
	mkdir -p $(DOCS_DIR)
	gen-doc --hierarchical-class-view --include-top-level-diagram --diagram-type mermaid_class_diagram -d $(DOCS_DIR) $(SCHEMA)

json: clean-json
	mkdir -p ${JSON_DIR}
	gen-json-schema $(SCHEMA) > ${JSON_DIR}/schema.json

python: clean-python
	mkdir -p ${PY_DIR}
	gen-pydantic $(SCHEMA) > ${PY_DIR}/nuclear_data_classes.py

clean-docs:
	rm -rf $(DOCS_DIR)

clean-html:
	rm -rf $(HTML_DIR)

clean-json:
	rm -rf $(JSON_DIR)

clean-python:
	rm -rf $(PY_DIR)

docker-build:
	docker build -t nuclei-docs .

docker-run:
	docker run -p 8080:80 nuclei-docs
