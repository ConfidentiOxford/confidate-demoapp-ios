ZK IOS integration is in ‘ZK-setup’ branch. 

![Project Components](https://github.com/ConfidentiOxford/.github/blob/main/Solution_long.png)

## Development Challanges

### ZK -> IOS 

We have used [Mopro](https://github.com/oskarth/mopro/tree/main) to prove custom Circom ZK on IOS.

Unfortunatelly, we could not finish full integration on time, so it has been kept in the ‘ZK-setup’ branch.

The issue was with the installation and linking of the FFI Library. For some reason, it worked on a M1 Mac, however it would not compile on x86 (old gen) Mac, which our App developer was using. Thu we left the ZK Cuiruit umerged.

We also had to fork and modify the [Mopro](https://github.com/ConfidentiOxford/mopro) to make the setup process quicker (removed unnessesary compilations).

### ML -> ZK 

We have used [keras2circom](https://github.com/socathie/keras2circom) as it produces Circom circuits, which are compatible with Mopro.

We also had to fork and modify the [keras2circom](https://github.com/ConfidentiOxford/keras2circom_transpile) to make it suitable for slightly different models than in example. In particular, we added a Relu on a single dimension layer.

### IOS -> Ethereum

We have used [WalletConnectModal](https://github.com/WalletConnect/web3modal-swift) to integrate our app with Ethereum. However, there is an unresolved [issue](https://github.com/WalletConnect/web3modal-swift/issues/58) in current version which makes the app unusable (the CI even do not pass and we wonder how it got there). So we had to fork the current version and roll back one of dependacies. We did not push it yet.

Even after this, once app opened, we could not make it send a transaction request, even though other functions worked, so we ended up using [Web3 Swift](https://github.com/Boilertalk/Web3.swift)  library to send TX instead.

### Summary 

The IOS Ethereum part was the hardest, as there was no documentation and largely little experience on our side. Some errors were not due to us and we had no idea how to fix them.
