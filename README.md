# LinuxMLTroubleshoot
All problems I encountered in building machine, trying to remove windows, install linux, conda, pytorch with cuda, rstudio, devtools and more--and how I got through.
This is a bit long, press ctrl F to find the section you want. If you have a similar setup, maybe read through.

# ** Why AI softwares are hard to install, and what to do?

I made a thorough video in:

[Part 1: direct install vs venv, vs conda, vs docker, vs I give up and use Colab, and some practical OS and hardware compatibilities and restrictions
and what to choose in some cases][https://youtu.be/VzluixBnXb0]

## conda env
cpu only, windows,

```
mamba install pytorch==1.10.1 torchvision==0.11.2 torchaudio==0.10.1 -c pytorch -c conda-forge
pip install tensorflow==2.7.1
pip install tpot==0.12.0
mamba install conda
```



Note 1-3



# What makes installation of system, environment or packages hard?
 - pre installation environment may not be clean

For example, you should clean your disk to remove drivers left from a previous windows or linux before a linux installation.
you should do dpkg configurations and remove half installed linux packages before adding packages. Or you need conda clear -a to remove half installed conda packages etc.(if there has been previous unsuccessful installation)
 - your package version causes compatibility issues
For example. NV cards 3090 can use driver 470-525. but only non open kernels can be detected from cudatoolkit. And your ML framework might be picky on cudatoolkit version and cudnn version. specification is needed during conda install.
 - package installation cannot be processes with the default grammar or options
For example, you need to add path for conda manually. conda init is experimental by the time I write this.

# My hardware 1 - OS 1 [Ubuntu 22.04]

My pc is msi Z790 DDR5 wifi
kingston 2TB ssd + a 3 year old (about 2019 Dec) ssd 512G from dell laptop.
i9 13900
Nvidia 3090 ZOTAC
Corsair DDR5  64GB(32GBB*2)
(these may not be specific enough, make sure yours work)

with some DDR5s the hardware LED does not turn off and the system does not boot up. I returned them--maybe there are way to fix it.
no other change in bios. no over clocking.

## OS, disk and fsck

I did not change much in the BIOS from the msi board coming Dec 2022. I turned the LED light control off and intel XMP off (clicked on the XMP profliles and made sure non of the XMP profile buttons 1-6 are highlighted)

## when installing OS(Ubuntu 20.04), found mismatch in copied files and installation halts: 

Tried remaking the image for the USB drive, formatting to FAT before mirroring on a windows laptop.
Also, in the "try linux" session booting from USB, used the disks manager to format all disks (ext4). Check V "erase". After that click on the little gear button, "fix file system".
In case the usb might get unstable, i used one usb for formatting and erasing disk in the try ubuntu environment and another for the actual installation:
When you boot from a new USB drive the GUI will stall after some time. seems to be the driver problem but just wait enough time forit to erase it and reboot works.

## system boots into initramfs command section

see which filament of the disk has broken file system. If it says manually type "fsck -y /dev/...[usually your partition of the disk that has broken file system]" for example, fsck -y /dev/root/nvme0n1p2
(note  the -y usually means automatically input y (yes) for all intermediate process)

sometimes your file sys might be locked when the pc finds errs when it is running. sometimes it happens when multiple softwares are installed together (but i am not sure the real reason)

If this does not work and the system says the root is in use or busy. Force reboot manually .



## if system repeatedly boots in to initramfs, and some disks have no write permissions

Check disks, find the disk that you have that you cannot use, format it.


# drivers and CUDA

I tried to use the terminal, but for a 3090, click on the bottom left, find the icon "Additional Drivers" and use a new (I used 525-open-propriety-testeed) and worked. You might need to reboot and maybe several times, and do the fsck -y thing mentioned above. open kernels might not be recognized by cuda. try use the 470 mega, if not working, try 515, 525 mega

If a cuda come with it and it is not the version you want, do not worry. Conda env can take a version supported by your ML framework, hopefully.

## conda, CUDA and py package dependencies

If slightly older package allows 
```
conda install pytorch==1.10.1 torchvision==0.11.2 torchaudio==0.10.1 cudatoolkit=11.3 -c pytorch -c conda-forge
```
works for python 3.7 and 3.8

To use torch and tensorflow together:

```
conda install tensorflow-gpu
conda install pytorch==1.10.1 torchvision==0.11.2 torchaudio==0.10.1 cudatoolkit=11.3 -c pytorch -c conda-forge
```

Note conda may downgrade tensorflow and cuda upon installation of pytorch, but this works-- maybe there is a better anc cleaner way.
On the manual way you have to match tf and torch with nvcc, cuda, cudnn, etc.


Do not conda install cudatoolkit before cudnn and pytorch!!! you might end up installing a prerequisite too new to be taken by the package you want to use.

conda handles the version pretty well for pytorch and tf at least in Dec 2022, though the latest tf and torch do not use same cuda (11.2 and 11.3 respectively, the latest is 12 when writing it. I used not the latest but the **latest one supported by conda -c install**, worked well

install conda using bash and select no on whether to conda init. by this time it says experimental. refer to the official documentation to fill out the path in .bashrc. if your conda says it is not properly preconfigured this is probably the reason. purge conda and redo it.

modify the bashrc file and conda init later. restart kernel before activating your first environment.

if some packages do not have a conda install. install pip and use pip before using conda to setup ml frameworks.

specifing torch version (shown in bash) works. but conda install torch at feb 28 also passes test and recognizes cuda.

conda activate torch. Use an environment when handling ML packages with CUDA togther!!! Then start with the **package you actually use**, not the one it requires. Work out the top package and let conda solve its dependencies!

And in general do not worry CUDA on top of NV drivers, I used 525 and I also seen a tutorial where 470 worked--they have better comp. than the ML package does/

if your ML framework still fights with environment, then try a nightly build version or build it on your pc.


## CUDA: unspecified launch failure

If sometimes your system also fails, and sometimes segmentation fault running some C programs, check your RAM, bios voltage settings and maybe check your bios website (motherboard manufacturer) to see if there is a compatibility search.

See also:

https://github.com/pytorch/pytorch/issues/74235


## when importing package cannot import name ... from PIL

this package changed. try pip uninstall pillow and also your package(if it is matplotlib) and then conda install matplotlib and let conda fix the dependency and linkages.

## a linux package is installed but cannot be called

run 
sudo apt-get update
to let the system know you have a new packagee
if that fails, either you have half-installed package or your dpkg needs fixing. how to remove them can be found online. usually apt get autoclean and dpkg config do the job

# Rstudio
## R studio installation on Ubuntu 20.04, the .deb file fails to run with package manager
First make sure you installed R.
get a daily build of Rstudio, these seems to be fixed.

## R packages installations exited with non zero exit status, especially **devtools**

and you cannot library(it) successfully.
Go to your terminal, run sudo -i R, install your package, check if any of the errors says one or more of your dependencies need other dependencies, install them.

For example, devtools needs something like liblib, libxml, and some fonts handling packages, whenever possible, use sudo apt-get install [your package needed] since it is easier and better maintained.

some packages need to r cran build-essential in the terminal
then update package list
then install in the terminal (sudo -i R) use install.packages()
e.x. pROC needs plyr, which needs RCpp which needs the build essentials and a proper GCC compiler(and it needs to be able to find it), install and test them one by one in the terminal.


















