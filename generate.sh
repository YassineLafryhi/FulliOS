#!/bin/zsh

# WIP: Script to generate iOS app using a specified architecture

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'
BOLD='\033[1m'

print_bold() {
  echo -e "${BOLD}${1}${RESET}"
}

print_color() {
  echo -e "${1}${2}${RESET}"
}

print_bold "Enter the app name:"
read app_name
print_color "${GREEN}" "App Name: ${app_name}"

print_bold "Enter the architecture (VIPER, VIP, MVVM, MVP, MVC):"
read architecture
print_color "${GREEN}" "Architecture: ${architecture}"

print_bold "Enter the path for menu PNG:"
read menu_png_path
print_color "${GREEN}" "Menu PNG Path: ${menu_png_path}"

print_bold "Enter the used libraries (comma-separated):"
read used_libs
print_color "${GREEN}" "Used Libraries: ${used_libs}"


echo "Generating project files for ${app_name} with ${architecture} architecture..."
