from brownie import Simple_Wallet, accounts
from scripts.helpful_scripts import get_account
from scripts.deploy import deploy_wallet
from web3 import Web3


def add_balance():
    account = get_account()
    wallet = deploy_wallet()
    print(wallet.get_balance())
    amount_fund = 10 * 10 ** 18
    # Añadimos balance
    print("Funding...")
    transaction = wallet.add_balance({"from": account, "value": amount_fund})
    print("Funded!")
    transaction.wait(1)
    print(wallet.balance())


def add_employee(first_name="Alex", last_name="Arias", address=accounts[1]):
    account = get_account()
    wallet = Simple_Wallet[-1]
    print("Adding employee...")
    wallet.add_employee(first_name, last_name, address, {"from": account})
    print("Employee aded!")


def withdraw_employee():
    account = accounts[0]
    wallet = Simple_Wallet[-1]
    print(f"El balance de la cuenta es: {account.balance()}")
    print("Withdrawing...")
    tx = wallet.withdraw_balance_employees({"from": account})
    tx.wait(1)

    print("Withdraw!")
    print(f"El balance de la cuenta ha sido actualizado: {account.balance()}")


def block_payments():
    account = get_account()
    wallet = Simple_Wallet[-1]
    print("Blocking account...")
    wallet.block_payments({"from": account})
    print("Blocked!")


def main():
    add_balance()
    add_employee()
    # block_payments()
    withdraw_employee()


# 100000000000000000000
# 101000000000000000000
