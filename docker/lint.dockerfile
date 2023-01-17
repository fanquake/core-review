# DOCKER_BUILDKIT=1 docker build --pull --no-cache -t linter - < lint.dockerfile
#	Use --build-arg PYTHON=3.11.0 etc to change installed versions
# docker run --rm -v $(pwd):/bitcoin -w /bitcoin -it linter
FROM ubuntu:jammy

ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C.UTF-8

ARG CODESPELL=2.2.1
ARG FLAKE=5.0.4
ARG MYPY=0.971
ARG PYTHON=3.6.15
ARG PYZMQ=24.0.1
ARG SHELLCHECK=v0.8.0
ARG VULTURE=2.6

COPY ./docker/lint-entrypoint.sh /entrypoint.sh

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install --no-install-recommends -y \
	ca-certificates \
	curl \
	gawk \
	git \
	jq && \
  apt install --no-install-recommends -y g++ pkg-config \
      libbz2-dev libffi-dev libgdbm-dev libgdbm-compat-dev liblzma-dev \
      libsqlite3-dev libssl-dev lzma lzma-dev make patch uuid-dev xz-utils zlib1g-dev && \
  curl https://pyenv.run | bash && \
	export PATH="$HOME/.pyenv/bin:$PATH" && \
	eval "$(pyenv init -)" && \
	pyenv install ${PYTHON} && pyenv global ${PYTHON} && \
	pip3 install -U packaging pip setuptools && pip3 install \
				 codespell==${CODESPELL} \
				 flake8==${FLAKE} \
				 mypy==${MYPY} \
				 pyzmq==${PYZMQ} \
				 vulture==${VULTURE} && \
  curl -sL "https://github.com/koalaman/shellcheck/releases/download/${SHELLCHECK}/shellcheck-${SHELLCHECK}.linux.x86_64.tar.xz" | \
  tar -Jx -C/usr/bin/ --strip-components=1 -f - shellcheck-${SHELLCHECK}/shellcheck && \
  echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.bashrc && \
  echo 'eval "$(pyenv init -)"' >> ~/.bashrc && \
  echo 'alias lint="./ci/lint/06_script.sh"' >> ~/.bashrc && \
  chmod 755 /entrypoint.sh && \
  rm -rf /var/lib/apt/lists/*


ENTRYPOINT ["/entrypoint.sh"]
