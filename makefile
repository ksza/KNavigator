
build: ## Build the container
	  docker build . -t knavi_img

up: ## Up all or c=<name> containers in foreground
	make build
	docker run -d \
		-e VNCPASSWORD=knavi \
		-p 5901:5901 \
		-v ./knavigator:/dos/drive_c/knavi \
		--name knavi_container knavi_img &

down: ## Up all or c=<name> containers in foreground
	docker kill knavi_container
	docker rm knavi_container


## Dongrade to docker desckto 4.24 or upgrade mac!