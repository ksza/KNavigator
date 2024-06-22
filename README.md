# KNavigator

## About

Written as my Highschool Thesis project in 2003, KNavigator is a replica written in TurboPascal 7 of the popular DosNavigator project.

Through this project I've managed two achieve two major things:

- create a working project implementing most of DosNavigator's functionality
- write a modula program in Turbo Pascal using the Object Oriented Programming features provided by the language since version 5.5

Although it cannot be called usefull anymore, I hope it will at least bring back some memories about the good old times... at least for some of you :)

## Development

I have created a development environment on top of a Docker image that provides a DOSBox environment and a VNC console - [jgoerzen/dosbox](https://hub.docker.com/r/jgoerzen/dosbox). The custom image has

- A copy of Borland Turbo Pascal 7
- An updated path so that TP7 can easily be started

### Prerequisites

1. [Docker](https://www.docker.com)
2. A VNC viwer - i.e. [Real VNC](https://www.realvnc.com)

### Set-up

To start the development environment, you can run `make up`. This command will

- Build a new docker image
- Start the container mounting the project folder (`knavigator`) as a volume
- Expose the VNC session on port `5901`

Connect to VNC server

- Host `localhost:5901`
- Password `knavi`

To stop the development environment, run `make down`.

### FAQ

If you encounter any issues running the development enviornment, you might be running into one of the following issues

- Mounting the local folder as a volume is denied. You might need to [update the docker file sharing settings](https://stackoverflow.com/a/45123074/1109579).
- You forgot to stop the container running from a previous session.
- There's already a docker image with the name `knavi_img`. You need to remove this image first.

---

Don't hesitate con contact me about the project or just for a friendly chat on szanto.karoly@gmail.com
