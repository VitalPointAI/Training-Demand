const Demand = artifacts.require('./Demand')

require('chai')
    .use(require('chai-as-promised'))
    .should()

const BN = require('bn.js')
require('chai')
    .use(require('chai-bn')(BN))

contract('Demand', ([contractOwner, administrator1, administrator2, soldier1, unitPositionManager1, careerManager1, recruiter1, trainingEstablishment1 ]) => {

    let demandContract
    let administrators
    let soldiers
    let unitPositionManagers
    let establishmentManagers
    let careerManagers
    let recruiters
    let trainingEstablishments

    let positionId
    let positionNumber = '123456'
    let positionName = 'OpsO'
    let lowRank = 24
    let highRank = 26
    let trade = 56
    let environment = 0
    let currentSoldier = 100
    let taskList = 0
    let status = 0
    let owningOrganization = contractOwner
    let component = 0

    beforeEach(async () => {

        demandContract = await Demand.new("CAFChain", "CAF")

        try {
            await demandContract.assignAdministratorRole([administrator1, administrator2], { from: contractOwner })
            await demandContract.assignSoldierRole([soldier1], { from: administrator1 })
            await demandContract.assignUnitPositionManagerRole([unitPositionManager1], { from: administrator1 })
            await demandContract.assignCareerManagerRole([careerManager1], { from: administrator1 })
            await demandContract.assignRecruiterRole([recruiter1], { from: administrator1 })
            await demandContract.assignTrainingEstablishmentRole([trainingEstablishment1], { from: administrator1 })
        } catch (e) {
            console.log("Error " + e)
        }
    });

    describe('role assignment', () => {
        it('ensure owner is the first address', async () => {
            const owner = await demandContract.owner()
            owner.should.equal(contractOwner)
        });
        it('ensure administrator1 has been given administrator rights', async () => {
            try {
                await demandContract.createPosition(
                    positionNumber,
                    positionName,
                    lowRank,
                    highRank,
                    trade,
                    environment,
                    taskList,
                    currentSoldier,
                    owningOrganization,
                    status,
                    component,
                    { from: administrator1 }
                    );
            } catch (e) {
                console.log(`Error: ${e}`);
            }
            let details = await demandContract.getPositionDetails(0)
            details.positionName.should.to.deep.equal("OpsO")
        });
        it('ensure administrator2 has been given administrator rights', async () => {
            try {
                await demandContract.createPosition(
                    positionNumber,
                    positionName,
                    lowRank,
                    highRank,
                    trade,
                    environment,
                    taskList,
                    currentSoldier,
                    owningOrganization,
                    status,
                    component,
                    { from: administrator2 }
                    );
            } catch (e) {
                console.log(`Error: ${e}`);
            }
            let details = await demandContract.getPositionDetails(0)
            details.positionName.should.to.deep.equal("OpsO")
        });
        it('ensure soldier1 does not have administrator rights', async () => {
            try {
                await demandContract.createPosition(
                    positionNumber,
                    positionName,
                    lowRank,
                    highRank,
                    trade,
                    environment,
                    taskList,
                    currentSoldier,
                    owningOrganization,
                    status,
                    component,
                    { from: soldier1 }
                    );
            } catch (e) {
                e.should.to.deep.equal(e);
            }
        });
        it('ensure unitPositionManager1 does not have administrator rights', async () => {
            try {
                await demandContract.createPosition(
                    positionNumber,
                    positionName,
                    lowRank,
                    highRank,
                    trade,
                    environment,
                    taskList,
                    currentSoldier,
                    owningOrganization,
                    status,
                    component,
                    { from: unitPositionManager1 }
                    );
            } catch (e) {
                e.should.to.deep.equal(e);
            }
        });
        it('ensure careerManager1 does not have administrator rights', async () => {
            try {
                await demandContract.createPosition(
                    positionNumber,
                    positionName,
                    lowRank,
                    highRank,
                    trade,
                    environment,
                    taskList,
                    currentSoldier,
                    owningOrganization,
                    status,
                    component,
                    { from: careerManager1 }
                    );
            } catch (e) {
                e.should.to.deep.equal(e);
            }
        });
        it('ensure recruiter1 does not have administrator rights', async () => {
            try {
                await demandContract.createPosition(
                    positionNumber,
                    positionName,
                    lowRank,
                    highRank,
                    trade,
                    environment,
                    taskList,
                    currentSoldier,
                    owningOrganization,
                    status,
                    component,
                    { from: recruiter1 }
                    );
            } catch (e) {
                e.should.to.deep.equal(e);
            }
        });
        it('ensure trainingEstablishment1 does not have administrator rights', async () => {
            try {
                await demandContract.createPosition(
                    positionNumber,
                    positionName,
                    lowRank,
                    highRank,
                    trade,
                    environment,
                    taskList,
                    currentSoldier,
                    owningOrganization,
                    status,
                    component,
                    { from: trainingEstablishment1 }
                    );
            } catch (e) {
                e.should.to.deep.equal(e);
            }
        });
    });
    describe('Position Creation', () => {
        it('administrator should properly create a position', async () => {
            try {
                await demandContract.createPosition(
                    positionNumber,
                    positionName,
                    lowRank,
                    highRank,
                    trade,
                    environment,
                    taskList,
                    currentSoldier,
                    owningOrganization,
                    status,
                    component,
                    { from: administrator1 }
                    );
            } catch (e) {
                console.log(`Error: ${e}`);
            }
            let details = await demandContract.getPositionDetails(0)
            assert.equal(details.positionId, 0, "positionId is not correct")
            assert.equal(details.positionNumber, '123456', "positionNumber is not correct")
            assert.equal(details.positionName, 'OpsO', "positionName is not correct")
            assert.equal(details.lowRank, 24, "lowRank is not correct")
            assert.equal(details.highRank, 26, "highRank is not correct")
            assert.equal(details.trade, 56, "trade is not correct")
            assert.equal(details.environment, 0, "environment is not correct")
            assert.equal(details.taskList, 0, "taskList is not correct")
            assert.equal(details.currentSoldier.toString(), currentSoldier.toString(), "currentSoldier is not correct")
            assert.equal(details.owningOrganization, contractOwner, "owningOrganization is not correct")
            assert.equal(details.status, 0, "status is not correct")
            assert.equal(details.component, 0, "component is not correct")
        });
    });
})