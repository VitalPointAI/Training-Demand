pragma solidity ^0.5.0;

import "@openzeppelin/contracts/token/ERC721/ERC721Full.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721Mintable.sol";
import "@openzeppelin/contracts/access/Roles.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";

contract Demand is ERC721Full, ERC721Mintable, Ownable {

    using Roles for Roles.Role;
    using SafeMath for uint256;

    Roles.Role private _administrator;
    Roles.Role private _establishmentManager;
    Roles.Role private _careerManager;
    Roles.Role private _unitPositionManager;
    Roles.Role private _recruiter;
    Roles.Role private _soldier;
    Roles.Role private _trainingEstablishment;

    enum Rank { PteB, AvrB, OS, PteT, AvrT, AB, Cpl, LS, MCpl, MS,
                Sgt, PO2, WO, PO1, MWO, CPO2, CWO, CPO1, OCdt, NCdt,
                ASlt, SecLt, Lt, SLt, Capt, LtN, Maj, LCdr, LCol, Cdr,
                Col, CaptN, BGen, Cmdre, MGen, RAdm, LGen, Gen, Adm }

    enum Trade { ACOPAEROOP, ACCISS, ACSTECH, ACSO, AEC, AERE, AESOP,
                AMSUP, AMMOTECH, ARMD, ARTY, ARTYMNAD, ARTYMNFD, ATISTECH,
                AVPHYSTECH, AVNTECH, AVSTECH, AWSTECH, BETECH, BIO, BOSN,
                CBRNOP, CBTENGR, CESUPT, CELEAIR, CHAP, CIC, CLDVR, COMMRSCH,
                CONSTENGR, CONSTTECH, COOK, CR, CRMN, CRTRPTR, CYBEROP, DENT,
                DENTTECH, DSTECH, ETECH, EDTECH, EGSTECH, EME, ENGR, EOTECHL,
                FIREFTR, FLTENGR, FSA, GEOTECH, GNR, GOL, GOSCHAPP, HTECH, HCA,
                HRA, HSO, IMAGETECH, INF, INFMN, INT, INTOP, LCISTECH, LEGAL,
                LMN, LOG, MAREL, MARENG, MARENGART, MARTECH, MARSSS, MATTECH, MED,
                MEDTECH, MESO, METTECH, MLABTECH, MP, MPO, MRADTECH, MSENG, MSEOP,
                MUSC, MUSCN, NAVCOMM, NAVENG, NCIOP, NCSENG, NDTTECH, NESOP, NUR, ORTECH,
                PAO, PANDD, PHTECH, PHARM, PHYSIO, PID, PLT, PMEDTECH, POSTCLK,
                PSEL, RMTECH, RMSCLK, SARTECH, SFOP, SIGOP, SIGS, SOCW, SONAROP,
                STWD, SUPTECH, TFCTECH, TRGDEV, VEHTECH, WENGTECH, WTECHL, WFETECH }

    enum Status { active, inactive, obsolete }
    enum Component { RegF, ResF, Civ }
    enum Environment { CA, RCN, RCAF, CANSOFCOM }

    struct Position {
        uint256 positionId;
        string positionNumber;
        string positionName;
        Rank lowRank;
        Rank highRank;
        Trade trade;
        Environment environment;
        uint256 taskList;
        uint256 currentSoldier;
        address owningOrganization;
        Status status;
        Component component;
    }

    struct Soldier {
        string serviceNumber;
        string[] currentQualifications;
        string[] desiredQualifications;
        Rank rank;
        Trade trade;
        Environment environment;
        Component component;
        address soldierAddress;
    }

    struct Task {
        uint256 taskId;
    }

    struct Qualification {
        uint256 qualificationId;
        string competencyCode;
        string qualificationTitle;
    }

    struct Organization {
        uint256 organizationId;
        string organizationName;
        address organizationAddress;
    }

    Position[] public positions;
    Soldier[] public soldiers;
    Task[] public tasks;
    Qualification[] public qualifications;

    // Events
    event PositionCreated(
        uint256 indexed positionId,
        string positionNumber,
        string positionName,
        Rank lowRank,
        Rank highRank,
        Trade trade,
        Environment environment,
        uint256 taskList,
        uint256 currentSoldier,
        address indexed owningOrganization,
        Status status,
        Component component
    );

    constructor(string memory _identifier, string memory _symbol) ERC721Full(_identifier, _symbol) public onlyOwner {
    }

    function terminateDemand() public onlyOwner {
        selfdestruct(msg.sender);
    }

    // Create contract and assign administrator access
    function assignAdministratorRole(address[] memory administrators) public onlyOwner {
        for (uint256 i = 0; i < administrators.length; i++) {
                _administrator.add(administrators[i]);
            }
    }

    // Role Assignments an Administrator must make
    function assignEstablishmentManagerRole(address[] memory establishmentManagers) public {
        require(_administrator.has(msg.sender), "DOES_NOT_HAVE_ADMINISTRATOR_ROLE");
        for (uint256 i = 0; i < establishmentManagers.length; ++i) {
            _establishmentManager.add(establishmentManagers[i]);
        }
    }

    function assignCareerManagerRole(address[] memory careerManagers) public {
        require(_administrator.has(msg.sender), "DOES_NOT_HAVE_ADMINISTRATOR_ROLE");
        for (uint256 i = 0; i < careerManagers.length; ++i) {
            _careerManager.add(careerManagers[i]);
        }
    }

    function assignRecruiterRole(address[] memory recruiters) public {
        require(_administrator.has(msg.sender), "DOES_NOT_HAVE_ADMINISTRATOR_ROLE");
        for (uint256 i = 0; i < recruiters.length; ++i) {
            _recruiter.add(recruiters[i]);
        }
    }

    function assignTrainingEstablishmentRole(address[] memory trainingEstablishments) public {
        require(_administrator.has(msg.sender), "DOES_NOT_HAVE_ADMINISTRATOR_ROLE");
        for (uint256 i = 0; i < trainingEstablishments.length; ++i) {
            _trainingEstablishment.add(trainingEstablishments[i]);
        }
    }

    // Role Assignments a Recruiter (or Administrator) must make
    function assignSoldierRole(address[] memory soldiersAddress) public {
        require((_administrator.has(msg.sender) ||
                _recruiter.has(msg.sender)),
                "DOES_NOT_HAVE_ADMINISTRATOR_OR_RECRUITER_ROLE");
        for (uint256 i = 0; i < soldiersAddress.length; ++i) {
            _soldier.add(soldiersAddress[i]);
        }
    }

    // Role Assignments an Establishment Manager (or Administrator) must make
    function assignUnitPositionManagerRole(address[] memory unitPositionManagers) public {
        require((_administrator.has(msg.sender) ||
                _establishmentManager.has(msg.sender)),
                "DOES_NOT_HAVE_ADMINISTRATOR_OR_ESTABLISHMENT_MANAGER_ROLE");
        for (uint256 i = 0; i < unitPositionManagers.length; ++i) {
            _unitPositionManager.add(unitPositionManagers[i]);
        }
    }

    // Creation Functions
    function createPosition(string memory _positionNumber,
                            string memory _positionName,
                            Rank _lowRank,
                            Rank _highRank,
                            Trade _trade,
                            Environment _environment,
                            uint256 _taskList,
                            uint256 _currentSoldier,
                            address _owningOrganization,
                            Status _status,
                            Component _component
                            ) public {
        require((_administrator.has(msg.sender) ||
            _establishmentManager.has(msg.sender)),
            "DOES_NOT_HAVE_ADMINISTRATOR_OR_ESTABLISHMENT_MANAGER_ROLE");
        uint256 positionId = positions.length; // generates unique positionId
        positions.push(Position(
                                positionId,
                                _positionNumber,
                                _positionName,
                                _lowRank,
                                _highRank,
                                _trade,
                                _environment,
                                _taskList,
                                _currentSoldier,
                                _owningOrganization,
                                _status,
                                _component
                                ));
        _mint(_owningOrganization, positionId); // Create a new position
        emit PositionCreated(
                            positionId,
                            _positionNumber,
                            _positionName,
                            _lowRank,
                            _highRank,
                            _trade,
                            _environment,
                            _taskList,
                            _currentSoldier,
                            _owningOrganization,
                            _status,
                            _component
        );
    }

    function getPositionDetails(uint _positionId)
        public view returns(
            uint256 positionId,
            string memory positionNumber,
            string memory positionName,
            Rank lowRank,
            Rank highRank,
            Trade trade,
            Environment environment,
            uint256 taskList,
            uint256 currentSoldier,
            address owningOrganization,
            Status status,
            Component component
        ) {
        Position memory _positions = positions[_positionId];
        positionId = _positions.positionId;
        positionNumber = _positions.positionNumber;
        positionName = _positions.positionName;
        lowRank = _positions.lowRank;
        highRank = _positions.highRank;
        trade = _positions.trade;
        environment = _positions.environment;
        taskList = _positions.taskList;
        currentSoldier = _positions.currentSoldier;
        owningOrganization = _positions.owningOrganization;
        status = _positions.status;
        component = _positions.component;
    }
}