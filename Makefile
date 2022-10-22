NAME=autocakechat
SERVER_ID=user#########

docker_setup:
	docker pull lukalabs/cakechat:latest
	@echo $(SERVER_ID) > server_id
	
docker_stop:
	@echo "Stoping the service..."
	docker stop $$(docker ps -alq)
	@echo "Service stopped"
	
docker_remove: docker_stop
	@echo "Removing the image..."
	docker container prune
	#docker rmi -f lukalabs/cakechat
	@echo "Image removed"

docker_train_from_scratch: docker_setup
	docker run -v $(PWD):/$(NAME) --name $(NAME) -it lukalabs/cakechat:latest bash -c /$(NAME)/scripts/train_from_scratch.sh
