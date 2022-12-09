const applicationContract = artifacts.require("./ApplicationContract.sol");
module.exports = function(deployer) {
  deployer.deploy(applicationContract);
};
