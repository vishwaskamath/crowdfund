const TruffleCrowd = artifacts.require("CrowdFund");

module.exports = function(deployer){
    deployer.deploy(TruffleCrowd, "0x6c79867b863B2eD7F46deD0375B137a6ece0E250")
}
