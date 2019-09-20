const Demand = artifacts.require('./Demand')

require('chai')
    .use(require('chai-as-promised'))
    .should()

contract('Demand', ([administrator]) => {
    let instance

    beforeEach(async () => {
        // Fetch Demand contract from blockchain
        instance = await Demand.deployed()
    })

    describe('deployment', () => {
        instance('should assign first account as an administrator', async() => {
            let deployer = await instance._administrator(0)
            deployer.should.equal(administrator)
        })
    })
})