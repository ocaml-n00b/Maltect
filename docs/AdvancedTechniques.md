<h1>Advanced Techniques</h1>
<p>
These functions are intended to extract features that go beyond the baseic file entropy statistics. 
Their all related to the structural entropy analysis of the file.
</p>

<h2>Intro</h2>
<p>
All of the main technique functions of this library need the <em>"time series"</em> of the file.
The time series in this case refers to a float array with the entropy list of a file calculated on 256 byte blocks. The functions used in the following code belong to the Entropy.ml library not the Advanced Techniques library.

  <code>
    let timeSeries =
    let entLst = 
    let freqLst = blockingByteCount fname 256 in
    List.rev (mleList freqLst 256) in
    Array.of_list entLst;;
  </code>
Replace fname with the file name. You must already have the "time series" of the file to proceed with the following examples.
</p>

<h2>Mean Change Point</h2>
<p>
The mean change point analysis is used in many different fields to detect changes using the maximum likelihood estimation.
</p>
<p>
In the following example we extract the features and discard the mean change point model obtained from the binary segmentstion algorithm:
  <code>
    let featMCP = 
    let bSegTuple = 
    let n = Array.length timeSeries in
    binarySegmentation timeSeries fitError (sicPenalty 1. n) in
    meanChangePoint bSegTuple;;
  </code>
</p>

<h2>Frequency Analysis</h2>
<p>
We use the Fourier transformation to extract features from the time series of the file.
This kind of analysis is very common in the analysis of many different types of files (sound, images, etc.) and has been used in many virus detection systems.
</p>
<p>
<code>
let featFT = 
let dFT = discreteFourierTransform timeSeries in
fourierFeatures dFT 5;;
</code>
The five in the last line of code represents the amount of harmonics you want features on. In this case from the "zero frequency" to the 4 harmonic. It returns the magnitude of the 0Freq and the magnitude and ratio of the first four harmonics (ratio = magnitude of harmonic/magnitude of 0Freq), and the "fundamental frequency", in that order.
</p>

<h2>Detrended Fluctuation Analysis</h2>
<p>
It is used in many biological and medical signal analysis and is considered to be a measure of how stationary a time series (signal) is.
</p>
<p>
In this case the feature is extracted directly and it consist in a single float value known as alpha:
<code>
let featAlpha = detrendedFluctuationAnalysis timeSeries;;
</code>
</p>




