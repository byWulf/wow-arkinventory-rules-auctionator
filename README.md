# ArkInventory [Rules] Auctionator

A small plugin for [ArkInventory](https://www.curseforge.com/wow/addons/ark-inventory) that gives ArkInventory rules access to auction house prices from [Auctionator](https://www.curseforge.com/wow/addons/auctionator).

ArkInventory evaluates rule formulas in a sandbox where only its own functions (`vendorprice()`, `soulbound()`, `tsm()`, …) are available. Auctionator is not supported out of the box. This plugin registers additional rule functions to fill that gap.

Typical use: an **"AH instead of vendor"** category for all items that sell for considerably more on the auction house than at a vendor.

## Supported game versions

| Version | Interface |
|---|---|
| WoW Classic Era | 11509 |
| WoW Classic Forever | 16001 |

Other versions are untested. If ArkInventory and Auctionator provide the same APIs there, adding the interface number to the `.toc` is usually enough.

## Requirements

- ArkInventory including **ArkInventoryRules** (enabled)
- Auctionator with scanned prices (full scan or searches at the AH)

## Installation

The folder in your AddOns directory **must** be named `ArkInventoryRules_Auctionator`, otherwise WoW will not load the addon:

```bash
cd "C:/Program Files (x86)/World of Warcraft/_classic_era_/Interface/AddOns"
git clone https://github.com/byWulf/wow-arkinventory-rules-auctionator.git ArkInventoryRules_Auctionator
```

For Forever, use `_forever_/Interface/AddOns` instead. Alternatively, download the repository as a ZIP and extract its contents to `Interface/AddOns/ArkInventoryRules_Auctionator/`.

Then `/reload` in game.

## Rule functions

All prices are in **copper** (1s = 100, 1g = 10000) and **per unit**.

| Function | Returns |
|---|---|
| `ahprice()` | Auction house price according to Auctionator, `0` if unknown |
| `vendorunit()` | Vendor sell price per unit. The built-in `vendorprice()` multiplies by stack size instead. |
| `ahflip(factor, mindiff)` | `true` if all conditions below are met |

`ahflip(factor, mindiff)` matches if the item

- is not soulbound,
- is not in the system category "Junk" (grey items and items flagged by junk addons),
- has a known AH price,
- sells on the AH for at least `factor` × vendor price (default `2`),
- sells on the AH for at least `mindiff` copper more than at a vendor (default `100` = 1s).

## Examples

Category for items that sell on the AH for at least twice the vendor price and at least 1s more:

```
ahflip()
```

Stricter threshold, triple the price and at least 50s difference:

```
ahflip(3, 5000)
```

Keep potions in the potion categories (419 = mana potions, 420 = healing potions, 424 = potions):

```
ahflip() and not category(419, 420, 424)
```

Exclude all consumables (item class 0):

```
ahflip() and not type(0)
```

Build your own conditions from the individual functions:

```
not soulbound() and ahprice() >= 10000 and vendorunit() > 0
```

## In-game setup

1. Open `/ai rules` and create a new rule, e.g. "AH instead of vendor".
2. Enter a formula, e.g. `ahflip()`, and enable the rule.
3. In the bag window, right-click a bar → *Categories – Assignable* → *Rule* → assign the new rule to the bar.

## Good to know

- **Rules beat built-in categories.** In ArkInventory a matching rule always wins over default categories such as "Potions". A rule's priority only matters against other rules. To exclude built-in categories, use `not category(...)` in the formula.
- **Manual assignments beat rules.** An item you assigned to a category by hand stays there.
- **Refresh after scans.** ArkInventory caches rule results. The plugin clears this cache automatically whenever Auctionator has processed new prices (full scan or search).
- **Items without a vendor price** (vendor price 0) match `ahflip()` as soon as their AH price reaches `mindiff`. Add `and vendorunit() > 0` if you don't want that.
- Without Auctionator loaded, `ahprice()` always returns `0` and `ahflip()` never matches. No errors are raised.
