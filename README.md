# Mitigating Obsolete TLS

This repository contains a number of tools, signatures, and configurations to help networks detect and remediate the use of obsolete TLS. More information about this topic is available in NSA guidance on **Obsolete Transport Layer Security (TLS) Protocol Detection and Remediation** at https://www.nsa.gov/cybersecurity-guidance. 

## Background

Encryption protocols, such as Transport Layer Security (TLS) and Secure Sockets Layer (SSL), provide data protection as it travels through a network. However, older versions of these protocols become obsolete as technology changes and vulnerabilities surface. Network connections employing obsolete encryption protocols are at an elevated risk of exploitation and decryption. As a result, all systems should detect and remediate the use of deprecated forms of encryption for TLS and SSL protocols.

See the [TLS background information page](./TLS%20background%20information.md) for more information.

## Detecting Obsolete TLS

This section describes different methods of detecting obsolete TLS.

###  Scanning Tools
Comprehensive analysis of servers can be performed by attempting to initiate weak TLS sessions using custom tools and seeing if the server agrees to utilize obsolete cryptography. There are a number of open source tools and commercial services available that can perform active scans to detect non-compliant TLS versions, cipher suites, and key exchanges. 
The following example tools claim to be able to scan for obsolete cryptography. These tools and services are listed as examples, and are not recommended, endorsed, or certified for any use. 
*	https://github.com/18F/domain-scan - a scanner from GSA 18F to orchestrate scanning tools at scale. Can use the https://github.com/nabla-c0d3/sslyze Python package to scan for and report use of obsolete cryptography.
*	https://pentest-tools.com/network-vulnerability-scanning/ssl-tls-scanner
*	http://ssllabs.com/ssltest 
*	https://gf.dev/tls-scanner
*	https://github.com/prbinu/tls-scan
*	https://www.thesslstore.com/ssltools/ssl-checker.php
*	https://www.wormly.com/test_ssl
*	https://www.digicert.com/help/
*	https://www.hardenize.com/
*	https://www.tenable.com/plugins/was/families/SSL%2FTLS for use with Tenable software.

### SNORT Rules
The provided SNORT rules are alerting rules. Investigation for accuracy is required for hits. The rules have been tested, but every system can be configured differently, so ensure that the signature is triggered properly or is adjusted as needed based on the sensors and the environment.

See the [SNORT Rules page](./snort/README.md) for more information.

## Detecting Secure TLS

See the [SNORT Rules page](./snort/README.md) for more information.

## Secure TLS Web Server Configurations

* [Apache HTTP Server](./webserver/apache-tls.txt)
* [Microsoft Internet Information Services](./webserver/iis-tls.txt)
* [NGINX](./webserver/nginx-tls.txt)
* [Node.js](./webserver/nodejs-tls.txt)

## License

See [LICENSE](./LICENSE.md).

## Contributing

See [CONTRIBUTING](./CONTRIBUTING.md).

## Disclaimer

See [DISCLAIMER](./DISCLAIMER.md).
