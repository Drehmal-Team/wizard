#!/bin/sh
echo -ne '\033c\033]0;Drehmal Installer\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/DrehmalInstaller - Linux.x86_64" "$@"
