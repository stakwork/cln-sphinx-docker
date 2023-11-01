# cln-sphinx

Core Lightning + VLS MQTT broker + HTLC interceptor

# build

docker build --no-cache -t cln-sphinx .

docker tag cln-sphinx sphinxlightning/cln-sphinx:0.3.2
docker push sphinxlightning/cln-sphinx:0.3.2
docker tag cln-sphinx sphinxlightning/cln-sphinx:latest
docker push sphinxlightning/cln-sphinx:latest
