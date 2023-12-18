cd ..
source .env
pipenv requirements > requirements.txt
cd .build
mkdir lambda_layer
cd lambda_layer
mkdir python

# https://github.com/pyca/cryptography/issues/6390
# https://github.com/pyca/cryptography/issues/6391
pip install --target=python/. --platform manylinux2014_x86_64 --python 3.11 --only-binary=:all: --upgrade -r ../../requirements.txt
