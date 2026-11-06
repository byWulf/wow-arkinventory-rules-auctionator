# AGENTS.md

## Language

All documentation in this repository (README, AGENTS.md, code comments, commit messages) is written in **English**.

## Project

WoW addon `ArkInventoryRules_Auctionator`: registers ArkInventory rule functions (`ahprice()`, `vendorunit()`, `ahflip()`) backed by Auctionator prices.

- `ArkInventoryRules_Auctionator.toc`: addon manifest, interface `16001` (WoW Forever only, Classic Era is not supported)
- `ArkInventoryRules_Auctionator.lua`: rule functions, registered via `ArkInventoryRules.Register`, plus a cache refresh hooked to `Auctionator.API.v1.RegisterForDBUpdate`
- `README.md`: user documentation, keep it in sync with the rule functions

## Installed copies

The addon is installed as a plain copy (not a clone) in:

- `C:\Program Files (x86)\World of Warcraft\_forever_\Interface\AddOns\ArkInventoryRules_Auctionator`

After changing the `.toc` or `.lua`, copy them to the Forever installation. The folder name must stay `ArkInventoryRules_Auctionator`.

## Testing

There is no automated test setup. Changes are verified in game with `/reload`; ArkInventory reports rule errors in chat and in the rule editor (`/ai rules`).

## Releasing

Published on CurseForge as project `1787592` (https://www.curseforge.com/wow/addons/arkinventory-rules-auctionator) and as GitHub releases. Releases are built by `.github/workflows/release.yml` with the BigWigs packager (`.pkgmeta` sets the folder name and leaves out `AGENTS.md`/`CLAUDE.md`):

1. Commit and push the changes to `main`.
2. Tag and push: `git tag -a vX.Y.Z -m "X.Y.Z"` and `git push origin vX.Y.Z` (semantic versioning).
3. The workflow packages the addon, replaces `@project-version@` in the TOC with the tag, uploads the zip to CurseForge (game version from the TOC interface, WoW Forever) and creates the GitHub release. The changelog is generated from the commit messages since the previous tag.

The CurseForge upload needs the repository secret `CF_API_TOKEN` (a CurseForge author API token). "Run workflow" on the Actions tab builds the package as an artifact without uploading. Never edit `## Version` in the TOC by hand; installed dev copies show `@project-version@`.
