
IMAGE_NAME = influxdb-centos7

.PHONY: build
build:
	docker build -t $(IMAGE_NAME) .

