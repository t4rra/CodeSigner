param (
	$operation='help',
	$certName,
	$folderPath,
	$filter
)

function error {
	write-host "Error! Something you entered isn't correct. Please  " -ForegroundColor Red
	write-host ".\CodeSign.ps1 [-operation] [Help/Sign/Create] [-certName] <Certificate Name> [-folderPath] <Folder Path>" -ForegroundColor Red
	exit
}

function help {
	start https://github.com/eaaasun/CodeSign
}

if ( $operation -eq 'sign') {
	if ( $certName -eq $null -or $folderPath -eq $null ) {
		error
	}

	$codeCertificate = Get-ChildItem Cert:\LocalMachine\My | Where-Object {$_.Subject -eq "CN=$($certName)"}

	if ( $codeCertificate -eq $null ) {
		write-host "Certificate could not be found. Please create a certificate or check that your certificate name is spelled correctly."
		exit
	}
	# https://stackoverflow.com/questions/13126175/get-full-path-of-the-files-in-powershell
	$scripts=Get-ChildItem $folderPath -Filter *.ps1 | % { $_.FullName }
	foreach ( $script in $scripts ) {
		Set-AuthenticodeSignature -FilePath $script -Certificate $codeCertificate -TimeStampServer http://timestamp.digicert.com
	}
} elseif ( $operation -eq 'create') {
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
	start https://github.com/eaaasun/CodeSigner
}