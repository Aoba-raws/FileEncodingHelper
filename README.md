# FileEncodingHelper

A Powershell module which can detected encoding automatically. And can transcode file to other encoding.
It is powered by [UTF-unknown](https://github.com/CharsetDetector/UTF-unknown). Based on [Mozilla Universal Charset Detector](https://mxr.mozilla.org/mozilla/source/extensions/universalchardet/).

## Usages
``` powershell
#Get files encoding with wildcard.
Get-FileEncoding *.txt
#Convert files with wildcard.
Convert-FileEncoding *.txt -SourceEncoding "shift-jis" -NewEncoding "utf-8" -OutputWithBom
#Auto detect and convert
Get-FileEncoding *.txt | Convert-FileEncoding -NewEncoding "utf-8" -OutputWithBom
```