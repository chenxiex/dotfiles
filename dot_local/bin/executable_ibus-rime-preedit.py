#!/usr/bin/env python3
import yaml
import argparse
import subprocess
import logging
from pathlib import Path

def load_config(file_path):
    """
    读取YAML配置文件
    
    Args:
        file_path: YAML文件的路径
        
    Returns:
        dict: 配置文件的内容
    """
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            config = yaml.safe_load(file)
        return config
    except FileNotFoundError:
        logging.error(f"错误: 文件 {file_path} 不存在")
        return None
    except yaml.YAMLError as e:
        logging.error(f"错误: YAML解析失败 - {e}")
        return None

def save_config(config, file_path):
    """
    保存配置到YAML文件
    
    Args:
        config: 配置内容
        file_path: YAML文件的路径
    """
    try:
        with open(file_path, 'w', encoding='utf-8') as file:
            yaml.safe_dump(config, file, allow_unicode=True)
    except Exception as e:
        logging.error(f"错误: 无法保存文件 {file_path} - {e}")

if __name__ == "__main__":
    logging.basicConfig(level=logging.WARNING)

    parser = argparse.ArgumentParser(description="Toggle inline preedit style for ibus-rime")
    parser.add_argument('--mode', choices=['on', 'off', 'toggle'], default='toggle', help="Set inline preedit style (default: toggle)")
    args = parser.parse_args()

    config_path = Path().home() / '.config' / 'ibus' / 'rime' / 'ibus_rime.custom.yaml'
    config = load_config(config_path)
    if config is None:
        exit(1)

    before_status = config['patch']['style/inline_preedit']
    if args.mode == 'on':
        config['patch']['style/inline_preedit'] = True
    elif args.mode == 'off':
        config['patch']['style/inline_preedit'] = False
    elif args.mode == 'toggle':
        config['patch']['style/inline_preedit'] = not before_status
    after_status = config['patch']['style/inline_preedit']

    if after_status != before_status:
        save_config(config, config_path)
        subprocess.run(['ibus', 'restart'])
        logging.info(f"Inline preedit style changed to {'on' if after_status else 'off'}")
