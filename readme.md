# Powershell Code Signer <!-- omit in toc -->
Command-line tool that creates a certificate and signs powershell scripts. 
> This is not intended for production use as it only creates a self-signed certificate.

### Table of Contents
- [Installation](#installation)
- [Usage](#usage)
	- [Options](#options)
- [Example](#example)
	- [Setup](#setup)
	- [Example 1](#example-1)
	- [Example 2](#example-2)
	- [Example 3](#example-3)

## Installation
1. Create an empty powershell script. (ex. `signer.ps1` created in the desktop directory)
2. Copy-paste contents of CodeSign.ps1 from the repository and paste into the script created previously.
	> Important: Do not download the script from the repository. Ironically enough, that script will not be trusted by Windows. Windows won't block the file if done according to these instructions.
3. Profit!
## Usage
> Values with spaces need to be wrapped in quotes.
### Options
| Parameter | Explanation | Example Value |
|---|---|---|
| `-operation` | Operation that will be done. Only `sign` or `create`, all else will open the Github repo. | `sign` |
| `-certName` | Name of the certificate. If signing, use the name of a previously created certificate. If creating, use any name. | `'calculator project'` |
| `-folderPath` | Path to the folder containing Powershell scripts. | `D:\Projects\Code\Calculator` |
| `-recurse` | Sign files in subdirectories too. | |
| `-filter` | Filename filter. Wildcards are supported. Defaults to `*`. Note: do not include a file extension, as this only works with powershell scripts so the extension is included already. | `*` |
## Example
### Setup
Folder structure:
```
├── Code
│   ├── Calculator
│   │   ├── README.MD
│   │   ├── output.txt
│   │   ├── calc_script.ps1
│   │   ├── modules
│   │   │   ├── calc_module.ps1
│   │   │   ├── calc_module2.ps1
│   │   ├── debug.ps1
│   ├── signer.ps1
```


### Example 1
**This command will create a certificate called 'calculator project'**

`.\signer.ps1 -operation create -certName 'calculator project'`
> Only the operation and certName parameters are required for creating a certificate.

> Result: A certificate called 'calculator project' is created.

### Example 2
**This command will sign all powershell scripts in the `Calculator` folder but not in subdirectories.**

`.\signer.ps1 -operation sign -certName 'calculator project' -folderPath '.\Calculator'`
> There is no need for the filter parameter as the default filter is `*`.

> Result: `calc_script.ps1` and `debug.ps1` are signed.

### Example 3
**This command will sign all powershell scripts prefixed with calc_**

`.\signer.ps1 -operation sign -certName 'calculator project' -folderPath '.\Calculator' -recurse -filter calc_*`
> Everything in the desktop that matches the filter is signed, including scripts in subdirectories because of the `-recurse` flag.

> Result: `calc_script.ps1`, `calc_module.ps1`, and `calc_module2.ps1` are signed.
