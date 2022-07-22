# JTCORES for MiSTer

This repository contains all of [Jotego's](https://twitter.com/topapate) cores and related files ready for usage on [MiSTer](https://github.com/MiSTer-devel/Main_MiSTer/wiki).

Jotego's arcade cores offer the most accurate arcade experience in modern hardware using FPGA technology.

Please support Jotego's work:
* Patreon: https://patreon.com/topapate
* Paypal: https://paypal.me/topapate
* Github: https://github.com/sponsors/jotego

Downloader development by theypsilon (get him a [Ko-fi](https://ko-fi.com/theypsilon))

## Download

You may download all of them at once as a zip through the [following link](https://github.com/jotego/jtcores_mister/archive/refs/heads/main.zip). Once you have them, place them as-is in your [properly initialised SD card](https://github.com/MiSTer-devel/mr-fusion), and everything should work out of the box.

The source code for these files is kept in independent repositories [here](https://github.com/jotego).

### MiSTer Downloader Configuration

The [Downloader](https://github.com/MiSTer-devel/Downloader_MiSTer) tool can be configured for downloading all these files directly from your MiSTer. If you are not getting the files automatically, add manually this database to `/media/fat/downloader.ini`. Add these lines to the end of the file:

```ini
[jtcores]
db_url = https://raw.githubusercontent.com/jotego/jtcores_mister/main/jtbindb.json.zip

```

#### List of Tags that you may use with the Downloader Filters:

`alternatives`, `arcade`, `arcade-cores`, `arcade-jt1942`, `arcade-jt1943`, `arcade-jtbiocom`, `arcade-jtbtiger`, `arcade-jtbubl`, `arcade-jtcommando`, `arcade-jtcomsc`, `arcade-jtcontra`, `arcade-jtcop`, `arcade-jtcps1`, `arcade-jtcps15`, `arcade-jtcps2`, `arcade-jtdd`, `arcade-jtdd2`, `arcade-jtexed`, `arcade-jtf1dream`, `arcade-jtflane`, `arcade-jtgng`, `arcade-jtgunsmoke`, `arcade-jthige`, `arcade-jtkicker`, `arcade-jtlabrun`, `arcade-jtmidres`, `arcade-jtmikie`, `arcade-jtmx5k`, `arcade-jtninja`, `arcade-jtpang`, `arcade-jtpinpon`, `arcade-jtrastan`, `arcade-jtroadf`, `arcade-jtrumble`, `arcade-jts16`, `arcade-jts16b`, `arcade-jtsarms`, `arcade-jtsbask1`, `arcade-jtsbaskt`, `arcade-jtsectionz`, `arcade-jtsf`, `arcade-jtslyspy`, `arcade-jttora`, `arcade-jttrack`, `arcade-jttrojan`, `arcade-jtvigil`, `arcade-jtvulgus`, `arcade-jtyiear`, `cores`, `hbmame`, `mra`

### Other Platforms

These cores are also available for MiST, SiDi, NeptUNO, MultiCore and MultiCore 2+. For these platforms check the [JTBIN](https://github.com/jotego/jtbin) repository.

