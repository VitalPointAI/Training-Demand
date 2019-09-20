const Demand = artifacts.require("Demand");

module.exports = async function(deployer) {
    await deployer.deploy(Demand, ['0xC18f95Bb4179C5CD41b64dd530027150b2C8CdcC']);
};
