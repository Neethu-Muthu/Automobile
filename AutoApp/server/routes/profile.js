let profile = {
    manufacturer: {
        "cryptoPath": "../../AutomobileNetwork/organizations/peerOrganizations/manufacturer.auto.com", 
		"keyDirectoryPath": "../../AutomobileNetwork/organizations/peerOrganizations/manufacturer.auto.com/users/User1@manufacturer.auto.com/msp/keystore/",
        "certPath":     "../../AutomobileNetwork/organizations/peerOrganizations/manufacturer.auto.com/users/User1@manufacturer.auto.com/msp/signcerts/cert.pem",
		"tlsCertPath":  "../../AutomobileNetwork/organizations/peerOrganizations/manufacturer.auto.com/peers/peer0.manufacturer.auto.com/tls/ca.crt",
		"peerEndpoint": "localhost:7051",
		"peerHostAlias":  "peer0.manufacturer.auto.com",
        "mspId": "ManufacturerMSP"
    },
    dealer: {
        "cryptoPath": "../../AutomobileNetwork/organizations/peerOrganizations/dealer.auto.com", 
		"keyDirectoryPath": "../../AutomobileNetwork/organizations/peerOrganizations/dealer.auto.com/users/User1@dealer.auto.com/msp/keystore/",
        "certPath":     "../../AutomobileNetwork/organizations/peerOrganizations/dealer.auto.com/users/User1@dealer.auto.com/msp/signcerts/cert.pem",
		"tlsCertPath":  "../../AutomobileNetwork/organizations/peerOrganizations/dealer.auto.com/peers/peer0.dealer.auto.com/tls/ca.crt",
		"peerEndpoint": "localhost:9051",
		"peerHostAlias":  "peer0.dealer.auto.com",
        "mspId": "DealerMSP"
    },
    mvd: {
        "cryptoPath": "../../AutomobileNetwork/organizations/peerOrganizations/mvd.auto.com", 
		"keyDirectoryPath": "../../AutomobileNetwork/organizations/peerOrganizations/mvd.auto.com/users/User1@mvd.auto.com/msp/keystore/",
        "certPath":     "../../AutomobileNetwork/organizations/peerOrganizations/mvd.auto.com/users/User1@mvd.auto.com/msp/signcerts/cert.pem",
		"tlsCertPath":  "../../AutomobileNetwork/organizations/peerOrganizations/mvd.auto.com/peers/peer0.mvd.auto.com/tls/ca.crt",
		"peerEndpoint": "localhost:11051",
		"peerHostAlias":  "peer0.mvd.auto.com",
        "mspId": "MvdMSP"
    }
}
module.exports = { profile }
