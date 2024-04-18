# cln-sphinx

Core Lightning + VLS MQTT broker + HTLC interceptor

# build

docker build --no-cache -t cln-sphinx .

docker tag cln-sphinx sphinxlightning/cln-sphinx:0.3.4

docker push sphinxlightning/cln-sphinx:0.3.4

docker tag cln-sphinx sphinxlightning/cln-sphinx:latest

docker push sphinxlightning/cln-sphinx:latest

# fix-gossip

docker build --no-cache -t cln-sphinx .

docker tag cln-sphinx sphinxlightning/cln-sphinx:v24-fix-gossip-2

docker push sphinxlightning/cln-sphinx:v24-fix-gossip-2

4cfbd6a
