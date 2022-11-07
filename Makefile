NAME=autocakechat
TELEGRAM_SERVER_ID=""
TELEGRAM_BOT_TOKEN=""

generate_corpus:
	@[ -d "tg_data" ] || { echo "Could not find corpus directory"; exit 1; }

	export AC_TSERVERID=$(TELEGRAM_SERVER_ID) && \
		python3 scripts/make_telegram_dataset.py

docker_setup:
	docker pull lukalabs/cakechat:latest
	
docker_stop:
	@echo "Stoping the service..."
	docker stop $$(docker ps -alq)
	@echo "Service stopped"
	
docker_remove: docker_stop
	@echo "Removing the image..."
	docker container prune
	@echo "Image removed"

docker_train_from_scratch: docker_setup
	docker run -v $(PWD):/$(NAME) --name $(NAME) -it lukalabs/cakechat:latest \
		bash -c /$(NAME)/scripts/train_from_scratch.sh

docker_update_pretrained: docker_setup
	docker run -v $(PWD):/$(NAME) --name $(NAME) -it lukalabs/cakechat:latest \
		bash -c /$(NAME)/scripts/update_pretrained.sh

docker_deploy_model: docker_setup
	docker run -v $(PWD):/$(NAME) --name $(NAME) -it lukalabs/cakechat:latest \
		bash -c "/$(NAME)/scripts/deploy_model.sh $(TELEGRAM_BOT_TOKEN)"

