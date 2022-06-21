param (
	$operation='help',
	$certName,
	$folderPath,
	$filter="*"
)

function error {
	param (
		$errorMSG='Something went wrong!'
	)
	write-host "ERROR! " -ForegroundColor Red -NoNewline
	write-host $errorMSG -ForegroundColor Red
	write-host ""
	write-host "Please read the documentation by running this file without any parameters."
	write-host ""
	write-host "Syntax: .\CodeSign.ps1 -operation <[Sign]/[Create]> -certName <Certificate Name> -folderPath <Folder Path> -filter <filter>"
	exit
}

function help {
	start https://github.com/eaaasun/CodeSigner
}

if ( $operation -eq 'sign') {
	if ( $certName -eq $null -or $folderPath -eq $null ) {
		error -errorMSG 'Missing parameters for script signing!'
	}

	$codeCertificate = Get-ChildItem Cert:\LocalMachine\My | Where-Object {$_.Subject -eq "CN=$($certName)"}

	if ( $codeCertificate -eq $null ) {
		error -errorMSG 'Certificate not found! Create a certificate or check the spelling of the certificate.'
	}
	# https://stackoverflow.com/questions/13126175/get-full-path-of-the-files-in-powershell
	$scripts=Get-ChildItem $folderPath -Filter "$($filter).ps1" | % { $_.FullName }
	foreach ( $script in $scripts ) {
		Set-AuthenticodeSignature -FilePath $script -Certificate $codeCertificate -TimeStampServer http://timestamp.digicert.com
	}
} elseif ( $operation -eq 'create') {
	if ( $certName -eq $null ) {
		error -errorMSG 'Missing certificate name!'
	}
	# https://adamtheautomator.com/how-to-sign-powershell-script/
	$authenticode = New-SelfSignedCertificate -Subject $certName -CertStoreLocation Cert:\LocalMachine\My -Type CodeSigningCert
	$rootStore = [System.Security.Cryptography.X509Certificates.X509Store]::new("Root","LocalMachine")
	$rootStore.Open("ReadWrite")
	$rootStore.Add($authenticode)
	$rootStore.Close()
	$publisherStore = [System.Security.Cryptography.X509Certificates.X509Store]::new("TrustedPublisher","LocalMachine")
	$publisherStore.Open("ReadWrite")
	$publisherStore.Add($authenticode)
	$publisherStore.Close()

} else {
	help
}