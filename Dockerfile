# FROM ubuntu:latest
FROM ubuntu:20.04
ENV TESSDATA_PREFIX=/usr/share/tesseract-ocr/4.00/tessdata

# Required in 20.04 because of tzdata asking for the Geographic area
# when installing modules.
ARG DEBIAN_FRONTEND=noninteractive

RUN set -e \
  && apt-get update \
  && apt-get install -yqq \
    # Audiveris dependencies
    git \
    openjdk-8-jdk \
    tesseract-ocr-eng \
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
  # && git clone -b tess4 https://github.com/Audiveris/audiveris.git /opt/audiveris
  && git clone https://github.com/Audiveris/audiveris.git /opt/audiveris

COPY ./main.py /opt/audiveris_controller.py

# Install gradle -> website recommended method
RUN ["/bin/bash", "-c", "source /root/.sdkman/bin/sdkman-init.sh && cd /opt/audiveris && sdk install gradle"]
# Install audiveris -> website recommended method
RUN ["/bin/bash", "-c", "cd /opt/audiveris && /root/.sdkman/candidates/gradle/current/bin/gradle build"]

RUN set -e \
  && unzip /opt/audiveris/build/distributions/Audiveris.zip

# In case you need a shell in the container, start in the Audiveris bin directory.
WORKDIR /Audiveris/bin
