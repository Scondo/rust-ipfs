$myname = $MyInvocation.InvocationName
if (!(Test-Path "./package.json")){
  Write-Error "Please run $myname from the conformance subdirectory"
  Exit
}
if ((Test-Path "./node_modules")){
  Write-Error "Directory exists already: node_modules/"
  Exit
}

# production will skip the dev dependencies
npm install --production

if ((Test-Path "./patches")){
    # Use name p.exe instead of patch.exe as name patch invoke UAC
    if (!(Test-Path "./p.exe")){
        # get gnu patch
        # TODO: rework to in-memory zip
        Write-Host "Get GNU patch utility"
        Invoke-WebRequest 'https://sourceforge.net/projects/gnuwin32/files/patch/2.5.9-7/patch-2.5.9-7-bin.zip'-OutFile 'patch.zip' -UserAgent [Microsoft.PowerShell.Commands.PSUserAgent]::FireFox
        Add-Type -Assembly System.IO.Compression.FileSystem
        $zip = [IO.Compression.ZipFile]::OpenRead('patch.zip')
        $zip.Entries | where {$_.Name -like '*patch.exe'} | foreach {[System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, "p.exe", $true)}
        $zip.Dispose()
    }
    Write-Host "Applying patches..."
    $files = Get-ChildItem "patches"
    foreach ($f in $files){
        # as we want to apply the patches create in a js-ipfs checkout to our node_modules
        # we'll need to remove a few leading path segments to match
        # a/packages/interface-ipfs-core/src/refs.js to node_modules/interface-ipfs-core/src/refs.js

        $fp = $f.FullName
        Write-Host "Applying $fp"
        Get-Content $fp | ./p.exe -d node_modules/ -p1
    }
}