# This Makefile contains a number of helpful commands for working with this
# demo project.

all:
	echo "Please specify a valid subcommand"
	exit 1

dev-build:
	docker build -f Dockerfile.base -t demo/dev .
	
# Run `make dev-start` to get a development environment working that will
# allow you to develop efficiently. It 
dev-start: dev-build
	docker run --rm -d -v `pwd`/web:/web -v /var/run/docker.sock:/var/run/docker.sock -v /tmp:/data -p 5000:5000 --name demo-dev -e FLASK_APP=/web/demo.py -e FLASK_DEBUG=1 demo/dev flask run --host=0.0.0.0
	echo "Dev server is now running. Head to port 5000 to view it. It supports hot-code reloading, so you can edit the files directly in the web directory, and it should work up automagically!"
	sleep 2
	docker logs demo-dev

# Shuts down the dev container.
dev-stop:
	docker kill demo-dev

# Builds the production docker 
prod-build: dev-build
	docker build -f Dockerfile.prod -t demo/prod .

# TODO: Add a run command that runs in prod mode.

clean:
	rm -f *~ web/*~ web/templates/*~
	docker rm -f demo-dev || echo "No running container to clean!"
	docker rmi -f demo/dev demo/prod || echo "No images to clean!"

# WARNING: cleans out all untagged images!!
clean-images:
	docker rmi $(docker images | grep "^<none>" | awk "{print $3}")

.PHONY: all dev-build dev-start dev-stop prod-build clean clean-images
