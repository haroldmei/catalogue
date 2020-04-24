NAME = haroldmei/catalogue
DBNAME = haroldmei/catalogue-db

TAG=$(TRAVIS_COMMIT)

INSTANCE = catalogue

GROUP=k8smaster:5000/haroldmei
TRAVIS_TAG=latest

TRAVIS_COMMIT=$(TRAVIS_TAG)
COMMIT=$(TRAVIS_TAG)
.EXPORT_ALL_VARIABLES:

build:
	./scripts/build.sh
	./scripts/push.sh
    
.PHONY: default copy test

default: test

release:
	docker build -t $(NAME) -f ./docker/catalogue/Dockerfile .

test: 
	GROUP=haroldmei COMMIT=test ./scripts/build.sh
	./test/test.sh unit.py
	./test/test.sh container.py --tag $(TAG)

dockertravisbuild: build
	docker build -t $(NAME):$(TAG) -f docker/catalogue/Dockerfile-release docker/catalogue/
	docker build -t $(DBNAME):$(TAG) -f docker/catalogue-db/Dockerfile docker/catalogue-db/
	docker login -u $(DOCKER_USER) -p $(DOCKER_PASS)
	scripts/push.sh
