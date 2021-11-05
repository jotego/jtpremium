# JTCORES for MiSTer

This repository contains all [Jotego](https://twitter.com/topapate) cores and related files for its usage on MiSTer.

Jotego's arcade cores offer the most accurate arcade experience in modern hardware using FPGA technology.

Please support Jotego's work:
* Patreon: https://patreon.com/topapate
* Paypal: https://paypal.me/topapate
* Github: https://github.com/sponsors/jotego

Downloader development by theypsilon (get him a [Ko-fi](https://ko-fi.com/theypsilon))

# Download

You may download all of them at once as a zip through the [following link](https://github.com/jotego/jtcores_mister/archive/refs/heads/main.zip). Once you have them, place them as-is in your [properly initialised SD card](https://github.com/MiSTer-devel/mr-fusion), and everything should work out of the box.

The source code for these files is kept in independent repositories [here](https://github.com/jotego).

## MiSTer Downloader section

The [Downloader](https://github.com/MiSTer-devel/Downloader_MiSTer) tool can be configured for downloading all these files. For adding manually this database in `/media/fat/downloader.ini`, add the following section:

```ini
[jtcores]
db_url = https://raw.githubusercontent.com/jotego/jtcores_mister/main/jtbindb.json.zip

```


## Other platforms

These cores are also available for MiST, SiDi, NeptUNO, MultiCore and MultiCore 2+. For these platforms check the [JTBIN](https://github.com/jotego/jtbin) repository.

