GROUP=eavatar
NAME=postgresql
VERSION=9.4


all: build tag

build: Dockerfile overlayfs.tar
	docker build  -t $(GROUP)/$(NAME):$(VERSION) .

overlayfs.tar: overlayfs/Dockerfile
	cd overlayfs && docker build  -t $(NAME)-builder .
	docker run  --rm $(NAME)-builder cat /overlayfs.tar > overlayfs.tar
	docker rmi $(NAME)-builder

tag:
	@if ! docker images $(GROUP)/$(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker tag $(GROUP)/$(NAME):$(VERSION) $(GROUP)/$(NAME):latest

clean:
	rm -f overlayfs.tar
