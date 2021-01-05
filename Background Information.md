# Background Information

The page provides additional background information related to TLS

## TLS General Packet Structure and Deprecated TLS Version Identification

TLS packets have a basic structure for all transaction types. Byte evaluation is required to identify the use of deprecated TLS versions. Remediation is to update server and client configurations. If updates do not solve the problem, blocking can be considered until remediation can be completed.

### General TLS Packet Construction

This is the general format for all TLS packets:

![TLS Packet Data Structure](/.figures/tls%20packet%20data%20structure.png)

### Identifying handshake messages

The Message Type can have several different values for the transaction type that is occurring. For purposes of this document, look for hex value 0x16 to be present in byte 0 of the packet's application data, symbolizing the Handshake transaction. The TLS record version being used is then identified with the Major and Minor Version bytes (1 and 2) within the TLS application packet. For TLS 1.0 through TLS 1.2, the record version may not indicate the TLS version supported for either the client or the server and should not be used for identifying obsolete TLS versions. For TLS 1.3, the record version may indicate either TLS 1.3 or TLS 1.2 and is not useful for distinguishing the negotiated TLS version

![Example Hex Dump of TLS Header](/.figures/example%20hex%20dump%20of%20tls%20header.png.png)

## TLS Handshake Transaction Packet Structure

Handshake TLS packets are seen during the initial set-up of a TLS communication. These packets include hello_request, client_hello, server_hello, certificate, server_key_exchange, certificate_request, server_hello_done, certificate_verify, client_key_exchange, and finished. Byte evaluation is required to identify the use of deprecated cipher suites. 

### TLS Handshake Packet Construction

The Handshake transaction includes additional features that need to be analyzed, including the client's supported TLS version and the server's selected TLS version. The overall structure is similar to the general TLS header.

![TLS Handshake Packet Data Structure.png](./figures/tls%20handshake%20packet%20data%20structure.png)

### Byte Specifications for Identification 

Bytes 0 thru 4 are considered the Record Header and function as described in Appendix A Section 1. Byte 0 should be hex 0x16 for the Handshake Transaction and bytes 1 and 2 will identify the record version. Bytes 5 thru 8 are the Handshake Header. Byte 5 has varying hex values to indicate what part of the Handshake is being performed, such as, 0x01 for client_hello, 0x02 for server_hello, etc. These values can be found on the IANA TLS table (iana.org/assignments/tls-parameters/tls-parameters.xhtml) Section TLS HandshakeType in decimal format. Utilize a decimal to binary calculator to convert if needed. Bytes 6 thru 8 represent the length of the message that follows, example from below is [00 00 AD]. Utilizing a decimal to binary calculator, [00 00 AD] = 173 bytes. The following identified bytes break out differently depending on the Handshake type, explained in the respective Appendices within this document.

![Example Hex Dump of Handshake Header Information.png](./figures/example%20hex%20dump%20of%20handshake%20header%20information.png)

## Client_hello Message within TLS Handshake Transaction Structure and Identification 

Client_hello messages allow administrators and network analysts to identify the TLS version supported by the client, and all cipher suites a client can use to initiate and complete a transaction. This does not indicate a choice for use, only what is available by the client. Client_hello messages are part of the Handshake types for TLS transactions. Byte evaluation is required to identify the use of obsolete versions or cipher suites. The proper remediation is to update client configurations. If updates do not solve the problem, blocking can be considered until remediation can be completed.

### Client_hello Message within TLS Handshake Byte Specification

