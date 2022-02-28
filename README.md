This repository contains the code to build a firmware for an InvizBox Device.

The devices currently supported are the original InvizBox, the InvizBox Go and the InvizBox 2.

**Note**: most of the description below refers to the InvizBox 2, you can do the same thing for the InvizBox Go and
InvizBox original by changing "2" to "go" or "original" in the file paths.

## Before building

### VPN Settings
* Edit the files in `src/files/2/etc/openvpn` so that they contain your own VPN configuration files
The files that are already there contain more information to help you initially.

  * `openvpn_1.conf`, `openvpn_2.conf`, `openvpn_3.conf` and `openvpn_4.conf` should contain your default config (aka
   initially selected when flashing) - make sure that the tunnels in these files are called tun1, tun2, tun3 and tun4
   respectively
  * `files/` should contains OVPN files 
  * `templates/` can be create templates if your ovpn files are identical apart from the server IP/hostname and the
   tunnel name (@TUN@)

* Edit `src/files/2/etc/config/vpn` as it should now be modified to define your VPN locations based on what you created 
in the previous point.

Note: If you own an original InvizBox 2, you can duplicate the /etc/openvpn setup from it to get started.

### Default Password
* If you own an original InvizBox 2, the passwords will be set to the flashed defaults
* If you DO NOT own an original InvizBox 2 and are trying to flash on another router, consider that the initial password
is most likely going to be TOKENPASSWORD (see `src/files/2/etc/config/wireless`). At this stage, you may want to consider
that the code here reads and writes from a partition called /private and you need to be sure that it suits your device.
(I'd consider being able to run a recovery via serial/tftp before trying this)

### Updating
If you want to get VPN updates, opkg updates and firmware updates from the Invizbox update server, you can enable the 
`CONFIG_PACKAGE_update` setting in the src/.config.2 file.

### DNS and DNS leaking
In `src/files/2/etc/config/dhcp`, the current DNS values (208.67.222.222 and 208.67.220.220) point to the OpenDNS servers.
If you want to use your VPN provider's DNS servers, make sure to edit that file and change the servers
from 208.67.222.222 and 208.67.220.220 to whatever your VPN provider DNS servers are (don't forget the @tun{0-4} after the IP address
when doing so). Similarly, make sure you put the correct DNS servers in `src/files/etc/config/vpn`, so they match
the ovpn file/template in use for that protocol or server.

## Building an InvizBox 2 firmware

* Use a build environment in which you can already successfully build OpenWRT
* Run `./build.sh 2`
* Find the sysupgrade file in the `output` directory

The build.sh script will create an `openwrt` directory and build your firmware there using the `src/.config.2` and 
`src/feeds.conf` files.

## Build script variants

* Run `./build.sh` or `./build.sh all` to build all firmwares
* Run `./build.sh 2` to build the InvizBox 2 firmware only 
* Run `./build.sh go` to build the InvizBox Go firmware only 
* Run `./build.sh original` to build the InvizBox original firmware only 

Enjoy!

The Invizbox Team.
