#!/bin/bash

function createManufacturer() {
  echo "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/manufacturer.auto.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/manufacturer.auto.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-manufacturer --tls.certfiles "${PWD}/organizations/fabric-ca/manufacturer/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-manufacturer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-manufacturer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-manufacturer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-manufacturer.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/manufacturer.auto.com/msp/config.yaml"

  # Since the CA serves as both the organization CA and TLS CA, copy the org's root cert that was generated by CA startup into the org level ca and tlsca directories

  # Copy manufacturer's CA cert to manufacturer's /msp/tlscacerts directory (for use in the channel MSP definition)
  mkdir -p "${PWD}/organizations/peerOrganizations/manufacturer.auto.com/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/manufacturer/ca-cert.pem" "${PWD}/organizations/peerOrganizations/manufacturer.auto.com/msp/tlscacerts/ca.crt"

  # Copy manufacturer's CA cert to manufacturer's /tlsca directory (for use by clients)
  mkdir -p "${PWD}/organizations/peerOrganizations/manufacturer.auto.com/tlsca"
  cp "${PWD}/organizations/fabric-ca/manufacturer/ca-cert.pem" "${PWD}/organizations/peerOrganizations/manufacturer.auto.com/tlsca/tlsca.manufacturer.auto.com-cert.pem"

  # Copy manufacturer's CA cert to manufacturer's /ca directory (for use by clients)
  mkdir -p "${PWD}/organizations/peerOrganizations/manufacturer.auto.com/ca"
  cp "${PWD}/organizations/fabric-ca/manufacturer/ca-cert.pem" "${PWD}/organizations/peerOrganizations/manufacturer.auto.com/ca/ca.manufacturer.auto.com-cert.pem"

  echo "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-manufacturer --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/manufacturer/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Registering user"
  set -x
  fabric-ca-client register --caname ca-manufacturer --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/manufacturer/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-manufacturer --id.name manufactureradmin --id.secret manufactureradminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/manufacturer/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-manufacturer -M "${PWD}/organizations/peerOrganizations/manufacturer.auto.com/peers/peer0.manufacturer.auto.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/manufacturer/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/manufacturer.auto.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/manufacturer.auto.com/peers/peer0.manufacturer.auto.com/msp/config.yaml"

  echo "Generating the peer0-tls certificates, use --csr.hosts to specify Subject Alternative Names"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-manufacturer -M "${PWD}/organizations/peerOrganizations/manufacturer.auto.com/peers/peer0.manufacturer.auto.com/tls" --enrollment.profile tls --csr.hosts peer0.manufacturer.auto.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/manufacturer/ca-cert.pem"
  { set +x; } 2>/dev/null

  # Copy the tls CA cert, server cert, server keystore to well known file names in the peer's tls directory that are referenced by peer startup config
  cp "${PWD}/organizations/peerOrganizations/manufacturer.auto.com/peers/peer0.manufacturer.auto.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/manufacturer.auto.com/peers/peer0.manufacturer.auto.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/manufacturer.auto.com/peers/peer0.manufacturer.auto.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/manufacturer.auto.com/peers/peer0.manufacturer.auto.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/manufacturer.auto.com/peers/peer0.manufacturer.auto.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/manufacturer.auto.com/peers/peer0.manufacturer.auto.com/tls/server.key"

  echo "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-manufacturer -M "${PWD}/organizations/peerOrganizations/manufacturer.auto.com/users/User1@manufacturer.auto.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/manufacturer/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/manufacturer.auto.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/manufacturer.auto.com/users/User1@manufacturer.auto.com/msp/config.yaml"

  echo "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://manufactureradmin:manufactureradminpw@localhost:7054 --caname ca-manufacturer -M "${PWD}/organizations/peerOrganizations/manufacturer.auto.com/users/Admin@manufacturer.auto.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/manufacturer/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/manufacturer.auto.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/manufacturer.auto.com/users/Admin@manufacturer.auto.com/msp/config.yaml"
}

