# DOCKER_BUILDKIT=1 docker build --pull --no-cache -t linter - < lint.Dockerfile
# docker run --rm -v $(pwd):/bitcoin -w /bitcoin -it linter
# ./ci/lint/06_script.sh
FROM ubuntu:jammy as builder

ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C.UTF-8

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install --no-install-recommends -y \
	ca-certificates \
	curl \
	gawk \
	git \
	jq

RUN apt install -y build-essential gdb lcov pkg-config \
      libbz2-dev libffi-dev libgdbm-dev libgdbm-compat-dev liblzma-dev \
      libncurses5-dev libreadline6-dev libsqlite3-dev libssl-dev \
      lzma lzma-dev tk-dev uuid-dev zlib1g-dev

RUN curl https://pyenv.run | bash && \
	export PATH="$HOME/.pyenv/bin:$PATH" && \
	eval "$(pyenv init -)" && \
	pyenv install 3.6.15 && pyenv global 3.6.15 && \
	pip3 install -U packaging pip setuptools && pip3 install \
				 codespell==2.2.1 \
				 flake8==4.0.1 \
				 mypy==0.942 \
				 pyzmq==22.3.0 \
				 vulture==2.3

RUN curl -sL "https://github.com/koalaman/shellcheck/releases/download/v0.8.0/shellcheck-v0.8.0.linux.x86_64.tar.xz" | tar --xz -xf - --directory /tmp/ && \
	mv /tmp/shellcheck-v0.8.0/shellcheck /usr/bin/

RUN echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.bashrc && \
	echo 'eval "$(pyenv init -)"' >> ~/.bashrc

CMD ["bash", "-l"]
