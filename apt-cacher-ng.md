# Apt-Cacher NG

[Apt-Cacher NG](https://www.unix-ag.uni-kl.de/~bloch/acng/) is a caching proxy
for linux distributions. It's handy to have installed when doing gitian builds
to cache packages. On macOS we'll install it inside a [Docker container](https://github.com/sameersbn/docker-apt-cacher-ng).

```bash
docker pull sameersbn/apt-cacher-ng:3.1-3

# run, pick a volume where you'd like the cache to persist
# using /tmp/ here as an example
docker run --name apt-cacher-ng --init -d --restart=always \
  --publish 3142:3142 \
  --volume /tmp/apt-cacher-ng:/var/cache/apt-cacher-ng \
  sameersbn/apt-cacher-ng:3.1-3

# tail the apt-cacher logs
docker exec -it apt-cacher-ng tail -f /var/log/apt-cacher-ng/apt-cacher.log
.....
1581754659|I|242396|172.17.0.1|uburep/dists/bionic/InRelease
1581754659|O|242343|172.17.0.1|uburep/dists/bionic/InRelease
1581754659|I|89089|172.17.0.1|security.ubuntu.com/ubuntu/dists/bionic-security/InRelease
1581754659|O|89028|172.17.0.1|security.ubuntu.com/ubuntu/dists/bionic-security/InRelease
1581754660|I|89070|172.17.0.1|uburep/dists/bionic-updates/InRelease
1581754660|O|89024|172.17.0.1|uburep/dists/bionic-updates/InRelease
```

If it's working you should see `Using cache` in the gitian build output:
```bash
Step 3/8 : RUN echo 'Acquire::http { Proxy "http://172.17.0.1:3142"; };' > /etc/apt/apt.conf.d/50cacher
 ---> Using cache
 ---> cb369fae21aa
 ```