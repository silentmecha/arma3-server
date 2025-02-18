[![Docker Pulls](https://img.shields.io/docker/pulls/silentmecha/arma-3-server.svg)](https://hub.docker.com/r/silentmecha/arma-3-server)
[![Image Size](https://img.shields.io/docker/image-size/silentmecha/arma-3-server/latest.svg)](https://hub.docker.com/r/silentmecha/arma-3-server)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-donate-success?logo=buy-me-a-coffee&logoColor=white)](https://www.buymeacoffee.com/silent001)

# silentmecha/arma-3-server

This repository contains the files needed to build and run a Docker image for an Arma 3 dedicated server. This image is built on Ubuntu and is specifically designed for quickly setting up an Arma 3 server. It uses a customized version of `steamcmd/steamcmd:ubuntu-24`, which includes additional programs, environment variables, and a dedicated USER account to ensure easy server creation and consistent configuration across instances. The image is optimized for streamlined deployment and management of **Arma 3** servers with all necessary dependencies and settings pre-configured.

> **Warning:** Due to the choice of the developers of Arma 3, we can only download the server files for the game server if we set the environment variable `$STEAM_LOGIN` to `<username> <password> <guardcode>` of an account that owns the game. As a result, the latest tag is exactly the same as `base`.

> **Note:** This image does not yet set all the settings for the server according to the ENV values. This is still a work in progress.

## Usage

This stack uses an image from [atmoz](https://github.com/atmoz). To see more on the image used visit their GitHub [https://github.com/atmoz/sftp](https://github.com/atmoz/sftp).

For more info on environment variables and what they do see [Environment Variables](#environment-variables)

### Available Tags

- `base`: Contains only the environment setup, excluding the game files.
- `latest`: This is exactly the same as base, **No game files included**

### Simplest Method

The simplest usage for this is using the `docker-compose` method to pull the `base` image and run it. Note that you will need a Steam account that owns the game and set the `$STEAM_LOGIN` environment variable correctly.

```console
git clone https://github.com/silentmecha/arma-3-server.git arma-3-server
cd arma-3-server
cp .env.example .env
nano .env
# Set the STEAM_LOGIN variable in the .env file to "<username> <password> <guardcode>"
docker-compose pull
docker-compose build
docker-compose up -d
```

### Using the `base` tag

If you don't want to pull the entire image and don't need to keep multiple instances up to date, you can use the `base` tag. Note that `base` is equivalent to `latest` but does not hold any game files.

```console
git clone https://github.com/silentmecha/arma-3-server.git arma-3-server
cd arma-3-server
cp .env.example .env
nano .env
# Set the STEAM_LOGIN variable in the .env file to "<username> <password> <guardcode>"
docker-compose -f docker-compose.base.yml up -d
```

### Building Locally

If you prefer to build everything locally, you can start by building the `base` image.

```console
git clone https://github.com/silentmecha/arma-3-server.git arma-3-server
cd arma-3-server
cp .env.example .env
nano .env
# Set the STEAM_LOGIN variable in the .env file to "<username> <password> <guardcode>"
docker build -f base.Dockerfile -t silentmecha/arma-3-server:base .
docker-compose up -d
```

### Updating

Updating is now as simple as running a build on the `Dockerfile` or using `docker-compose build`. This will update the image without downloading all the game files again.

```console
docker-compose build
docker-compose up -d
```

### Environment Variables

| Variable Name   | Default Value | Description                                                               |
|-----------------|---------------|---------------------------------------------------------------------------|
| SERVER_NAME     | Arma 3 Docker | Name of your server as seen in server browser (accepts spaces)            |
| PORT            | 2302          | Port used to connect to the server                                        |
| QUERYPORT       | 2303          | Port used to query the server                                             |
| MASTERPORT      | 2304          | Port used for the master server                                           |
| VONPORT         | 2305          | Port used for VON                                                         |
| BEPORT          | 2306          | Port used for BattlEye                                                    |
| SERVER_PASSWORD | secret        | Password to enter your server                                             |
| ADMIN_PASSWORD  | ChangeMe      | Password for admin access                                                 |
| ADDITIONAL_ARGS |               | Additional arguments for the server                                       |
| SFT_USER        | foo           | Username for SFTP access to edit save data                                |
| SFT_PASS        | pass          | Password for SFTP access to edit save data                                |
| SFT_PORT        | 2222          | Port for SFTP access (should not be 22 )                                  |
| STEAM_LOGIN     |               | Steam login credentials in the format `<username> <password> <guardcode>` |

For more info on the usage of SFTP see [here](https://github.com/atmoz/sftp). If you do not want to use a plain text password see [encrypted-password](https://github.com/atmoz/sftp#encrypted-password)

### Ports
Currently the following ports are used.

| Port        | Type | Default |
|-------------|------|---------|
| PORT        | TCP  | 2302    |
| PORT        | UDP  | 2302    |
| QUERYPORT   | TCP  | 2303    |
| QUERYPORT   | UDP  | 2303    |
| MASTERPORT  | TCP  | 2304    |
| MASTERPORT  | UDP  | 2304    |
| VONPORT     | TCP  | 2305    |
| VONPORT     | UDP  | 2305    |
| BEPORT      | TCP  | 2306    |
| BEPORT      | UDP  | 2306    |
| SFT_PORT    | TCP  | 2222    |

All these ports must be forwarded through your router, except for `SFT_PORT`, unless you wish to remotely edit the save data.

## License

This project is licensed under the [MIT License](LICENSE).

If you enjoy this project and would like to support my work, consider [buying me a coffee](https://www.buymeacoffee.com/silent001). Your support is greatly appreciated!
