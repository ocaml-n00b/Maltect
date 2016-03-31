<h1>What?</h1>


<h2>How the values were obtained:</h2>
<p>
<strong>File:</strong> Calculating the entropy of the entire file in one go byte by byte.
</p>
<p>
<strong>Blocks:</strong> the files are broken into blocks of 256 bytes from the begining of the file with no other consideration. The last block may have less than 256 bytes. Each blocks entropy is calculated by the byte.
</p>


<h2>EntrData.csv:</h2>
<p>
The EntrData CSV file contains the information analized in R to determine the right parameters to have a high virus file detection with the least amount of flase positive as possible (as would be best for the average user).
</p>
<p>
90% of the data was used for training.
The most simple/effective detection combination was:
  Mean > 5.4 ; X3Q  > 5.6 ; File > 6.6. 
With a 67.9% true postive and 0% false positve detection rate.
Up to 79.25% true positive with 1.5% false positive was obtained using Regression Trees.
Up to 75.47% true positive with 0% false positive using manual selection.
</p>

<h2>Known limitations:</h2>
<!-- use ordered list instead of numbers -->
1. TODO: check => "The samples used as virus are not infected files but just the virus exe."
2. The clean files used are unix binary files. This leaves out clean windows .exe files and closed source bin files which tend to use obfuscation and will probably present different entropy signitures.
3. The viruses are mostly windows viruses.
4. There is disproportionately higher amount amount of clean files; 133 "clean" vs 53 viruses.
5. More information can still be extracted e.g. File and Block Standard Deviations.
6. Not all clean files are bin e.g. "false" and "true" files
7. Meta-obfuscation techniques (e.g. null content insertion) can then disguise the encryption and compression so that the file passes through entropy filters. This makes this usless ageinst modern viruses.
8. Far from enough files were used to testing.


<h2>TODO:<h2>
<strong>Command line input:</strong> makeing it a real program
<strong>Structural entropy analysis:</strong> Time series analysis
<strong>Graphing capabilities:</strong> For ease of testing and viewing, histograms, conventional plots, etc.
<strong>Better output :</strong> For ease of integration with R and other statistics and Machine Learning languages
<strong>More virus and non-virus files:</strong> For testing
<strong>More advanced techniques:</strong> For better detection of newer viruses.
<strong>Techniques for network analysis:</strong> So not just files can be checked.




