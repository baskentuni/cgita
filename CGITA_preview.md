# Introduction #

This page describes the features of CGITA in detail.

# Open-source project #

CGITA is open-source and free for academic research use. The terms of CGITA can be found at [Terms\_CGITA](Terms_CGITA.md).

# Development platform #

CGITA is developed as a MATLAB toolbox. However, it has its own user interface. You may use it under MATLAB, or as a standalone application. For the standalone application, you do not need a MATLAB license to run CGITA. Detailed installation guide can be found [here](UserManual.md).

To run CGITA as a standalone application, you need to download MATLAB Compiler Runtime (MCR) at [here](http://www.mathworks.com/products/compiler/mcr/index.html).

# User interface #

CGITA has an graphical user interface (GUI). Also it comes with many command-line functions. CGITA screen shot:

<img src='http://cgita.googlecode.com/svn/wiki/screen3.png' align='right' height='330' width='450' alt='Pulpit rock' border='5' />

# Supported textural features #

We currently support more than 70 textural features, including features based on:
  * Cooccurrence matrix (Haralick 1973)
  * Voxel-alignment matrix (Run-length, Loh 1988)
  * Neighborhood intensity difference matrix (Amadasun 1989)
  * Intensity size-zone matrix (Thibault 2009)
  * Normalized cooccurrence matrix (Haralick 1973)
  * Voxel statistics
  * Texture spectrum (He 1991)
  * Texture feature coding (Horng 2002)
  * Texture feature coding co-occurrence matrix (Horng 2002)
  * Neighborhood gray level dependence (Sun 1983)

# Citation of CGITA #
We are currently preparing for the CGITA manuscript to be submitted.

# Supported VOI #
We currently support VOI stored as DICOM-RT files and PMOD .voi files.

# Segmentation #
We currently support region growing (based on a threshold) and fuzzy C-mean segmentation.

# Input image format #
We current support DICOM format.

# Processing large amount of data #
We offer a batch mode to run CGITA automatically for processing large cohort data.

# Parametric imaging #
Users may use CGITA to generate parametric images of textural features.

# Modifying and improving CGITA #
We welcome developers to join us to make CGITA better and more powerful! You may modify CGITA for your own applications, as long as it is within the terms of CGITA. Feel free to contact us about joining this project.