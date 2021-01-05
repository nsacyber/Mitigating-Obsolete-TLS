# The following PowerShell® command on on 
#    disable SSL 2.0, SSL 3.0, TLS 1.0, TLS 1.1 and enabling TLS 1.2
#    and setting Cipher Suite for Interoperability
# was derived from the following Microsoft® Web Documentation

# Microsoft, "Managing SSL/TLS Protocols and Cipher Suites for AD FS," Microsoft, 31 May 2017. 
# [Online]. Available: 
# https://docs.microsoft.com/en-us/windows-server/identity/ad-fs/operations/manage-ssl-protocols-in-ad-fs. 
# [Accessed 15 Dec 2020].
#
# PowerShell® is a registered trademark of Microsoft Corporation.
# Microsoft® is a registered trademark of Microsoft Corporation.

function SetProtocol {

# Require two parameters
# First Parameter Protocol Name
# Second Parameter is 'enable' 'disable'

   param(
       [Parameter(Mandatory=$true)]
       [ValidateSet('SSL 2.0', 'SSL 3.0', 'TLS 1.0', 'TLS 1.1', 'TLS 1.2')]
       [string]$Protocol,
       [Parameter(Mandatory=$true)]
       [ValidateSet('enable','disable')]
       [string]$SetProtocolState
   )

   $SCHANNELStr = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\'
   $ServerStr = $SCHANNELSTR + $Protocol + '\Server'
   $ClientStr = $SCHANNELSTR + $Protocol + '\Client'


# Create new registry key if required for the protocol
   
   New-Item $ServerStr -Force | Out-Null
   New-Item $ClientStr -Force | Out-Null

# If protocol is enabled.
   if ($SetProtocolState -eq 'enable') {
       $EnabledValue = '1'
       $DisabledByDefaulValue = '0'
   } else {

# If protocol is disabled.
       $EnabledValue = '0'
       $DisabledByDefaulValue = '1'
   }

# Set registry property for appropriate protocol registry key
   New-ItemProperty -path $ServerStr -name 'Enabled' -value $EnabledValue -PropertyType 'DWord' -Force | Out-Null
   New-ItemProperty -path $ServerStr -name 'DisabledByDefault' -value $DisabledByDefaulValue -PropertyType 'DWord' -Force | Out-Null   
   New-ItemProperty -path $ClientStr -name 'Enabled' -value $EnabledValue -PropertyType 'DWord' -Force | Out-Null
   New-ItemProperty -path $ClientStr -name 'DisabledByDefault' -value $DisabledByDefaulValue -PropertyType 'DWord' -Force | Out-Null   
   
   Write-Host $Protocol 'has been' $SetProtocolState '.'

}

# Disable SSL 2.0, SSL 3.0, TLS 1.0, TLS 1.1 and only enable TLS 1.2
SetProtocol -Protocol 'SSL 2.0' -SetProtocol 'disable'
SetProtocol -Protocol 'SSL 3.0' -SetProtocol 'disable'
SetProtocol -Protocol 'TLS 1.0' -SetProtocol 'disable'
SetProtocol -Protocol 'TLS 1.1' -SetProtocol 'disable'
SetProtocol -Protocol 'TLS 1.2' -SetProtocol 'enable'

# Set Cipher Suite for CNSA
# Set ECC for CNSA

#Cipher Suites Path
$CipherSuitesPathStr = 'HKLM:\SYSTEM\CurrentControlSet\Control\Cryptography\Configuration\Local\SSL\00010002'
$CipherValue = ('TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384',
                'TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384',
                'TLS_DHE_RSA_WITH_AES_256_GCM_SHA384',
                'TLS_RSA_WITH_AES_256_GCM_SHA384',
                'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384',
                'TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256',
                'TLS_DHE_RSA_WITH_AES_128_GCM_SHA256',
                'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256',
                'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA',
                'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA') 

$EccCurvesValue = ('secP384r1','secP521r1','secP224r1')

# Ciphers: 
#   TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384 (not supported)
#   
#   does not seem supported by Microsoft Windows
#   but not harmful and maybe useful if added in later.

New-Item $CipherSuitesPathStr -Force | Out-Null
New-ItemProperty -path $CipherSuitesPathStr -name 'Functions' -value $CipherValue -PropertyType MultiString -Force | Out-Null
New-ItemProperty -path $CipherSuitesPathStr -name 'EccCurves' -value $EccCurvesValue -PropertyType MultiString -Force | Out-Null

# Enable TLS 1.2 for .NET Framework 3.5/4.0/4.5.x applications
New-ItemProperty -path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v2.0.50727' -name 'SchUseStrongCrypto' -value '1' -PropertyType 'DWord' -Force | Out-Null
New-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319' -name 'SchUseStrongCrypto' -value '1' -PropertyType 'DWord' -Force | Out-Null

Write-Host -ForegroundColor red "***** WARNING *****"
Write-Host -ForegroundColor red "!!! System Reboot Required For Any Changes To Take Effect"
Write-Host -ForegroundColor red "***** WARNING *****"

