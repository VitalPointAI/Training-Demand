const Demand = artifacts.require("Demand");

module.exports = async function(deployer) {
    await deployer.deploy(Demand, "CAFChain", "CAF");
};