The client_hello message is identified by hex 0x01 in byte 5 of the packet. Byte 9 and 10 identify the highest (legacy) version of TLS the client can use. Bytes 9 and 10 should not be listed in Table 5 of Appendix F. If they are, the client is obsolete and should be updated or reconfigured. Note that TLS 1.3 redefines this field as the legacy version and sets it to '03 03' (TLS 1.2). If it is necessary to distinguish TLS 1.2 from TLS 1.3, additional fields must be considered. Bytes 11 thru 42 are random data (the nonce) generated and sent by the client. Byte 43 will indicate whether there is a session id specified by giving the length of bytes for the id. In the example below, the session id length is 0x00 which means no additional bytes need to be passed over to find the cipher suites that the client has available. If that byte has a value, jump that many bytes starting from byte 44 (call this location m). Byte m and m+1 give the length of bytes that have the available cipher suites in order of client precedence (call this length p). All byte pairs starting at m+2 to the length of p are where the hex values for unauthorized cipher suites may appear. The list of these cipher suites is found in Appendix F Table 6. If all cipher suites supported are included in Appendix F Table 6, the client is obsolete and should be updated or reconfigured. Inclusion of TLS 1.3 cipher suites values is consistent with, but does not confirm support for TLS 1.3. 

![Example Hex Dump of client_hello](./figures/example%20hex%20dump%20of%20client_hello.png)

## Server_hello Message within TLS HandshakeTransaction Structure and Identification

Server_hello messages allow administrators and network analysts to identify the cipher suite a server chose from the list a client provided in the client_hello to be used for the TLS communication. Server_hello messages are part of the Handshake types for TLS transactions. Byte evaluation is required to identify the use of deprecated cipher suites. Remediation is to update server and/or any proxy or TLS termination points to ensure proper configurations. If updates do not solve the problem, blocking can be considered until remediation can be completed.

### Server_hello Message within TLS Handshake Byte Specification

The Handshake transaction structure is explained in Appendix B. This Appendix is to explain how the server_hello type within the TLS Handshake Packet is to be interpreted.
The server_hello message is identified by hex 0x02 in byte 5 of the packet. Byte 9 and 10 identify the TLS (legacy) version chosen for the communication. Bytes 9 and 10 should not be listed in Table 1 of Appendix F. If they are, the server is obsolete and should be updated or reconfigured. Bytes 11 thru 42 are random data generated and sent by the server. Byte 43 will indicate whether there is a session id specified by giving the length of bytes for the id. In the example below, the session id length is 0x20 which means 32 bytes need to be passed over to find the cipher suite that the server has chosen for the communication. If that byte has a different value, convert to decimal and jump that many bytes starting from byte 44 (call this location m). Byte m and m+1 give the hex value of the cipher suite chosen for the communication. The list of obsolete cipher suites is found in Appendix F Table 6; if the server selects one of these versions it is obsolete and should be updated or reconfigured. A cipher suite associated to TLS 1.3 is a strong indicator that TLS 1.3 has been selected. To determine TLS 1.3 unambiguously, additional processing of the rest of the server hello is required. Appendix F Table 7 holds cipher suite values that require an additional check on the key length or curve value.

![example hex dump of server_hello](./figures/example%20hex%20dump%20of%20server_hello.png)

## Key Exchange Handshake Messages

The server_key_exchange message in TLS 1.2 and below is identified by hex 0x0c in the Handshake protocol, while the client_key_exchange message is identified by hex 0x10. For all three types of key exchanges, RSA, DH/DHE, and ECDH/ECDHE, the byte structure is different. For TLS 1.3, the key exchange information is available in the Supported Groups and Key Share extensions of the client and server hello messages. Writing rules for this data is beyond simple implementation. Due to this, it is recommended to utilize network analysis tools already in use or one from a variety of open source options

## Obsolete TLS Versions and Cipher Suites

The obsolete TLS versions to search for are in bytes 9 and 10 of the TLS client_hello and server_hello Handshake packets are listed below within the table.

Field | Name | Hex Values | Source
------------ | ------------- | ------------- | -------------
TLS Version | SSL 2.0 | 00 02 | SSL and TLS Essentials page 110
TLS Version | SSL 3.0 | 03 00 | SSL and TLS Essentials page 110
TLS Version | TLS 1.0 | 03 01 | RFC 2246
TLS Version | TLS 1.1 | 03 02 | RFC 4346

## Obsolete TLS Cipher Suites

The following table indicates the hex values for cipher suites that use the obsolete algorithm in column 2 within the KeyExchangeAlgorithm or EncryptionAlgorithm section.

