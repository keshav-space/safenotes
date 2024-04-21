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

clean:
	@echo "-> Delete the build/ and .dart_tool/ directories"
	flutter clean

get:
	@echo "-> Get the current package's dependencies"
	flutter pub get

analyze:
	@echo "-> Analyze the code for linting errors"
	flutter analyze lib test

isort:
	@echo "-> Apply import_sorter to ensure proper imports ordering"
	dart run import_sorter:main

format:
	@echo "-> Fix formatting issues in the code"
	dart format .

valid: isort format check analyze

test:
	@echo "-> Run widget tests"
	flutter test

.PHONY: clean get check test isort format valid