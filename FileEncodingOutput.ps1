class FileEncodingOutput {
    [string]$Path;
    $Detected;
    $Details;
    FileEncodingOutput([string]$fullname, $output) {
        $this.Path = $fullname;
        $this.Detected = $output.Detected;
        $this.Details = $output.Details;
    }
}