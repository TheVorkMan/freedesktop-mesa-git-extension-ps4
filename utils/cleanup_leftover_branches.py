#!/usr/bin/env python3
"""Usage: python utils/cleanup_leftover_branches.py"""

import os
import re
import gitlab

url = "https://gitlab.com"
proj_id = os.environ.get("CI_PROJECT_ID", "4339844")
token = os.environ.get("FREEDESKTOP_API_KEY")

branch_regex = r"^update/(components|include|abi|bootstrap)_.*[.](bst|yml)-diff_md5-.*-for-(master|release/\d{2}[.]08)$"

gl = gitlab.Gitlab(url, private_token=token)
project = gl.projects.get(proj_id, lazy=True)
branches = project.branches.list(iterator=True, regex=branch_regex)
open_mrs = project.mergerequests.list(state="opened", iterator=True)

branch_names = {branch.name for branch in branches}
open_mr_branches = {
    mr.source_branch for mr in open_mrs if re.match(branch_regex, mr.source_branch)
}
branches_without_open_mrs = branch_names - open_mr_branches

if branches_without_open_mrs:
    for branch in branches_without_open_mrs:
        print(f"Deleting branch: {branch}")
        project.branches.delete(branch)
