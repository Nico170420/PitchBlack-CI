#!/bin/bash

#
# Copyright © 2023 Nico170420
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Variables
Device="p3s"                                                                                         #<--- Set Device Codename here
TARGET="pbrp"                                                                                        #<--- Set Target (recoveryimage or pbrp)

# A Function to Send Posts to Telegram
telegram_message() {
	curl -s -X POST "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" \
	-d chat_id="${TG_CHAT_ID}" \
	-d parse_mode="HTML" \
	-d text="$1"
}

# Send the Telegram Message

echo -e \
"
PitchBlack Recovery CI

✔️ The Build has been Triggered!

📱 Device: "${Device}"
🖥 Build System: "PBRP 4.0"
🌲 Logs: <a href=\"https://cirrus-ci.com/build/${CIRRUS_BUILD_ID}\">Here</a>
" > tg.html

TG_TEXT=$(< tg.html)

telegram_message "${TG_TEXT}"
echo " "

# Setup the Build Enviroment
. build/envsetup.sh
export ALLOW_MISSING_DEPENDENCIES=true
export TEST_BUILD=true
lunch twrp_${Device}-eng

# Build ZIP/IMG File
mka -j$(nproc) ${TARGET}

# Exit
exit 0
