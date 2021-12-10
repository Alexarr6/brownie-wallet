from brownie import Simple_Wallet
from scripts.helpful_scripts import get_account

# Deployamos el contrato
def deploy_wallet():
    account = get_account()
    wallet = Simple_Wallet.deploy({"from": account})
    return wallet


def main():
    deploy_wallet()
