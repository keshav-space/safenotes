#
# Copyright (C) Keshav Priyadarshi and others - All Rights Reserved.
#
# SPDX-License-Identifier: GPL-3.0-or-later
# You may use, distribute and modify this code under the
# terms of the GPL-3.0+ license.
#
# You should have received a copy of the GNU General Public License v3.0 with
# this file. If not, please visit https://www.gnu.org/licenses/gpl-3.0.html
#
# See https://safenotes.dev for support or download.
#

import os
import re
import shutil
from pathlib import Path


def copy(src: str, dst: str, newdir: Path):
    """
    Copies a file from one location to another.
    """
    source = (
        Path(f"build/app/outputs/bundle/release/{src}").resolve()
        if dst.endswith(".aab")
        else Path(f"build/app/outputs/apk/release/{src}").resolve()
    )
    destination = Path.joinpath(newdir, dst)
    shutil.copy2(src=source, dst=destination)


def get_destination():
    """
    Gets the destination path for the release.

    Parameters:
        None

    Returns:
        github (Path): The path to the github release.
        playstore (Path): The path to the playstore release.
        version (str): The version of the release.
    """
    pubspec = open("pubspec.yaml", "r")
    x = re.search(r"version:\s.+\+(\d+)", pubspec.read())

    if x is None:
        print("Couldn't parse pubspec.yaml for version")
        exit()
    version = x[0].split("version:")[-1].split("+")[0].strip()

    github = Path(f"releases/{version}/github").resolve()
    playstore = Path(f"releases/{version}/playstore").resolve()
    playstore.mkdir(parents=True, exist_ok=True)
    github.mkdir(parents=True, exist_ok=True)
    return github, playstore, version


def make_release():
    """
    Makes a release.
    """
    github, playstore, version = get_destination()
    os.system("flutter clean && flutter pub get")
    os.system(
        "flutter build apk --target-platform android-arm,android-arm64,android-x64 --split-per-abi"
    )
    copy(
        src="app-x86_64-release.apk",
        dst=f"safenotes-{version}-x86_64.apk",
        newdir=github,
    )
    copy(
        src="app-arm64-v8a-release.apk",
        dst=f"safenotes-{version}-arm64-v8a.apk",
        newdir=github,
    )
    copy(
        src="app-armeabi-v7a-release.apk",
        dst=f"safenotes-{version}-armeabi-v7a.apk",
        newdir=github,
    )
    copy(
        src="output-metadata.json",
        dst=f"metadata-{version}-split-per-abi.json",
        newdir=github,
    )

    os.system("flutter clean && flutter pub get")
    os.system("flutter build apk")
    copy(
        src="app-release.apk",
        dst=f"safenotes-{version}-all.apk",
        newdir=github,
    )
    copy(
        src="output-metadata.json",
        dst=f"metadata-{version}-all.json",
        newdir=github,
    )

    os.system("flutter clean && flutter pub get")
    os.system("flutter build appbundle")
    copy(
        src="app-release.aab",
        dst=f"safenotes-{version}.aab",
        newdir=playstore,
    )


if __name__ == "__main__":
    make_release()
