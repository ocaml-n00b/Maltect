#Quick Use
  There is no command line program yet so all of the following commands must
  be executed from the interpreter (ocaml or utop).<br>
  Many of the commands depend on previously initialized variables so not all code
  snippets are self contained.

##Install
You must install `ocaml` and optionally utop command line interpreter. To install both in Ubuntu:

`sudo apt-get install ocaml opam`<br>
`opam install utop`

##Start
Navigate to the root folder of the project in your console and then start `ocaml` or `utop`.

##Initialize
  First we load the relevant libraries:
``` 
  #use "Entropy.ml";;
  #use "basicEntropyAnalysis.ml";;
  #use "advancedTechniques.ml";;
  #use "predict.ml";;
```

## Step by step

### Full File Entropy
  To get the average entropy of file we write:
  
```
    let (bcaF, error), nBytes =<br>
    let tmpic = open_in *fname* in<br>
    let size = in_channel_length tmpic in<br>
    (streamByteCount tmpic (-1)), size ;;
```

Replace **_fname_** with the name of the file you want to check.
  This creates a *byte count array* called bcaF where all the occurrences of the 256 different possible values of a byte in the file are counted and stored in order. This is used to calculate the entropy of the file:
  
  `let fileEnt = maxLikelihoodEstimator bcaF nBytes;;`

###By the Blocks
  For many different features used in classification of files (virus detection)
  the entropy is calculated on chunks of data (blocks of bytes). The most 
  common seen in literature is 256 bytes per block. To achieve this you may
  write:
  
```
    let entLst =
    let freqLst = blockingByteCount fname 256 in
    List.rev (mleList freqLst 256);;
```

  Replace *fname* with the name of the file you want to check.
  
  This returns a list of floats in *entLst* that contains the entropy
  of the 256 byte blocks of the file. This can also be referred to as the files
  **_"time series"_** when referring to structural entropy analysis.

####Basic Statistics
  To get a simple analysis of the distribution of the entropy of the blocks we write:
  
  `let bStats = entropyStat entLst;;`

  `bStat` is a list of floats that contains the following blocks entropy stat values:<br>
   |> Maximum, 3 quartile, Median, Mean, 1 Quartile, Minimum.
   
  In that order.

####Structure Analysis
For most feature extractions we need the entropy list of the files blocks to be in array form:

  `let timeSeries = Array.of_list entLst;;`

**Mean Change Point Model** <br>
  To obtain the mean change point fit of the time series using the binary segmentation algorithm and the Scwartz Information Criterion penalty:
  
```
    let binSegFit = 
    let n = Array.length timeSeries in
    binarySegmentation timeSeries fitError (sicPenalty 1. n);;
```

**Mean Change Point Feats** <br>
  To obtain the mean change point features of the model obtained previously:
  
`let featMCP = meanChangePoint binSegFit;;`

**Detrended Fluctuation Analysis** <br>
  To obtain the alpha feature of the file we write:
  
`let featAlpha = detrendedFluctuationAnalysis timeSeries;;`

**Fourier Transformation Analysis** <br>
  To obtain the features from the FT of the file we write:
```
    let featFT = 
    let dFT = discreteFourierTransform timeSeries in
    fourierFeatures dFT 5;;
```

**Prediction** <br>
  To obtain a prediction on whether the file is a virus or not you most have a list of coefficients (including the intercept) of a linear regression fit and the corresponding values of the file. There is already a coefficient list available:<br>
```
    let calculated_values = fileEnt::bStats@featMCP@featAlpha@featFT in
    predictLinear coefA *calculated_values*;;
```
**_coefA_** is a variable in the predict.ml lib with the coefficients of linear model fitted with all the values *calculated_values* and an intercept. You can use your own.

##Even Faster
  Get basic stats of a file:<br>
`let bStats = autoSingleFile fname 256;;`

###Quick Prediction
`singleFilePredict fname coef blockSize;;`

**fname:** The file name and directory<br>
**coef:** You may use **_coefA_**<br>
**blockSize:** 256