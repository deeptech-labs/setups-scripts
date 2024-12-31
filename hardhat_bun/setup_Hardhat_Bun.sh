#!/usr/bin/env bash

#######################################
# setup_Hardhat_Bun.sh
#
# This script initializes a new Hardhat project using Bun and
# generates demo Solidity contracts, tests, migration scripts, 
# and basic project files.
#######################################

# Exit on error
set -e

echo "================================================="
echo "  Setting up Hardhat project with Bun..."
echo "================================================="

#######################################
# Create directories
#######################################
echo "Creating project directories..."
mkdir -p contracts/interfaces
mkdir -p contracts/utils
mkdir -p migrations
mkdir -p tests
mkdir -p scripts

#######################################
# Create demo Solidity contract files
#######################################
echo "Creating demo .sol files..."

# IPriceFeed.sol
cat <<EOF > contracts/interfaces/IPriceFeed.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IPriceFeed {
    function getPrice() external view returns (uint256);
}
EOF

# ITokenPriceFeed.sol
cat <<EOF > contracts/interfaces/ITokenPriceFeed.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ITokenPriceFeed {
    function getTokenPrice(address token) external view returns (uint256);
}
EOF

# Constants.sol
cat <<EOF > contracts/utils/Constants.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library Constants {
    uint256 constant SOME_CONSTANT = 1e18;
}
EOF

# ChainlinkPriceFeed.sol
cat <<EOF > contracts/ChainlinkPriceFeed.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IPriceFeed.sol";

contract ChainlinkPriceFeed is IPriceFeed {
    function getPrice() external pure override returns (uint256) {
        // Demo chainlink feed returning a fixed value
        return 42;
    }
}
EOF

# TeslaChainlinkPriceFeed.sol
cat <<EOF > contracts/TeslaChainlinkPriceFeed.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IPriceFeed.sol";

contract TeslaChainlinkPriceFeed is IPriceFeed {
    function getPrice() external pure override returns (uint256) {
        // Demo chainlink feed returning a fixed value
        return 123;
    }
}
EOF

#######################################
# Create migration and script files
#######################################
echo "Creating migration and deployment script files..."
cat <<EOF > migrations/1_initial_migration.js
// migrations/1_initial_migration.js
// Demo migration file

module.exports = async function (deployer) {
  // Deploy steps go here if needed
};
EOF

cat <<EOF > scripts/deploy_tesla_feed.js
// scripts/deploy_tesla_feed.js
// Demo script to deploy TeslaChainlinkPriceFeed

async function main() {
  const TeslaChainlinkPriceFeed = await ethers.getContractFactory("TeslaChainlinkPriceFeed");
  const feed = await TeslaChainlinkPriceFeed.deploy();
  await feed.deployed();
  console.log("TeslaChainlinkPriceFeed deployed to:", feed.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
EOF

#######################################
# Create test files
#######################################
echo "Creating test files..."
cat <<EOF > tests/ChainlinkPriceFeed.test.js
// tests/ChainlinkPriceFeed.test.js
const { expect } = require("chai");

describe("ChainlinkPriceFeed", function () {
  it("Should return the correct price", async function () {
    const ChainlinkPriceFeed = await ethers.getContractFactory("ChainlinkPriceFeed");
    const feed = await ChainlinkPriceFeed.deploy();
    await feed.deployed();
    expect(await feed.getPrice()).to.equal(42);
  });
});
EOF

cat <<EOF > tests/TeslaChainlinkPriceFeed.test.js
// tests/TeslaChainlinkPriceFeed.test.js
const { expect } = require("chai");

describe("TeslaChainlinkPriceFeed", function () {
  it("Should return the correct price", async function () {
    const TeslaChainlinkPriceFeed = await ethers.getContractFactory("TeslaChainlinkPriceFeed");
    const feed = await TeslaChainlinkPriceFeed.deploy();
    await feed.deployed();
    expect(await feed.getPrice()).to.equal(123);
  });
});
EOF

#######################################
# Initialize Bun and install Hardhat
#######################################
echo "Initializing Bun and installing Hardhat..."

# Create package.json if it doesn't exist
if [ ! -f package.json ]; then
  echo "{}" > package.json
fi

# Install Hardhat as a dev dependency via Bun
bun add -d hardhat

#######################################
# Set up Hardhat project
#######################################
echo "Setting up Hardhat project..."
bunx hardhat

#######################################
# Create README and .env files
#######################################
echo "Creating README.md and .env files..."
cat <<EOF > README.md
# Hardhat Project (Bun)

This is a demo Hardhat project set up via Bun.

## Getting Started

1. Install [Bun](https://bun.sh/)
2. Run \`chmod +x setup_Hardhat_Bun.sh && ./setup_Hardhat_Bun.sh\`
3. Use \`bunx hardhat test\` to run tests.

## Project Structure

- **contracts/**: Contains all Solidity contract files
- **migrations/**: Demo migration scripts
- **scripts/**: Deployment and other utility scripts
- **tests/**: JavaScript test files
EOF

touch .env

#######################################
# Create .gitignore
#######################################
echo "Creating .gitignore file..."
cat <<EOF > .gitignore
node_modules/
coverage/
.env
artifacts/
cache/
EOF

echo "================================================="
echo "  Hardhat + Bun Project Setup Complete!"
echo "================================================="
echo "You can now run:"
echo "  bunx hardhat compile"
echo "  bunx hardhat test"
echo
