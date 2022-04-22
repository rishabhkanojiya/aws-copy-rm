FROM python:3.8-alpine

LABEL "com.github.actions.name"="S3 Copy and Remove"
LABEL "com.github.actions.description"="Backing up (Copy) and removing files in AWS S3 repository"
LABEL "com.github.actions.icon"="copy"
LABEL "com.github.actions.color"="green"

LABEL version="0.5.1"
LABEL repository="https://github.com/rishabhkanojiya/aws-copy-rm"
LABEL homepage=""
LABEL maintainer="Rishabh Kanojiya <rishabhkanojiya75@gmail.com>"

# https://github.com/aws/aws-cli/blob/master/CHANGELOG.rst
ENV AWSCLI_VERSION='1.18.14'

RUN pip install --quiet --no-cache-dir awscli==${AWSCLI_VERSION}

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

