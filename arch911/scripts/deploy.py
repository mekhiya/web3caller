from importlib.abc import Loader
import json
import os
import shutil
from brownie import Arch911Contract, MockV3Aggregator, network, config
from scripts.helpful_scripts import (
    get_account,
    deploy_mocks,
    LOCAL_BLOCKCHAIN_ENVIRONMENTS,
)
import yaml


def deploy_arch_911(update_frontend_do_it=False):
    account = get_account()
    print(f"account is {account}")
    print(f"Network is {network.show_active()}")

    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        price_feed_address = config["networks"][network.show_active()][
            "eth_usd_price_feed"
        ]
        print(f"price_feed_address is {price_feed_address}")
    else:
        deploy_mocks()
        price_feed_address = MockV3Aggregator[-1].address

    arch_911_contract = Arch911Contract.deploy(
        price_feed_address,
        {"from": account},
        publish_source=config["networks"][network.show_active()].get("verify"),
    )
    print(f"Contract deployed to {arch_911_contract.address}")
    if update_frontend_do_it:
        update_front_end()


def update_front_end():
    # copy build folder to front-end project
    copy_folders_to_front_end("./build", "./front_end/src/chain-info")

    # Sedinf config to front end in json format since it doesnt understnat yaml
    with open("brownie-config.yaml", "r") as brownie_config:
        config_dict = yaml.load(brownie_config, Loader=yaml.FullLoader)
        with open("./front_end/src/brownie-config.json", "w") as brownie_config_json:
            json.dump(config_dict, brownie_config_json)
    print("json config sent to frontend")


def copy_folders_to_front_end(src, dest):
    if os.path.exists(dest):
        shutil.rmtree(dest)
    shutil.copytree(src, dest)


def main():
    deploy_arch_911(update_frontend_do_it=True)
