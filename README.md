# Intel Quartus II Web 13.1.4 Docker
Docker-based Quartus Web 13.1.4 IDE

## Requirements

- Linux
- [Docker](https://docs.docker.com/install/)
- docker compose plugin

## How to use

### Prepare to building

- Got to Intel Quartus II Web 13.1 downloads:

https://www.intel.com/content/www/us/en/software-kit/666220/intel-quartus-ii-web-edition-design-software-version-13-1-for-linux.html

Download files:
- QuartusSetupWeb-13.1.0.162.run (Main Install)
- QuartusSetup-13.1.4.182.run (Latest Update)
- Your device QDZ
- Additional Software (Optional)

Copy those files to directory `quartus-install`

Ex.:
```
/quartus-install
  |_ cyclone_web-13.1.0.162.qdz
  |_ QuartusSetup-13.1.4.182.run
  |_ QuartusSetupWeb-13.1.0.162.run
```

### Building

```
> docker build -t quartus/web:v13.1.4 .
```

### Running

Run once on every new session:
```
> xhost +
```

Start Quartus:
```
> docker compose run quartus
```
