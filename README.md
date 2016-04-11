# MalTect - Virus Scanner

The intention of this project is to build a set of open source libraries for detecting new virus as a complement to conventional signature based detection software, like ClamAV.

## Getting started
The libraries are writen in ocaml.
For more information see the /docs/ folder. It includes a [*Quick Reference*](https://github.com/ocaml-n00b/Maltect/blob/master/docs/Quick%20Reference.md) guide to try out in the interpreter.


## How the values are obtained:

**File:** Calculating the entropy of the entire file in one go byte by byte.

**Blocks:** The files are broken into blocks of 256 bytes from the beginning of the file with no other consideration. The last block may have less than 256 bytes. Each block entropy is calculated by the byte.


### Analysis
The block entropy of the files are subjected to different test including basic statistics on the distribution of the values and their sequential analysis for evaluating the file entropy structure.

Among the structural analysis techniques used we currently include:

* Mean Change Point Analysis
* Detrended Fluctuation Analysis
* Fourier Transform


## Data
The CSV files contain the information related to the features of the entropy of files that were used to do linear model fit.
Three files contain all the currently extractable (using this project) information on the files mentioned on the CSVs.
### Analysis
The analysis of the files was done in gnuR and the codes and files used can be found in the /stats folder.
For more details on the csv files /docs/Statistics.html.

A simple linear model using all currently available features achived the following results:

- Over All: 96.85%* 
- Virus Detection: 93.12% 
- False Positives: 1.63%

This was on the small data set used (133 clean files, 53 viruses)<br>
*read "Known limitations"

## Known limitations

1. The clean files used are unix binary files. This leaves out clean windows .exe files and closed source bin files which tend to use obfuscation and will probably present different entropy signitures.
2. The viruses are mostly windows viruses.
3. There is a disproportionately higher amount of clean files; 133 "clean" vs 53 viruses.
4. More information can still be extracted e.g. File and Block Standard Deviations.
5. Meta-obfuscation techniques (e.g. null content insertion) can then disguise the encryption and compression so that the file passes through entropy filters. This makes this useless against modern viruses.
6. Far from enough files were used for testing.

## TODO
The following are not in order of priority.

**Command line input:** Make it a real program!<br>
**Wavelet Energy Decomposition:** Structural Analysis<br>
**Better output:** For easy integration with R and other statistics and Machine Learning languages.<br>
**More virus and non-virus files:** For better fitting.<br>
**More advanced techniques:** For better detection of newer viruses.<br>
**Abstracting:** To use streams so not just files can be checked. <br>
**Techniques for network analysis:** So not just files can be checked.<br>
**More Features:** Many more features are required to get better detection. Including mixed (interaction) features.<br>


