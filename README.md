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
- Your device QDZ (For Cyclone III, use cyclone_web-13.1.0.162.qdz)
- Additional Software (Optional)

Copy those files to directory `quartus-install/components`

Ex.:
```$ tree quartus-install/
quartus-install/
├── components
│   ├── arria_web-13.1.0.162.qdz
│   ├── cyclonev-13.1.0.162.qdz
│   ├── cyclone_web-13.1.0.162.qdz
│   ├── max_web-13.1.0.162.qdz
│   ├── ModelSimSetup-13.1.0.162.run
│   ├── QuartusHelpSetup-13.1.0.162.run
|   |── QuartusSetup-13.1.4.182.run
│   └── QuartusSetupWeb-13.1.0.162.run
├── Quartus-web-13.1.0.162-linux.tar
└── setup.sh

1 directory, 9 files
```

### Building

```
$ docker build -t quartus/web:v13.1.4 .
```

Copy to `51-usbblaster.rules` to `/etc/udev/rules.d/51-usbblaster.rules`

```
$ sudo cp 51-usbblaster.rules /etc/udev/rules.d/51-usbblaster.rules
$ sudo udevadm control --reload-rules 
$ udevadm trigger
```

### Running

Start Quartus:

```
$ docker compose -f docker-compose.yml up
```
