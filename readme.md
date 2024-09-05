# cln-sphinx

Core Lightning + VLS MQTT broker + HTLC interceptor

# build

docker build --no-cache -t cln-sphinx .

docker tag cln-sphinx sphinxlightning/cln-sphinx:0.3.5

docker push sphinxlightning/cln-sphinx:0.3.5

docker tag cln-sphinx sphinxlightning/cln-sphinx:latest

docker push sphinxlightning/cln-sphinx:latest

# update sphinxlightning/cln:latest

### stakwork/lightning repo

sync branch to CLN master

find the commit of the latest CLN release

5ec5580a587faf7b19f2d0b9dc445f6a42db2602

git checkout 5ec5580a587faf7b19f2d0b9dc445f6a42db2602 -b v24.08

apply these changes to the dockerfile: https://github.com/stakwork/lightning/commit/e7fd37bff2294619da2e1345846a66f67a1da6cf

docker build --no-cache -t cln-sphinx .
docker tag cln-sphinx sphinxlightning/cln:latest
docker push sphinxlightning/cln:latest
