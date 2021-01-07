# Mitigating Obsolete TLS

This repository lists a number of tools, SNORT signatures, and web server configurations to help network owners detect and remediate the use of obsolete TLS. More information is available in NSA Cybsecurity Information Sheet (CSI) **Eliminating Obsolete Transport Layer Security (TLS) Protocol Configurations**:

* [Press release](https://www.nsa.gov/News-Features/Feature-Stories/Article-View/Article/2462345/nsa-releases-eliminating-obsolete-transport-layer-security-tls-protocol-configu/)
* [Infographic](https://media.defense.gov/2021/Jan/05/2002560126/-1/-1/0/ELIMINATING%20OBE%20TLS%20INFOGRAPHIC.PDF/ELIMINATING%20OBE%20TLS%20INFOGRAPHIC.PDF)
* [CSI](https://media.defense.gov/2021/Jan/05/2002560140/-1/-1/0/ELIMINATING_OBSOLETE_TLS_UOO197443-20.PDF)

## Background

Encryption protocols, such as Transport Layer Security (TLS) and Secure Sockets Layer (SSL), provide data protection as it travels through a network. However, older versions of these protocols become obsolete as technology changes and vulnerabilities surface. Network connections employing obsolete encryption protocols are at an elevated risk of exploitation and decryption. As a result, all systems should detect and remediate the use of deprecated forms of encryption for TLS and SSL protocols.

See the TLS [background information page](./Background%20Information.md) for more information.

## TLS Scanning and Configuration Tools

Note that these tools and services are listed as examples, and are not recommended, endorsed, or certified for any use.

### Scanning Tools

Comprehensive analysis of servers can be performed by attempting to initiate weak TLS sessions using custom tools and seeing if the server agrees to utilize obsolete cryptography. There are a number of open source tools and commercial services available that can perform active scans to detect non-compliant TLS versions, cipher suites, and key exchanges.
The following example tools claim to be able to scan for obsolete cryptography.

* https://github.com/18F/domain-scan - a scanner from GSA 18F to orchestrate scanning tools at scale. Can use the https://github.com/nabla-c0d3/sslyze Python package to scan for and report use of obsolete cryptography.
* https://pentest-tools.com/network-vulnerability-scanning/ssl-tls-scanner
* http://ssllabs.com/ssltest
* https://gf.dev/tls-scanner
* https://github.com/prbinu/tls-scan
* https://www.thesslstore.com/ssltools/ssl-checker.php
* https://www.wormly.com/test_ssl
* https://www.digicert.com/help/
* https://www.hardenize.com
* https://www.tenable.com/plugins/was/families/SSL%2FTLS for use with Tenable software.
* https://github.com/drwetter/testssl.sh

### Configuration Tools

The following example tools can assist, in addition to this repository, in creating server configuration files using compliant TLS versions, cipher suites, and key exchanges.

* https://ssl-config.mozilla.org

### SNORT Rules

The provided SNORT rules are alerting rules. Investigation for accuracy is required for hits. The rules have been tested, but every system can be configured differently, so ensure that the signature is triggered properly or is adjusted as needed based on the sensors and the environment.

See [SNORT rules](./snort/) readme and text files for more information.

## Detecting Secure TLS

See [SNORT rules](./snort/) for more information.

## Secure TLS Web Server Configurations

See [web server configuration](./webserver/) readme and text files for more information.

## License

See [LICENSE](./LICENSE.md).

## Contributing

See [CONTRIBUTING](./CONTRIBUTING.md).

## Disclaimer

See [DISCLAIMER](./DISCLAIMER.md).
