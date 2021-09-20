# Stock Watcher (WIP)
This project is designed to pull Stock data from Ally Investment with the intention of integrating it with TradingView.com. It includes the local development toolset.

## AWS
It makes use of several AWS tools and services
* Lambda
* DynamoDB
* CloudWatch

This runs [DynamoDB locally][dyno-local] using Docker.

[dyno-local]: https://hub.docker.com/r/amazon/dynamodb-local