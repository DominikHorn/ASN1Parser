import XCTest
@testable import ASN1Parser

import BigInt

func createCert() -> SecCertificate? {
    let str = """
    -----BEGIN CERTIFICATE-----
    MIIGuTCCBKGgAwIBAgIQAv4qsyJpAcAUg4A9KMzh8jANBgkqhkiG9w0BAQwFADBN
    MQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xJTAjBgNVBAMT
    HERpZ2lDZXJ0IFRMUyBSU0E0MDk2IFJvb3QgRzUwHhcNMjIwNTI2MDAwMDAwWhcN
    MzIwNTI1MjM1OTU5WjBWMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQs
    IEluYy4xLjAsBgNVBAMTJVRoYXd0ZSBHNSBUTFMgUlNBNDA5NiBTSEEzODQgMjAy
    MiBDQTEwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCxmeAZITkz2kwO
    Cv3is/gHClg+Gg/+t9X6jhYR82bzdKqyv4Q4MS5z2jUGmPaXzEIhOv41lt5S59Qw
    HuURjQy/V12ycNQwUnLhMXfGhbJ62tnBX9ezRO5SdpBvpjDI4CFiLnl5V+lhPA+z
    u3Qy4CisAAllIQtmiZ9rGqHG3qwi9UhgAHvzEDMH44Bax2VvvgA+mpgV5NWomvbI
    66k7w3635iClqGsmtEFd1pqRK2lrDa/KNcu9KomQt7iuSDZA+Tl4uu8hf0F9NAya
    rr7XEHAkFxwiDK/9n7HfwVVBBlri1OhvU4DPFE7E4rBpuOXPk7L4RPwSiJMa1qIz
    5prmLIRLxuMrG3M5IqQ+W9ptYhvQLzBTvUIIzjy62GfvJ5Kq0t1AvlmKOlprsSCW
    6R5bG+yCvrIdsDcvcxJgU9ZKvtHxmC3TGhckybUyFQeLgd01cXrkJGRP0dcGzIYv
    37jW82dr4O1OvJbZnl8/b6cxIIul2fTxS0djgoW3ow7hvFu/0ZNUM5o4THMaBt6R
    I8e1F2x3XJqEwJrQegS3JYijmihgC5B/tqgwKZmXS0u42e9oMQH0yvUUBgHtVewh
    7CGAnoTlKiODy6Z8Q0TUc/dsGGD9E8h/Ecia1feKVN3okB/VOZBlOaMB4uNSBp0h
    W8XuX+5DPu+Q2P7xowU7d+YvOfj0aQIDAQABo4IBijCCAYYwEgYDVR0TAQH/BAgw
    BgEB/wIBADAdBgNVHQ4EFgQUTedvYaz6SwI1b6hXPOFOoEU8DmcwHwYDVR0jBBgw
    FoAUUTMc7TZArxfTJc1paPKvTiM+s0EwDgYDVR0PAQH/BAQDAgGGMB0GA1UdJQQW
    MBQGCCsGAQUFBwMBBggrBgEFBQcDAjB6BggrBgEFBQcBAQRuMGwwJAYIKwYBBQUH
    MAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBEBggrBgEFBQcwAoY4aHR0cDov
    L2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VExTUlNBNDA5NlJvb3RHNS5j
    cnQwRgYDVR0fBD8wPTA7oDmgN4Y1aHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0Rp
    Z2lDZXJ0VExTUlNBNDA5NlJvb3RHNS5jcmwwPQYDVR0gBDYwNDALBglghkgBhv1s
    AgEwBwYFZ4EMAQEwCAYGZ4EMAQIBMAgGBmeBDAECAjAIBgZngQwBAgMwDQYJKoZI
    hvcNAQEMBQADggIBAJf6PrJL7qiaZMBzTjmxEHA/9so1c3NtkaPAj8Toch+wvTLQ
    AZiAAvwghHLeWsEWAzDUy1B49RT1dsvAhjN11+x6G++enasPPoLRGuPYMbUHkFzd
    bodY5Dk4VZeYi59xmaGHLi018RlcZ8sOaHan04YDBWWdfARo+lFtyiVNrZFiRYCw
    ScWIon5sWfNskdGQ/mk/H3cv3zubEx1vHpRSO+y2l6Sxd0Au8XTyrQDCfBQp8GKl
    GQKISsRDbqFwAVNsFGOGFJ26DoHRNTTyuVnaLkGs39BywBi+sT1hsdCQFIC3bvjl
    u2vsdhJoXYtxDDCKvgrRd8Ny7ovJv2MHbvf8SWc6uRwtrl0uR6SNQ3bPy+SxXlnK
    /w4VO2267GuRcmwCgkOwK6aWbp6/OEZ2xJg1pKKORLvKvaUDhb8Mk3bYwF82dtcq
    zRpn1Nk6oCJYUXI3eTAOyfStX70gpm17nE6l0yM/oANqVPxeCXe1/iW0SyjNGLtD
    DcRvprkh7xONHXG7dCUlUoqjnvVxxV9isbbRiA3z2BVHckb4thxzd5tK8ntdkSyC
    efO5mbV6kofpFMJgXCsfs1CilJrfSdPHMTx407z9id0N2L6dcroY77eqE8jylZad
    ktJ5nIuziadSasnep+ltgHbQSU1JTFUah1RT/E9ke9rFy1sfFeXpdLLmT7a7
    -----END CERTIFICATE-----
    """
    
    // cleanup string to get plain base64 coded data
    var pemWithoutHeaderFooterNewlines = str.replacingOccurrences(of: "-----BEGIN CERTIFICATE-----", with: "")
    pemWithoutHeaderFooterNewlines = pemWithoutHeaderFooterNewlines.replacingOccurrences(of: "-----END CERTIFICATE-----", with: "")
    pemWithoutHeaderFooterNewlines = pemWithoutHeaderFooterNewlines.replacingOccurrences(of: "\n", with: "")
    pemWithoutHeaderFooterNewlines = pemWithoutHeaderFooterNewlines.replacingOccurrences(of: "\r", with: "")
    pemWithoutHeaderFooterNewlines = pemWithoutHeaderFooterNewlines.replacingOccurrences(of: " ", with: "")
    
    let data = Data(base64Encoded: pemWithoutHeaderFooterNewlines)!
    // finally create the certificate (SecCertificate)
    return SecCertificateCreateWithData(nil, data as CFData)
}

