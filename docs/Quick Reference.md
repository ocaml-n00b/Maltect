<h1>Quick Use</h1>
<p>
  There is no command line program yet so all of the following commands must
  be executed from the interpreter (ocaml or utop).
  First navigate to the root folder of the project in your console then start
  the ocaml/utop.
  Many of the commands depend on previously initialized variables so not all code
  snippets are self contained.
</p>

<h2>Initialize</h2>
<p>
  First we load the relevant libraries:
  <code>
    #use "Entropy.ml";;
    #use "basicEntropyAnalysis.ml";;
    #use "advancedTechniques.ml";;
    #use "predict.ml";;
  </code>
</p>

<h2>Step by step</h2>
<p>
  <h3>Full File Entropy</h3>
  To get the average entropy of file we write:
  <code>
    let (bcaF, error), nBytes =
    let tmpic = open_in <em>fname</em> in
    let size = in_channel_length tmpic in
    (streamByteCount tmpic (-1)), size ;;
  </code>
</p>
<p>
  Replace <em>fname</em> with the name of the file you want to check.
  This creates a <em>byte count array</em> called bcaF where all the
  ocurences of the 256 different possible values of a byte in the file
  are counted and stored in order. This is used to calculate the entropy
  of the file:
  <code>let fileEnt = maxLikelihoodEstimator bcaF nBytes;;</code>
</p>


<h3>By the Blocks</h3>
<p>
  For many different features used in classification of files (virus detection)
  the entropy is calculated on chunks of data (blocks of bytes). The most 
  common seen in leterature is 256 bytes per block. To achieve this you may
  write:
  <code>
    let entLst = 
    let freqLst = blockingByteCount fname 256 in
    List.rev (mleList freqLst 256);;
  </code>
  Replace <em>fname</em> with the name of the file you want to check.
  This returns a list of floats in <em>entLst</em> that contains the entropy
  of the 256 byte blocks of the file. This can also be referred to as the files
  "time series" when referring to structural entropy analysis.
</p>

  <strong>Basic Statistics</strong>
<p>
  To get a simple analysis of the distribution of the entropy of the blocks we
  write:
  <code>let bStats = entropyStat entLst;;</code>

  bStat is a list of floats that contains the following blocks entropy values:
   |> Maximum, 3 quartile, Median, Mean, 1 Quartile, Minimum.
  In that order.
</p>

  <strong>Structure Analysis</strong>
<p>
For most feature extractions we need the entropy list of the files blocks to be in array form:
  <code>
    let timeSeries = Array.of_list entLst;;
  </code>
</p>

  <strong>Structure Analysis</strong>
<p>
  <strong>Mean Change Point Model</strong> <br>
  To obtain the mean change point fit of the time series using the binary 
  segmentation algorithm and the Scwartz Information Criterion penalty:
  <code>
    let binSegFit = 
    let n = Array.length timeSeries in
    binarySegmentation timeSeries fitError (sicPenalty 1. n);;
  </code>
</p>

<p>
  <strong>Mean Change Point Feats</strong> <br>
  To obtain the mean change point features of the model obtained previously:
  <code>
    let featMCP = meanChangePoint binSegFit;;
  </code>
</p>

<p>
  <strong>Detrended Fluctuation Analysis</strong> <br>
  To obtain the alpha feature of the file we write:
  <code>
    let featAlpha = detrendedFluctuationAnalysis timeSeries;;
  </code>
</p>

<p>
  <strong>Fourier Transformation Analysis</strong> <br>
  To obtain the features from the FT of the file we write:
  <code>
    let featFT = 
    let dFT = discreteFourierTransform timeSeries in
    fourierFeatures dFT 5;;
  </code>
</p>

<p>
  <strong>Prediction</strong> <br>
  To obtain a prediction on whether the file is a virus or not you most have a list of coefficients (including the intercept) of a linear regression fit and the corresponding values of the file. There is already a coefficient list available:<br>
  <code>
    predictLinear coef <em>calculated_values</em>
  </code>
</p>

<h2>Even Faster:</h2>

<p>
  Get basic stats of a file:
  <code>let bStats = autoSingleFile fname 256;;</code>  
</p>

<h2>Quick Prediction</h2>
<p>
  <code>
    singleFilePredict fname coef 256;;
  </code>
</p>

