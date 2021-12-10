from brownie import accounts, network, config


FORKED_LOCAL_ENVIRONMENTS = ["mainnet-fork", "mainnet-fork-dev"]
LOCAL_BLOCKCHAIN_ENVIRONMENTS = ["development", "ganache-local"]


def get_account():
    if network.show_active() == "development":
        account = accounts[0]
        return account

    else:
        account = accounts.add(config["wallets"]["from_key"])
        return account

