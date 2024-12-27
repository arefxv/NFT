# NFT Contracts - Foundry Project

This repository contains 10 smart contracts built using Foundry. It includes implementations for two types of NFTs—BasicNft (IPFS-hosted) and MoodNft (on-chain SVG)—along with deployment, minting, flipping, and testing scripts.

---

## 🚀 Getting Started


### Prerequisites

Ensure you have Foundry installed. If not, install it using the following steps:

```
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

Verify the installation:

```
forge --version
```

## 📂 Project Structure

```
.
├── contracts/
│   ├── BasicNft.sol         # IPFS-hosted NFT contract
│   ├── MoodNft.sol          # On-chain SVG NFT contract
│   ├── DeployBasicNft.s.sol # Deployment script for BasicNft
│   ├── DeployMoodNft.s.sol  # Deployment script for MoodNft
│   ├── Interactions.s.sol   # Minting script for BasicNft
│   ├── Interactions.s.sol   # Minting script for MoodNft
│   ├── Interactions.s.sol   # Mood toggling script for MoodNft
├── test/
│   ├── BasicNftTest.sol     # Unit tests for BasicNft
│   ├── MoodNftTest.sol      # Unit tests for MoodNft
│   ├── InteractionsTest.sol # Integration tests for interactions
├── foundry.toml
└── README.md
```


## 📜 Contracts Overview

### 1. BasicNft.sol

* **Purpose** : Implements an ERC721 NFT hosted on IPFS.

* **Key Features**:

  * Metadata URI stored on IPFS.

  * Simple minting functionality.

### 2. MoodNft.sol

* **Purpose**: Implements an SVG-based ERC721 NFT stored 100% on-chain.

* **Key Features**:

  * Fully on-chain SVG rendering.

  * Dynamic mood flipping feature.

### 3. Deploy Scripts

* DeployBasicNft.s.sol - Deploys the `BasicNft `contract.

* DeployMoodNft.s.sol - Deploys the `MoodNft` contract.

### 4. Mint Scripts

* MintBasicNft.s.sol - Mints a `BasicNft` token.

* MintMoodNft.s.sol - Mints a `MoodNft` token.

### 5. Mood Interaction

* FlipMoodNft.s.sol - Flips the mood state of `MoodNft`.

### 6. Testing Scripts

* BasicNftTest.sol - Tests for `BasicNft` functionalities.

* MoodNftTest.sol - Tests for `MoodNft` functionalities.

* InteractionsTest.sol - Tests for interactions between contracts.

---

## ⚙️ Setup and Deployment



### 1. Compile Contracts
```
forge build
```
### 2. Run Tests
```
forge test
```
### 3. Deploy Contracts

Example for `BasicNft` deployment:
```
forge script script/DeployBasicNft.s.sol:DeployBasicNft --rpc-url <RPC_URL> --private-key <PRIVATE_KEY> --broadcast
```
Replace `<RPC_URL>` and `<PRIVATE_KEY>` with appropriate values.

---

## 🛠 Key Features

* BasicNft: Stores metadata URI on IPFS for off-chain storage.

* MoodNft: Fully on-chain storage with SVG rendering.

* Automated Scripts: Simplified deployment and minting processes.

* Testing Coverage: Unit and integration tests included.

---
## 📄 License

This project is licensed under the MIT License, but the license file is excluded from pushing to GitHub.

---

## 👥 Contributing

Contributions are welcome! Feel free to fork the repository and submit pull requests.

---

## 📧 Contact

For any queries or collaborations: 
https://linktr.ee/arefxv

---

Happy Building! 🚀