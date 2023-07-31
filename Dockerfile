FROM debian:latest
WORKDIR /app
COPY . .
RUN ln -sf /bin/bash /bin/sh
RUN apt-get update && apt-get upgrade && \
	apt-get install -y curl unzip zip git python3 && \
	curl -s https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash && \
	source ~/.bashrc && \
	nvm install 18 && \
	nvm alias default 18 && \
	npm install -g yarn && \
	curl -s https://get.sdkman.io | bash && \
	source "$HOME/.sdkman/bin/sdkman-init.sh" && \
	sdk install java 11.0.20-tem && \
	sdk install sbt 1.5.5

WORKDIR core
RUN source ~/.bashrc && scripts/build.sh

CMD [ "scripts/deploy-docker.sh" ]

EXPOSE 8080
