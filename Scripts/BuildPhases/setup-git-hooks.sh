#!/bin/sh

SCRIPTS_DIR="${SRCROOT}/Scripts/GitHooks"
GIT_HOOKS_DIR="${SRCROOT}/.git/hooks"

cp "${SCRIPTS_DIR}/pre-commit" "${GIT_HOOKS_DIR}/pre-commit"
cp "${SCRIPTS_DIR}/prepare-commit-msg" "${GIT_HOOKS_DIR}/prepare-commit-msg"

chmod +x "${GIT_HOOKS_DIR}/pre-commit"
chmod +x "${GIT_HOOKS_DIR}/prepare-commit-msg"
