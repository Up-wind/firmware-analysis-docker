docker build -t upw1nd/firmware-analysis-docker-v2 \
    --network host \
    --build-arg HTTP_PROXY=http://127.0.0.1:7890 \
	--build-arg HTTPS_PROXY=http://127.0.0.1:7890 \
    ./