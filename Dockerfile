FROM alpine
RUN apk --no-cache add jq curl

COPY speedtest-cli.json /root/.config/ookla/
RUN curl -Lo speedtest.tar.gz "https://bintray.com/ookla/download/download_file?file_path=ookla-speedtest-1.0.0-arm-linux.tgz" && tar zxvf speedtest.tar.gz && mv speedtest /usr/local/bin

COPY test_speed.sh /

ENTRYPOINT ["/test_speed.sh"]
