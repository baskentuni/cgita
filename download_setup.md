### Introduction ###
This is a guide to show you how to download and set up CGITA. For description of CGITA features, refer to [this page](CGITA_preview.md).

### Determining how to run CGITA ###
There are two ways to run CGITA:
  1. Under MATLAB - Using CGITA under CGITA gives you more flexibility in error tracing, debugging, adding new functions, etc.
  1. As a stand-alone application (SAA) - The advantage is that you do not need a MATLAB license for this. However, you will not be able to add new functions or modify the CGITA program.

If you just need to use built-in functions of CGITA, either mode is good. These two modes are almost identical in speed and capability.

**If you do have a MATLAB license (and it's not too old), it is recommended to use CGITA under MATLAB. If you do not own a MATLAB license, CGITA as a stand-alone application will be the only choice.**

<font color='red'> <b>Please also note that, currently, the stand-alone version of CGITA only supports windows platforms.</b></font>

### Download MATLAB Compiler Runtime (MCR) for stand-alone version of CGITA ###
<font color='red'> <b>If you want to run CGITA as a stand-alone application, you must install the latest version of MCR on your computer.</b></font> Go to [this Mathworks webpage](http://www.mathworks.com/products/compiler/mcr/index.html) to download the MCR for your platform.

### Download the CGITA file you need ###
After you have determined whether to run it under MATLAB or as an SAA, go to the [Download page](https://sites.google.com/site/deanfanglab/software/software-download) to get the file you need.

### Setting CGITA up under MATLAB ###
  1. Uncompress the zip file 'CGITA\_v1.0\_matlab.zip' to a local drive on your computer.
  1. Open MATLAB. Go to 'File' -> 'Set path' -> 'Add with subfolders'. Then select the folder that you uncompressed CGITA to on your computer. Press OK. Press save and exit this window.
  1. Under the MATLAB command window, type 'CGITA\_GUI' and enter. If the CGITA GUI pops up, the setup should have been properly done.
  1. If you wish to accelerate DICOM reading with functions included in [COMKAT](http://comkat.case.edu). Follow [this page](faster_DICOM_with_COMKAT.md).

### Setting CGITA under SAA ###
  1. Uncompress the zip file (either CGITA\_v1.0\_win32\_app.zip or CGITA\_v1.0\_win64\_app.zip) to a local drive on your computer.
  1. Make sure MCR has been installed on your computer.
  1. Execute CGITA\_saa.exe

### User manual ###
A user manual can be found under the 'docs' folder of CGITA distribution or [here](http://cgita.googlecode.com/files/CGITA_v1.0_Manual.pdf).

### Tell us what you think of CGITA ###
Please leave us with your comments on [our guest book](Guestbook.md).

### Bug report and feedback ###
Go to the [Issues section to report bugs and problems](http://code.google.com/p/cgita/issues/list). We will try our best to solve them promptly.