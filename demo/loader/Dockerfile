FROM scratch

# curl
# https://github.com/tsenart/vegeta/releases/download/v6.1.1/vegeta-v6.1.1-linux-amd64.tar.gz
ADD vegeta  /vegeta
ADD targets.lst /targets.lst

ENTRYPOINT ["/vegeta"]

CMD ["--help"]