Field | Name | Hex Values  
------------ | ------------- | ------------- 
Cipher Suite | NULL | '00 00', '00 01', '00 02', '00 2C', '00 2D', '00 2E', '00 3B', '00 B0', '00 B1', '00 B4', '00 B5', '00 B8', '00 B9', 'C0 01', 'C0 06', 'C0 0B', 'C0 10', 'C0 15', 'C0 39', 'C0 3A', 'C0 3B' 
Cipher Suite | EXPORT | '00 03', '00 06', '00 08', '00 0B', '00 0E', '00 11', '00 14', '00 17', '00 19',  '00 26', '00 27', '00 28', '00 29', '00 2A', '00 2B'
Cipher Suite | ANON | '00 17', '00 18', '00 19', '00 1A', '00 1B', '00 34', '00 3A', '00 46', '00 6C', '00 6D', '00 89', '00 9B', '00 A6', '00 A7', '00 BF', '00 C5', 'C0 15', 'C0 16', 'C0 17', 'C0 18', 'C0 19', 'C0 46', 'C0 47', 'C0 5A', 'C0 5B', 'C0 84', 'C0 85' 
Cipher Suite | RC2 | '00 06', '00 27', '00 2A'
Cipher Suite | RC4 | '00 03', '00 04', '00 05', '00 17', '00 18', '00 20', '00 24', '00 28', '00 2B',  '00 8A', '00 8E', '00 92', 'C0 02', 'C0 07', 'C0 0C', 'C0 11', 'C0 16', 'C0 33'
Cipher Suite | DES | '00 08', '00 09', '00 0B', '00 0C', '00 0E', '00 0F', '00 11', '00 12', '00 14', '00 15', '00 19', '00 1A', '00 1E', '00 22', '00 26', '00 29' 
Cipher Suite | IDEA | '00 07', '00 21', '00 25' 
Cipher Suite | TDES/3DES | '00 0A', '00 0D', '00 10', '00 13', '00 16', '00 1B', '00 1F', '00 23', '00 8B', '00 8F', '00 93', 'C0 03', 'C0 08', 'C0 0D', 'C0 12', 'C0 17', 'C0 1A', 'C0 1B', 'C0 1C', 'C0 34'

These values can be found on the IANA TLS table (iana.org/assignments/tls-parameters/tls-parameters.xhtml)

## TLS Cipher Suites needing a Key Size Check

The following table indicates the hex values for cipher suites containing RSA, DH/DHE, or ECDH/ECDHE. While not all of these cipher suites are in compliance with NIST or NSA guidance, they are not considered obsolete and may be commonly encountered when interoperating with entities not required to follow federal standards.  For these cipher suites, there is an additional check required to ensure the key length is not weak. RSA, DH/DHE or ECDH/ECDHE will appear as the first acronym after "TLS_ ". If cipher suites not on this list and not explicitly authorized are encountered, it is appropriate to investigate the reason for the unusual traffic.

Field | Name | Hex Values 
------------ | ------------- | ------------- 
Cipher Suite | RSA | '00 2F', '00 35', '00 3C', '00 3D', '00 94', '00 95', '00 9C', '00 9D', '00 AC', '00 AD', '00 B6', '00 B7', 'C0 9C', 'C0 9D', 'C0 A0', 'C0 A1', 'CC AE' 
Cipher Suite | DH | '00 31', '00 37', '00 3F', '00 69', '00 A0', '00 A1' 
Cipher Suite | DHE | '00 33', '00 39', '00 67', '00 6B', '00 90', '00 91', '00 9E', '00 9F', '00 AA', '00 AB', '00 B2', '00 B3', 'C0 9E', 'C0 9F', 'C0 A2', 'C0 A3', 'C0 A6', 'C0 A7', 'C0 AA', 'C0 AB', 'CC AA', 'CC AD' 
Cipher Suite | ECDH | 'C0 04', 'C0 05', 'C0 0E', 'C0 0F', 'C0 25', 'C0 26', 'C0 29', 'C0 2A', 'C0 2D', 'C0 2E' 
Cipher Suite | ECDHE | 'C0 09', 'C0 0A', 'C0 13', 'C0 14', 'C0 23', 'C0 24', 'C0 27', 'C0 28', 'C0 2B', 'C0 2C', 'C0 2F', 'C0 AC', 'C0 AD', 'C0 AE', 'C0 AF', 'CC A8', 'CC A9', 'CC AC', 'D0 01', 'D0 02', 'D0 03', 'D0 05' 

