As rust-ipfs uses OpenSSL library it may need some extra steps on Windows to provide OpenSSL:

1) Download full pack of OpenSSL (typically you need Win64 as rust-init install x64 by default) from https://slproweb.com/products/Win32OpenSSL.html and install it. Choose to copy DLLs to the Windows system directory
2) Setup enviroment variables OPENSSL_DIR; OPENSSL_INCLUDE_DIR and OPENSSL_LIB_DIR. 
* Typically you can do this by right click on "Computer", then choose link "Advanced system settings" and button "Enviroment Variables". After that create three variables and point them to folder you install OpenSSL and it's include and lib subfolders.
* Alternatively you can use command line
 ```
set OPENSSL_INCLUDE_DIR=c:\Program Files\OpenSSL-Win64\include\
set OPENSSL_LIB_DIR=c:\Program Files\OpenSSL-Win64\lib\
set OPENSSL_DIR=c:\Program Files\OpenSSL-Win64\
 ```
3) Ok, now you can run ```cargo build --workspace```

If you expirience problems like "libcrypto.dll not found" during tests or run check if you copy DLL in Windows system directory.

For conformance test:
1) Install nodejs with npm from https://nodejs.org/en/download/
2) Run PowerShell as Administrator (e.g press Win+R, type `powershell`, press Ctrl+Shift+Enter and confirm UAC), then execute `Set-ExecutionPolicy RemoteSigned` to allow executing of local PowerShell scripts. (if you want to undo this action later check your current policy with `Get-ExecutionPolicy`)
3) Run `cargo build -p ipfs-http` for 
4) Run setup.ps1 with PowerShell. If you use cmd just run `powershell ./setup.ps1`.
