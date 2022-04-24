/*
Sam A. Markelon
smarkelon@ufl.edu
04/07/2022
*/

pragma solidity >=0.4.22 <0.9.0;


contract DecCert {

  // allows us to quickly check uniqueness of fraud tags
  struct addressSet {
    address[] addresses;
    mapping(address => bool) is_in;
  }

  struct Certificate {
    string name; // identity
    string p0; // publicly verifialbe "proofs"
    string p1;
    string p2; 
    string p3;
    string p4; 
    uint mu; // max stake amount
    uint gamma; // current amount staked
    bytes32 r; // revocation token
    bool x; // revoked? 
  }

  // address to certificate mapping
  mapping(address => Certificate) internal certificates; 
  // mapping of cert address to mapping of cert stakers to stake amount
  mapping(address => mapping(address => uint)) internal sArrows; 
  // fraud tag set
  mapping(address => addressSet) internal fraud_tags;

  // the DecCA "deployer"
  address public deployer;

  constructor() public {
    deployer = msg.sender;
  }

  function new_certifcate( 
    string memory iname,
    string memory ip0,
    string memory ip1,
    string memory ip2,
    string memory ip3,
    string memory ip4,
    uint imu,
    bytes32 ir)
    public{
    
    require(certificates[msg.sender].x == false, "Certificate from this address is previously revoked.");
    require(certificates[msg.sender].mu == 0, "Certificate already exists.");
    require(imu > 0, "Max stake amount must be greater than 0.");

    certificates[msg.sender] = Certificate(iname, ip0, ip1, ip2, ip3, ip4, imu, 0, ir, false);
  }
  
  function stake_certificate(address cert) public payable{
    
    require(certificates[cert].x == false, "Certificate is revoked.");
    require(msg.value > 0, "Stake must be greater than 0.");
    uint max_indivdual_stake = certificates[cert].mu / 40;
    require(msg.value <= max_indivdual_stake, "Stake must be less 2.5% of max state for a certificate.");
    require(sArrows[cert][msg.sender] + msg.value <= max_indivdual_stake, "Stake must be less 2.5% of max state for a certificate. (2)");
    require(msg.value + certificates[cert].gamma <= certificates[cert].mu, "Stake amount will overflow gamma.");
    certificates[cert].gamma+=msg.value;
    sArrows[cert][msg.sender]+=msg.value;
  }

  function fraud_tag_certificate(address cert) public {
    require(certificates[cert].x == false, "Certificate is revoked.");
    require(fraud_tags[cert].is_in[msg.sender] == false, "Already fraud tagged.");
    
    fraud_tags[cert].is_in[msg.sender] = true;
    fraud_tags[cert].addresses.push(msg.sender); 
  }

  function revoke_certificate(address cert, string memory psi) public {
    require(certificates[cert].x == false, "Certificate is revoked.");
    
    bytes32 r_compare = certificates[cert].r;
    bytes32 r_computed = keccak256(abi.encodePacked(psi));
    
    require(r_compare == r_computed, "Revocated secret does not compute to correct token.");
    certificates[cert].x = true; 
  }

  /* WARNING!!!

  DO NOT USE THIS CONTRACT IN DEPLOYMENT...FUNDS WILL BE PERMANENTLY LOST!!!

  For actual deployment need to implement the time lock staking and unstaking functionality.

  Also need to implement functionality so stakers can remove immediately refund stake from a revoked certificate.
  */

}
