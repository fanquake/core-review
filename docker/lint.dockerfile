# DOCKER_BUILDKIT=1 docker build --pull --no-cache -t linter - < lint.dockerfile
#	Use --build-arg PYTHON=3.11.0 etc to change installed versions
# docker run --rm -v $(pwd):/bitcoin -w /bitcoin -it linter
# lint
FROM ubuntu:jammy as builder

ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C.UTF-8

ARG CODESPELL=2.2.1
ARG FLAKE=4.0.1
ARG MYPY=0.942
ARG PYTHON=3.6.15
ARG PYZMQ=22.3.0
ARG SHELLCHECK=v0.8.0
ARG VULTURE=2.3

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install --no-install-recommends -y \
	ca-certificates \
	curl \
	gawk \
	git \
	jq

RUN apt install --no-install-recommends -y build-essential gdb lcov pkg-config \
      libbz2-dev libffi-dev libgdbm-dev libgdbm-compat-dev liblzma-dev \
      libncurses5-dev libreadline6-dev libsqlite3-dev libssl-dev \
      lzma lzma-dev tk-dev uuid-dev zlib1g-dev

RUN curl https://pyenv.run | bash && \
	export PATH="$HOME/.pyenv/bin:$PATH" && \
	eval "$(pyenv init -)" && \
	pyenv install ${PYTHON} && pyenv global ${PYTHON} && \
	pip3 install -U packaging pip setuptools && pip3 install \
				 codespell==${CODESPELL} \
				 flake8==${FLAKE} \
				 mypy==${MYPY} \
				 pyzmq==${PYZMQ} \
				 vulture==${VULTURE}

RUN curl -sL "https://github.com/koalaman/shellcheck/releases/download/${SHELLCHECK}/shellcheck-${SHELLCHECK}.linux.x86_64.tar.xz" | tar -Jx -C/usr/bin/ --strip-components=1 -f - shellcheck-${SHELLCHECK}/shellcheck

RUN echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.bashrc && \
	echo 'eval "$(pyenv init -)"' >> ~/.bashrc && \
	echo 'alias lint="./ci/lint/06_script.sh"' >> ~/.bashrc

CMD ["bash", "-l"]
