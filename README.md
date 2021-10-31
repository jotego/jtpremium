# jtcores for MiSTer

This repository contains all jotego cores and related files for its usage on MiSTer.

You may download all of them at once as a zip through the [following link](https://github.com/jotego/jtcores_mister/archive/refs/heads/main.zip). Once you have them, place them as-is in your [properly initialised SD card](https://github.com/MiSTer-devel/mr-fusion), and everything should work out of the box.

### MiSTer Downloader section

The [Downloader](https://github.com/MiSTer-devel/Downloader_MiSTer) tool can be configured for downloading all these files. For adding manually this database in `/media/fat/downloader.ini`, add the following section:

```ini
[jtcores]
db_url = https://raw.githubusercontent.com/jotego/jtcores_mister/main/jtbindb.json.zip

```


### Other platforms

For platforms other than MiSTerm please check the [jtbin](https://github.com/jotego/jtbin) repository.

