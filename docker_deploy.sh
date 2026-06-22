#!/bin/bash

USERNAME=$(zenity --entry \
--title="Docker Login" \
--text="Enter Docker Username")

PASSWORD=$(zenity --password \
--title="Docker Password")

echo "$PASSWORD" | docker login -u "$USERNAME" --password-stdin

if [ $? -ne 0 ]; then
    zenity --error --text="Docker Login Failed"
    exit
fi

DOCKERFILE=$(zenity --file-selection \
--title="Select Dockerfile")

if [ -z "$DOCKERFILE" ]; then
    exit
fi

IMAGE=$(zenity --entry \
--title="Docker Image" \
--text="Enter Image Name")

TAG=$(zenity --entry \
--title="Image Tag" \
--text="Enter Tag" \
--entry-text="latest")

DIRECTORY=$(dirname "$DOCKERFILE")

cd "$DIRECTORY"

docker build -t $USERNAME/$IMAGE:$TAG .

if [ $? -ne 0 ]; then
    zenity --error --text="Build Failed"
    exit
fi

docker push $USERNAME/$IMAGE:$TAG

if [ $? -eq 0 ]; then
    zenity --info --text="Image Successfully Pushed"
else
    zenity --error --text="Push Failed"
fi
