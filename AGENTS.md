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
