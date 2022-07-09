# Root-A-Toon-USB-Stick

Software for rooting a (dutch/belgian) Toon/Boxx using software running from a USB stick only.

After rooting you don't need a subscription anymore and you have access to a ToonStore with a growing number of apps. For more technical people there is a possibility to ssh into the Toon if they want with username root and password toon.

Based on Root-A-Toon from https://github.com/ToonSoftwareCollective/Root-A-Toon.

I modified the 2 scripts root-toon.sh and activate-toon.sh so they run from Kali which can be booted from a USB stick.

Like with the original initiating scripts, the actual rooting is done by the so called 'payload' scripts which are still maintained on https://github.com/ToonSoftwareCollective/Root-A-Toon.

I created the script setup_wifi.sh to simplify the sharing of the wired Internet connection of your computer over the Wi-Fi to your Toon.

## What do you need?

A 4 GB memory stick and a Windows/Linux/macOS/OS X computer with an Ethernet card and wifi.

Details for USB stick creation are available on https://www.kali.org/docs/usb.

Summary to prepare a stick from Windows ( 1 time only ) :
 - old instruction was :
    - download Kali live from https://www.kali.org/get-kali/#kali-live
    - ( until I received an issue that ncat does not support -q option)
 - new instruction what I did not test yet but was confirmed by issue sender :
    - find a live image from a folder in http://old.kali.org/kali-images/
    - based on my Kali version info from 'lsb_release -a' :
        - No LSB modules are available.
        - Distributor ID: Kali
        - Description:    Kali GNU/Linux Rolling
        - Release:        2021.2
        - Codename:       kali-rolling
    - this is version 2021.2 but the issue sender confirmed it works for 2021.4
    - so I think a good start could be one of the live iso's from :
        - http://old.kali.org/kali-images/kali-2021.4/
        - probably http://old.kali.org/kali-images/kali-2021.4/kali-linux-2021.4-live-amd64.iso
 - download rufus from https://rufus-portable.en.uptodown.com/windows
 - insert USB stick
 - start rufus
    - make sure that the right USB stick is selected
    - click SELECT to browse to the Kali iso you downloaded
    - click Start and accept all default answers
    - (unlike Kali site which suggests to use dd and create an extra partition)
    - wait for iso to be written to stick

To root a Toon you need the stick with Kali you created before.
So for every next time you want to root a Toon  :
 - boot from the Kali USB stick
    - ( you may need to enable USB boot in the BIOS )
    - press enter on the blue Kali startup menu
    - wait for Kali with menu bar at top of the screen
 - in the top left corner of Kali is a black box and a $ sign in it
 - click that and in the window you enter the next statements :
    - git clone https://github.com/JackV2020/Root-A-Toon-USB-Stick.git
    - cd Root-A-Toon-USB-Stick
    - ./setup-wifi.sh<br>
       read and follow the instructions<br>
       connect your Toon to the Wi-Fi named ToonRouter<br>
       when you find out your Toon needs to be activated before you can root :
    - ./activate-toon.sh<br>
       read and follow the instructions<br>
       now you are ready to root your Toon :
    - ./root-toon.sh<br>
      read and follow the instructions

## Rooting test run

To start a rooting test run which does not modify the Toon yet you can issue ```sudo bash root-toon.sh test```<br>
This will generate 2 messages on your Toon and restart the GUI if the access is succesfull.

## Rooting

To root the Toon yet you can issue ```sudo bash root-toon.sh root```<br>
This will download the 'payload' as maintained on https://github.com/ToonSoftwareCollective/Root-A-Toon and root your Toon with the latest version of these scripts.

## Sending own payload

To send your own script as 'payload' to the Toon you can issue ```sudo bash root-toon.sh yourpayloadfile```<br>
For demo purpose I included a payload file named 'check' which you can run by ```sudo bash root-toon.sh check```<br>
This will generate 4 messages on your Toon if the access is succesfull.

Below is a direct copy of the explanation from https://github.com/ToonSoftwareCollective/Root-A-Toon:

## How is root access possible?
The script intercepts Toon traffic as it is trying to create a VPN connection towards the Toon servicecenter. First it starts blocking port 443 which results in blocking this VPN access (and also other traffic, but that is not a problem during rooting). Next, the Toon will try to access the servicecenter (from 172.16.0.0/12 address space) over the normal network port (wlan0 interface on the Toon) because there is no more-specific route over a (non existing) VPN connection anymore. The script will see this traffic (using tcpdump) and will store the IP address for the servicecenter which the Toon wants to talk to.

The next step for the script is to open a listen port (by using netcat) on port 31080 (the service center port) on the just learned service center IP address. The effect is that the Toon will simulate to be the servicecenter. Next, the user is requested to press the 'software' button on the Toon which in turn will cause the Toon to request the servicecenter if there is a software update available. This request is received by the script and a answer is given to the Toon with a hidden 'curl 1.1|sh' command within the 'new' version number. A bug in the Toon software which should download the version of the new software will run this hidden command. This will initiate a shell command on the Toon to download the payload from the machine running the script. Once the payload is downloaded by the Toon, this payload script will do the rest.

## It is not working on my 5.xx.100 firmware toon
These devices are linked to a new service center in the AWS IOT cloud. It is a test group as we speak which contains about 10% toon2's and 30% toon1's. Rooting these devices with this firmware installed is not always working correctly. Best is to fall back to toon1 old-fashioned rooting with the ToonRooter script and for the toon2 first perform a recovery of the firmware to the factory default firmware which from there you can use this tool.

### Toon 2 recovery procedure
You have to press the reset button at the bottom of the screen. Keep it pressed while you reboot the toon. After a few seconds you will enter the recovery mode. Press anywhere on the screen to start the recovery flashing while still keeping the reset button pressed. When the recovery flashing has been completed (it is quite fast) you will see a message that the Toon will reboot in 3 seconds. You can then release the reset button and you will be on version 4.9.
Don't release the reset button while flashing is still busy because the Toon will restart rightaway.

## What if my Toon needs to be activated first?
Without an activated toon you will not be able to root it using this script as you are unable to start the check for new software process. As rooted toons are not connected to the official service portal an activation should not be necesssary also. Only, there is currently no official way to activate a toon without contacting a supplier (like Eneco NL or Engie Belgium). A common method used by some rooted Toon owners is just to activate a toon with an official subscription and then end that subscription within a week so you don't pay anything.

But there is another way to fool the toon to be activated. Use the activation script for this. If your toon is in the activation wizard, connect your toon to the wifi hotspot and let it connect to the internet. It will then show you an 'activate' button. From there start the activation script: ``sudo bash activate-toon.sh``
