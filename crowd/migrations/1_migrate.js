const TruffleCrowd = artifacts.require("CrowdFund");

module.exports = function(deployer){
    deployer.deploy(TruffleCrowd)
}
