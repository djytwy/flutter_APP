"""
修改版本号的Python脚本，Python 版本 3.7
date: 2019-11-18
author：twy
"""

import re
import time


def run():
    with open('./lib/config/config.dart', 'r') as f:
        my_str = f.read()
        re_v = re.findall(r"const appVersion = '1.0.(\d+) ", my_str)
        v = int(re_v[0]) + 1
        new_str = my_str.replace(f"const appVersion = '1.0.{re_v[0]}", f"const appVersion = '1.0.{v}")
        re_time_str = re.findall(r' (\d+)-(\d+)-(\d+)', new_str)[0]
        time_str = "-".join(re_time_str)
        local_time = time.localtime()
        new_time = f'{local_time.tm_year}-{local_time.tm_mon}-{local_time.tm_mday}'
        print(f'构建版本：1.0.{v} {new_time}')
        new_str = new_str.replace(time_str, new_time)
        f.close()
    with open('./lib/config/config.dart', 'w') as f:
        f.write(new_str)
        f.close()

    with open('pubspec.yaml', 'r') as f:
        _str = f.read()
        new_str = _str.replace(f'version: 1.0.{re_v[0]}+1', f'version: 1.0.{v}+1')
        f.close()

    with open('pubspec.yaml', 'w') as f:
        f.write(new_str)
        f.close()


if __name__ == "__main__":
    run()
    print("修改版本号完成，进入构建......")

