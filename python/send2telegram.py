#!/usr/bin/env python3

__author__ = "@zorbax"

import argparse
import json
from configparser import ConfigParser

import requests

CONFIG_FILE = "config.cfg"


class TelegramBot:
    def __init__(self, config):
        self.token = self.read_token(config)
        self.base = "https://api.telegram.org/bot{}/".format(self.token)

    def get_updates(self):
        getupdates = self.base + "getUpdates?timeout=100"
        r = requests.get(getupdates)
        return json.loads(r.content)

    def get_chatid(self):
        getupdates = self.base + "getUpdates?timeout=100"
        r = requests.get(getupdates, params={"result": "chat"})
        input_dict = json.loads(r.content)
        return input_dict["result"][0]["message"]["chat"]["id"]

    def send_message(self, msg, chat_id):
        url = self.base + "sendMessage?chat_id={}&text={}".format(chat_id, msg)
        if msg is not None:
            requests.get(url)
        return None

    @staticmethod
    def read_token(config):
        cfg_parser = ConfigParser()
        cfg_parser.read(config)
        return cfg_parser.get("credentials", "token")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Send message to a Telegram Bot.")
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument(
        "-m",
        dest="msg",
        type=str,
        metavar="MESSAGE_STRING",
        help='"The Message, like string"',
    )
    group.add_argument(
        "-f",
        dest="msg_file",
        metavar="MESSAGE_FILE",
        type=argparse.FileType("r"),
        help="Message as file, e.g. file.log",
    )
    args = parser.parse_args()

    bot = TelegramBot(config=CONFIG_FILE)
    chatid = bot.get_chatid()

    if args.msg:
        bot.send_message(args.msg, chatid)
    else:
        bot.send_message(args.msg_file.read(), chatid)
