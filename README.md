<h1>MalTect - Virus Scanner</h1>
<p>
The intention of this project is to build a set of open source libraries for detecting new virus as a complement to conventional signature based detection software, like ClamAV.
</p>

<h2>How the values are obtained:</h2>
<h>
<p>
<strong>File:</strong> Calculating the entropy of the entire file in one go byte by byte.
</p>
<p>
<strong>Blocks:</strong> The files are broken into blocks of 256 bytes from the beginning of the file with no other consideration. The last block may have less than 256 bytes. Each block entropy is calculated by the byte.
</p>

<h3>Analysis</h3>
<p>
The block entropy of the files are submitted to different test including basic statistics on the distribution of the values and their sequential analysis for evaluating the file entropy structure.
</p>
<p>
Among the structural analysis techniques used we currently include:
<ul>
<li>Mean Change Point Analysis</li>
<li>Detrended Fluctuation Analysis</li>
<li>Fourier Transform</li>
</ul>
</p>

<h2>Data</h2>
<p>
The CSV files contain the information related to the features of the entropy of files that were used to do linear model fit.
Three files contain all the currently extractable (using this project) information on the files mentioned on the CSVs.
</p>

<h3>Analysis</h3>
<p>
The analysis of the files was done in gnuR and the codes and files used can be found in the /stats folder.
For more details on the csv files /docs/Statistics.html.
</p>
<p>
A simple linear model using all currently available features achived the following results:
Over All: 96.85%
Virus Detection: 93.12%
False Positives: 1.63%
This was on the small data set used (133 clean files, 53 viruses)
*read "Known limitations"
</p>

<h2>Known limitations</h2>
<ol>
<li>
The clean files used are unix binary files. This leaves out clean windows .exe files and closed source bin files which tend to use obfuscation and will probably present different entropy signitures.
</li>
<li>The viruses are mostly windows viruses.</li>
<li>There is a disproportionately higher amount of clean files; 133 "clean" vs 53 viruses.
</li>
<li>More information can still be extracted e.g. File and Block Standard Deviations.
</li>
<li>Meta-obfuscation techniques (e.g. null content insertion) can then disguise the encryption and compression so that the file passes through entropy filters. This makes this useless against modern viruses.
</li>
<li>Far from enough files were used for testing.</li>
</ol>

<h2>TODO</h2>
<p>
The following are not in order of priority.
</p>
<strong>Command line input:</strong> Make it a real program!
<strong>Wavelet Energy Decomposition:</strong> Structural Analysis
<strong>Better output:</strong> For easy integration with R and other statistics and Machine Learning languages.
<strong>More virus and non-virus files:</strong> For better fitting.
<strong>More advanced techniques:</strong> For better detection of newer viruses.
<strong>Abstracting:</strong> To use streams so not just files can be checked. 
<strong>Techniques for network analysis:</strong> So not just files can be checked.
<strong>More Features:</strong> Many more features are required to get better detection. Including mixed (interaction) features.


