FROM ubuntu:latest
ENV TESSDATA_PREFIX=/opt/tessdata

RUN set -e \
  && apt-get update \
  && apt-get install -yqq \
    # Audiveris dependencies
    git \
    openjdk-8-jdk \
    tesseract-ocr-eng \
    # not part of the audiveris documentation
    libtesseract-dev \
    # SDKMAN dependencies
    curl \
    zip

RUN set -e \
  # Install sdkman -> website recommended method
  && curl -o "/opt/sdkman-install.sh" "https://get.sdkman.io" \
  && chmod +x /opt/sdkman-install.sh \
  && /opt/sdkman-install.sh \
  && chmod +x /root/.sdkman/bin/sdkman-init.sh \
  # Grab audiveris
  && git clone https://github.com/Audiveris/audiveris.git /opt/audiveris

COPY ./tessdata /opt/tessdata

# Install gradle -> website recommended method
RUN ["/bin/bash", "-c", "source /root/.sdkman/bin/sdkman-init.sh && cd /opt/audiveris && sdk install gradle"]
# Install audiveris -> website recommended method
RUN ["/bin/bash", "-c", "cd /opt/audiveris && /root/.sdkman/candidates/gradle/current/bin/gradle build"]

RUN set -e \
  && unzip /opt/audiveris/build/distributions/Audiveris.zip

# In case you need a shell in the container, start in the Audiveris bin directory.
WORKDIR /Audiveris/bin
