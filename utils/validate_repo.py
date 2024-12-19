#!/usr/bin/env python3
"""Usage python validate_repo.py --path /path/to/ostree/repo"""

import subprocess
import re
import os
import argparse


def list_refs(path):
    refs = subprocess.check_output(["ostree", "refs"], cwd=path).decode().splitlines()
    return set(refs)


def get_branch():
    return os.environ["CI_COMMIT_BRANCH"]


def validate_environment():
    if not os.environ.get("GITLAB_CI", "false") == "true":
        raise ValueError("Not running inside Gitlab CI")

    if not os.environ.get("CI_COMMIT_REF_PROTECTED", "false") == "true":
        raise ValueError("Not running for a protected ref")

    if os.environ.get("RELEASE_CHANNEL", None) != "beta":
        raise ValueError("RELEASE_CHANNEL is not set to beta")


def validate_refs(path):
    ref_id_pattern = r"^org\.freedesktop\.Platform\.(GL(32)?(?:\.Debug)?\.mesa-git)$"

    ref_branch_pattern = r"^\d{2}\.08$"
    if get_branch() == "master":
        ref_branch_pattern = r"^\d{2}\.08beta$"

    expected_refs = {
        "runtime/org.freedesktop.Platform.GL.mesa-git/aarch64",
        "runtime/org.freedesktop.Platform.GL.mesa-git/x86_64",
        "runtime/org.freedesktop.Platform.GL.Debug.mesa-git/x86_64",
        "runtime/org.freedesktop.Platform.GL32.Debug.mesa-git/x86_64",
        "runtime/org.freedesktop.Platform.GL32.mesa-git/x86_64",
        "runtime/org.freedesktop.Platform.GL.Debug.mesa-git/aarch64",
    }
    arches = ("x86_64", "aarch64")

    refs = list_refs(path)

    if not refs:
        raise ValueError(f"No refs found in {path}")

    refs_unbranched = {item.rsplit("/", 1)[0] for item in refs}

    for ref in refs:
        if ref.startswith(("appstream/", "appstream2/", "screenshots/")):
            continue
        ref_splits = ref.split("/")

        if len(ref_splits) != 4:
            raise ValueError(f"Invalid ref: {ref}")

        ref_type, ref_id, ref_arch, ref_branch = (
            ref_splits[0],
            ref_splits[1],
            ref_splits[2],
            ref_splits[3],
        )

        if not ref_type == "runtime":
            raise ValueError(f"Ref is not a runtime: {ref}")

        if not re.match(ref_id_pattern, ref_id):
            raise ValueError(f"Invalid ID: {ref_id}, {ref}")

        if ref_arch not in arches:
            raise ValueError(f"Invalid architecture: {ref_arch}, {ref}")

        if not re.match(ref_branch_pattern, ref_branch):
            raise ValueError(f"Invalid branch: {ref_branch}, {ref}")

    if not refs_unbranched == expected_refs:
        raise Exception("Did not find all expected refs")


def main():
    parser = argparse.ArgumentParser(
        description="Validate refs before Flathub push (mesa-git)"
    )
    parser.add_argument("--path", type=str, help="path to the OSTree repository")
    args = parser.parse_args()

    validate_environment()
    validate_refs(args.repo_path)


if __name__ == "__main__":
    main()
