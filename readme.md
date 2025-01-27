# cln-sphinx

Core Lightning + VLS MQTT broker + HTLC interceptor

# build

docker build --no-cache -t cln-sphinx .

docker tag cln-sphinx sphinxlightning/cln-sphinx:0.3.6

docker push sphinxlightning/cln-sphinx:0.3.6

docker tag cln-sphinx sphinxlightning/cln-sphinx:latest

docker push sphinxlightning/cln-sphinx:latest

# update sphinxlightning/cln:latest

### stakwork/lightning repo

sync branch to CLN master

find the commit of the latest CLN release

fa103238479afe5e984674d15175a867572bb4dd

git checkout -b v24.11.1 fa103238479afe5e984674d15175a867572bb4dd

apply these changes to the dockerfile: https://github.com/stakwork/lightning/commit/e7fd37bff2294619da2e1345846a66f67a1da6cf

docker build --no-cache -t cln .
docker tag cln sphinxlightning/cln:v24.11.1
docker push sphinxlightning/cln:v24.11.1

docker build --no-cache -t cln .
docker tag cln sphinxlightning/cln:latest
docker push sphinxlightning/cln:latest