/// Parsing values from certificate
final class ParseCertificateTests: XCTestCase {
    
    var cert: SecCertificate?
    
    override func setUp() {
        // XCTest calls it before calling the first test method.
        // Set up any overall initial state here.
        self.cert = createCert()
    }
    
    func testParseCertificateIssuerSequence() throws {
        // get the issuer sequence
        let issuerSequenceData = SecCertificateCopyNormalizedIssuerSequence(cert!) as Data?
                
        let tree = try DERParser.parse(der: issuerSequenceData!)
        print(tree)
     
        // Access values within the tree
        let sequence1 = try tree.asSequence[0]
        
        let set1 = try sequence1.asSet.first
        XCTAssertEqual(try set1.asSequence[0].asObjectIdentifier, try ASN1ObjectIdentifier(oid: "2.5.4.6"))
        XCTAssertEqual(try set1.asSequence[1].asPrintableString, ASN1PrintableString("US"))
        
        let sequence2 = try tree.asSequence[1]
        let set2 = try sequence2.asSet.first
        XCTAssertEqual(try set2.asSequence[0].asObjectIdentifier, try ASN1ObjectIdentifier(oid: "2.5.4.10"))
        XCTAssertEqual(try set2.asSequence[1].asPrintableString, ASN1PrintableString("DIGICERT, INC."))
    }
    
    func testParseCertificateKey() throws {
        // get the key and parse
        var error: Unmanaged<CFError>?
        if let key = SecCertificateCopyKey(cert!),
           let keyData = SecKeyCopyExternalRepresentation(key, &error) as Data? {
            XCTAssertNoThrow(try DERParser.parse(der: keyData))
        }
    }
}
