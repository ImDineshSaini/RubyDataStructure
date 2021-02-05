/* File: CN_Dev&Prod.pac */
 
function FindProxyForURL(url, host)
{
    /*
     * Don't proxy Oracle corporate sites
     */
    if(dnsDomainIs(host, "oracle.com"))
	return "DIRECT";
    if(dnsDomainIs(host, "oraclecorp.com"))
	return "DIRECT";
    /*
     * Proxy Production Ashburn VCN hosts to local port 5556
     */
    if(isInNet(host, "10.19.224.0", "255.255.240.0"))
	return "SOCKS5 localhost:5556";
    /*
     * Proxy Production Frankfurt VCN hosts to local port 5556
     */
    if(isInNet(host, "100.122.0.0", "255.255.240.0"))
	return "SOCKS5 localhost:5556";
    /*
     * Proxy Production Phoenix VCN hosts to local port 5556
     */
    if(isInNet(host, "100.122.16.0", "255.255.240.0"))
	return "SOCKS5 localhost:5556";
    /*
     * Proxy Production London VCN hosts to local port 5556
     */
    if(isInNet(host, "100.122.96.0", "255.255.240.0"))
	return "SOCKS5 localhost:5556";
    /*
     * Proxy Production Sydney (SYD) VCN hosts to local port 5556
     */
    if(isInNet(host, "10.2.0.0", "255.255.0.0"))
    return "SOCKS5 localhost:5556";

    /*
     * Proxy Production Toronto (YYZ) VCN hosts to local port 5556
     */
    if(isInNet(host, "100.122.112.0", "255.255.240.0"))
    return "SOCKS5 localhost:5556";

    /*
     * Proxy Production Tokyo (NRT) VCN hosts to local port 5556
     */
    if(isInNet(host, "10.6.0.0", "255.255.0.0"))
        return "SOCKS5 localhost:5556";

    /*
     * Proxy Development v2 VCN hosts to local port 5555
     */
    if(isInNet(host, "10.19.240.0", "255.255.240.0"))
	return "SOCKS5 localhost:5555";
    if(isInNet(host, "10.19.208.0", "255.255.240.0"))
	return "SOCKS5 localhost:5555";
    /*
     * Proxy Devcorp Phoenix VCN hosts to local port 5555
     */
    if(isInNet(host, "100.122.64.0", "255.255.240.0"))
	return "SOCKS5 localhost:5555";
    /*
     * Don't proxy hosts that match IP address pattern
     */
    if(/^(?!0)(?!.*\.$)((1?\d?\d|25[0-5]|2[0-4]\d)(\.|$)){4}$/.test(host))
	return "DIRECT";
    /*
     * Proxy hosts in the CNE DNS domain to local port 5555
     */
    if(dnsDomainIs(host, "oraclecne"))
	return "SOCKS5 localhost:5555";
    /*
     * Proxy DNS hosts in the OCI Prod Ashburn VCN domain to local port 5556
     */
    if(dnsDomainIs(host, "vcniadcneprd.oraclevcn.com"))
	return "SOCKS5 localhost:5556";
    /*
     * Proxy DNS hosts in the OCI Prod Frankfurt VCN domain to local port 5556
     */
    if(dnsDomainIs(host, "vcnfracneprd.oraclevcn.com"))
	return "SOCKS5 localhost:5556";
    /*
     * Proxy DNS hosts in the OCI Prod London VCN domain to local port 5556
     */
    if(dnsDomainIs(host, "vcnlhrcneprd.oraclevcn.com"))
	return "SOCKS5 localhost:5556";
    /*
     * Proxy DNS hosts in the OCI Prod Phoenix VCN domain to local port 5556
     */
    if(dnsDomainIs(host, "vcnphxcneprd.oraclevcn.com"))
	return "SOCKS5 localhost:5556";

    /*
     * Proxy DNS hosts in the OCI Prod Sydney (SYD) VCN domain to local port 5556
     */
    if(dnsDomainIs(host, "vcnsydcneprd.oraclevcn.com"))
    return "SOCKS5 localhost:5556";

    /*
     * Proxy DNS hosts in the OCI Prod Toronto (YYZ) VCN domain to local port 5556
     */
    if(dnsDomainIs(host, "vcnyyzcneprd.oraclevcn.com"))
    return "SOCKS5 localhost:5556";

    /*
     * Proxy DNS hosts in the OCI Prod Tokyo (NRT) VCN domain to local port 5556
     */
    if(dnsDomainIs(host, "vcnnrtcneprd.oraclevcn.com"))
    return "SOCKS5 localhost:5556";

    /*
     * Proxy DNS hosts in the OCI Dev Phoenix VCN domain to local port 5555
     */
    if(dnsDomainIs(host, "vcnphxcnedev.oraclevcn.com"))
	return "SOCKS5 localhost:5555";
    /*
     * Proxy DNS hosts in the OCI Devcorp Phoenix VCN domain to local port 5555
     */
    if(dnsDomainIs(host, "vcnphxcnedvcdev.oraclevcn.com"))
	return "SOCKS5 localhost:5555";
    /*
     * Send all other hosts to the Oracle corporate proxy server
     */
    return "PROXY www-proxy-adcq7-new.us.oracle.com:80; DIRECT;";
}
