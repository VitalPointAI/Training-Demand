pragma solidity ^0.5.0;

import "@openzeppelin/contracts/access/Roles.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract Demand {

    using Roles for Roles.Role;
    using SafeMath for uint256;

    Roles.Role private _administrator;
    Roles.Role private _establishmentManager;
    Roles.Role private _careerManager;
    Roles.Role private _unitPositionManager;
    Roles.Role private _recruiter;
    Roles.Role private _soldier;
    Roles.Role private _trainingEstablishment;

    // Create contract and assign administrator access
    constructor(address[] memory administrators) public {
        for (uint256 i = 0; i < administrators.length; ++i) {
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



}