function createDealer() {
  echo "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/dealer.auto.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/dealer.auto.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-dealer --tls.certfiles "${PWD}/organizations/fabric-ca/dealer/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-dealer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-dealer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-dealer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-dealer.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/dealer.auto.com/msp/config.yaml"

  # Since the CA serves as both the organization CA and TLS CA, copy the org's root cert that was generated by CA startup into the org level ca and tlsca directories

  # Copy dealer's CA cert to dealer's /msp/tlscacerts directory (for use in the channel MSP definition)
  mkdir -p "${PWD}/organizations/peerOrganizations/dealer.auto.com/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/dealer/ca-cert.pem" "${PWD}/organizations/peerOrganizations/dealer.auto.com/msp/tlscacerts/ca.crt"

  # Copy dealer's CA cert to dealer's /tlsca directory (for use by clients)
  mkdir -p "${PWD}/organizations/peerOrganizations/dealer.auto.com/tlsca"
  cp "${PWD}/organizations/fabric-ca/dealer/ca-cert.pem" "${PWD}/organizations/peerOrganizations/dealer.auto.com/tlsca/tlsca.dealer.auto.com-cert.pem"

  # Copy dealer's CA cert to dealer's /ca directory (for use by clients)
  mkdir -p "${PWD}/organizations/peerOrganizations/dealer.auto.com/ca"
  cp "${PWD}/organizations/fabric-ca/dealer/ca-cert.pem" "${PWD}/organizations/peerOrganizations/dealer.auto.com/ca/ca.dealer.auto.com-cert.pem"

  echo "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-dealer --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/dealer/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Registering user"
  set -x
  fabric-ca-client register --caname ca-dealer --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/dealer/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-dealer --id.name dealeradmin --id.secret dealeradminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/dealer/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-dealer -M "${PWD}/organizations/peerOrganizations/dealer.auto.com/peers/peer0.dealer.auto.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/dealer/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/dealer.auto.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/dealer.auto.com/peers/peer0.dealer.auto.com/msp/config.yaml"

  echo "Generating the peer0-tls certificates, use --csr.hosts to specify Subject Alternative Names"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-dealer -M "${PWD}/organizations/peerOrganizations/dealer.auto.com/peers/peer0.dealer.auto.com/tls" --enrollment.profile tls --csr.hosts peer0.dealer.auto.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/dealer/ca-cert.pem"
  { set +x; } 2>/dev/null

  # Copy the tls CA cert, server cert, server keystore to well known file names in the peer's tls directory that are referenced by peer startup config
  cp "${PWD}/organizations/peerOrganizations/dealer.auto.com/peers/peer0.dealer.auto.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/dealer.auto.com/peers/peer0.dealer.auto.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/dealer.auto.com/peers/peer0.dealer.auto.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/dealer.auto.com/peers/peer0.dealer.auto.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/dealer.auto.com/peers/peer0.dealer.auto.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/dealer.auto.com/peers/peer0.dealer.auto.com/tls/server.key"

  echo "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-dealer -M "${PWD}/organizations/peerOrganizations/dealer.auto.com/users/User1@dealer.auto.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/dealer/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/dealer.auto.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/dealer.auto.com/users/User1@dealer.auto.com/msp/config.yaml"

  echo "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://dealeradmin:dealeradminpw@localhost:8054 --caname ca-dealer -M "${PWD}/organizations/peerOrganizations/dealer.auto.com/users/Admin@dealer.auto.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/dealer/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/dealer.auto.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/dealer.auto.com/users/Admin@dealer.auto.com/msp/config.yaml"
}


