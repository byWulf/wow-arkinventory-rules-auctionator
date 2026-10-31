local rule = ArkInventoryRules:NewModule( "ArkInventoryRules_Auctionator" )

local CALLER_ID = "ArkInventoryRules_Auctionator"

local function IsItem( )
	return ArkInventoryRules.Object.h and ArkInventoryRules.Object.class == "item"
end

local function AuctionatorReady( )
	return Auctionator and Auctionator.API and Auctionator.API.v1 and Auctionator.API.v1.GetAuctionPriceByItemLink
end

-- auction house price per unit in copper (0 if unknown)
function rule.ahprice( )
	if not IsItem( ) or not AuctionatorReady( ) then
		return 0
	end
	local ok, price = pcall( Auctionator.API.v1.GetAuctionPriceByItemLink, CALLER_ID, ArkInventoryRules.Object.h )
	return ( ok and price ) or 0
end

-- vendor sell price per unit in copper (vendorprice() is multiplied by stack size)
function rule.vendorunit( )
	if not IsItem( ) then
		return 0
	end
	local price = ArkInventoryRules.Object.info.vendorprice or 0
	return price > 0 and price or 0
end

-- ahflip( factor, mindiff ): not soulbound, not junk, AH price known, AH >= factor * vendor and AH - vendor >= mindiff (copper)
function rule.ahflip( factor, mindiff )
	if not IsItem( ) then
		return false
	end
	if ArkInventoryRules.System.boolean_soulbound( ) or ArkInventoryRules.System.boolean_junk( ) then
		return false
	end
	local factor = tonumber( factor ) or 2
	local mindiff = tonumber( mindiff ) or 100
	local ah = rule.ahprice( )
	if ah <= 0 then
		return false
	end
	local vendor = rule.vendorunit( )
	return ah >= factor * vendor and ah - vendor >= mindiff
end

-- Auctionator prices change after scans, ArkInventory caches rule results per item
local refreshPending = false
local function RefreshCategories( )
	if refreshPending then return end
	refreshPending = true
	C_Timer.After( 2, function( )
		refreshPending = false
		ArkInventory.ItemCacheClear( )
		ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Recalculate )
	end )
end

function rule:OnEnable( )
	ArkInventoryRules.Register( self, "ahprice", rule.ahprice )
	ArkInventoryRules.Register( self, "vendorunit", rule.vendorunit )
	ArkInventoryRules.Register( self, "ahflip", rule.ahflip )
	if AuctionatorReady( ) and Auctionator.API.v1.RegisterForDBUpdate then
		Auctionator.API.v1.RegisterForDBUpdate( CALLER_ID, RefreshCategories )
	end
	ArkInventory.ItemCacheClear( )
end
