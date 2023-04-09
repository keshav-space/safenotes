import os
import pathlib

copyright = """/*
* Copyright (C) Keshav Priyadarshi and others - All Rights Reserved.
*
* SPDX-License-Identifier: GPL-3.0-or-later
* You may use, distribute and modify this code under the
* terms of the GPL-3.0+ license.
*
* You should have received a copy of the GNU General Public License v3.0 with
* this file. If not, please visit https://www.gnu.org/licenses/gpl-3.0.html
*
* See https://safenotes.dev for support or download.
*/

"""


def text_prepender(file, text):
    """
    Prepends text to a file.
    Parameters:
        file (str): The file to prepend to.
        text (str): The text to prepend.
    Returns:
        None
    """
    with open(file, "r") as f:
        with open("newfile.txt", "w") as f2:
            f2.write(text)
            f2.write(f.read())
    os.remove(file)
    os.rename("newfile.txt", file)


def update_copyright():
    """
    Updates the copyright in all dart files in lib directory.
    """
    for file in pathlib.Path("lib").glob("**/*.dart"):
        text_prepender(file=str(file), text=copyright)


if __name__ == "__main__":
    update_copyright()
