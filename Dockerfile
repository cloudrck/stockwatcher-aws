FROM ruby:2.7

WORKDIR /home/app

ENV PORT 3000

EXPOSE $PORT

# TODO Move to Gemfile
RUN gem install oj oauth oauth2 aws-sdk

RUN apt update && apt install -y awscli 

ENTRYPOINT [ "/bin/bash", "-l", "-c" ]