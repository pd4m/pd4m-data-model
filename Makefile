DOCS_DIR := docs
HTML_DIR := html
JSON_DIR := json
PY_DIR := python
SCHEMA := schema/nuclei.yaml
SITE_FILE := Dockerfile.site
SITE_DIR ?= site

docs: clean-docs
	mkdir -p $(DOCS_DIR)
	gen-doc \
		--hierarchical-class-view \
		--include-top-level-diagram \
		--diagram-type mermaid_class_diagram \
		-d $(DOCS_DIR) $(SCHEMA)

clean-docs:
	rm -rf $(DOCS_DIR)

html: docs clean-html
	mkdir -p ${HTML_DIR}
	python3 -m mkdocs build -d ${HTML_DIR}

clean-html:
	rm -rf $(HTML_DIR)

docker-build-site: clean-site
	mkdir -p ${SITE_DIR}
	docker buildx build -f ${SITE_FILE} --output type=local,dest=${SITE_DIR} .

clean-site:
	rm -rf ${SITE_DIR}

json: clean-json
	mkdir -p ${JSON_DIR}
	gen-json-schema $(SCHEMA) > ${JSON_DIR}/schema.json

clean-json:
	rm -rf $(JSON_DIR)

python: clean-python
	mkdir -p ${PY_DIR}
	gen-pydantic $(SCHEMA) > ${PY_DIR}/nuclear_data_classes.py

clean-python:
	rm -rf $(PY_DIR)

docker-build:
	docker build -t nuclei-docs .

docker-run:
	docker run -p 8080:80 nuclei-docs