These values can be found on the IANA TLS table (iana.org/assignments/tls-parameters/tls-parameters.xhtml)


The server_key_exchange message determines the elliptic curve selected for ECDH/ECDHE, and consists of two fields, indicating the curve type and the curve parameter. Any key exchange with curve type '01' or '02' is obsolete. Any key exchange message with curve type '03' (named curve) and having curve parameters 'FF01' or 'FF02' is also considered obsolete and should be blocked. No other named curves are of sufficient concern to require immediate blocking, but when reconfiguring a server, the CNSS-P 15 curve secp384r1 (curve parameter '0018') should be configured as the preferred curve.
For information on the sourcing of these hex values, refer to IANA's TLS Table at iana.org/assignments/tls-parameters/tls-parameters.xhtml. Some values in this table are decimal and must be converted to hex (or vice versa from this document to the IANA table).

## Secure  TLS Versions and Cipher Suites – Hex Values

CNSS-P 15 recommends that NSS clients and servers support TLS 1.2 or TLS 1.3. According to NIST SP 800-52rev2 (pg 8 & 33), all government systems, both server and client, SHALL be configured to use TLS 1.2 and SHOULD be configured to use TLS 1.3, so interoperability with Non-NSS government partners does not require support for obsolete TLS versions. IETF also has draft document “Deprecating TLSv1.0 and TLSv1.1” under consideration that will obsolete these versions for commercial use. 

These lists will continue to change over time as technology and circumstances change. Administrators and analysts should embrace cryptographic agility as a continual requirement and adjust cryptographic configurations and capabilities accordingly for all network hardware, software, and services. The following list is accurate as of November 1, 2020.

### Secure TLS Versions and Cipher Suites

The table below provides the list of cipher suites using CNSA recommended algorithms for TLS versions 1.2 and 1.3. At least one of these must be offered by NSS clients, and NSS servers must select them if offered. All CNSA compliant cipher suites should be supported by NSS servers. Additional cipher suites, especially those identified in NIST SP 800-52rev2 (pg. 15-19, 36, Appendix C and Appendix D), that are not deprecated can be supported for interoperability. U.S. Government systems that are not classified as NSS are recommended to also follow this guidance.

TLS Version (hex) | Chipher Suite Names (hex code) | Source
------------ | ------------- | -------------
TLS 1.2 [03 03] | TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384 [C0 2C], TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 [C0 30], TLS_DHE_RSA_WITH_AES_256_GCM_SHA384 [00 9F], TLS_RSA_WITH_AES_256_GCM_SHA384 [00 9D] | RFC 5246
TLS 1.3  [03 04] | TLS_AES_256_GCM_SHA384 [13 02] | RFC 8446 


This table consists of the CNSS-P 15 recommended key exchange groups, including an ECC curve and safe-prime finite field groups. NSS clients and servers must support recommended groups corresponding to the cipher suites they support – ECDHE cipher suites must use the recommended Elliptic Curve group and DHE cipher suites must use one of the Finite field groups. Support for additional, non-deprecated groups, especially those indicated in NIST SP 800-56Arev3, are allowed for interoperability.  U.S. Government systems that are not classified as NSS are recommended to also follow this guidance.

Field | Name | Hex Values
------------ | ------------- | -------------
Elliptic Curve Cryptography (ECC) | secp384r1 | [00 18] 
Finite Field Cryptography (FFC) | ffdhe3072 | [01 01] 
Finite Field Cryptography (FFC) | ffdhe4096 | [01 02] 