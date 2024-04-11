# cln-sphinx

Core Lightning + VLS MQTT broker + HTLC interceptor

# build

docker build --no-cache -t cln-sphinx .

docker tag cln-sphinx sphinxlightning/cln-sphinx:0.3.3

docker push sphinxlightning/cln-sphinx:0.3.3

docker tag cln-sphinx sphinxlightning/cln-sphinx:latest

docker push sphinxlightning/cln-sphinx:latest

### alt

docker tag cln-sphinx sphinxlightning/cln-sphinx:v24.02-amd64

docker push sphinxlightning/cln-sphinx:v24.02-amd64
