HTML_DIR := html
JSON_DIR := json
PY_DIR := python
SCHEMA := schema/nuclei.yaml

.PHONY: html docs

html: clean-html
	mkdir -p $(HTML_DIR)
	gen-doc --format html --output $(HTML_DIR) $(SCHEMA)

json: clean-json
	mkdir -p ${JSON_DIR}
	gen-json-schema --output ${JSON_DIR} $(SCHEMA)

python: clean-python
	mkdir -p ${PY_DIR}
	gen-py-classes --output ${PY_DIR} $(SCHEMA)

clean-html:
	rm -rf $(HTML_DIR)

clean-json:
	rm -rf $(JSON_DIR)

clean-python:
	rm -rf $(PY_DIR)
