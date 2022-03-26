from scripts.helpful_scripts import (
    get_account,
    deploy_mocks,
    LOCAL_BLOCKCHAIN_ENVIRONMENTS,
)
from brownie import Arch911Contract, MockV3Aggregator, network, config


def read_deposits():
    # get contract object of kovan
    # call getValue
    arch911 = Arch911Contract[-1]
    (
        numOfDeposits,
        numOfUniqueDepositors,
        totalDepositValue,
        numberOfWatch,
    ) = arch911.getVaultDetails()

    print(f"numOfDeposits : {numOfDeposits}")
    print(f"numOfUniqueDepositors : {numOfUniqueDepositors}")
    print(f"totalDepositValue : {totalDepositValue}")
    print(f"numberOfWatch : {numberOfWatch}")

    arrDeposit = arch911.getDepositsByOwner(
        "0xb86b8890b4200C8B49f611b941334CA45Dce6Dd6"
    )
    print(arrDeposit)

    arrWatchs = arch911.getWatchesOnDeposit(
        "14011211573969000904704374191174873019621272439701847264185678318135851813298"
    )
    print(arrWatchs)
    print(f"totalVaultValue is : {arch911.totalVaultValue()}")


def main():
    read_deposits()