function createMvd() {
  echo "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/mvd.auto.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/mvd.auto.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:11054 --caname ca-mvd --tls.certfiles "${PWD}/organizations/fabric-ca/mvd/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-mvd.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-mvd.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-mvd.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-mvd.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/mvd.auto.com/msp/config.yaml"

  # Since the CA serves as both the organization CA and TLS CA, copy the org's root cert that was generated by CA startup into the org level ca and tlsca directories

  # Copy mvd's CA cert to mvd's /msp/tlscacerts directory (for use in the channel MSP definition)
  mkdir -p "${PWD}/organizations/peerOrganizations/mvd.auto.com/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/mvd/ca-cert.pem" "${PWD}/organizations/peerOrganizations/mvd.auto.com/msp/tlscacerts/ca.crt"

  # Copy mvd's CA cert to mvd's /tlsca directory (for use by clients)
  mkdir -p "${PWD}/organizations/peerOrganizations/mvd.auto.com/tlsca"
  cp "${PWD}/organizations/fabric-ca/mvd/ca-cert.pem" "${PWD}/organizations/peerOrganizations/mvd.auto.com/tlsca/tlsca.mvd.auto.com-cert.pem"

  # Copy mvd's CA cert to mvd's /ca directory (for use by clients)
  mkdir -p "${PWD}/organizations/peerOrganizations/mvd.auto.com/ca"
  cp "${PWD}/organizations/fabric-ca/mvd/ca-cert.pem" "${PWD}/organizations/peerOrganizations/mvd.auto.com/ca/ca.mvd.auto.com-cert.pem"

  echo "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-mvd --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/mvd/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Registering user"
  set -x
  fabric-ca-client register --caname ca-mvd --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/mvd/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-mvd --id.name mvdadmin --id.secret mvdadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/mvd/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-mvd -M "${PWD}/organizations/peerOrganizations/mvd.auto.com/peers/peer0.mvd.auto.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/mvd/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/mvd.auto.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/mvd.auto.com/peers/peer0.mvd.auto.com/msp/config.yaml"

  echo "Generating the peer0-tls certificates, use --csr.hosts to specify Subject Alternative Names"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-mvd -M "${PWD}/organizations/peerOrganizations/mvd.auto.com/peers/peer0.mvd.auto.com/tls" --enrollment.profile tls --csr.hosts peer0.mvd.auto.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/mvd/ca-cert.pem"
  { set +x; } 2>/dev/null

  # Copy the tls CA cert, server cert, server keystore to well known file names in the peer's tls directory that are referenced by peer startup config
  cp "${PWD}/organizations/peerOrganizations/mvd.auto.com/peers/peer0.mvd.auto.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/mvd.auto.com/peers/peer0.mvd.auto.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/mvd.auto.com/peers/peer0.mvd.auto.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/mvd.auto.com/peers/peer0.mvd.auto.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/mvd.auto.com/peers/peer0.mvd.auto.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/mvd.auto.com/peers/peer0.mvd.auto.com/tls/server.key"

  echo "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:11054 --caname ca-mvd -M "${PWD}/organizations/peerOrganizations/mvd.auto.com/users/User1@mvd.auto.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/mvd/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/mvd.auto.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/mvd.auto.com/users/User1@mvd.auto.com/msp/config.yaml"

  echo "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://mvdadmin:mvdadminpw@localhost:11054 --caname ca-mvd -M "${PWD}/organizations/peerOrganizations/mvd.auto.com/users/Admin@mvd.auto.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/mvd/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/mvd.auto.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/mvd.auto.com/users/Admin@mvd.auto.com/msp/config.yaml"
}


function createOrderer() {
  echo "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/auto.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/auto.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/ordererOrganizations/auto.com/msp/config.yaml"

  # Since the CA serves as both the organization CA and TLS CA, copy the org's root cert that was generated by CA startup into the org level ca and tlsca directories

  # Copy orderer org's CA cert to orderer org's /msp/tlscacerts directory (for use in the channel MSP definition)
  mkdir -p "${PWD}/organizations/ordererOrganizations/auto.com/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem" "${PWD}/organizations/ordererOrganizations/auto.com/msp/tlscacerts/tlsca.auto.com-cert.pem"

  # Copy orderer org's CA cert to orderer org's /tlsca directory (for use by clients)
  mkdir -p "${PWD}/organizations/ordererOrganizations/auto.com/tlsca"
  cp "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem" "${PWD}/organizations/ordererOrganizations/auto.com/tlsca/tlsca.auto.com-cert.pem"

  echo "Registering orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/auto.com/orderers/orderer.auto.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/auto.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/auto.com/orderers/orderer.auto.com/msp/config.yaml"

  echo "Generating the orderer-tls certificates, use --csr.hosts to specify Subject Alternative Names"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/auto.com/orderers/orderer.auto.com/tls" --enrollment.profile tls --csr.hosts orderer.auto.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"
  { set +x; } 2>/dev/null

  # Copy the tls CA cert, server cert, server keystore to well known file names in the orderer's tls directory that are referenced by orderer startup config
  cp "${PWD}/organizations/ordererOrganizations/auto.com/orderers/orderer.auto.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/auto.com/orderers/orderer.auto.com/tls/ca.crt"
  cp "${PWD}/organizations/ordererOrganizations/auto.com/orderers/orderer.auto.com/tls/signcerts/"* "${PWD}/organizations/ordererOrganizations/auto.com/orderers/orderer.auto.com/tls/server.crt"
  cp "${PWD}/organizations/ordererOrganizations/auto.com/orderers/orderer.auto.com/tls/keystore/"* "${PWD}/organizations/ordererOrganizations/auto.com/orderers/orderer.auto.com/tls/server.key"

  # Copy orderer org's CA cert to orderer's /msp/tlscacerts directory (for use in the orderer MSP definition)
  mkdir -p "${PWD}/organizations/ordererOrganizations/auto.com/orderers/orderer.auto.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/auto.com/orderers/orderer.auto.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/auto.com/orderers/orderer.auto.com/msp/tlscacerts/tlsca.auto.com-cert.pem"

  echo "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/auto.com/users/Admin@auto.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/auto.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/auto.com/users/Admin@auto.com/msp/config.yaml"
}

createManufacturer
createDealer
createMvd
createOrderer