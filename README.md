# LinuxMLTroubleshoot
All problems I encountered in building machine, trying to remove windows, install linux, conda, pytorch with cuda, rstudio, devtools and more--and how I got through.
This is a bit long, press ctrl F to find the section you want. If you have a similar setup, maybe read through.


My pc is msi Z790 DDR5 wifi
kingston 2TB ssd + a 3 year old (about 2019 Dec) ssd 512G from dell laptop.
i9 13900
Nvidia 3090 ZOTAC
Corsair DDR5  64GB(32GBB*2)
(these may not be specific enough, make sure yours work)

with some DDR5s the hardware LED does not turn off and the system does not boot up. I returned them--maybe there are way to fix it.


# OS, disk and fsck

I did not change much in the BIOS from the msi board coming Dec 2022. I turned the LED light control off and intel XMP off (clicked on the XMP profliles and made sure non of the XMP profile buttons 1-6 are highlighted)

## when installing OS(Ubuntu 20.04), found mismatch in copied files and installation halts: 

Tried remaking the image for the USB drive, formatting to FAT before mirroring on a windows laptop.
Also, in the "try linux" session booting from USB, used the disks manager to format all disks (ext4). Check V "erase". After that click on the little gear button, "fix file system".

When you boot from a new USB drive the GUI will stall after some time. seems to be the driver problem but just wait enough time forit to erase it and reboot works.

## system boots into initramfs command section

see which filament of the disk has broken file system. If it says manually type "fsck -y /dev/...[usually your partition of the disk that has broken file system]" for example, fsck -y /dev/root/nvme0n1p2
(note  the -y usually means automatically input y (yes) for all intermediate process)

If this does not work and the system says the root is in use or busy. Reboot.

## 


# drivers and CUDA

I tried to use the terminal, but for a 3090, click on the bottom left, find the icon "Additional Drivers" and use a new (I used 525-open-propriety-testeed) and worked. You might need to reboot and maybe several times, and do the fsck -y thing mentioned above.

If a cuda come with it and it is not the version you want, do not worry. Conda env can take a version supported by your ML framework, hopefully.

## conda, CUDA and py package dependencies

Do not conda install cudatoolkit before cudnn and pytorch!!! you might end up installing a prerequisite too new to be taken by the package you want to use.

conda handles the version pretty well for pytorch and tf at least in Dec 2022, though the latest tf and torch do not use same cuda (11.2 and 11.3 respectively, the latest is 12 when writing it. I used not the latest but the **latest one supported by conda -c install**, worked well

conda activate torch. Use an environment when handling ML packages with CUDA togther!!! Then start with the **package you actually use**, not the one it requires. Work out the top package and let conda solve its dependencies!

And in general do not worry CUDA on top of NV drivers, I used 525 and I also seen a tutorial where 470 worked--they have better comp. than the ML package does/

if your ML framework still fights with environment, then try a nightly build version or build it on your pc.

## when importing package cannot import name ... from PIL

this package changed. try pip uninstall pillow and also your package(if it is matplotlib) and then conda install matplotlib and let conda fix the dependency and linkages.

## a new package is installed but cannot be called

run 
sudo apt-get update
to let the system know you have a new packagee
if that fails, either you have half-installed package or your dpkg needs fixing. how to remove them can be found online.

# Rstudio
## R studio installation on Ubuntu 20.04, the .deb file fails to run with package manager
First make sure you installed R.
get a daily build of Rstudio, these seems to be fixed.

## R packages installations exited with non zero exit status

and you cannot library(it) successfully.
Go to your terminal, run sudo -i R, install your package, check if any of the errors says one or more of your dependencies need other dependencies, install them.

For example, devtools needs something like liblib, libxml, and some fonts handling packages, whenever possible, use sudo apt-get install [your package needed] since it is easier and better maintained.




















