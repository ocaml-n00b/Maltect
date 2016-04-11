<h1>Entropy</h1>

<p>
This library contains the basic functions used for obtaining the entropy information of a file or set of files.
</p>

<h2>blockingByteCount</h2>
<p>
  Count the number of occurrences of each byte in every n bytes blocks of data in a file 
  and return a list of arrays with the number of observations of each byte value.<br>
  Note: List is in reverse order of blocks in file.
</p>
<p>bytes -> int -> float array list</p>
<p>
Common use Example:<br>
<code>
let bcaLst = blockingByteCount fname 256;;
</code>
Generally not used alone.
</p>

<h2>mleList</h2>
<p>
  Get Entropy from a bca float array list and block size used.
  Returns a list of floats.
  float array -> int -> float list
</p>
<p>
  Common use Example:<br>
  <code>
    let entLst =
    let bcaLst = blockingByteCount fname 256 in
    List.rev (mleList bcaLst 256);;
  </code>
  Generally not used alone.
</p>

