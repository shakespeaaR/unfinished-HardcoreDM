//HardcoreM

#include <a_samp>
#include <a_zone>
#include <dini>
#include <dudb>
#include <colors>
#include <weapon-config>
#include <zcmd>
#include <sscanf2>
#include <callbacks>
#include <streamer>
#include <foreach>
#include <geolite>
#include <mapandreas>
#include "includes/textdraws.inc"
#include "includes/mapfix.inc"

#pragma unused ret_memcpy
#undef MAX_PLAYERS

#define MAX_GANGS                           50
#define MAX_AREAS                           250
#define MAX_SPAWNS                          15
#define MAX_PLAYERS							40
#define MAX_GW								3
#define MAX_ARENAS							40
#define CADD_SAVES							30
#define MAP_ANDREAS_MODE_NONE				0

#define DB_PATCH 							"HardcoreDM/playersbase.db"
#define FILE_CONFIG                         "HardcoreDM/Config.cfg"
#define GM_VER								"HardcoreDM Beta v0.12"
#define PATH_ARENAS							"HardcoreDM/Arenas/"

#define AREA_SETTING_NONE           		0
#define AREA_SETTING_NE_POS         		1
#define AREA_SETTING_SW_POS         		2
#define AREA_SETTING_SPAWNS                 3

#define KEY_AIM KEY_HANDBRAKE

#define D_REGISTER              			10001
#define D_LOGIN                 			10002
#define D_GANG                              10003
#define D_GANG_DELETE                       10004
#define D_GANG_ADMIN_PLAYER_DELETE          10005
#define D_GANG_ADMIN_CHANGE_NAME            10006
#define D_GANG_ADMIN_CHANGE_TAG             10007
#define D_GANG_INVITE_PLAYER                10008
#define D_GANG_REMOVE_PLAYER                10009
#define D_GANG_INVITE                       10010
#define D_GANG_ADMIN_CHANGE_LIMIT           10011
#define D_GANG_CREATE                       10012
#define D_AREA                      		10013
#define D_AREA_DELETE               		10014
#define D_AREA_CREATE_NAME          		10015
#define D_SELECT_FIRST_WEAPON               10016
#define D_SELECT_SECOND_WEAPON              10017
#define D_SELECT_THIRD_WEAPON               10018
#define D_SELECT_FOURTH_WEAPON              10020
#define D_GANG_COLOR_CHANGE                 10021
#define D_COLORS                			10022
#define D_COLORS2               			10023
#define D_COLORS3               			10024
#define D_SOLO								10025
#define D_SOLO2								10026
#define D_GANG_SKIN_CHANGE					10027
#define D_SOLOCBUG							10028
#define D_SOLOARMOUR						10029
#define D_RULES								10030
#define D_HELP								10031
#define D_CMD								10032
#define D_AREALIST							10033
#define D_HDMPANEL							10034
#define D_HDMPANEL_ACCOUNTS					10035
#define D_HDMPANEL_ACCOUNTEDIT				10036
#define D_PLAYERSTATS						10037
#define D_LASTIP							10038
#define D_PINFO								10039
#define D_GANGWARWEAPON						10040	
#define D_CRASHADDPLAYERSLIST				10042
#define D_CRASHADDPLAYERADD					10043
#define D_AREALIST2							10044
#define D_GANGCHALLENGE						10045
#define D_GANGCHALL_GANGLIST				10046
#define D_GANGCHALL_PLAYERSLIMIT			10047
#define D_GANGCHALL_ARMOURS					10048
#define D_GANGCHALL_CBUG					10049
#define D_GANGCHALL_FF						10050

//gangwar
#define AINI_HOME						"Home"
#define AINI_INTERIOR					"Interior"
#define AINI_SPAWN1						"SpawnT1"
#define AINI_SPAWN2						"SpawnT2"
#define AINI_AREA						"Area"

//antycbug
#define PRESSED(%0) (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

new bool:cbuger[MAX_PLAYERS];
new cbugslap[MAX_PLAYERS];
new LastFiredWeapon[MAX_PLAYERS];

new SniperTimer, HorseshoeTimer, AreaTimer;
new total_vehicles_from_files=0;
//colors
#define COLOR_INFO 							0xFFB400FF
#define COLOR_JOIN							0xFFE600ff
#define COLOR_LEAVE							0xFFE6A0FF
#define COLOR_GANGINFO						0x985600FF
#define COLOR_PM							0x00ED9AFF
#define COLOR_ERROR							0xC7836AFF
#define COLOR_BANKICK						0xFF83FFFF
#define COLOR_AREA							0xFF88FFFF
//geolite
#define MAX_AUTONOMOUS_SYSTEM_LENGTH    95
#define MAX_COUNTRY_LENGTH              45
#define MAX_CITY_LENGTH                 109
#define MAX_UTC_LENGTH                  7

new Float:RandomSpawnOneDe[][4] =
{
		
	{231.9205,144.1670,1003.0234,121.2105},
	{209.5662,151.0520,1003.0234,331.1759},
	{208.3694,142.1815,1003.0234,277.5059},
	{219.8839,168.2187,1003.0234,0.9117},
	{190.6700,158.1537,1003.0234,90.3011},
	{191.4854,179.4305,1003.0234,87.3093},
	{227.8413,181.9559,1003.0313,318.9366},
	{230.2379,162.4702,1003.0234,20.5844},
	{254.2162,190.6175,1008.1719,271.9754},
	{257.7975,195.8050,1008.1719,92.2049},
	{299.5930,190.7475,1007.1794,84.9467},
	{285.6904,176.2697,1007.1794,153.1220}	
};

new Float:RandomSpawnSawn[][4] = 
{
	{-1290.2472,-96.8194,14.1484,43.6452},
	{-1236.9280,-94.9154,14.1440,260.8579},
	{-1201.3809,-99.6040,14.1440,308.5443}, 
	{-1150.8037,-154.9004,14.1484,249.7976}, 
	{-1142.9146,-109.5682,14.1440,349.1594}, 
	{-1149.7616,-214.1337,14.1484,180.3584},
	{-1188.0563,-251.6154,14.1484,141.9190},
	{-1241.9377,-251.2751,14.1440,81.3591},
	{-1244.6710,-202.0254,14.1440,355.8680},
	{-1227.1487,-154.1960,14.1484,313.7118}
};

new Float:RandomSpawnGangWarLobby[][4] = 
{
	{2008.1030,1018.2995,994.4688,217.3911},
	{1976.6150,996.6804,994.4688,146.6188},
	{1964.1248,989.4542,992.4688,108.2497},
	{1947.6418,972.6204,994.4688,88.8312},
	{1944.6180,1008.2519,992.4688,0.9802},
	{1951.2516,1033.9886,992.4688,311.9660},
	{1960.7910,1030.9297,992.4688,242.9485},
	{1974.6475,1041.8339,994.4688,21.6854},
	{1959.7850,1062.4370,994.4688,59.7034},
	{1941.8516,1047.1757,992.4727,163.2297},
	{1936.1439,1027.6069,992.4688,144.1621},
	{1930.4109,990.0656,994.4609,185.8066}
};

new aVehicleNames[212][] =
{
        {"Landstalker"},    {"Bravura"},            {"Buffalo"},            {"Linerunner"},     {"Perrenial"},      {"Sentinel"},       {"Dumper"},
        {"Firetruck"},      {"Trashmaster"},        {"Stretch"},            {"Manana"},         {"Infernus"},       {"Voodoo"},         {"Pony"},           {"Mule"},
        {"Cheetah"},        {"Ambulance"},          {"Leviathan"},          {"Moonbeam"},       {"Esperanto"},      {"Taxi"},           {"Washington"},
        {"Bobcat"},         {"Mr Whoopee"},         {"BF Injection"},       {"Hunter"},         {"Premier"},        {"Enforcer"},       {"Securicar"},
        {"Banshee"},        {"Predator"},           {"Bus"},{"Rhino"},      {"Barracks"},       {"Hotknife"},       {"Artic Trailer 1"},      {"Previon"},
        {"Coach"},          {"Cabbie"},             {"Stallion"},           {"Rumpo"},          {"RC Bandit"},      {"Romero"},         {"Packer"},         {"Monster"},
        {"Admiral"},        {"Squalo"},             {"Seasparrow"},         {"Pizzaboy"},       {"Tram"},           {"Artic Trailer 2"},      {"Turismo"},
        {"Speeder"},        {"Reefer"},             {"Tropic"},             {"Flatbed"},        {"Yankee"},         {"Caddy"},          {"Solair"},         {"Berkley's RC Van"},
        {"Skimmer"},        {"PCJ-6_0_0"},          {"Faggio"},             {"Freeway"},        {"RC Baron"},       {"RC Raider"},      {"Glendale"},       {"Oceanic"},
        {"Sanchez"},        {"Sparrow"},            {"Patriot"},            {"Quad"},           {"Coastguard"},     {"Dinghy"},         {"Hermes"},         {"Sabre"},
        {"Rustler"},        {"ZR-3_5_0"},           {"Walton"},             {"Regina"},         {"Comet"},{"BMX"},  {"Burrito"},        {"Camper"},         {"Marquis"},
        {"Baggage"},        {"Dozer"},              {"Maverick"},           {"News Chopper"},   {"Rancher"},        {"FBI Rancher"},    {"Virgo"},          {"Greenwood"},
        {"Jetmax"},         {"Hotring"},            {"Sandking"},           {"Blista Compact"}, {"Police Maverick"},{"Boxville"},       {"Benson"},
        {"Mesa"},           {"RC Goblin"},          {"Hotring Racer A"},    {"Hotring Racer B"},{"Bloodring Banger"},{"Rancher"},
        {"Super GT"},       {"Elegant"},            {"Journey"},            {"Bike"},           {"Mountain Bike"},  {"Beagle"},         {"Cropdust"},       {"Stunt"},
        {"Tanker"},         {"Roadtrain"},          {"Nebula"},             {"Majestic"},       {"Buccaneer"},      {"Shamal"},         {"Hydra"},          {"FCR-900"},
        {"NRG-500"},        {"HPV1000"},            {"Cement Truck"},       {"Tow Truck"},      {"Fortune"},        {"Cadrona"},        {"FBI Truck"},
        {"Willard"},        {"Forklift"},           {"Tractor"},            {"Combine"},        {"Feltzer"},        {"Remington"},      {"Slamvan"},
        {"Blade"},          {"Freight"},            {"Streak"},             {"Vortex"},         {"Vincent"},        {"Bullet"},         {"Clover"},         {"Sadler"},
        {"Firetruck LA"},   {"Hustler"},            {"Intruder"},           {"Primo"},          {"Cargobob"},       {"Tampa"},          {"Sunrise"},        {"Merit"},
        {"Utility"},        {"Nevada"},             {"Yosemite"},           {"Windsor"},        {"Monster A"},      {"Monster B"},      {"Uranus"},         {"Jester"},
        {"Sultan"},         {"Stratum"},            {"Elegy"},              {"Raindance"},      {"RC Tiger"},       {"Flash"},          {"Tahoma"},         {"Savanna"},
        {"Bandito"},        {"Freight Flat"},       {"Streak Carriage"},    {"Kart"},           {"Mower"},          {"Duneride"},       {"Sweeper"},
        {"Broadway"},       {"Tornado"},            {"AT-400"},             {"DFT-30"},         {"Huntley"},        {"Stafford"},       {"BF-400"},         {"Newsvan"},
        {"Tug"},            {"Chemical Trailer"},   {"Emperor"},            {"Wayfarer"},       {"Euros"},          {"Hotdog"},         {"Club"},           {"Freight Carriage"},
        {"Artic Trailer 3"},{"Andromada"},          {"Dodo"},               {"RC Cam"},         {"Launch"},         {"Police Car LSPD"},{"Police Car SFPD"},
        {"Police _LVPD"},   {"Police Ranger"},      {"Picador"},            {"SWAT. Van"},      {"Alpha"},          {"Phoenix"},        {"Glendale"},
        {"Sadler"},         {"Luggage Trailer A"},  {"Luggage Trailer B"},  {"Stair Trailer"},{"Boxville"},         {"Farm Plow"},
        {"Utility Trailer"}
};

new WeaponNames[55][] =
{
        {"Punch"},{"Brass Knuckles"},{"Golf Club"},{"Nite Stick"},{"Knife"},{"Baseball Bat"},{"Shovel"},{"Pool Cue"},{"Katana"},{"Chainsaw"},{"Purple Dildo"},
        {"Smal White Vibrator"},{"Large White Vibrator"},{"Silver Vibrator"},{"Flowers"},{"Cane"},{"Grenade"},{"Tear Gas"},{"Molotov Cocktail"},
        {""},{""},{""}, // Empty spots for ID 19-20-21 (invalid weapon id's)
        {"9mm"},{"Silenced 9mm"},{"Deagle"},{"Shotgun"},{"Sawn-off"},{"Combat"},{"Micro SMG"},{"MP5"},{"AK-47"},{"M4"},{"Tec9"},
        {"Rifle"},{"Sniper"},{"Rocket"},{"HS Rocket"},{"Flamethrower"},{"Minigun"},{"Satchel Charge"},{"Detonator"},
        {"Spraycan"},{"Fire Extinguisher"},{"Camera"},{"Nightvision Goggles"},{"Thermal Goggles"},{"Parachute"}, {"Fake Pistol"},{""}, {"Vehicle"}, {"Helicopter Blades"},
		{"Explosion"}, {""}, {"Suicide"}, {"Collision"}
};



new GangColors[] = {
0x6600337D,0x9900337D,0xCC00337D,0xFF00337D,0xFF33667D,0xCC33667D,0xCC00667D,0x9933667D,0xCC33997D,0xFF66CC7D,0xFF99CC7D,0xFFCCFF7D,0xFF99FF7D,
0xFF99997D,0xFF66997D,0xFF00667D,0xFF00997D,0xFF33997D,0xFF00CC7D,0xFF33CC7D,0xFF66FF7D,0xFF33FF7D,0xFF00FF7D,0xCC00997D,0x9900667D,0xCC33CC7D,
0xCC66CC7D,0xCC99FF7D,0xCC66FF7D,0xCC33FF7D,0xCC00CC7D,0xCC00FF7D,0x9900CC7D,0x9900997D,0x9933997D,0x9966CC7D,0xCC99CC7D,0x9966997D,0x6633997D,
0x6633667D,0x6600667D,0x6600997D,0x9933CC7D,0x9900FF7D,0x9966FF7D,0x6633CC7D,0x6600CC7D,0x3300337D,0x3300667D,0x6600FF7D,0x6633FF7D,0xCCCCFF7D,
0x9999FF7D,0x9999CC7D,0x6666CC7D,0x6666FF7D,0x6666997D,0x3333667D,0x3333997D,0x3300997D,0x3300CC7D,0x3300FF7D,0x3333FF7D,0x3333CC7D,0x0066FF7D,
0x0033FF7D,0x3366FF7D,0x3366CC7D,0x0000667D,0x0000337D,0x0000FF7D,0x0000997D,0x0033CC7D,0x0000CC7D,0x3366997D,0x0066CC7D,0x99CCFF7D,0x6699FF7D,
0x0033667D,0x6699CC7D,0x0066997D,0x3399CC7D,0x0099CC7D,0x66CCFF7D,0x3399FF7D,0x0033997D,0x0099FF7D,0x33CCFF7D,0x00CCFF7D,0x99FFFF7D,0x66FFFF7D,
0x33FFFF7D,0x00FFFF7D,0x00CCCC7D,0x0099997D,0x6699997D,0x99CCCC7D,0xCCFFFF7D,0x33CCCC7D,0x66CCCC7D,0x3399997D,0x3366667D,0x0066667D,0x0033337D,
0x00FFCC7D,0x00CC997D,0x66FFCC7D,0x99FFCC7D,0x00FF997D,0x3399667D,0x0066337D,0x3366337D,0x6699667D,0x66CC667D,0x99FF997D,0x66FF667D,0x99CC997D,
0x33FF997D,0x00CC667D,0x66CC997D,0x0099667D,0x0099337D,0x00FF667D,0xCCFFCC7D,0xCCFF997D,0x99FF667D,0x00FF337D,0x00CC337D,0x66FF337D,0x00FF007D,
0x66CC337D,0x0066007D,0x0033007D,0x0099007D,0x33FF007D,0x66FF007D,0x99FF007D,0x66CC007D,0x3399007D,0x33CC007D,0x99CC667D,0x99CC337D,0x6699337D,
0x3366007D,0x6699007D,0x99CC007D,0xCCFF667D,0xCCFF007D,0x9999007D,0x3333007D,0x6666007D,0x9999337D,0xCCCC337D,0xCCCC667D,0x6666337D,0x9999667D,
0xCCCC997D,0xFFFFCC7D,0xFFFF997D,0xFFFF007D,0xFFCC007D,0xFFCC667D,0xFFCC337D,0xCC99337D,0x9966007D,0xCC99007D,0xFF99007D,0xCC66007D,0x9933007D,
0xCC66337D,0xFF99337D,0xFF99667D,0xFF66337D,0xFF66007D,0xCC33007D,0x9966337D,0x6633007D,0x3300007D,0x6633337D,0x9966667D,0x9933337D,0xCC66667D,
0xCC99997D,0xFFCCCC7D,0xFF66667D,0xFF33337D,0xCC33337D,0x6600007D,0x9900007D,0xCC00007D,0xFF00007D,0xFF33007D,0xCC99667D,0xB5A6427D,0x8C78537D,
0xA67D3D7D,0x5F9F9F7D,0x5C40337D,0x5C33177D,0x2F4F2F7D,0x4A766E7D,0x4F4F2F7D,0x9932CD7D,0x9F5F9F7D,0x871F787D,0x6B238E7D,0x2F4F4F7D,0x97694F7D,
0x7093DB7D,0x855E427D,0x5454547D,0x8563637D,0xD192757D,0xA62A2A7D,0x4E2F2F7D,0x8E23237D,0xCD7F327D,0xF5CCB07D,0xDBDB707D,0x93DB707D,0x70DB937D,
0x238E237D,0x527F767D,0x215E217D,0x9F9F5F7D,0xC0D9D97D,0xC0C0C07D,0xA8A8A87D,0x8F8FBD7D,0xE9C2A67D,0x32CD997D,0x32CD327D,0x6B8E237D,0x9370DB7D,
0xDB70937D,0xFF6EC77D,0x8E236B7D,0x2F2F4F7D,0x23238E7D,0x00009C7D,0x3232CD7D,0x4D4DFF7D,0xEBC79E7D,0xCFB53B7D,0xFF7F007D,0xFF24007D,0xDB70DB7D,
0x8FBC8F7D,0xBC8F8F7D,0x5959AB7D,0x4F2F4F7D,0x6F42427D,0x8C17177D,0x6B42267D,0x8E6B237D,0xA680647D,0xE478337D,0xDB93707D,0xD8BFD87D,0x3299CC7D,
0x236B8E7D,0x38B0DE7D,0xADEAEA7D,0xFFEBEE7D,0xFFCDD27D,0xEF9A9A7D,0xE573737D,0xEF53507D,0xF443367D,0xE539357D,0xD32F2F7D,0xC628287D,0xB71C1C7D,
0xFF8A807D,0xFF52527D,0xFF17447D,0xFCE4EC7D,0xF8BBD07D,0xF48FB17D,0xF062927D,0xEC407A7D,0xE91E637D,0xD81B607D,0xC2185B7D,0xAD14577D,0x880E4F7D,
0xFF80AB7D,0xFF40817D,0xF500577D,0xC511627D,0xF3E5F57D,0xE1BEE77D,0xCE93D87D,0xBA68C87D,0xAB47BC7D,0x9C27B07D,0x8E24AA7D,0x7B1FA27D,0x6A1B9A7D,
0x4A148C7D,0xEA80FC7D,0xE040FB7D,0xD500F97D,0xAA00FF7D,0xEDE7F67D,0xD1C4E97D,0xB39DDB7D,0x9575CD7D,0x7E57C27D,0x673AB77D,0x5E35B17D,0x512DA87D,
0x4527A07D,0x311B927D,0xB388FF7D,0x7C4DFF7D,0x651FFF7D,0x6200EA7D,0xE8EAF67D,0xC5CAE97D,0x9FA8DA7D,0x7986CB7D,0x5C6BC07D,0x3F51B57D,0x3949AB7D,
0x303F9F7D,0x2835937D,0x1A237E7D,0x8C9EFF7D,0x536DFE7D,0x3D5AFE7D,0x304FFE7D,0xE3F2FD7D,0xBBDEFB7D,0x90CAF97D,0x64B5F67D,0x42A5F57D,0x2196F37D,
0x1E88E57D,0x1976D27D,0x1565C07D,0x0D47A17D,0x82B1FF7D,0x448AFF7D,0x2979FF7D,0x2962FF7D,0xE1F5FE7D,0xB3E5FC7D,0x81D4FA7D,0x4FC3F77D,0x29B6F67D,
0x03A9F47D,0x039BE57D,0x0288D17D,0x0277BD7D,0x01579B7D,0x80D8FF7D,0x40C4FF7D,0x00B0FF7D,0x0091EA7D,0xE0F7FA7D,0xB2EBF27D,0x80DEEA7D,0x4DD0E17D,
0x26C6DA7D,0x00BCD47D,0x00ACC17D,0x0097A77D,0x00838F7D,0x0060647D,0x84FFFF7D,0x18FFFF7D,0x00E5FF7D,0x00B8D47D,0xE0F2F17D,0xB2DFDB7D,0x80CBC47D,
0x4DB6AC7D,0x26A69A7D,0x0096887D,0x00897B7D,0x00796B7D,0x00695C7D,0x004D407D,0xA7FFEB7D,0x64FFDA7D,0x1DE9B67D,0x00BFA57D,0xE8F5E97D,0xC8E6C97D,
0xA5D6A77D,0x81C7847D,0x66BB6A7D,0x4CAF507D,0x43A0477D,0x388E3C7D,0x2E7D327D,0x1B5E207D,0xB9F6CA7D,0x69F0AE7D,0x00E6767D,0x00C8537D,0xF1F8E97D,
0xDCEDC87D,0xC5E1A57D,0xAED5817D,0x9CCC657D,0x8BC34A7D,0x7CB3427D,0x689F387D,0x558B2F7D,0x33691E7D,0xCCFF907D,0xB2FF597D,0x76FF037D,0x64DD177D,
0xF9FBE77D,0xF0F4C37D,0xE6EE9C7D,0xDCE7757D,0xD4E1577D,0xCDDC397D,0xC0CA337D,0xAFB42B7D,0x9E9D247D,0x8277177D,0xF4FF817D,0xEEFF417D,0xC6FF007D,
0xAEEA007D,0xFFFDE77D,0xFFF9C47D,0xFFF59D7D,0xFFF1767D,0xFFEE587D,0xFFEB3B7D,0xFDD8357D,0xFBC02D7D,0xF9A8257D,0xF57F177D,0xFFFF8D7D,0xFFFF007D,
0xFFEA007D,0xFFD6007D,0xFFF8E17D,0xFFECB37D,0xFFE0827D,0xFFD54F7D,0xFFCA287D,0xFFC1077D,0xFFB3007D,0xFFA0007D,0xFF8F007D,0xFF6F007D,0xFFE57F7D,
0xFFD7407D,0xFFC4007D,0xFFAB007D,0xFFF3E07D,0xFFE0B27D,0xFFCC807D,0xFFB74D7D,0xFFA7267D,0xFF98007D,0xFB8C007D,0xF57C007D,0xEF6C007D,0xE651007D,
0xFFD1807D,0xFFAB407D,0xFF91007D,0xFF6D007D,0xFBE9E77D,0xFFCCBC7D,0xFFAB917D,0xFF8A657D,0xFF70437D,0xFF57227D,0xF4511E7D,0xE64A197D,0xD843157D,
0xBF360C7D,0xFF9E807D,0xFF6E407D,0xFF3D007D,0xDD2C007D,0xEFEBE97D,0xD7CCC87D,0xBCAAA47D,0xA1887F7D,0x8D6E637D,0x7955487D,0x6D4C417D,0x5D40377D,
0x4E342E7D,0x3E27237D,0x7575757D,0x6161617D,0x4242427D};

new RoundM, RoundS, GWM, TRound, GWS, GWTimer, GWNextS, CrashTimeM, CrashTimeS, UnpauseT, maxarenas, Float:TeamHP[2], PlayersAlive[2], CurrentArena;
enum ENUM_GANG
{
	gID,
	gOwner[24],
	gName[24],
	gTag[24],
	gColor,
	gPoints,
	gKills,
	gDeaths,
	gDamage,
	MAX_PLAYERS_PER_GANG,
	gSkin
}

new Gang[MAX_GANGS][ENUM_GANG];

enum CADD_VAR
{
	Float: pos[3],
	Weapon[2],
	Float:HPoints,
	Float:APoints,
	Float:ArenaDMG,
	Float:TotalDMG,
	ArenaKills,
	Kills,
	Deaths,
	nickname[24],
	intid,
	vwid,
	idgang		
}
new CADDPlayer[CADD_SAVES][CADD_VAR];

enum CADDID
{
	reeplaceid,
	tooaddid
}
new CADD[CADDID];

enum ENUM_GANGWAR
{
    GANG1ID,
    GANG2ID,
	PlayersLimit, 
    Gang1Players,
    Gang2Players,
    Gang1Points,
    Gang2Points,
    RoundsPlayed,
    GangWarONOFF,
	CBUG,
	Armours,
	PlayersReady,
	ActiveRound, 
	Pause,
	Crash,
	NextRoundCD,
	FF
}

new GangWar[ENUM_GANGWAR];

enum ENUM_GWROUND
{
	Float:Arena[4],
	Float:G1Spawn[4],
	Float:G2Spawn[4],
	Float:center[3],
	int,
	ArenaZone,
	SniperLimitT1,
	SniperLimitT2
}

new GWROUND[ENUM_GWROUND];

enum ENUM_GW
{
	Ready,
	OnArena,
	ReadyGW,
	Weapon[2],
	Float:ArenaDMG,
	ArenaKills,
	Float:TotalDMG,
	GunMenu,
	Kills,
	Deaths
}

new GangPlayer[MAX_PLAYERS][ENUM_GW];

new FPSlimit,
	FPSlimitH,
	Pinglimit,
	areasavilable,
	Float:Packetlimit;

enum ENUM_AREA
{
	aSampID,
	aID,
	aName[24],
	aHorseshoe,
	aSniperdrop,
	aSniperTimer,
	Float:aPos[4],
	GangPoints[MAX_GANGS],
	bool:AreaPlayed
}

new Area[MAX_AREAS][ENUM_AREA];
new podkowa, sniperrifle;
new CurrentArea;
new Float: toreach;

enum ENUM_SPAWN
{
	spawnid,
	Float:sPos[4]
}

new Spawn[MAX_AREAS][MAX_SPAWNS][ENUM_SPAWN];

new AreaS, AreaM, SoloCD, SniperM, SniperS;

enum ENUM_SESSION
{
	Kills,
	Deaths,
	Points,
	Float:Damage
}

new SessionPlayerData[MAX_PLAYERS][ENUM_SESSION];


enum ENUM_PLAYER
{
	bool:LoggedIn,
	Kills,
	Deaths,
	skinID,
	Points,
	Float:Damage,
	GangID,
	GangInvite,
	AdminLevel,
	Muted,
	CreatingStage,
	CreatingID,
	CreatingSpawnID,
	Weapon[4],
	GettedWeapons,
	Weather,
	SetTime,
	KillStreak,
	Name[24],
	SpawnProtect,
	WeaponChange,
	podkowa1,
	afk,
	bool:PlayerInSolo,
	SoloOponnentID,
	SoloCBUG,
	SoloArmour,
	SoloWeapon,
	SoloTimer,
	DuelPlayed,
	DuelWins,
	PlayerLevel,
	Respawn,
	Spec,
	onede,
	onedekills,
	onededeaths,
	sawn,
	sawnkills,
	sawndeaths,
	syncing,
	warningfps,
	warningping,
	warningpacket,
	moviemode,
	sniperdrop,
	sniperkills,
	inGWAR,
	Text3D:	pPing,
	Text3D: pFPS,
	Text3D: pLoss
}

new PlayerData[MAX_PLAYERS][ENUM_PLAYER];
new DB:General;

new lastip[10][128], ReasonText[5][128], ipstring[1024], onlineplayers, GWRoundInfoPlayersG1[4][512], GWRoundInfoPlayersG2[4][512];

//finalresultboard
new arenas[6][32], G1Finalinfo[6][32], G2Finalinfo[6][32], GWFinalPinfoG1[4][512], GWFinalPinfoG2[4][512];  	

main()
{
	print("\n----------------------------------");
	print("Hardcore DM by SKYLINE and SHAKE");
	print("----------------------------------\n");
}


public OnGameModeInit()
{
	General = db_open(DB_PATCH);
 	//db_query(General, "CREATE TABLE IF NOT EXISTS `players` (`nick` VARCHAR(32), `pass` VARCHAR(64), `kills` INT, `deaths` INT, `dmg` INT);");
	
	print("Setting up server");
	WeaponConfig();
	ServerConfig();
	GetMaxArenas();
	CreateObjects();
	LoadData();
	//loadvehs();
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_GLOBAL);
	SetTimer("ScriptUpdateGlobal", 1000, true);
	SetTimer("SavePlayers", 5*60000, true);
	SetTimer("discord", 3*60000, true);
	print("Server ready!");
	
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		PlayerData[i][pFPS] = Create3DTextLabel(" ", COLOR_YELLOW, 0.0, 0.0, 0.0, 10, 1);
		PlayerData[i][pPing] = Create3DTextLabel(" ", COLOR_YELLOW, 0.0, 0.0, 0.0, 10, 1);
		PlayerData[i][pLoss] = Create3DTextLabel(" ", COLOR_YELLOW, 0.0, 0.0, 0.0, 10, 1);
	}
	return 1;
}

public OnGameModeExit()
{
	foreach(new i : Player)
		if(IsPlayerConnected(i)){
		    SetPlayerName(i, PlayerData[i][Name]);
			//Kick(i);
		}

	SendClientMessageToAll(COLOR_RED, "Hardcore DM: RESTART Rejoin to server.");
	destroyGlobal();
	DestroyDynamicPickup(podkowa);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
   	SetPlayerWeather(playerid, 2);
	SetPlayerTime(playerid, 21, 0);
	SetPlayerCameraPos(playerid, 1096.4615,-842.0411,111.9685);
	SetPlayerCameraLookAt(playerid, 1377.3027,-1158.1976,187.1403, CAMERA_MOVE);
	showJoinScreen(playerid);
	PlayerTextDrawSetString(playerid, HDM_JoinScreenNews[playerid], nowosci());
	if(PlayerData[playerid][LoggedIn] == false)
	{
		new Query[128], DBResult: Result;
		format(Query, sizeof(Query), "SELECT `Kills` FROM `players` WHERE `name` = '%s' LIMIT 1", PlayerName(playerid));
		Result = db_query(General, Query);
			
		if(db_num_rows(Result) > 0)
		{
			format(Query, sizeof(Query), "Welcome back %s to Hardcore DM!\nPlease enter your password below to login!", PlayerName(playerid));
			ShowPlayerDialog(playerid, D_LOGIN, DIALOG_STYLE_PASSWORD, "Hardcore DM - Login", Query, "Login", "Cancel");
		}
		else
		{
			SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: Now register your account and PLAY!");
			ShowPlayerDialog(playerid, D_REGISTER, DIALOG_STYLE_PASSWORD, "Hardcore DM - Register", "Welcome to Hardcore DM!\nPlease enter your password so that we can register your account!", "Register", "Cancel");
		}
	}
	PlayerPlaySound(playerid, 1068, 0, 0, 0);
	hidePlayerHud(playerid);
	return 1;
}

public OnPlayerConnect(playerid)
{
	lastipupdate(playerid, PlayerIP(playerid), ver(playerid));
	ResetAccountVar(playerid);
	new string[150], country[100];
	GetPlayerCountry(playerid, country, MAX_COUNTRY_LENGTH);
	foreach(new i : Player)
	{
		if(IsLevelAdmin(i) && IsPlayerConnected(i))
		{
			format(string, sizeof(string), "Hardcore DM: %s [ID:%d] has joined from %s. (%s) SAMP Ver. %s", PlayerName(playerid), playerid, country, PlayerIP(playerid), ver(playerid));
			SendClientMessage(i, COLOR_JOIN, string);
		}
		else
		{
			format(string, sizeof(string), "Hardcore DM: %s [ID:%d] has joined from %s.", PlayerName(playerid), playerid, country);
			SendClientMessage(i, COLOR_JOIN, string);
		}
	}
	
	//Attach3DTextLabelToPlayer(PlayerData[playerid][pFPS], playerid, 0.0, 0.0, -0.6);
	//Attach3DTextLabelToPlayer(PlayerData[playerid][pPing], playerid, 0.0, 0.0, -0.7);
	//Attach3DTextLabelToPlayer(PlayerData[playerid][pLoss], playerid, 0.0, 0.0, -0.8);

	GangZoneHideForPlayer(playerid, 0);

	ClearPlayerChat(playerid);
	format(string, sizeof(string), "Welcome %s [ID:%d] on Hardcore DM. Type /help for little info what to do here. Commands are described under the /cmd", PlayerName(playerid), playerid);
	SendClientMessage(playerid, COLOR_JOIN, string);
	SetPlayerColor(playerid, 0x000000FF);
	createPlayerTextDraws(playerid);
	
	return 1;
}


public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	PlayerTextDrawSetPreviewModel(playerid, PTD_CarInfoModel[playerid], GetVehicleModel(vehicleid));
	showCarInfo(playerid);
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	hideCarInfo(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	new Query[512], string[512];

	if(GangWar[GangWarONOFF] == 1 && GangPlayer[playerid][OnArena] == 1 && GangWar[ActiveRound] == 1)CrashAddLeave(playerid);
	if(PlayerData[playerid][sniperdrop] == 1)
	{
		SendClientMessageToAll(COLOR_GREEN, "Hardcore DM: Player with sniper leave the server. New Sniper Drop starting...");
		DestroySniperDrop();
		Sniperdrop();
	}
	if(PlayerData[playerid][LoggedIn] == true)
	{
		format(Query, sizeof(Query), "UPDATE `players` SET `kills` = %d, `deaths` = %d, `damage` = %.0f, `points` = %d, `gangID` = %d, `weather` = %d, `time` = %d, `adminlevel` = %d, `skinID` = %d WHERE `name` = '%s'", 
		PlayerData[playerid][Kills], PlayerData[playerid][Deaths], PlayerData[playerid][Damage], PlayerData[playerid][Points], PlayerData[playerid][GangID], PlayerData[playerid][Weather], PlayerData[playerid][SetTime], PlayerData[playerid][AdminLevel], PlayerData[playerid][skinID], PlayerData[playerid][Name]);
    	db_query(General, Query);
		print(Query);
		format(Query, sizeof(Query), "UPDATE `players` SET `duelswin` = %d, `duelsplayed` = %d, `playerlevel` = %d, `onedekills` = %d, `onededeaths` = %d, `sawnkills` = %d, `sawndeaths` = %d, `ingame` = 0 WHERE `name` = '%s'", 
		PlayerData[playerid][DuelWins],  PlayerData[playerid][DuelPlayed],  PlayerData[playerid][PlayerLevel], PlayerData[playerid][onedekills], PlayerData[playerid][onededeaths], PlayerData[playerid][sawnkills], PlayerData[playerid][sawndeaths], PlayerData[playerid][Name]);
    	db_query(General, Query);
		print(Query);

	}

	ResetAccountVar(playerid);
	ResetCbug(playerid);
	hideGangControl(playerid);
	destroyPlayerHUD(playerid);

	switch(reason)
	{
		case 0:
		{
			format(string, sizeof(string), "Hardcore DM: %s [ID:%d] has left the server. (Timeout or Crash)", PlayerName(playerid), playerid);
			SendClientMessageToAll(COLOR_LEAVE, string);
		}
		case 1: 
		{
			format(string, sizeof(string), "Hardcore DM: %s [ID:%d] has left the server. (Quit)", PlayerName(playerid), playerid);
			SendClientMessageToAll(COLOR_LEAVE, string);
		}
		case 2: 
		{
			format(string, sizeof(string), "Hardcore DM: %s [ID:%d] has left the server. (Kick or Ban)", PlayerName(playerid), playerid);
			SendClientMessageToAll(COLOR_LEAVE, string);
		}
	}

	if(PlayerData[playerid][PlayerInSolo])
	{
	    new id = PlayerData[playerid][SoloOponnentID];
	    
	    new str[128];
	    format(str, sizeof(str), "Hardcore DM: %s(id: %d) left server. Duel canceled.", PlayerName(playerid), playerid);
	    SendClientMessage(id, COLOR_LIGHTGREEN, str);
	    
	    new strr[128];
	    format(strr, sizeof(strr), "Hardcore DM: Duel wins %s(id: %d)", PlayerName(id), id);
	    SendClientMessageToAll(COLOR_LIGHTGREEN, strr);
	    
	    PlayerData[id][PlayerInSolo] = false;
	    
	    SpawnPlayer(id);
	}
	return 1;
}

public OnPlayerSpawn(playerid)
{
	EnableHealthBarForPlayer(playerid, true);

	if(IsLevelAdmin(playerid) > 0)
	{
		hideReports(playerid);
		showReports(playerid);
	}

	if(PlayerData[playerid][inGWAR] == 1 && GangWar[ActiveRound] == 0)
	{
		SpawnGangWarPlayerInLobby(playerid);
	}

	AddCrashedPlayer(playerid);

	if(PlayerData[playerid][onede] == 1)
	{
		new spawn = random(sizeof(RandomSpawnOneDe));
		SetPlayerPos(playerid, RandomSpawnOneDe[spawn][0],RandomSpawnOneDe[spawn][1],RandomSpawnOneDe[spawn][2]);
		SetPlayerFacingAngle(playerid, RandomSpawnOneDe[spawn][3]);
		SetPlayerInterior(playerid, 3);
		SetPlayerVirtualWorld(playerid, 69);
		ResetPlayerWeapons(playerid);
		SetPlayerHealth(playerid, 33.0);
		GivePlayerWeapon(playerid, 24, 1000);
		hideGangControl(playerid);
		hideArenaInfo(playerid);
		showArenaInfo(playerid);
	}
	
	if(PlayerData[playerid][sawn] == 1)
	{
		new SawnZone,spawn = random(sizeof(RandomSpawnSawn));
		SetPlayerVirtualWorld(playerid, 72);
		ResetPlayerWeapons(playerid);
		SetPlayerPos(playerid, RandomSpawnSawn[spawn][0],RandomSpawnSawn[spawn][1],RandomSpawnSawn[spawn][2]);
		SetPlayerFacingAngle(playerid, RandomSpawnSawn[spawn][3]);
		GivePlayerWeapon(playerid, 26, 1000);
		SetPlayerHealth(playerid, 100.0);
		SetPlayerArmour(playerid, 100.0);
		hideGangControl(playerid);
		hideArenaInfo(playerid);
		showArenaInfo(playerid);
		for(new i = 0; i<MAX_AREAS; i++)
		{
			GangZoneHideForPlayer(playerid, i);
		}
		SawnZone = GangZoneCreate(-1309.0546875, -267.4765625, -1136.0546875, -80.4765625);
		GangZoneShowForPlayer(playerid, SawnZone, 0xFBCC007D);
		GangZoneStopFlashForPlayer(playerid, SawnZone);
		GangZoneFlashForPlayer(playerid, SawnZone, 0xFFFFFF00);
	}

	if(PlayerData[playerid][podkowa1] != 0)
	{
		SetPlayerColor(playerid, 0xFF00FFFF);
	}	
	else if(PlayerData[playerid][GangID] != 0)
	{
	    new gid = PlayerData[playerid][GangID];
	    SetPlayerColor(playerid, Gang[gid][gColor]);
	}
	else if(PlayerData[playerid][GangID] == 0 && PlayerData[playerid][podkowa1] == 0)
	{
		SetPlayerColor(playerid, 0xFFFFFFFF);
	}

	if(PlayerData[playerid][Weapon][0] == -1 && PlayerData[playerid][Weapon][1] == -1 && PlayerData[playerid][Weapon][2] == -1 && PlayerData[playerid][Weapon][3] == -1)
	{
		new string[512];
						
		strcat(string, "0\tNone\n24\tDeagle\n25\tShotgun\n29\tMP5\n31\tM4\n33\tRifle");
		ShowPlayerDialog(playerid, D_SELECT_FIRST_WEAPON, DIALOG_STYLE_LIST, "Hardcore DM - Weapon Selection (1/4)", string, "Select", "Cancel");
	}
		
	if(PlayerData[playerid][GangID] != 0)
	{
		new gid = PlayerData[playerid][GangID];
		SetPlayerSkin(playerid, Gang[gid][gSkin]);
	}
	else if(PlayerData[playerid][GangID] <=1)
	{
		SetPlayerSkin(playerid, PlayerData[playerid][skinID]);
	}
	
	if(PlayerData[playerid][syncing] == 0 && PlayerData[playerid][onede] == 0 && PlayerData[playerid][afk] == 0 && PlayerData[playerid][sawn] == 0 && PlayerData[playerid][inGWAR] == 0)
	{
		SetPlayerHealth(playerid, 100);
		SetPlayerArmour(playerid, 0.0);
		SetTimerEx("SpawnProtection", 2000, false, "i", playerid);
		hideArenaInfo(playerid);
		hideGangControl(playerid);
		showGangControl(playerid);
		hidePlayerHud(playerid);
		showPlayerHud(playerid);
		hideArenaInfo(playerid);
		new areaid;
		for(new i = 1; i<MAX_AREAS; i++)
		if(Area[i][AreaPlayed])
			areaid = i;

		//new sid = random(MAX_SPAWNS);
		ShowGangZones(playerid);
		//SetPlayerPos(playerid, Spawn[areaid][sid][sPos][0], Spawn[areaid][sid][sPos][1], Spawn[areaid][sid][sPos][2]);
		//SetPlayerFacingAngle(playerid, Spawn[areaid][sid][sPos][3]);
		SpawnPlayerInArea(playerid, Area[areaid][aPos][0], Area[areaid][aPos][1], Area[areaid][aPos][2], Area[areaid][aPos][3]);
		//SpawnPlayerInArea(playerid);
		if(Area[CurrentArea][aSniperdrop] == 1)
		{
			TextDrawShowForPlayer(playerid, HDM_SniperDropInfo);
		}
	}

	ClearAnimations(playerid);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	new string[128], gid = PlayerData[killerid][GangID], Query[512]; 
	new areaid;
	for(new i = 0; i<MAX_AREAS; i++)
    if(Area[i][AreaPlayed])
	    areaid = i;
	
	if(PlayerData[playerid][PlayerInSolo] == true)
	{
	    new str[128];
	    format(str, sizeof(str), "Hardcore DM: Duel wins %s(id: %d)!", PlayerName(killerid), killerid);
	    SendClientMessageToAll(COLOR_LIGHTGREEN, str);
		PlayerData[playerid][PlayerInSolo] = false;
	    PlayerData[killerid][PlayerInSolo] = false;
		PlayerData[playerid][SoloCBUG] = 0;
	    PlayerData[killerid][SoloCBUG] = 0;
		PlayerData[killerid][Points]+= 50;
		PlayerData[killerid][DuelWins]++;
		SessionPlayerData[killerid][Kills]++;
		SessionPlayerData[playerid][Deaths]++;
		SessionPlayerData[playerid][Points]+= 50;

		format(string, sizeof(string), "You killed ~g~%s", PlayerName(playerid));
		PlayerTextDrawSetString(killerid, PTD_DeathKill[killerid], string);
		showKillDeath(killerid);
		SetTimerEx("KillDeathHide", 2200, false, "i", killerid);
		SendDeathMessage(killerid, playerid, reason);

		format(string, sizeof(string), "Killed by ~r~%s", PlayerName(killerid));
		PlayerTextDrawSetString(playerid, PTD_DeathKill[playerid], string);
		showKillDeath(playerid);
		SetTimerEx("KillDeathHide", 2200, false, "i", playerid);

		SetPlayerInterior(playerid, 0);
		SetPlayerInterior(killerid, 0);
		SetPlayerArmour(killerid, 0.0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerVirtualWorld(killerid, 0);
	    SpawnPlayer(killerid);
		return 1;
	}

	if(PlayerData[playerid][onede] == 1 && PlayerData[killerid][onede] == 1)
	{
		PlayerData[killerid][onedekills]++;
		PlayerData[playerid][onededeaths]++;

		format(string, sizeof(string), "You killed ~g~%s", PlayerName(playerid));
		PlayerTextDrawSetString(killerid, PTD_DeathKill[killerid], string);
		showKillDeath(killerid);
		SetTimerEx("KillDeathHide", 2200, false, "d", killerid);
		SendDeathMessage(killerid, playerid, reason);

		format(string, sizeof(string), "Killed by ~r~%s", PlayerName(killerid));
		PlayerTextDrawSetString(playerid, PTD_DeathKill[playerid], string);
		showKillDeath(playerid);
		SetTimerEx("KillDeathHide", 2200, false, "d", playerid);

		return 1;
	}

	if(PlayerData[playerid][sawn] == 1 && PlayerData[killerid][sawn] == 1)
	{
		if(!IsPlayerInArea(killerid, -1309.0546875, -267.4765625, -1136.0546875, -80.4765625)) return SendClientMessage(killerid, COLOR_RED, "Hardcore DM: You killed outside the zone. No kill! Fight in Area!");		
		
		PlayerData[killerid][sawnkills]++;
		PlayerData[playerid][sawndeaths]++;

		format(string, sizeof(string), "You killed ~g~%s", PlayerName(playerid));
		PlayerTextDrawSetString(killerid, PTD_DeathKill[killerid], string);
		showKillDeath(killerid);
		SetTimerEx("KillDeathHide", 2200, false, "d", killerid);
		SendDeathMessage(killerid, playerid, reason);

		format(string, sizeof(string), "Killed by ~r~%s", PlayerName(killerid));
		PlayerTextDrawSetString(playerid, PTD_DeathKill[playerid], string);
		showKillDeath(playerid);
		SetTimerEx("KillDeathHide", 2200, false, "d", playerid);
			
		return 1;
	}


	if(PlayerData[playerid][inGWAR] == 1 && PlayerData[killerid][inGWAR] == 1 && GangPlayer[killerid][OnArena] == 1 && GangPlayer[playerid][OnArena] == 1)
	{
		if(!IsPlayerInArea(killerid, GWROUND[Arena][0], GWROUND[Arena][2], GWROUND[Arena][1], GWROUND[Arena][3])) return SendClientMessage(killerid, COLOR_PINK, "Hardcore DM: You killed outside the zone. No kill! Fight in Area!");		
		
		format(string, sizeof(string), "You killed ~g~%s", PlayerName(playerid));
		PlayerTextDrawSetString(killerid, PTD_DeathKill[killerid], string);
		showKillDeath(killerid);
		SetTimerEx("KillDeathHide", 2200, false, "d", killerid);
		SendDeathMessage(killerid, playerid, reason);
		GangPlayer[playerid][OnArena] = 0;
		format(string, sizeof(string), "Killed by ~r~%s", PlayerName(killerid));
		PlayerTextDrawSetString(playerid, PTD_DeathKill[playerid], string);
		showKillDeath(playerid);
		SetTimerEx("KillDeathHide", 2200, false, "d", playerid);
		GangPlayer[killerid][ArenaKills]++;
		GangPlayer[killerid][Kills]++;
		GangPlayer[playerid][Deaths]++;
			
		return 1;
	}

	if(IsPlayerInArea(killerid, Area[areaid][aPos][2], Area[areaid][aPos][3], Area[areaid][aPos][0], Area[areaid][aPos][1])) // zabijanie w strefie, jeśli poza nie nalicza zadnych statów i pkt
	{

		if(PlayerData[killerid][GangID] > 0 && PlayerData[killerid][GangID] == PlayerData[playerid][GangID])
		{
			SendClientMessage(killerid, COLOR_REALRED, "Hardcore DM: You killed your gangmate.");
			SendClientMessage(playerid, COLOR_REALRED, "Hardcore DM: You died from your gangmate.");

			format(string, sizeof(string), "You killed ~g~%s", PlayerName(playerid));
			PlayerTextDrawSetString(killerid, PTD_DeathKill[killerid], string);
			showKillDeath(killerid);
			SetTimerEx("KillDeathHide", 2200, false, "d", killerid);


			format(string, sizeof(string), "Killed by ~r~%s", PlayerName(killerid));
			PlayerTextDrawSetString(playerid, PTD_DeathKill[playerid], string);
			showKillDeath(playerid);
			SetTimerEx("KillDeathHide", 2200, false, "d", playerid);

			return 1;
		}
		else
		SendDeathMessage(killerid, playerid, reason);
		
		new point = minrand(5,15), point2 = minrand(8,15)*2, point3 = minrand(10,15)*2, killergangid = PlayerData[killerid][GangID], playergangid = PlayerData[playergangid][GangID];
		
		if(PlayerData[killerid][podkowa1] == 1) 
			{
				PlayerData[killerid][Points]+= point2;
				SessionPlayerData[killerid][Points]+= point2;
				
				if(gid > 0)
				{
					Gang[killergangid][gPoints]+= point2;
					Area[areaid][GangPoints][killergangid]+= point2;
				}
				format(string, sizeof(string), "Horseshoe: Gained %d points", point2);
				SendClientMessage(killerid, COLOR_AREA, string);
			}
			else
			{
				PlayerData[killerid][Points]+= point;
				SessionPlayerData[killerid][Points]+= point;

				if(gid > 0)
				{
					Gang[killergangid][gPoints]+= point;
					Area[areaid][GangPoints][killergangid]+= point;
				}
				format(string, sizeof(string), "Gained %d points", point);
				SendClientMessage(killerid, COLOR_INFO, string);
			}

		PlayerData[killerid][Kills]++;
		SessionPlayerData[killerid][Kills]++;
		
		PlayerData[playerid][Deaths]++;
		SessionPlayerData[playerid][Deaths]++;

		PlayerData[killerid][KillStreak]++;
		PlayerData[playerid][KillStreak] = 0;

		if(PlayerData[playerid][podkowa1] == 1) 
		{
			PlayerData[playerid][podkowa1] = 0; //przekazywanie podkowy (umierający)
			hideHorseshoe(playerid);
			SetPlayerColor(playerid, 0xFFFFFFFF);
			PlayerData[killerid][podkowa1] = 1; //przekazywanie podkowy (zabijający)
			SetPlayerColor(killerid, 0xFF00FFFF);
			showHorseshoe(killerid);
			format(string, sizeof(string), "Hardcore DM: %s killed the lucky guy and now he has horseshoe, kill him for more points.", PlayerName(killerid));
			SendClientMessageToAll(COLOR_AREA, string);
			if(gid > 0)SetPlayerColor(playerid, Gang[playergangid][gColor]);
		}

		if(PlayerData[playerid][sniperkills] >= 0 && PlayerData[playerid][sniperdrop] == 1)
		{
			new sniperpoint = PlayerData[playerid][sniperkills]*10, Float:sniperpos[3];
			GetPlayerPos(playerid, sniperpos[0],sniperpos[1],sniperpos[2]);
			PlayerData[killerid][Points]+= sniperpoint;
			SessionPlayerData[killerid][Points]+= sniperpoint;
			hideSniperInfo(playerid);
			if(gid > 0)
			{
				Gang[killergangid][gPoints]+= sniperpoint;
				Area[areaid][GangPoints][killergangid]+= sniperpoint;
			}
			format(string, sizeof(string), "Sniper: You killed a sniper and gained %d", sniperpoint);
			PlayerData[killerid][sniperkills] = 0;
			PlayerData[killerid][sniperdrop] = 0;
			PlayerData[playerid][sniperdrop] = 0;
			SendClientMessage(killerid, COLOR_GREEN, string);
			sniperrifle = CreateDynamicPickup(358, 3, sniperpos[0],sniperpos[1]+3,sniperpos[2], 0);
			if(PlayerData[playerid][GangID] > 0)
			{
				SetPlayerColor(playerid, Gang[playergangid][gColor]);
			}
			else
			{
				SetPlayerColor(playerid, 0xFFFFFFFF);	
			}
		}
		
		if(GetPlayerWeapon(killerid) == WEAPON_SNIPER) 
		{
			PlayerData[killerid][Points]+= point3;
			SessionPlayerData[killerid][Points]+= point3;
			PlayerData[killerid][sniperkills]++;
			format(string, sizeof(string), "Sniper Kills: ~y~%d", PlayerData[killerid][sniperkills]);
			PlayerTextDrawSetString(killerid, HDM_SniperKills[killerid], string);
			if(gid > 0)
			{
				Gang[killergangid][gPoints]+= point3;
				Area[areaid][GangPoints][killergangid]+= point3;
			}
			format(string, sizeof(string), "Sniper: Gained %d points", point3);
			SendClientMessage(killerid, COLOR_GREEN, string);
		}

		if(gid > 0) //naliczanie kill/smierci gangu
			{
				Gang[killergangid][gKills]++;
				Gang[playergangid][gDeaths]++;
			}

		if(PlayerData[killerid][KillStreak] == 2)
			{
				PlayerTextDrawSetString(killerid, PTD_KillStreak[playerid], "~y~You kidding? Double kill?");
				showKillStreak(killerid);
				SetTimerEx("KillStreakHide", 2200, false, "d", killerid);
			}
					
		if(PlayerData[killerid][KillStreak] == 5)
			{
				PlayerTextDrawSetString(killerid, PTD_KillStreak[playerid], "~y~PENTA! You rock!");
				showKillStreak(killerid);
				SetTimerEx("KillStreakHide", 2200, false, "d", killerid);
			}
					
		if(PlayerData[killerid][KillStreak] == 8)
			{
				PlayerTextDrawSetString(killerid, PTD_KillStreak[playerid], "~y~Dude... 8 kills.");
				showKillStreak(killerid);
				SetTimerEx("KillStreakHide", 2200, false, "d", killerid);
			}
				
		if(PlayerData[killerid][KillStreak] == 10)
			{
				PlayerTextDrawSetString(killerid, PTD_KillStreak[playerid], "~y~Woooohoo! High roller");
				SendClientMessage(killerid, COLOR_INFO, "Hardcore DM: What the hell! You are awesome. You have 50 points here. Don't tell anyone.");
				showKillStreak(killerid);
				PlayerData[killerid][Points]+= 50;
				SessionPlayerData[playerid][Points]+= 50;
				Gang[gid][gPoints]+= 50;
				Area[areaid][GangPoints][killergangid]+= 50;
				SetTimerEx("KillStreakHide", 2200, false, "d", killerid);
			}

		format(Query, sizeof(Query), "UPDATE `area_points` SET `gangpoints` = %d WHERE `gangid` = %d AND `areaid` = %d", Area[CurrentArea][GangPoints][killergangid], PlayerData[killerid][GangID], Area[CurrentArea][aID]);
		db_query(General, Query);
		print(Query);

		format(Query, sizeof(Query), "UPDATE `gangs` SET `gKills` = %d, `gDeaths` = %d, `gPoints` = %d WHERE `gID` = %d", Gang[gid][gKills], Gang[gid][gDeaths], Gang[gid][gPoints], PlayerData[killerid][GangID]);
		db_query(General, Query);
		print(Query);
		
		if(PlayerData[killerid][onede] == 0 || PlayerData[killerid][sawn] == 0)
			{
			new Float:hprestore, Float:HP;
			GetPlayerHealth(killerid, Float:HP);
			hprestore = HP + minrand(8,20);
			SetPlayerHealth(killerid, Float:hprestore);
			}
		
		format(string, sizeof(string), "You killed ~g~%s", PlayerName(playerid));
		PlayerTextDrawSetString(killerid, PTD_DeathKill[killerid], string);
		showKillDeath(killerid);
		SetTimerEx("KillDeathHide", 2200, false, "d", killerid);


		format(string, sizeof(string), "Killed by ~r~%s", PlayerName(killerid));
		PlayerTextDrawSetString(playerid, PTD_DeathKill[playerid], string);
		showKillDeath(playerid);
		SetTimerEx("KillDeathHide", 2200, false, "d", playerid);		
	}
	else
	{
		SendClientMessage(killerid, COLOR_RED, "Hardcore DM: You killed outside the zone. No points and no kill! Fight in Area!");
	}

	ShowGangZones(playerid);
	ShowGangZones(killerid);
	hideGangControl(killerid);
	showGangControl(killerid);

	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	//if(!PlayerData[playerid][LoggedIn]) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You must login first."); //niezalogowany, wypierdalaj
	SetPlayerTime(playerid, PlayerData[playerid][SetTime], 0);
	SetPlayerWeather(playerid, PlayerData[playerid][Weather]);
	PlayerPlaySound(playerid, 0, 0, 0, 0);
	hideJoinScreen(playerid);
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{	
	new animlib[32], animname[32];

	if(newkeys == 160 && (GetPlayerWeapon(playerid) == 0 && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT))cmd_sync(playerid);

	//acbug
	if(PlayerData[playerid][SoloCBUG] == 0 && PlayerData[playerid][onede] == 0 || GangWar[CBUG] == 0 && GangPlayer[playerid][OnArena] == 1)
	{
		if(!cbuger[playerid] && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
		{
			if(PRESSED(KEY_FIRE) || PRESSED(KEY_ACTION))
			{
				switch(GetPlayerWeapon(playerid))
				{
					case WEAPON_DEAGLE, WEAPON_SHOTGUN, WEAPON_SNIPER, WEAPON_RIFLE:
					{
						LastFiredWeapon[playerid] = gettime();
					}
				}
			}
			else if(PRESSED(KEY_CROUCH))
			{
				if((gettime() - LastFiredWeapon[playerid]) < 0.4)
				{
					TogglePlayerControllable(playerid, false);
					cbuger[playerid] = true;
					animlib = "PED", animname = "handsup";
					ClearAnimations(playerid, 1);
					SendClientMessage(playerid, -1, "cbug test");
					ApplyAnimation(playerid, animlib, animname, 4.1, 0, 0, 0, 0, 0, 1);
					KillTimer(cbugslap[playerid]);
					cbugslap[playerid] = SetTimerEx("CBugFreezeOver", 800, false, "i", playerid);
				}
			}
		}
	}

	if(newkeys == KEY_YES)
	{
	    if(PlayerData[playerid][CreatingID] != -1)
	    {
	        new Query[256];
	        if(PlayerData[playerid][CreatingStage] == AREA_SETTING_NE_POS)
	        {
	            new Float:X, Float:Y, Float:Z, areaid = PlayerData[playerid][CreatingID];
	            GetPlayerPos(playerid, X, Y, Z);
	            Area[areaid][aPos][0] = X;
	            Area[areaid][aPos][1] = Y;

	            format(Query, sizeof(Query), "UPDATE `areas` SET `NorthX` = '%f', `NorthY` = '%f' WHERE `AreaID` = %d", Area[areaid][aPos][0], Area[areaid][aPos][1], Area[areaid][aID]);
				db_query(General, Query);

	            PlayerData[playerid][CreatingStage] = AREA_SETTING_SW_POS;

	            SendClientMessage(playerid, -1, "Hardcore DM: First position has been saved. Please go to SOUTH-WEST position and press \"Y\"");
			}
			else if(PlayerData[playerid][CreatingStage] == AREA_SETTING_SW_POS)
			{
			    new Float:X, Float:Y, Float:Z, areaid = PlayerData[playerid][CreatingID];
			    GetPlayerPos(playerid, X, Y, Z);
			    Area[areaid][aPos][2] = X;
			    Area[areaid][aPos][3] = Y;

			    format(Query, sizeof(Query), "UPDATE `areas` SET `SouthX` = '%f', `SouthY` = '%f' WHERE `AreaID` = %d", Area[areaid][aPos][2], Area[areaid][aPos][3], Area[areaid][aID]);
				db_query(General, Query);

				for(new i=0; i<MAX_GANGS; i++)
				{
					format(Query, sizeof(Query), "INSERT INTO `area_points` (areaid, gangid, gangpoints) VALUES (%d, %d, 0)", areaid, i);
					db_query(General, Query);
				}
				
				format(Query, sizeof(Query), "INSERT INTO `area_spawns` (areaid, spawnid) VALUES (%d, 0)", areaid);
				db_query(General, Query);

			    Area[areaid][aSampID] = GangZoneCreate(Area[areaid][aPos][0], Area[areaid][aPos][1], Area[areaid][aPos][2], Area[areaid][aPos][3]);
				GangZoneShowForAll(Area[areaid][aSampID], 0x4200007D);
				
				

			    PlayerData[playerid][CreatingStage] = AREA_SETTING_SPAWNS;
				PlayerData[playerid][CreatingSpawnID] = 0;

			    SendClientMessage(playerid, -1, "Hardcore DM: New area has been fully created. Now create spawns using the same key!");
			}
			else if(PlayerData[playerid][CreatingStage] == AREA_SETTING_SPAWNS)
			{
			    if(PlayerData[playerid][CreatingSpawnID] == MAX_SPAWNS) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You have set maximum number of spawns. Click \"H\" to save!");
			
			    new Float:X, Float:Y, Float:Z, Float:A, areaid = PlayerData[playerid][CreatingID], sid = PlayerData[playerid][CreatingSpawnID];
			    GetPlayerPos(playerid, X, Y, Z);
			    GetPlayerFacingAngle(playerid, A);
				Spawn[areaid][sid][sPos][0] = X;
				Spawn[areaid][sid][sPos][1] = Y;
				Spawn[areaid][sid][sPos][2] = Z;
				Spawn[areaid][sid][sPos][3] = A;
				SetPlayerMapIcon(playerid, sid, Spawn[areaid][sid][sPos][0], Spawn[areaid][sid][sPos][1], Spawn[areaid][sid][sPos][2], 56, 0, MAPICON_LOCAL);


				if(sid == 0)
				{
					format(Query, sizeof(Query), "UPDATE `area_spawns` SET `SpawnX` = %f, `SpawnY` = %f, `SpawnZ` = %f, `SpawnA` = %f WHERE `areaid` = %d AND `spawnid` = %d",
				        Spawn[areaid][sid][sPos][0], Spawn[areaid][sid][sPos][1], Spawn[areaid][sid][sPos][2], Spawn[areaid][sid][sPos][3], areaid, sid);
					db_query(General, Query);
				}
				else
				{
				    format(Query, sizeof(Query), "INSERT INTO `area_spawns` (areaid, spawnid, SpawnX, SpawnY, SpawnZ, SpawnA) VALUES (%d, %d, %f, %f, %f, %f)",
				        areaid, sid, Spawn[areaid][sid][sPos][0], Spawn[areaid][sid][sPos][1], Spawn[areaid][sid][sPos][2], Spawn[areaid][sid][sPos][3]);
					db_query(General, Query);
				}
				
				SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: New spawn has been created, go to the next location and press \"Y\"!");
				
				PlayerData[playerid][CreatingSpawnID]++;
			}
		}

		if(GangWar[GangWarONOFF] == 1 && GangWar[ActiveRound] == 1 && PlayerData[playerid][Name] == Gang[GangWar[GANG1ID]][gOwner] || Gang[GangWar[GANG2ID]][gOwner])
		{
			PauseRound(0);
		}
		else if(GangWar[GangWarONOFF] == 1 && GangWar[ActiveRound] == 1)
		{
			SendClientMessage(playerid, COLOR_PINK, "Gang War: Only gang leader can pause the round.");
		}
	}
	
	if(newkeys == KEY_CTRL_BACK)
	{
		new areaid = PlayerData[playerid][CreatingID], sid = PlayerData[playerid][CreatingSpawnID];
	    if(PlayerData[playerid][CreatingID] != -1)
	    {
	        PlayerData[playerid][CreatingID] = -1;
	        PlayerData[playerid][CreatingSpawnID] = -1;
	        PlayerData[playerid][CreatingStage] = AREA_SETTING_NONE;
	        
	        SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: All spawns now have been saved. New map and area created!");
			
			for(new x=0; x<sid; x++)
			{
				RemovePlayerMapIcon(playerid, x);
			}
			GangZoneDestroy(areaid);
			ReloadNewAreas();
		}
	}
	
	return 1;
}

public OnPlayerDamage(&playerid, &Float:amount, &issuerid, &weapon, &bodypart)
{	
	new string[120];
	new Float: health, Float: armour;
	 
	GetPlayerHealth(playerid, health);
	GetPlayerArmour(playerid, armour);
		
	if(amount >= health + armour)
		amount = health + armour + 0.001;

	if(PlayerData[playerid][moviemode] == 1 || PlayerData[playerid][Respawn] == 1 || GangPlayer[playerid][OnArena] == 0 || GangWar[GangWarONOFF] == 1 && GangWar[FF] == 1 && PlayerData[playerid][GangID] == PlayerData[issuerid][GangID])
	{
		new Float:HP, Float:restorehp;
		GetPlayerHealth(playerid, Float:HP);
		restorehp = HP + amount;
		SetPlayerHealth(playerid, restorehp);		
	}

	if(GangPlayer[issuerid][OnArena] == 1 && GangWar[ActiveRound] == 1)
	{
		GangPlayer[issuerid][ArenaDMG]+= amount;
		GangPlayer[issuerid][TotalDMG]+= amount;
		format(string, sizeof(string),"%s: %.0f", PlayerName(issuerid), GangPlayer[issuerid][ArenaDMG]);
		SendClientMessage(issuerid, -1, string);		
	}

	if(PlayerData[issuerid][GangID] > 0 && PlayerData[issuerid][GangID] == PlayerData[playerid][GangID])
	{
		SendClientMessage(issuerid, COLOR_REALRED, "Hardcore DM: You hitted your gangmate.");
		SendClientMessage(playerid, COLOR_REALRED, "Hardcore DM: You have been hitted from your gangmate.");
	}
	else
	{
		PlayerData[issuerid][Damage]+= amount;
		SessionPlayerData[issuerid][Damage]+= amount;
	}
	return 1;

}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(Area[CurrentArea][aSniperdrop] == 1 && GangPlayer[playerid][OnArena] == 0)
	{
		if(GetPlayerWeapon(playerid) == WEAPON_SNIPER)
		{
			SetTimerEx("hideSniper", 700, false, "d", playerid);
		}
	}
	return 1;	
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == D_GANGCHALLENGE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					ShowPlayerDialog(playerid, D_GANGCHALL_GANGLIST, DIALOG_STYLE_LIST, "Challenge Gang:", ListGangsGW(playerid), "Ok", "Cancel");
				}
				case 1:
				{
					ShowPlayerDialog(playerid, D_GANGCHALL_PLAYERSLIMIT, DIALOG_STYLE_INPUT, "Challenge Gang: Players Limit", "Enter number of players per team (2-4):", "Ok", "Cancel");
				}				
				case 2:
				{
					if(GangWar[Armours] == 0)
					{
						GangWar[Armours] = 1;
						ChallengeGang(playerid);
					}
					else if(GangWar[Armours] == 1)
					{
						GangWar[Armours] = 0;
						ChallengeGang(playerid);	
					}
				}				
				case 3:
				{
					if(GangWar[CBUG] == 0)
					{
						GangWar[CBUG] = 1;
						ChallengeGang(playerid);
					}
					else if(GangWar[CBUG] == 1)
					{
						GangWar[CBUG] = 0;
						ChallengeGang(playerid);	
					}	
				}				
				case 4:
				{					
					if(GangWar[FF] == 0)
					{
						GangWar[FF] = 1;
						ChallengeGang(playerid);
					}
					else if(GangWar[FF] == 1)
					{
						GangWar[FF] = 0;
						ChallengeGang(playerid);	
					}
				}				
				case 5:
				{
					StartGangWar(playerid);
				}				
			}
		}
		else
		{
			GangWar[GANG2ID] = 0;
			GangWar[PlayersLimit] = 0;
			GangWar[Armours] = 0;
			GangWar[CBUG] = 0;
			GangWar[FF] = 0;
			SendClientMessage(playerid, COLOR_PINK, "Gang War: Canceled!");
		}
	}
	if(dialogid == D_GANGCHALL_GANGLIST)
	{
		if(response)
		{
			GangWar[GANG2ID] = strval(inputtext[0]);
			ChallengeGang(playerid);
		}
		else ChallengeGang(playerid);
	}
	if(dialogid == D_GANGCHALL_PLAYERSLIMIT)
	{
		if(response)
		{
			new limit = strval(inputtext[0]);
			if(limit < 2 || limit > 4) return ShowPlayerDialog(playerid, D_GANGCHALL_PLAYERSLIMIT, DIALOG_STYLE_INPUT, "Challenge Gang: Players Limit", "Enter number of players per team (2-4):\nInvalid Players Limit. Must be 3-5!", "Ok", "Cancel");
			GangWar[PlayersLimit] = limit;
			ChallengeGang(playerid);
		}
		else ChallengeGang(playerid);
	}
	if(dialogid == D_GANGWARWEAPON)
	{
		new stringweapon[256];
		if(response)
		{
			switch(listitem) 
			{
				case 0:	
				{
					GangPlayer[playerid][Weapon][0] = 24;
					GangPlayer[playerid][Weapon][1] = 25;
					format(stringweapon, sizeof(stringweapon), "Gang War: %s picekd a Deagle / Shotgun set", PlayerName(playerid));
				}
				
				case 1:
				{
					GangPlayer[playerid][Weapon][0] = 24;
					GangPlayer[playerid][Weapon][1] = 31;
					format(stringweapon, sizeof(stringweapon), "Gang War: %s picekd a Deagle / M4 set", PlayerName(playerid));

				}

				case 2:
				{
					GangPlayer[playerid][Weapon][0] = 24;
					GangPlayer[playerid][Weapon][1] = 33;
					format(stringweapon, sizeof(stringweapon), "Gang War: %s picekd a Deagle / Rifle set", PlayerName(playerid));
									
				}
				case 3:
				{
					if(PlayerData[playerid][GangID] == GangWar[GANG1ID] && GWROUND[SniperLimitT1] == 1 || PlayerData[playerid][GangID] == GangWar[GANG2ID] && GWROUND[SniperLimitT2] == 1)
					{
						ShowGWWeaponMenu(playerid);
						SendClientMessage(playerid, COLOR_PINK, "Gang War: Sniper Limit reached!");
						return 1;
					}
					if(PlayerData[playerid][GangID] == GangWar[GANG1ID])GWROUND[SniperLimitT1] = 1;
					if(PlayerData[playerid][GangID] == GangWar[GANG2ID])GWROUND[SniperLimitT2] = 1;
					GangPlayer[playerid][Weapon][0] = 24;
					GangPlayer[playerid][Weapon][1] = 34;
					format(stringweapon, sizeof(stringweapon), "Gang War: %s picekd a Deagle / Sniper Rifle set", PlayerName(playerid));		
				}
				case 4:
				{
					GangPlayer[playerid][Weapon][0] = 25;
					GangPlayer[playerid][Weapon][1] = 31;
					format(stringweapon, sizeof(stringweapon), "Gang War: %s picekd a Shotgun / M4 set", PlayerName(playerid));
			
				}
				case 5:
				{
					GangPlayer[playerid][Weapon][0] = 25;
					GangPlayer[playerid][Weapon][1] = 33;
					format(stringweapon, sizeof(stringweapon), "Gang War: %s picekd a Shotgun / Rifle set", PlayerName(playerid));
				
				}
				case 6: 
				{
					if(PlayerData[playerid][GangID] == GangWar[GANG1ID] && GWROUND[SniperLimitT1] == 1 || PlayerData[playerid][GangID] == GangWar[GANG2ID] && GWROUND[SniperLimitT2] == 1)
					{
						ShowGWWeaponMenu(playerid);
						SendClientMessage(playerid, COLOR_PINK, "Gang War: Sniper Limit reached!");
						return 1;
					}
					if(PlayerData[playerid][GangID] == GangWar[GANG1ID])GWROUND[SniperLimitT1] = 1;
					if(PlayerData[playerid][GangID] == GangWar[GANG2ID])GWROUND[SniperLimitT2] = 1;
					GangPlayer[playerid][Weapon][0] = 25;
					GangPlayer[playerid][Weapon][1] = 34;
					format(stringweapon, sizeof(stringweapon), "Gang War: %s picekd a Shotgun / Sniper Rifle set", PlayerName(playerid));				
				}				
			}
			if(PlayerData[playerid][GangID] == GangWar[GANG1ID])
			{
				foreach(new i : Player)
				{
					if(PlayerData[i][GangID] == GangWar[GANG1ID]) SendClientMessage(i, COLOR_PINK, stringweapon);				
				}
			}
			else if(PlayerData[playerid][GangID] == GangWar[GANG2ID])
			{
				foreach(new i : Player)
				{
					if(PlayerData[i][GangID] == GangWar[GANG2ID]) SendClientMessage(i, COLOR_PINK, stringweapon);				
				}
			}
			GiveWeaponsArena(playerid);
		}
		else
		{ 
			ShowGWWeaponMenu(playerid);
			SendClientMessage(playerid, COLOR_PINK, "Gang War: You must pick a weaponset!");
		}
	}
	if(dialogid == D_HDMPANEL)
	{
		
		//if(strval(inputtext[0]) == '1')
		//if(strval(inputtext[0]) == '2')
		if(inputtext[0] == '3')
		{	
			new string[1024], Query[512], DBResult: Result, name[24];
			for(new i=0; i<100; i++)
			{			
				format(Query, sizeof(Query), "SELECT * FROM `players` WHERE `accid` = %d", i);
				Result = db_query(General, Query);
				
				if(db_num_rows(Result) > 0)
				{	
					db_get_field_assoc(Result, "name", name, sizeof(name));
					format(string, sizeof(string), "%s%d. %s\n", string, i, name);
				}
				db_free_result(Result);
			}
			ShowPlayerDialog(playerid, D_HDMPANEL_ACCOUNTS, DIALOG_STYLE_LIST, "Hardcore DM: Accounts list", string, "Ok", "Close");
		}

	}

	if(dialogid == D_HDMPANEL_ACCOUNTS)
	{
		if(response)
		{
			new string[1024], Query[512], DBResult: Result, name[24], Kills2, Deaths2, Points2, Float:Damage2, GangID2, PlayerLevel2, title[64];
			format(Query, sizeof(Query), "SELECT * FROM `players` WHERE `accid` = %d", strval(inputtext[0]));
			Result = db_query(General, Query);
			db_get_field_assoc(Result, "name", name, sizeof(name));
			Kills2 = db_get_field_assoc_int(Result, "kills");
			Deaths2 = db_get_field_assoc_int(Result, "deaths");
			Points2 = db_get_field_assoc_int(Result, "points");
			Damage2 = db_get_field_assoc_int(Result, "damage");
			GangID2 = db_get_field_assoc_int(Result, "gangID");
			PlayerLevel2 = db_get_field_assoc_int(Result, "playerlevel");
			format(string, sizeof(string), "Nickname: %s\nKills: %d\nDeaths: %d\nPoints: %d\nDamage: %.0f\nGang: %s\nLevel: %d", name, Kills2, Deaths2, Points2, Damage2, Gang[GangID2][gName], PlayerLevel2);
			format(title, sizeof(title), "Hardcore DM: Account Edit %s", name);
			ShowPlayerDialog(playerid, D_HDMPANEL_ACCOUNTEDIT, DIALOG_STYLE_LIST, title, string, "Ok", "Close");
			db_free_result(Result);
		}
	}
	if(dialogid == D_AREALIST)
	{
		if(response)
		{
			new idarea = strval(inputtext[0]);
			StartAreaID(idarea);
		}
		else
		{
			ListAreas2(playerid);
		}
	}

	if(dialogid == D_AREALIST2)
	{
		if(response)
		{
			new idarea = strval(inputtext[0]);
			StartAreaID(idarea);
		}
	}

	if(dialogid == D_CRASHADDPLAYERSLIST)
	{
		if(response)
		{
			CADD[reeplaceid] = strval(inputtext[0]);
			ShowPlayerDialog(playerid, D_CRASHADDPLAYERADD, DIALOG_STYLE_INPUT, "Gangwar: Replacing player", "Enter player id from your gang.", "Replace", "Cancel");
		}
		else
		{
			return cmd_gang(playerid, "");
		}
	}
	if(dialogid == D_CRASHADDPLAYERADD)
	{
		if(response)
		{
			sscanf(inputtext, "d", CADD[tooaddid]);
			ShowPlayerDialog(playerid, D_CRASHADDPLAYERADD, DIALOG_STYLE_INPUT, "Gangwar: Replacing player", "Enter player id from your gang.", "Replace", "Cancel");
			ReplaceCrashPlayer(CADD[reeplaceid], CADD[tooaddid]);
		}
		else
		{
			return cmd_gang(playerid, "");
		}
	}
	if(dialogid == D_RULES)
	{
		if(response)
		{
			SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: Now register your account and PLAY!");
			ShowPlayerDialog(playerid, D_REGISTER, DIALOG_STYLE_PASSWORD, "Hardcore DM - Register", "Welcome to Hardcore DM!\nPlease enter your password so that we can register your account!", "Register", "Cancel");
		}
		else
		{
			new string[512];
			hidePlayerHud(playerid);
			PlayerPlaySound(playerid, 1068, 0, 0, 0);
			format(string, sizeof(string), "~y~KICKED~w~ for ~r~Not accepting the rules.~w~~n~~n~ Enough of that! ~n~~n~You've been ~y~KICKED~w~ out, and that means something has gone wrong or you're behaving incorrectly.");
			PlayerTextDrawSetString(playerid, HDM_JoinScreenNews[playerid], string);
			showBanScreen(playerid);
		}
	}
	
	if(dialogid == D_REGISTER)
	{
	    if(response)
	    {
	        if(strlen(inputtext) < 3 || strlen(inputtext) > 24) return SendClientMessage(playerid, COLOR_RED, "Hardcore DM: Password needs to be between 3 and 24 characters!");
	        
	        new Query[128];
            format(Query, sizeof(Query), "INSERT INTO players (name, password, kills, deaths, damage, gangID) VALUES ('%s', %d, %d, %d, %.0f, 0)", PlayerName(playerid), udb_hash(inputtext), PlayerData[playerid][Kills], PlayerData[playerid][Deaths], PlayerData[playerid][Damage]);
			db_query(General, Query);
			
			PlayerData[playerid][LoggedIn] = true;
			format(PlayerData[playerid][Name], 24, "%s", PlayerName(playerid));
			SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: Account registered successfully, you are now logged in!");
			ShowPlayerDialog(playerid, D_HELP, DIALOG_STYLE_MSGBOX, "Hardcore DM: Help", help(), "Ok", "Close");		
		}
		else
		{
		    showJoinScreen(playerid);
			SelectTextDraw(playerid, 0xFF0000FF);
			hidePlayerHud(playerid);
		}
	}

	if(dialogid == D_LOGIN)
	{
	    if(response)
	    {
	        new Query[128], DBResult: Result, password, banned = 0;
	        format(Query, sizeof(Query), "SELECT * FROM `players` WHERE `name` = '%s'", PlayerName(playerid));
			Result = db_query(General, Query);
			
			password = db_get_field_assoc_int(Result, "password");
			
			if(udb_hash(inputtext) == password)
			{
			    PlayerData[playerid][Kills] = db_get_field_assoc_int(Result, "kills");
			    PlayerData[playerid][Deaths] = db_get_field_assoc_int(Result, "deaths");
				PlayerData[playerid][Points] = db_get_field_assoc_int(Result, "points");
			    PlayerData[playerid][Damage] = db_get_field_assoc_int(Result, "damage");
				PlayerData[playerid][GangID] = db_get_field_assoc_int(Result, "gangID");
				PlayerData[playerid][skinID] = db_get_field_assoc_int(Result, "skinID");
				PlayerData[playerid][Weather] = db_get_field_assoc_int(Result, "weather");
				PlayerData[playerid][SetTime] = db_get_field_assoc_int(Result, "time");
				PlayerData[playerid][AdminLevel] = db_get_field_assoc_int(Result, "adminlevel");
				PlayerData[playerid][DuelPlayed] = db_get_field_assoc_int(Result, "duelsplayed");
				PlayerData[playerid][DuelWins] = db_get_field_assoc_int(Result, "duelswin");
				PlayerData[playerid][PlayerLevel] = db_get_field_assoc_int(Result, "playerlevel");
				PlayerData[playerid][onededeaths] = db_get_field_assoc_int(Result, "onededeaths");
				PlayerData[playerid][onedekills] = db_get_field_assoc_int(Result, "onedekills");
				PlayerData[playerid][sawndeaths] = db_get_field_assoc_int(Result, "sawndeaths");
				PlayerData[playerid][sawnkills] = db_get_field_assoc_int(Result, "sawnkills");
				banned = db_get_field_assoc_int(Result, "banned");
				
				if(banned == 1)
				{
				    new string[512];
					showBanScreen(playerid);
					PlayerPlaySound(playerid, 1068, 0, 0, 0);
    				hidePlayerHud(playerid);
    				format(string, sizeof(string), "~r~BANNED~w~~n~~n~Enough for that!~n~~n~ You are still banned, and that means you're stupid and you don't follow the rules.~n~~n~You can appeal this ban by writing a request on our discord server.");
    				PlayerTextDrawSetString(playerid, HDM_JoinScreenNews[playerid], string);
					format(string, sizeof(string), "Hardcore DM: %s [ID:%d] has been kicked for Still banned by Server. ", PlayerName(playerid), playerid);
					SendClientMessage(playerid, COLOR_BANKICK, string);
    				SetTimerEx("DelayedKick", 300, false, "d", playerid);
    				return 1;
				}
			    
			    PlayerData[playerid][LoggedIn] = true;
			    
			    format(PlayerData[playerid][Name], 24, "%s", PlayerName(playerid));
			    
			    format(Query, sizeof(Query), "UPDATE `players` SET `ingame` = 1 WHERE `name` = '%s'", PlayerName(playerid));
			    db_query(General, Query);
			    new gid = PlayerData[playerid][GangID], string[300];
			    PlayerPlaySound(playerid, 0, 0, 0, 0);
				hideJoinScreen(playerid);
				if(gid != 0)
				{
					format(string, sizeof(string), "%s.%s", Gang[gid][gTag], PlayerName(playerid));
					SetPlayerName(playerid, string);
					SetPlayerColor(playerid, Gang[gid][gColor]);
					SetPlayerTime(playerid, PlayerData[playerid][SetTime], 0);
					SetPlayerWeather(playerid, PlayerData[playerid][Weather]);
					SetPlayerScore(playerid, PlayerData[playerid][Points]);
					
					new str[64];
					format(str, sizeof(str), "Hardcore DM: (GANG) %s is now online!", PlayerName(playerid));
					foreach(new i : Player)
						if(IsPlayerConnected(i) && PlayerData[i][GangID] == gid)
							SendClientMessage(i, Gang[gid][gColor], str);
				}
			    SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You have logged in successfully!");
			    onlineplayers++;
			    if(PlayerData[playerid][Weapon][0] == -1 && PlayerData[playerid][Weapon][1] == -1 && PlayerData[playerid][Weapon][2] == -1 && PlayerData[playerid][Weapon][3] == -1)
				{				
					new stringz[512];
					strcat(stringz, "0\tNone\n24\tDeagle\n25\tShotgun\n29\tMP5\n31\tM4\n33\tRifle");
					ShowPlayerDialog(playerid, D_SELECT_FIRST_WEAPON, DIALOG_STYLE_LIST, "Hardcore DM - Weapon Selection (1/4)", stringz, "Select", "Cancel");
				}
				else SpawnPlayer(playerid);
			}
			else
			{
			    format(Query, sizeof(Query), "Welcome back %s to Hardcore DM!\nPlease enter your password below to login!\n\n{FF0000}Password incorrect!", PlayerName(playerid));
		    	ShowPlayerDialog(playerid, D_LOGIN, DIALOG_STYLE_PASSWORD, "Hardcore DM - Login", Query, "Login", "Cancel");
			}
			
			db_free_result(Result);
		}
		else
		{
			if(PlayerData[playerid][LoggedIn] == false)
			{
		    	new string[256];
				showJoinScreen(playerid);
				hidePlayerHud(playerid);
				SendClientMessage(playerid, COLOR_RED, "Hardcore DM: You need to login!");
				format(string, sizeof(string), "Welcome back %s to Hardcore DM!\nPlease enter your password below to login!", PlayerName(playerid));
		    	ShowPlayerDialog(playerid, D_LOGIN, DIALOG_STYLE_PASSWORD, "Hardcore DM - Login", string, "Login", "Cancel");
			}
		}
	}
	
	if(dialogid == D_GANG)
	{
	    if(response)
		{
			switch(listitem) 
			{
				case 0:	
				{
					if(PlayerData[playerid][GangID] >= 1) return SendClientMessage(playerid, COLOR_GANGINFO, "Hardcore DM: You are in gang!");
					ShowPlayerDialog(playerid, D_GANG_CREATE, DIALOG_STYLE_INPUT, "Hardcore DM - Create a new gang", "Insert a new gang tag and name below:\nExample: NGN New Gang Name", "Create", "Cancel");
				}
				
				case 1:
				{
					new gid = PlayerData[playerid][GangID];
					if(gid == 0) return SendClientMessage(playerid, COLOR_GANGINFO, "Hardcore DM: You are not in a gang!");
					if(strcmp(Gang[gid][gOwner], PlayerData[playerid][Name])) return SendClientMessage(playerid, COLOR_GANGINFO, "Hardcore DM: You are not the owner of this gang!");

					new Query[128], DBResult: Result;
					format(Query, sizeof(Query), "SELECT `gangID` FROM `players` WHERE `gangID` = %d", gid);
					Result = db_query(General, Query);
					
					if(db_num_rows(Result) == Gang[gid][MAX_PLAYERS_PER_GANG]) return SendClientMessage(playerid, COLOR_GANGINFO, "Hardcore DM: You have reached the maximum amount of players per gang!");

					ShowPlayerDialog(playerid, D_GANG_INVITE_PLAYER, DIALOG_STYLE_INPUT, "Hardcore DM - Invite player to your gang", "Insert ID of the player that you would like to invite:", "Invite", "Cancel");
				}
				case 2:
				{
					new gid = PlayerData[playerid][GangID];
					if(gid == 0) return SendClientMessage(playerid, COLOR_GANGINFO, "Hardcore DM: You are not in a gang!");
					if(strcmp(Gang[gid][gOwner], PlayerData[playerid][Name])) return SendClientMessage(playerid, COLOR_GANGINFO, "Hardcore DM: You are not the owner of this gang!");
					ShowPlayerDialog(playerid, D_GANG_REMOVE_PLAYER, DIALOG_STYLE_INPUT, "Hardcore DM - Remove player from your gang", "Insert ID of the player you would like to remove:", "Remove", "Cancel");
				}
				case 3:
				{
					new gid = PlayerData[playerid][GangID];
					if(gid == 0) return SendClientMessage(playerid, COLOR_GANGINFO, "Hardcore DM: You are not in a gang!");
					if(strcmp(Gang[gid][gOwner], PlayerData[playerid][Name])) return SendClientMessage(playerid, COLOR_GANGINFO, "Hardcore DM: You are not the owner of this gang!");

					new str[3062];
					for(new i=0; i<190; i++)
						format(str, sizeof(str), "%s\n{%06x}%s", str, GangColors[i] >>> 8, Gang[gid][gName]);

					ShowPlayerDialog(playerid, D_COLORS, DIALOG_STYLE_LIST, "Hardcore DM - Colors (1/3)", str, "Select", "Next");
				}
				case 4:
				{
					new gid = PlayerData[playerid][GangID];
					if(gid == 0) return SendClientMessage(playerid, COLOR_GANGINFO, "Hardcore DM: You are not in a gang!");
					if(strcmp(Gang[gid][gOwner], PlayerData[playerid][Name])) return SendClientMessage(playerid, COLOR_GANGINFO, "Hardcore DM: You are not the owner of this gang!");
					ShowPlayerDialog(playerid, D_GANG_SKIN_CHANGE, DIALOG_STYLE_INPUT, "Gang Skin Change", "Please type a skin ID for your gang", "Set", "Cancel");
				}
				case 5:
				{
					new Query[128], gid = PlayerData[playerid][GangID];
					if(gid == 0) return SendClientMessage(playerid, COLOR_GANGINFO, "Hardcore DM: You are not in a gang!");
					format(Query, sizeof(Query), "UPDATE `players` SET `gangID` = 0 WHERE `name` = '%s'", PlayerName(playerid));
					db_query(General, Query);

					PlayerData[playerid][GangID] = 0;
					
					SetPlayerColor(playerid, 0xFFFFFFFF);
					SetPlayerName(playerid, PlayerData[playerid][Name]);

					SendClientMessage(playerid, COLOR_GANGINFO, "Hardcore DM: You've left the gang!");
				}
				case 6: ShowPlayerDialog(playerid, D_GANG_DELETE, DIALOG_STYLE_INPUT, "Hardcore DM - Gang delete", "Insert gang ID to delete a gang:", "Delete", "Back");
				case 7: ShowPlayerDialog(playerid, D_GANG_ADMIN_PLAYER_DELETE, DIALOG_STYLE_INPUT, "Hardcore DM - Remove player from a gang", "Insert gang ID and players ID(must be online!) to remove them from gang:\nIf you want to remove an offline player, do it through database!", "Remove", "Back");
				case 8: ShowPlayerDialog(playerid, D_GANG_ADMIN_CHANGE_NAME, DIALOG_STYLE_INPUT, "Hardcore DM - Change gang name", "Insert gang ID and new name of the gang:", "Change", "Cancel");
				case 9: ShowPlayerDialog(playerid, D_GANG_ADMIN_CHANGE_TAG, DIALOG_STYLE_INPUT, "Hardcore DM - Change gang tag", "Insert gang ID and new gang tag including '[]' example [NGN]:", "Change", "Cancel");
				case 10: ShowPlayerDialog(playerid, D_GANG_ADMIN_CHANGE_LIMIT, DIALOG_STYLE_INPUT, "Hardcore DM - Change MAX_PLAYERS_PER_GANG limit", "Insert a new limit of players for gangs:", "Change", "Cancel");
			}
		}
	}
	
	/*if(dialogid == D_GANG_COLOR_CHANGE)
	{
	    if(response)
	    {
	        new gid = PlayerData[playerid][GangID], Query[128];
	        
			Gang[gid][gColor] = HexToInt(inputtext);
	        
	        for(new i=0; i<MAX_PLAYERS; i++)
	            if(IsPlayerConnected(i))
	                if(PlayerData[i][GangID] == gid)
	                    SetPlayerColor(i, Gang[gid][gColor]);
	        
	        format(Query, sizeof(Query), "UPDATE `gangs` SET `gColor` = %d WHERE `gID` = %d", Gang[gid][gColor], gid);
			db_query(General, Query);
			
			SendClientMessage(playerid, Gang[gid][gColor], "Hardcore DM: Gang color has been changed.");
			return cmd_gang(playerid, "");
	    }
	    else
	    {
	        return cmd_gang(playerid, "");
		}
	}*/
	
	if(dialogid == D_GANG_CREATE)
	{
	    if(response)
	    {
	        new gid = GetNewGangID();
			PlayerData[playerid][GangID] = gid;
			Gang[gid][gID] = gid;
			format(Gang[gid][gOwner], 24, "%s", PlayerName(playerid));
			sscanf(inputtext, "s[24]s[24]", Gang[gid][gTag], Gang[gid][gName]);
			Gang[gid][gPoints] = 0;
			Gang[gid][gKills] = 0;
			Gang[gid][gDeaths] = 0;
			Gang[gid][gDamage] = 0;
			Gang[gid][gColor] = 0xFFFFFF8D;
			Gang[gid][gSkin] = 110;

			new Query[512];
			format(Query, sizeof(Query), "INSERT INTO `gangs` (gID, gOwner, gName, gTag, gPoints, gKills, gDeaths, gDamage, gColor, gSkin) VALUES (%d, '%s', '%s', '%s', 0, 0, 0, 0, 0, 110)",
   				Gang[gid][gID], Gang[gid][gOwner], Gang[gid][gName], Gang[gid][gTag], Gang[gid][gPoints], Gang[gid][gKills], Gang[gid][gDeaths], Gang[gid][gDamage], Gang[gid][gColor]);
			db_query(General, Query);
			SendClientMessage(playerid,  COLOR_GANGINFO, Query);
			format(Query, sizeof(Query), "UPDATE `players` SET `gangID` = %d WHERE `name` = '%s'", gid, PlayerName(playerid));
			db_query(General, Query);
			SendClientMessage(playerid,  COLOR_GANGINFO, Query);
			format(Query, sizeof(Query), "Hardcore DM: You have created new gang %s([%s], ID: %d)", Gang[gid][gName], Gang[gid][gTag], Gang[gid][gID]);
			SendClientMessage(playerid,  COLOR_GANGINFO, Query);
			
			SetPlayerColor(playerid, Gang[gid][gColor]);

			new strnick[24];
			format(strnick, sizeof(strnick), "%s.%s", Gang[gid][gTag], PlayerName(playerid));
			SetPlayerName(playerid, strnick);
			
			new str[3062];
			for(new i=0; i<190; i++)
				format(str, sizeof(str), "%s\n{%06x}%s", str, GangColors[i] >>> 8, Gang[gid][gName]);

			ShowPlayerDialog(playerid, D_COLORS, DIALOG_STYLE_LIST, "Hardcore DM - Colors (1/3)", str, "Select", "Next");

			ReloadPoints(); //przeładowanko

			return cmd_gang(playerid, "");
		}
		else
		{
		    return cmd_gang(playerid, "");
		}
	}

	if(dialogid == D_GANG_ADMIN_CHANGE_LIMIT)
	{
	    if(response)
	    {
	        dini_IntSet(FILE_CONFIG, "MAX_PLAYERS_PER_GANG", strval(inputtext));
	        for(new i=0; i<MAX_GANGS; i++)
	            Gang[i][MAX_PLAYERS_PER_GANG] = strval(inputtext);
	            
			SendClientMessage(playerid, COLOR_GANGINFO, "Hardcore DM: Limit of players in a gang has been changed!");
			return cmd_gang(playerid, "");
		}
		else
		{
		    return cmd_gang(playerid, "");
		}
	}

	if(dialogid == D_GANG_DELETE)
	{
	    if(response)
	    {
	        new gid = strval(inputtext[0]), Query[128];
	        format(Query, sizeof(Query), "DELETE FROM `gangs` WHERE `gID` = %d", gid);
	        db_query(General, Query);

			format(Query, sizeof(Query), "UPDATE `area_points` SET `gangpoints` = 0 WHERE `gangid` = %d", gid);
	        db_query(General, Query);

			format(Query, sizeof(Query), "UPDATE `players` SET `gangID` = 0 WHERE `gangID` = %d", gid);
			db_query(General, Query);

			foreach(new i : Player)
			    if(IsPlayerConnected(i) && PlayerData[i][GangID] == gid)
			        PlayerData[i][GangID] = 0, SetPlayerName(i, PlayerData[i][Name]), SetPlayerColor(i, 0xFFFFFFFF);

			Gang[gid][gOwner] = -1;
			Gang[gid][gID] = 0;
			SendClientMessage(playerid, COLOR_GANGINFO, "Hardcore DM: Gang has been deleted!");
			ReloadPoints();
			LoadGangs();
	        return cmd_gang(playerid, "");
		}
		else
		{
		    return cmd_gang(playerid, "");
		}
	}

	if(dialogid == D_GANG_ADMIN_PLAYER_DELETE)
	{
	    if(response)
	    {
	        new gid = strval(inputtext[0]), pid = strval(inputtext[1]), Query[128];
	        if(!IsPlayerConnected(pid) || PlayerData[pid][GangID] != gid) return SendClientMessage(playerid, COLOR_GANGINFO, "Hardcore DM: This player isn't a member of this gang or the player isn't online!"), cmd_gang(playerid, "");
			if(!strcmp(PlayerData[pid][Name], Gang[gid][gOwner], true)) return SendClientMessage(playerid, COLOR_GANGINFO, "Hardcore DM: You cannot remove the owner, instead change the owner through database!"), cmd_gang(playerid, "");
			if(PlayerData[pid][GangID] != gid) return SendClientMessage(playerid, COLOR_GANGINFO, "Hardcore DM: That player isn't part of this gang!"), cmd_gang(playerid, "");

			format(Query, sizeof(Query), "UPDATE `players` SET `gangID` = 0 WHERE `name` = '%s'", PlayerName(pid));
			db_query(General, Query);

			PlayerData[pid][GangID] = 0;
			
			SetPlayerColor(pid, 0xFFFFFFFF);
			SetPlayerName(pid, PlayerData[pid][Name]);

			SendClientMessage(playerid, COLOR_GANGINFO, "Hardcore DM: Player has been removed from the gang!");
			return cmd_gang(playerid, "");
		}
		else
		{
		    return cmd_gang(playerid, "");
		}
	}

 	if(dialogid == D_GANG_ADMIN_CHANGE_NAME)
	{
	    if(response)
	    {
	        new gid, gangName[24], Query[128];
			sscanf(inputtext, "ds[24]", gid, gangName);

			format(Query, sizeof(Query), "UPDATE `gangs` SET `gName` = '%s' WHERE `gID` = %d", gangName, gid);
			db_query(General, Query);

			format(Gang[gid][gName], 24, "%s", gangName);

			SendClientMessage(playerid, COLOR_GANGINFO, "Hardcore DM: Gang name has been changed!");
			return cmd_gang(playerid, "");
		}
		else
		{
		    return cmd_gang(playerid, "");
		}
	}

	if(dialogid == D_GANG_ADMIN_CHANGE_TAG)
	{
	    if(response)
	    {
	        new gid, gangTag[24], Query[128];
			sscanf(inputtext, "ds[24]", gid, gangTag);

			format(Query, sizeof(Query), "UPDATE `gangs` SET `gTag` = '%s' WHERE `gID` = %d", gangTag, gid);
			db_query(General, Query);

			format(Gang[gid][gTag], 24, "%s", gangTag);
			
			foreach(new i : Player)
			{
				if(IsPlayerConnected(i) && PlayerData[i][GangID] == gid)
				{
				    new str[64];
				    format(str, sizeof(str), "%s.%s", Gang[gid][gTag], PlayerData[i][Name]);
				    SetPlayerName(i, str);
				}
			}

			SendClientMessage(playerid, COLOR_GANGINFO, "Hardcore DM: Gang tag has been changed!");
			return cmd_gang(playerid, "");
		}
		else
		{
		    return cmd_gang(playerid, "");
		}
	}

	if(dialogid == D_GANG_INVITE_PLAYER)
	{
	    if(response)
	    {
	        new gid = PlayerData[playerid][GangID], id = strval(inputtext[0]), Query[128];
	        if(PlayerData[id][GangID] == gid) return SendClientMessage(playerid, COLOR_GANGINFO, "Hardcore DM: This player is already part of your gang!");
	        if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_GANGINFO, "Hardcore DM: The player must be online!");
	        if(PlayerData[id][GangInvite] != -1) return SendClientMessage(playerid, COLOR_GANGINFO, "Hardcore DM: This player has already been invited to a gang!");

	        PlayerData[id][GangInvite] = gid;

	        SetTimerEx("InviteRespond", 60*1000, false, "d", id);

	        SendClientMessage(playerid, COLOR_GANGINFO, "Hardcore DM: You have invited a player to your gang!");
	        SendClientMessage(id, COLOR_GANGINFO, "Hardcore DM: You have been invited to a gang, respond!");

	        format(Query, sizeof(Query), "You have been invited to join %s (%s) by %s", Gang[gid][gName], Gang[gid][gTag], PlayerName(playerid));
	        ShowPlayerDialog(id, D_GANG_INVITE, DIALOG_STYLE_MSGBOX, "Hardcore DM - Gang invite", Query, "Accept", "Decline");
	        return cmd_gang(playerid, "");
		}
		else
		{
		    return cmd_gang(playerid, "");
		}
	}

	if(dialogid == D_GANG_REMOVE_PLAYER)
	{
	    if(response)
	    {
	        new gid = PlayerData[playerid][GangID], id = strval(inputtext[0]), Query[128];
	        if(PlayerData[id][GangID] != gid) return SendClientMessage(playerid, COLOR_GANGINFO, "Hardcore DM: This player isn't part of your gang!");
	        if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_GANGINFO, "Hardcore DM: The player must be online!");

	        format(Query, sizeof(Query), "UPDATE `players` SET `gangID` = 0 WHERE `name` = '%s'", PlayerName(id));
	        db_query(General, Query);

	        PlayerData[id][GangID] = 0;
	        
			SetPlayerName(id, PlayerData[id][Name]);
			SetPlayerColor(id, 0xFFFFFFFF);
			SetPlayerSkin(id, PlayerData[id][skinID]);

	        SendClientMessage(playerid, COLOR_GANGINFO, "Hardcore DM: You have removed the player from your gang!");
	        SendClientMessage(id, COLOR_GANGINFO, "Hardcore DM: You have been removed from the gang!");
	        return cmd_gang(playerid, "");
		}
		else
		{
		    return cmd_gang(playerid, "");
		}
	}

	if(dialogid == D_GANG_INVITE)
	{
	    if(response)
	    {
	        new gid = PlayerData[playerid][GangInvite], Query[128];
	        if(gid == 0) return SendClientMessage(playerid, COLOR_GANGINFO, "Hardcore DM: The gang invite has expired!");

	        format(Query, sizeof(Query), "UPDATE `players` SET `gangID` = %d WHERE `name` = '%s'", gid, PlayerName(playerid));
	        db_query(General, Query);

	        PlayerData[playerid][GangID] = gid;

	        new str[24];
			format(str, sizeof(str), "%s.%s", Gang[gid][gTag], PlayerData[playerid][Name]);
			SetPlayerName(playerid, str);
			SetPlayerColor(playerid, Gang[gid][gColor]);
			SetPlayerSkin(playerid, Gang[gid][gSkin]);
	        SendClientMessage(playerid, COLOR_GANGINFO, "Hardcore DM: You have joined gang!");
		}
	}
	
	if(dialogid == D_GANG_SKIN_CHANGE)
	{
		if(response)
		{
			new gid = PlayerData[playerid][GangID], id = strval(inputtext[0]), Query[128];
			sscanf(inputtext, "d", id);
	        format(Query, sizeof(Query), "UPDATE `gangs` SET `gSkin` = %d WHERE `gID` = %d", id, gid);
	        db_query(General, Query);
			printf("%s",Query);
	        Gang[gid][gSkin] = id;
			foreach(new i : Player)
	        if(IsPlayerConnected(i))
	        if(PlayerData[i][GangID] == gid)
	        SetPlayerSkin(i, Gang[gid][gSkin]);
			SendClientMessage(playerid, COLOR_GANGINFO, "Hardcore DM: Owner of your gang changed gangskin!");

	        return cmd_gang(playerid, "");
		}
	}

	if(dialogid == D_AREA)
	{
		if(response)
		{
			if(inputtext[0] == '0')
				ShowPlayerDialog(playerid, D_AREA_CREATE_NAME, DIALOG_STYLE_INPUT, "Hardcore DM - Create new area", "Insert the name of the area then follow instructions displayed in chat:", "Create", "Cancel");
			if(inputtext[0] == '1')
			    ShowPlayerDialog(playerid, D_AREA_DELETE, DIALOG_STYLE_INPUT, "Hardcore DM - Delete an area", "Insert ID of the area you would like to delete:", "Delete", "Cancel");
		}
	}

	if(dialogid == D_AREA_CREATE_NAME)
	{
	    if(response)
	    {
	        new string[300], Query[512];
			if(!strlen(inputtext)) return ShowPlayerDialog(playerid, D_AREA_CREATE_NAME, DIALOG_STYLE_INPUT, "Hardcore DM - Create new area", "Insert the name of the area then follow instructions displayed in chat:", "Create", "Cancel");

			new areaid = GetNewAreaID();
			Area[areaid][aID] = areaid;
			format(Area[areaid][aName], 24, "%s", inputtext);
    		Area[areaid][aPos][0] = 0.0;
    		Area[areaid][aPos][1] = 0.0;
    		Area[areaid][aPos][2] = 0.0;
    		Area[areaid][aPos][3] = 0.0;
    		for(new i=1; i<MAX_GANGS; i++)
          		Area[areaid][GangPoints][i] = 0;
			Area[areaid][AreaPlayed] = false;

			format(Query, sizeof(Query), "INSERT INTO `areas` (AreaID, AreaName, NorthX, NorthY, SouthX, SouthY) VALUES (%d, '%s', '%f', '%f', '%f', '%f')", Area[areaid][aID], Area[areaid][aName], Area[areaid][aPos][0], Area[areaid][aPos][1], Area[areaid][aPos][2], Area[areaid][aPos][3]);
			db_query(General, Query);

			format(string, sizeof(string), "Hardcore DM: You created Area: %s [ID:%d]. Go to NORTH-EAST position and press \"Y\"", Area[areaid][aName], Area[areaid][aID]);
			SendClientMessage(playerid, -1, string);

			PlayerData[playerid][CreatingStage] = AREA_SETTING_NE_POS;
			PlayerData[playerid][CreatingID] = areaid;
			return cmd_area(playerid, "");
		}
		else
		{
		    return cmd_area(playerid, "");
		}
	}


	if(dialogid == D_AREA_DELETE)
	{
	    if(response)
	    {
			new aid = strval(inputtext[0]), sid = PlayerData[playerid][CreatingSpawnID], Query[128];
			format(Query, sizeof(Query), "DELETE FROM `areas` WHERE `AreaID` = %d", aid);
	        db_query(General, Query);

			format(Query, sizeof(Query), "DELETE FROM `area_spawns` WHERE `areaid` = %d", aid);
	        db_query(General, Query);

			format(Query, sizeof(Query), "DELETE FROM `area_points` WHERE `areaid` = %d", aid);
	        db_query(General, Query);

			Area[aid][aID] = -1;

			for(new x=0; x<sid; x++)
			{
				RemovePlayerMapIcon(playerid, x);
			}
			GangZoneDestroy(Area[aid][aSampID]);

			SendClientMessage(playerid, -1, "Hardcore DM: Area has been deleted!");
	        return cmd_area(playerid, "");
		}
		else
		{
		    return cmd_area(playerid, "");
		}
	}
	
	if(dialogid == D_SELECT_FIRST_WEAPON)
	{
		if(response)
		{
			PlayerData[playerid][Weapon][0] = strval(inputtext[0]);
			new string[512];			
			strcat(string, "0\tNone\n24\tDeagle\n25\tShotgun\n29\tMP5\n31\tM4\n33\tRifle");
			ShowPlayerDialog(playerid, D_SELECT_SECOND_WEAPON, DIALOG_STYLE_LIST, "Hardcore DM - Weapon Selection (2/4)", string, "Select", "Cancel");
		}
	}

	if(dialogid == D_SELECT_SECOND_WEAPON)
	{
	    if(response)
	    {
	      	PlayerData[playerid][Weapon][1] = strval(inputtext[0]);
			new string[512];
						
			strcat(string, "0\tNone\n24\tDeagle\n25\tShotgun\n29\tMP5\n31\tM4\n33\tRifle");
	        ShowPlayerDialog(playerid, D_SELECT_THIRD_WEAPON, DIALOG_STYLE_LIST, "Hardcore DM - Weapon Selection (3/4)", string, "Select", "Cancel");
		}
	}
	
	if(dialogid == D_SELECT_THIRD_WEAPON)
	{
	    if(response)
	    {
	        PlayerData[playerid][Weapon][2] = strval(inputtext[0]);
			new string[512];
						
			strcat(string, "0\tNone\n24\tDeagle\n25\tShotgun\n29\tMP5\n31\tM4\n33\tRifle");
	        ShowPlayerDialog(playerid, D_SELECT_FOURTH_WEAPON, DIALOG_STYLE_LIST, "Hardcore DM - Weapon Selection (4/4)", string, "Select", "Cancel");
		}
	}

	if(dialogid == D_SELECT_FOURTH_WEAPON)
	{
	    if(response)
	    {
	        PlayerData[playerid][Weapon][3] = strval(inputtext[0]);	        
	        SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: Weapons have been selected, you are now automatically spawned!");	        
	        SpawnPlayer(playerid);
		}
	}
	
	if(dialogid == D_COLORS)
	{
	    if(response)
	    {
	        new gid = PlayerData[playerid][GangID], Query[128];

			Gang[gid][gColor] = GangColors[listitem];
	        foreach(new i : Player)
	            if(IsPlayerConnected(i))
	                if(PlayerData[i][GangID] == gid)
	                    SetPlayerColor(i, Gang[gid][gColor]);

	        format(Query, sizeof(Query), "UPDATE `gangs` SET `gColor` = %d WHERE `gID` = %d", Gang[gid][gColor], gid);
			db_query(General, Query);

			SendClientMessage(playerid, Gang[gid][gColor], "Hardcore DM: Gang color has been changed.");
			return cmd_gang(playerid, "");
		}
		else
		{
		    new gid = PlayerData[playerid][GangID];
		
		    new str[3062];
		    for(new i=190; i<380; i++)
		        format(str, sizeof(str), "%s\n{%06x}%s", str, GangColors[i] >>> 8, Gang[gid][gName]);

			ShowPlayerDialog(playerid, D_COLORS2, DIALOG_STYLE_LIST, "Hardcore DM - Colors (2/3)", str, "Select", "Next");
		}
	}

	if(dialogid == D_COLORS2)
	{
	    if(response)
	    {
	        new gid = PlayerData[playerid][GangID], Query[128];

			Gang[gid][gColor] = GangColors[listitem+190];

	        foreach(new i : Player)
	            if(IsPlayerConnected(i))
	                if(PlayerData[i][GangID] == gid)
	                    SetPlayerColor(i, Gang[gid][gColor]);

	        format(Query, sizeof(Query), "UPDATE `gangs` SET `gColor` = %d WHERE `gID` = %d", Gang[gid][gColor], gid);
			db_query(General, Query);

			SendClientMessage(playerid, Gang[gid][gColor], "Hardcore DM: Gang color has been changed.");
			return cmd_gang(playerid, "");
		}
		else
		{
		    new gid = PlayerData[playerid][GangID];
		    new str[3062];
		    for(new i=380; i<sizeof(GangColors); i++)
		        format(str, sizeof(str), "%s\n{%06x}%s", str, GangColors[i] >>> 8, Gang[gid][gName]);

			ShowPlayerDialog(playerid, D_COLORS3, DIALOG_STYLE_LIST, "Hardcore DM - Colors (3/3)", str, "Select", "Cancel");
		}
	}

	if(dialogid == D_COLORS3)
	{
	    if(response)
	    {
            new gid = PlayerData[playerid][GangID], Query[128];

			Gang[gid][gColor] = GangColors[listitem+380];

	        foreach(new i : Player)
	            if(IsPlayerConnected(i))
	                if(PlayerData[i][GangID] == gid)
	                    SetPlayerColor(i, Gang[gid][gColor]);

	        format(Query, sizeof(Query), "UPDATE `gangs` SET `gColor` = %d WHERE `gID` = %d", Gang[gid][gColor], gid);
			db_query(General, Query);

			SendClientMessage(playerid, Gang[gid][gColor], "Hardcore DM: Gang color has been changed.");
			return cmd_gang(playerid, "");
		}
	}
	
	if(dialogid == D_SOLO2)
	{
	    if(response)
	    {
            new string[128], giveplayerid, cbugstring[20], armorstring[20];
			if(PlayerData[playerid][SoloCBUG] == 1)
			{
				format(cbugstring, sizeof(cbugstring), "ON ");
			}
			else
			{
				format(cbugstring, sizeof(cbugstring), "OFF ");
			}
			
			if(PlayerData[playerid][SoloArmour] == 1)
			{
				format(armorstring, sizeof(cbugstring), "ON ");
			}
			else
			{
				format(armorstring, sizeof(cbugstring), "OFF ");
			}

	    	giveplayerid = PlayerData[playerid][SoloOponnentID];
			format(string, sizeof(string), "%s(id: %d) Invite You for a duel\nCBUG:%s \nArmours:%s", PlayerName(playerid), playerid, cbugstring, armorstring);
			switch(listitem)
			{
			    case 0:
			    {
			        PlayerData[playerid][SoloWeapon] = 24;
	        		new str[128];
					format(str, sizeof(str), "%s \nDesert Eagle", string);
					ShowPlayerDialog(giveplayerid, D_SOLO, DIALOG_STYLE_MSGBOX, "Duel Invite...", str, "Accept", "Decline");

				}
				case 1:
				{
				    PlayerData[playerid][SoloWeapon] = 25;
				    new str[128];
					format(str, sizeof(str), "%s \nShotgun", string);
					ShowPlayerDialog(giveplayerid, D_SOLO, DIALOG_STYLE_MSGBOX, "Duel Invite...", str, "Accept", "Decline");

				}
				case 2:
				{
				    PlayerData[playerid][SoloWeapon] = 26;
				    new str[128];
					format(str, sizeof(str), "%s \nSawn-Off Shotgun", string);
					ShowPlayerDialog(giveplayerid, D_SOLO, DIALOG_STYLE_MSGBOX, "Duel Invite...", str, "Accept", "Decline");

				}
				case 3:
				{
				    PlayerData[playerid][SoloWeapon] = 34;
				    new str[128];
					format(str, sizeof(str), "%s \nSniper Rifle", string);
					ShowPlayerDialog(giveplayerid, D_SOLO, DIALOG_STYLE_MSGBOX, "Duel Invite...", str, "Accept", "Decline");
				}
				case 4:
				{
				    PlayerData[playerid][SoloWeapon] = 33;
				    new str[128];
					format(str, sizeof(str), "%s \nRifle", string);
					ShowPlayerDialog(giveplayerid, D_SOLO, DIALOG_STYLE_MSGBOX, "Duel Invite...", str, "Accept", "Decline");
				}
			}
		}
	}
	
	if(dialogid == D_SOLO)
	{
		if(response)
		{
		    if(PlayerData[PlayerData[playerid][SoloOponnentID]][PlayerInSolo]) return SendClientMessage(playerid, COLOR_RED, "Hardcore DM: This player is already on duel.");
		
      		ResetPlayerWeapons(playerid);
		    ResetPlayerWeapons(PlayerData[playerid][SoloOponnentID]);

			GivePlayerWeapon(PlayerData[playerid][SoloOponnentID], PlayerData[PlayerData[playerid][SoloOponnentID]][SoloWeapon], 5000);
			GivePlayerWeapon(playerid, PlayerData[PlayerData[playerid][SoloOponnentID]][SoloWeapon], 5000);

			PlayerData[playerid][PlayerInSolo] = true;
			PlayerData[PlayerData[playerid][SoloOponnentID]][PlayerInSolo] = true;

			PlayerData[playerid][Points]-= 25;
			PlayerData[PlayerData[playerid][SoloOponnentID]][Points]-= 25;
			PlayerData[playerid][DuelPlayed]++;
			PlayerData[PlayerData[playerid][SoloOponnentID]][DuelPlayed]++;

			SetPlayerHealth(playerid, 100.0);
			SetPlayerHealth(PlayerData[playerid][SoloOponnentID], 100.0);
			
			if(PlayerData[playerid][SoloArmour] == 1 && PlayerData[PlayerData[playerid][SoloOponnentID]][SoloArmour] == 1)
			{
				SetPlayerArmour(playerid, 100.0);
				SetPlayerArmour(PlayerData[playerid][SoloOponnentID], 100.0);
			}
			else
			{
				SetPlayerArmour(playerid, 0.0);
				SetPlayerArmour(PlayerData[playerid][SoloOponnentID], 0.0);
			}
			
			new world = playerid+1000;
			SetPlayerVirtualWorld(playerid, world);
			SetPlayerVirtualWorld(PlayerData[playerid][SoloOponnentID], world);
			
			SetCameraBehindPlayer(playerid);
			SetCameraBehindPlayer(PlayerData[playerid][SoloOponnentID]);

            SetPlayerPos(PlayerData[playerid][SoloOponnentID], 1365.6608,0.3852,1000.9219);
			SetPlayerFacingAngle(PlayerData[playerid][SoloOponnentID], 225.5148);
			SetPlayerInterior(PlayerData[playerid][SoloOponnentID], 1);

			SetPlayerPos(playerid, 1415.6342,-43.2280,1000.9224);
			SetPlayerFacingAngle(playerid, 46.1268);
			SetPlayerInterior(playerid, 1);
			
			SetCameraBehindPlayer(playerid);
			SetCameraBehindPlayer(PlayerData[playerid][SoloOponnentID]);

			SoloCD = 4;

			CountDownSolo(playerid);
			showCountDown(playerid);
			showCountDown(PlayerData[playerid][SoloOponnentID]);
			TogglePlayerControllable(playerid, 0);
			TogglePlayerControllable(PlayerData[playerid][SoloOponnentID], 0);
		}
		else
		{
		    if(PlayerData[PlayerData[playerid][SoloOponnentID]][PlayerInSolo]) return SendClientMessage(playerid, 0xFF0000AA, "Hardcore DM: This player is already on duel!");
		
		    new str[128];
	    	format(str, sizeof(str), "Hardcore DM: Invitation declined", PlayerName(playerid), playerid);
		    SendClientMessage(PlayerData[playerid][SoloOponnentID], COLOR_RED, str);
		    
		    SendClientMessage(playerid, COLOR_RED, "Hardcore DM: Invitation declined");

		    PlayerData[playerid][PlayerInSolo] = false;
			PlayerData[PlayerData[playerid][SoloOponnentID]][PlayerInSolo] = false;
		}
	}
	if(dialogid == D_SOLOCBUG)
	{
		if(response)
		{
		   PlayerData[playerid][SoloCBUG] = 1;
		   PlayerData[PlayerData[playerid][SoloOponnentID]][SoloCBUG] = 1;
		   ShowPlayerDialog(playerid, D_SOLOARMOUR, DIALOG_STYLE_MSGBOX, "Hardcore DM: Duel Armour", "With Armours?", "Yes", "No");
		}
		else
		{
		   PlayerData[playerid][SoloCBUG] = 0;
		   PlayerData[PlayerData[playerid][SoloOponnentID]][SoloCBUG] = 0;
		   ShowPlayerDialog(playerid, D_SOLOARMOUR, DIALOG_STYLE_MSGBOX, "Hardcore DM: Duel Armour", "With Armours?", "Yes", "No");
		}
	}

	if(dialogid == D_SOLOARMOUR)
	{
		if(response)
		{
		   PlayerData[playerid][SoloArmour] = 1;
		   PlayerData[PlayerData[playerid][SoloOponnentID]][SoloArmour] = 1;
		   ShowPlayerDialog(playerid, D_SOLO2, DIALOG_STYLE_LIST, "Hardcore DM: Choose Weapon", "Desert Eagle\nShotgun\nSawn-Off Shotgun\nSniper Rifle\nRifle", "Choose", "Cancel");
		}
		else
		{
		   PlayerData[playerid][SoloArmour] = 0;
		   PlayerData[PlayerData[playerid][SoloOponnentID]][SoloArmour] = 0;
		   ShowPlayerDialog(playerid, D_SOLO2, DIALOG_STYLE_LIST, "Hardcore DM: Choose Weapon", "Desert Eagle\nShotgun\nSawn-Off Shotgun\nSniper Rifle\nRifle", "Choose", "Cancel");
		}
	}
	return 1;
}



public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	if(podkowa == pickupid)
	{
		new string[128];
		PlayerData[playerid][podkowa1] = 1;
		SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You found a Horseshoe! 2x points on kill, and you are visible on map. Good Luck");
		format(string, sizeof(string), "Hardcore DM: %s found a horseshore and he is a lucky guy now. Kill him to get 2x more points.", PlayerName(playerid));
		SendClientMessageToAll(COLOR_AREA, string);
		showHorseshoe(playerid);
		SetPlayerColor(playerid, 0xFF00FFFF);
		DestroyDynamicPickup(podkowa);
		podkowa = 0;
		return 1;
	}	
///
	if(sniperrifle == pickupid)
	{
		new string[128], ammo = minrand(45, 150);
		PlayerData[playerid][sniperdrop] = 1;
		SendClientMessage(playerid, COLOR_GREEN, "Hardcore DM: You found a Sniper! From now u get more points on kill, and you are visible on");
		format(string, sizeof(string), "Hardcore DM: %s found a sniper", PlayerName(playerid));
		SendClientMessageToAll(COLOR_GREEN, string);
		GivePlayerWeapon(playerid, 34, ammo);
		showSniperInfo(playerid);
		RadarFix();
		DestroyDynamicPickup(sniperrifle);
		if(Area[CurrentArea][aSniperTimer] == 1)return 1;
		SniperTimer = SetTimer("SniperCD", 1000, true);
		Area[CurrentArea][aSniperTimer] = 1;
		return 1;
	}
	return 1; 
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    SetPlayerPos(playerid, fX, fY, fZ);
    return 1;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	if(playertextid == HDM_JoinScreenPlay[playerid])
	{
	    CancelSelectTextDraw(playerid);
	
		new Query[128], DBResult: Result;
		format(Query, sizeof(Query), "SELECT `Kills` FROM `players` WHERE `name` = '%s' LIMIT 1", PlayerName(playerid));
		Result = db_query(General, Query);
		
		if(db_num_rows(Result) > 0)
		{
		    format(Query, sizeof(Query), "Welcome back %s to Hardcore DM!\nPlease enter your password below to login!", PlayerName(playerid));
		    ShowPlayerDialog(playerid, D_LOGIN, DIALOG_STYLE_PASSWORD, "Hardcore DM - Login", Query, "Login", "Cancel");
		}
		else
		{
			///ShowPlayerDialog(playerid, D_RULES, DIALOG_STYLE_MSGBOX, "Hardcore DM: Rules", regulamin(), "Ok", "Close");
		}

		
		db_free_result(Result);
	}

	if(playertextid == HDM_JoinScreenExit[playerid])
	{
		new string[512];
		format(string, sizeof(string), "~y~KICKED~w~~n~Did you leave?~n~Are you afraid?~n~Then go away, you don't belong here.");
    	PlayerTextDrawSetString(playerid, HDM_JoinScreenNews[playerid], string);
		showBanScreen(playerid);
		PlayerPlaySound(playerid, 1068, 0, 0, 0);
		hidePlayerHud(playerid);
  		SetTimerEx("DelayedKick", 300, false, "i", playerid);
	}
	return 1;
}
/*
CMD:speckomenda(playerid, cmdtext[])
{
	new gidd, Query[256];
	if(sscanf(cmdtext, "d", gidd)) return SendClientMessage(playerid, COLOR_ERROR, "WPISZ ID GANGU MAX 50");
	for(new i=0; i<areasavilable; i++)
	{
		format(Query, sizeof(Query), "INSERT INTO `area_points` (areaid, gangid, gangpoints) VALUES (%d, %d, 0)", i, gidd);
		db_query(General, Query);
		SendClientMessageToAll(-1, Query);
	}
	return 1;
}*/
CMD:add5points(playerid){

	GangWar[RoundsPlayed] = 5;
	SendClientMessage(playerid, -1, "dodano");
	return 1;
}

stock RadarFix()
{
    foreach(new i : Player)
	{
		foreach(new x : Player)
		{
			if(GangPlayer[i][OnArena] == 1 && GangPlayer[x][OnArena] == 1 && GangWar[GangWarONOFF] == 1)
			{
				if(PlayerData[i][GangID] != PlayerData[x][GangID])
				{
					SetPlayerMarkerForPlayer(x,i, GetPlayerColor(i) & 0xFFFFFF00);
				}
				else
				{
					SetPlayerMarkerForPlayer(x,i,GetPlayerColor(i) | 0x00000055);
				}
			}
			else if(GangPlayer[i][OnArena] == 1 && GangPlayer[x][OnArena] == 0 && GangWar[GangWarONOFF] == 1)
			{
				if(PlayerData[x][GangID] != PlayerData[i][GangID])
				{
					SetPlayerMarkerForPlayer(x,i, GetPlayerColor(i) & 0xFFFFFF00);
				}
				else
				{
					SetPlayerMarkerForPlayer(x,i,GetPlayerColor(i) | 0x00000055);
				}
			}
			//SniperDrop
			if(PlayerData[i][sniperdrop] == 1 && PlayerData[x][sniperdrop] == 0)
			{
				if(PlayerData[i][sniperdrop] == 1)
				{
					SetPlayerMarkerForPlayer(x,i, GetPlayerColor(i) & 0xFFFFFF00);
				}
				else
				{
					SetPlayerMarkerForPlayer(x,i,GetPlayerColor(i) | 0x00000055);
				}
			}
		}
    }
    return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	if(GangPlayer[playerid][OnArena] == 1 && GangPlayer[forplayerid][OnArena] == 1 && GangWar[GangWarONOFF] == 1)
	{
		if(PlayerData[playerid][GangID] != PlayerData[forplayerid][GangID])
		{
			SetPlayerMarkerForPlayer(forplayerid,playerid, GetPlayerColor(playerid) & 0xFFFFFF00);
		}
		else
		{
			SetPlayerMarkerForPlayer(forplayerid,playerid,GetPlayerColor(playerid) | 0x00000055);
		}
	}
	else if(GangPlayer[playerid][OnArena] == 1 && GangPlayer[forplayerid][OnArena] == 0 && GangWar[GangWarONOFF] == 1)
	{
		if(PlayerData[forplayerid][GangID] != PlayerData[playerid][GangID])
		{
			SetPlayerMarkerForPlayer(forplayerid,playerid, GetPlayerColor(playerid) & 0xFFFFFF00);
		}
		else
		{
			SetPlayerMarkerForPlayer(forplayerid,playerid,GetPlayerColor(playerid) | 0x00000055);
		}
	}
	//SniperDrop
	if(PlayerData[playerid][sniperdrop] == 1 && PlayerData[forplayerid][sniperdrop] == 0)
	{
		if(PlayerData[playerid][sniperdrop] == 1)
		{
			SetPlayerMarkerForPlayer(forplayerid,playerid, GetPlayerColor(playerid) & 0xFFFFFF00);
		}
		else
		{
			SetPlayerMarkerForPlayer(forplayerid,playerid, GetPlayerColor(playerid) | 0x00000055);
		}
	}
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	if(GangPlayer[playerid][OnArena] == 1 && GangPlayer[forplayerid][OnArena] == 1 && GangWar[GangWarONOFF] == 1)
	{
		if(PlayerData[playerid][GangID] != PlayerData[forplayerid][GangID])
		{
			SetPlayerMarkerForPlayer(forplayerid,playerid, GetPlayerColor(playerid) & 0xFFFFFF00);
		}
		else
		{
			SetPlayerMarkerForPlayer(forplayerid,playerid,GetPlayerColor(playerid) | 0x00000055);
		}
	}
	else if(GangPlayer[playerid][OnArena] == 1 && GangPlayer[forplayerid][OnArena] == 0 && GangWar[GangWarONOFF] == 1)
	{
		if(PlayerData[forplayerid][GangID] != PlayerData[playerid][GangID])
		{
			SetPlayerMarkerForPlayer(forplayerid,playerid, GetPlayerColor(playerid) & 0xFFFFFF00);
		}
		else
		{
			SetPlayerMarkerForPlayer(forplayerid,playerid,GetPlayerColor(playerid) | 0x00000055);
		}
	}
	//SniperDrop
	if(PlayerData[playerid][sniperdrop] == 1 && PlayerData[forplayerid][sniperdrop] == 0)
	{
		if(PlayerData[playerid][sniperdrop] == 1)
		{
			SetPlayerMarkerForPlayer(forplayerid,playerid, GetPlayerColor(playerid) & 0xFFFFFF00);
		}
		else
		{
			SetPlayerMarkerForPlayer(forplayerid,playerid,GetPlayerColor(playerid) | 0x00000055);
		}
	}
	return 1;
}

public OnPlayerText(playerid, text[])
{
	new string[180];
	
	if(PlayerData[playerid][Muted] == 1)
	{
		SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You are muted!");
		return 0;
	}

	if(text[0] == '@' && IsLevelAdmin(playerid) > 0)
	{
		format(string, sizeof(string), "Admin/Mod Chat:%d'%s: %s", playerid, PlayerName(playerid), text[1]);
		foreach(new i : Player)
		{
			if(IsPlayerConnected(i) && IsLevelAdmin(i) >= 1)
			{
				SendClientMessage(i, COLOR_RED, string);
			}
		}	
		return 0;
	}
	
	if(text[0] == '#')
	{
	    new gid = PlayerData[playerid][GangID];
	    format(string, sizeof(string), "Gang Chat:[%s]%d'%s: %s", Gang[gid][gTag], playerid, PlayerData[playerid][Name], text[1]);
		foreach(new i : Player)
			if(IsPlayerConnected(i) && PlayerData[i][GangID] == gid)
			    SendClientMessage(i, Gang[gid][gColor], string);
		return 0;
	}

	if(IsLevelAdmin(playerid) == 1)
	{
		format(string, sizeof(string), "%d'%s (Moderator): {00D7FF}%s", playerid, PlayerName(playerid), text);
    	SendClientMessageToAll(GetPlayerColor(playerid), string);
		return 0;
	}

	if(IsLevelAdmin(playerid) == 2)
	{
		format(string, sizeof(string), "%d'%s (Admin): {FFFF00}%s", playerid, PlayerName(playerid), text);
    	SendClientMessageToAll(GetPlayerColor(playerid), string);
		return 0;
	}

	if(IsLevelAdmin(playerid) == 3)
	{
		format(string, sizeof(string), "%d'%s (Management): {FF0000}%s", playerid, PlayerName(playerid), text);
    	SendClientMessageToAll(GetPlayerColor(playerid), string);
		return 0;
	} 

	else
	{ 
		format(string, sizeof(string), "%d'%s (Player): {ECECEC}%s", playerid, PlayerName(playerid), text);
    	SendClientMessageToAll(GetPlayerColor(playerid), string);
	}

	return 0;
}


//PlayerCommands

CMD:replace(playerid)
{
	new string[1024];
	for(new i=0; i<CADD_SAVES; i++)
	{
		if(CADDPlayer[i][idgang] > 0)
		{
			format(string, sizeof(string), "%s\n%d. %s - %s", string, i, CADDPlayer[i][nickname], Gang[CADDPlayer[i][idgang]][gName]);
		}
	}
	ShowPlayerDialog(playerid, D_CRASHADDPLAYERSLIST, DIALOG_STYLE_LIST, "Gang War: Crashed players", string, "Ok", "Close");
	return 1;
}

CMD:showfinal(playerid)
{
	PrepareFinalResult();
	showFinalResult(playerid);
	PlayerPlaySound(playerid, 19800, 0, 0, 0);
	SendClientMessage(playerid, COLOR_CORAL, "Pokaz tablica wynikow");
	return 1;
}

CMD:hidefinal(playerid)
{
	PlayerPlaySound(playerid, 0, 0, 0, 0);
	hideFinalResult(playerid);
	SendClientMessage(playerid, COLOR_CORAL, "Ukryj tablica wynikow");
	return 1;
}


CMD:gwgunmenu(playerid)
{
	if(GangPlayer[playerid][GunMenu] == 1) return SendClientMessage(playerid, COLOR_PINK, "Gang War: You had a chance to change weapons");
	ShowGWWeaponMenu(playerid);
	GangPlayer[playerid][GunMenu] = 1;
	return 1;
}

CMD:gangwar(playerid, cmdtext[])
{
	if(GangWar[GangWarONOFF] == 1) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: Gang War is on");
	if(PlayerData[playerid][GangID] == 0) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You're not in gang");
	if(PlayerData[playerid][Name] != Gang[PlayerData[playerid][GangID]][gOwner]) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You are not a gang owner");
	GangWar[GANG1ID] = PlayerData[playerid][GangID];
	ChallengeGang(playerid);
	return 1;
}

CMD:joinwar(playerid, cmdtext[])
{
	new string[512];
	if(GangWar[GangWarONOFF] == 1)
	{
		if(PlayerData[playerid][GangID] == GangWar[GANG1ID] && GangPlayer[playerid][ReadyGW] == 0)
		{
			format(string, sizeof(string), "Hardcored DM: Joined Gang War [%s]", Gang[GangWar[GANG1ID]][gName]);
			SendClientMessage(playerid, COLOR_PINK, string);
			GangWar[Gang1Players]++;
			GangPlayer[playerid][ReadyGW] = 1;
		}
		else if(PlayerData[playerid][GangID] == GangWar[GANG1ID] && GangPlayer[playerid][ReadyGW] == 1)
		{
			format(string, sizeof(string), "Hardcored DM: Leaved Gang War [%s]", Gang[GangWar[GANG1ID]][gName]);
			SendClientMessage(playerid, COLOR_PINK, string);
			GangWar[Gang1Players]--;
			GangPlayer[playerid][ReadyGW] = 0;
		}
		
		if(PlayerData[playerid][GangID] == GangWar[GANG2ID])
		{
			format(string, sizeof(string), "Hardcored DM: Joined Gang War [%s]", Gang[GangWar[GANG2ID]][gName]);
			SendClientMessage(playerid, COLOR_PINK, string);
			GangWar[Gang2Players]++;
			GangPlayer[playerid][ReadyGW] = 1;
		}
		else if(PlayerData[playerid][GangID] == GangWar[GANG2ID] && GangPlayer[playerid][ReadyGW] == 1)
		{
			format(string, sizeof(string), "Hardcored DM: Leaved Gang War [%s]", Gang[GangWar[GANG2ID]][gName]);
			SendClientMessage(playerid, COLOR_PINK, string);
			GangWar[Gang2Players]--;
			GangPlayer[playerid][ReadyGW] = 0;
		}
		GangPlayer[playerid][ArenaDMG] = 0;
		GangPlayer[playerid][ArenaKills] = 0;
		GangPlayer[playerid][TotalDMG] = 0.0;
		GangPlayer[playerid][Kills] = 0;
		GangPlayer[playerid][Deaths] = 0;
	}
	else return SendClientMessage(playerid, COLOR_PINK, "Hardcore DM: You're not a member of warring gangs");
	return 1;
}

CMD:help(playerid)
{
	ShowPlayerDialog(playerid, D_HELP, DIALOG_STYLE_MSGBOX, "Hardcore DM: Help", help(), "Ok", "Close");		
	return 1;
}

CMD:sync(playerid)
{
	if(PlayerData[playerid][onede] == 1 || PlayerData[playerid][afk] == 1 || PlayerData[playerid][sawn] == 1) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You can't do this");
	SyncPlayer2(playerid);
	return 1;
}

CMD:cmd(playerid)
{
	ShowPlayerDialog(playerid, D_CMD, DIALOG_STYLE_MSGBOX, "Hardcore DM: Help", komendy(), "Ok", "Close");
	return 1;
}

CMD:sniper(playerid)
{
	if(Area[CurrentArea][aSniperdrop] == 1) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: Sniper Drop is already on");
	Sniperdrop();
	return 1;
}

CMD:afk(playerid, cmdtext[])
{
	new string[500], sid = random(MAX_SPAWNS);
	if(PlayerData[playerid][onede] == 1 || PlayerData[playerid][sawn] == 1) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: Leave arena /onede or /sawn");
	if(PlayerData[playerid][afk] == 0)
	{
		SetPlayerInterior(playerid, 2);
		SetPlayerVirtualWorld(playerid, playerid+13);
		SetPlayerPos(playerid, 1204.66,-13.54,1000.92);
		PlayerData[playerid][afk] = 1;
		PlayAudioStreamForPlayer(playerid, "https://ia800201.us.archive.org/17/items/GtaIvTbogtPauseMenuSongMp3DownloadFree/Gta%20Iv%20Tbogt%20Pause%20Menu%20Song%20Mp3%20Download%20Free.mp3");
		ResetPlayerWeapons(playerid);
		SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You're away from keyboard. Use /afk for back to area.");
		
		if(PlayerData[playerid][sniperdrop] == 1)
		{
			SendClientMessageToAll(COLOR_GREEN, "Hardcore DM: Player with sniper is on /onede. New Sniper Drop starting...");
			DestroySniperDrop();
			Sniperdrop();
		}		
		if(PlayerData[playerid][podkowa1] == 1)
		{
			format(string, sizeof(string), "Hardcore DM: %s went to afk. His horseshoe was destroyed.", PlayerName(playerid));
			SendClientMessageToAll(COLOR_AREA, string);
			PlayerData[playerid][podkowa1] = 0;
			Area[CurrentArea][aHorseshoe] = 0;
			PlayerData[playerid][WeaponChange] = 0;
			hideHorseshoe(playerid);
			SetTimer("Horseshoe", 25000, false);
			format(string, sizeof(string), "Hardcore DM: Horseshoe will show up in few seconds!");
			SendClientMessageToAll(COLOR_AREA, string);
		}
	}
	else if(PlayerData[playerid][afk] == 1)
	{
		
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid,  Spawn[CurrentArea][sid][sPos][0], Spawn[CurrentArea][sid][sPos][1], Spawn[CurrentArea][sid][sPos][2]);
		PlayerData[playerid][afk] = 0;
		StopAudioStreamForPlayer(playerid);
		SetPlayerHealth(playerid, 9999);
		if(PlayerData[playerid][Weapon][0] == -1 && PlayerData[playerid][Weapon][1] == -1 && PlayerData[playerid][Weapon][2] == -1 && PlayerData[playerid][Weapon][3] == -1)
		{
		new stringz[512];
		strcat(stringz, "0\tNone\n24\tDeagle\n25\tShotgun\n29\tMP5\n31\tM4\n33\tRifle");
		ShowPlayerDialog(playerid, D_SELECT_FIRST_WEAPON, DIALOG_STYLE_LIST, "Hardcore DM - Weapon Selection (1/4)", stringz, "Select", "Cancel");
		}
		SetTimerEx("SpawnProtection", 2000, false, "i", playerid);
		SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You're back on the area.");
	}
	return 1;
}


CMD:duel(playerid, cmdtext[])
{
	new id;
	if(PlayerData[playerid][onede] == 1 || PlayerData[playerid][afk] == 1 || PlayerData[playerid][sawn] == 1) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You can't do this");
	if(PlayerData[playerid][Points] <= 25) return SendClientMessage(playerid, COLOR_ERROR, "Hardcore DM: You don't have enough points (25)!");
	if(PlayerData[playerid][PlayerInSolo]) return SendClientMessage(playerid, COLOR_ERROR, "Hardcore DM: You are already on duel!");
	if(sscanf(cmdtext, "u", id)) return SendClientMessage(playerid, COLOR_ERROR, "Hardcore DM: Use /duel id");
	if(PlayerData[id][Points] <= 25) return SendClientMessage(playerid, COLOR_ERROR, "Hardcore DM: This player don't have enough points (25)!");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_ERROR, "Hardcore DM: This player isn't connected.");
	if(PlayerData[id][afk]) return SendClientMessage(playerid, COLOR_ERROR, "Hardcore DM: This player is on AFK.");
	if(PlayerData[id][onede]) return SendClientMessage(playerid, COLOR_ERROR, "Hardcore DM: This player is on /onede.");
	if(PlayerData[id][PlayerInSolo]) return SendClientMessage(playerid, COLOR_ERROR, "Hardcore DM: This player is on duel.");
	if(id == playerid) return SendClientMessage(playerid, COLOR_ERROR, "Hardcore DM: You can not invite urself.");

	PlayerData[id][SoloOponnentID] = playerid;
	PlayerData[playerid][SoloOponnentID] = id;
	ShowPlayerDialog(playerid, D_SOLOCBUG, DIALOG_STYLE_MSGBOX, "Hardcore DM: Duel CBUG", " With CBUG?", "Yes", "No");
	return 1;
}

CMD:respawn(playerid, cmdtext[])
{
	new Float: Health;
	if(PlayerData[playerid][onede] == 1 || PlayerData[playerid][afk] == 1 || PlayerData[playerid][sawn] == 1) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You can't do this");
	if(PlayerData[playerid][Respawn] == 1) return SendClientMessage(playerid, COLOR_ERROR, "Hardcore DM: You need to wait.");
	if(PlayerData[playerid][syncing] == 0)
	{
		GetPlayerHealth(playerid, Health);
		if(Health < 90) return SendClientMessage(playerid, COLOR_ERROR, "Hardcore DM: You have less than 90HP, you can't do it.");
		SpawnPlayer(playerid);
		SetPlayerHealth(playerid, 100);
		PlayerData[playerid][Respawn] = 1;
	}
	return 1;
}

CMD:gunmenu(playerid, cmdtext[])
{
	new string[512], sniperstring[256];
	if(PlayerData[playerid][onede] == 1 || PlayerData[playerid][afk] == 1 || PlayerData[playerid][sawn] == 1 || PlayerData[playerid][inGWAR] == 1) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You can't do this");
	if(PlayerData[playerid][WeaponChange] == 0)
	{
		strcat(string, "0\tNone\n24\tDeagle\n25\tShotgun\n29\tMP5\n31\tM4\n33\tRifle");
		ShowPlayerDialog(playerid, D_SELECT_FIRST_WEAPON, DIALOG_STYLE_LIST, "Hardcore DM - Weapon Selection (1/4)", string, "Select", "Cancel");
		if(PlayerData[playerid][sniperdrop] == 1)
		{
			format(sniperstring, sizeof(sniperstring), "Sniper Drop: %s'%d Used a weapon change. New Sniper Drop starting...");
			SendClientMessageToAll(COLOR_GREEN, sniperstring);
			DestroySniperDrop();
			Sniperdrop();
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_INFO,"Hardcore DM: You have already taken the chance to change weapons.");
	}
	return 1;
}

CMD:w(playerid, cmdtext[])
{
	cmd_weather(playerid, cmdtext);
	return 1;
}

CMD:t(playerid, cmdtext[])
{
	cmd_time(playerid, cmdtext);
	return 1;
}


CMD:weather(playerid,cmdtext[])
{
    if(isnull(cmdtext)) return SendClientMessage(playerid, COLOR_INFO,"Hardcore DM: Use /weather [ID 0 - 21]");
	new weather, string[60];
	weather = strval(cmdtext);
	if(weather < 0 || weather > 255) return SendClientMessage(playerid, COLOR_ERROR, "ERROR: Invalid weather ID.");
	PlayerData[playerid][Weather] = weather;
	SetPlayerWeather(playerid, weather);
    format(string, sizeof(string), "Hardcore DM: You set the weather to %d", weather);
    SendClientMessage(playerid, COLOR_INFO, string);
    return 1;
}

CMD:time(playerid,cmdtext[])
{
    if(isnull(cmdtext)) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: Use /time [Time 0 - 23]");
	new time, string[60];
	time = strval(cmdtext);
	if(time < 0 || time > 23) return SendClientMessage(playerid, COLOR_ERROR, "ERROR: Invalid time.");
	PlayerData[playerid][SetTime] = time;
	SetPlayerTime(playerid, time, 0);
    format(string, sizeof(string), "Hardcore DM: You set the time to %d", time);
    SendClientMessage(playerid, COLOR_INFO, string);
    return 1;
}

CMD:pm(playerid, cmdtext[])
{
    new PM, Message[256], String[256], PmSent[256];
    if(sscanf(cmdtext, "us[140]", PM, Message)) return SendClientMessage(playerid, COLOR_INFO, "Use: /pm [Player ID] [Message]");
    if(!IsPlayerConnected(PM)) return SendClientMessage(playerid, COLOR_ERROR, "ERROR: That player isn't connected.");
    if(PM == playerid) return SendClientMessage(playerid, COLOR_ERROR, "ERROR: You can't PM urself.");
    if(strlen(Message) < 2) return SendClientMessage(playerid, COLOR_ERROR, "ERROR: You've got to type more than 1 letter.");

	format(PmSent, sizeof(PmSent), "Hardcore DM: PM sent to %d'%s: %s", PM, PlayerName(PM), Message);
	SendClientMessage(playerid, COLOR_INFO, PmSent);
	format(String, sizeof(String), "Hardcore DM:[PM] %d'%s: %s", playerid, PlayerName(playerid), Message);
	SendClientMessage(PM, COLOR_PM, String);
	PlayerPlaySound(PM, 5202, 0, 0, 0);

	format(String, sizeof(String), "Hardcore PMEye: %d'%s to %d'%s sent: %s", playerid, PlayerName(playerid), PM, PlayerName(PM), Message);
	foreach(new i : Player)
		if(IsPlayerConnected(i) && IsLevelAdmin(i) > 0 && i != playerid && i != PM) return SendClientMessage(i, COLOR_PM, String);
    return 1;
}

CMD:skin(playerid, cmdtext[])
{
	new skinid, string[128], Query[512];
	skinid = strval(cmdtext);
	if(skinid < 5 || skinid > 311 && skinid == 74) return SendClientMessage(playerid, COLOR_ERROR, "ERROR: Invalid skin ID.");
	if(sscanf(cmdtext, "d", skinid)) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: Use /skin [Skin ID]");

	format(Query, sizeof(Query), "UPDATE `players` SET `skinID` = %d WHERE `name` = '%s'", skinid, PlayerName(playerid));
	db_query(General, Query);
	PlayerData[playerid][skinID] = skinid;
	SetPlayerSkin(playerid, skinid);
	format(string, sizeof(string), "Hardcore DM: Skin changed to ID:%d", skinid);
	SendClientMessage(playerid, COLOR_INFO, string);
	return 1;
}

CMD:stats(playerid, cmdtext[])
{
    new ID, stringtitle[60], stringdata[1024];

	if(sscanf(cmdtext, "d", ID)) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: Use /stats Player ID");
    if(!IsPlayerConnected(ID)) return SendClientMessage(playerid, COLOR_ERROR, "ERROR: That player isn't conected.");
	format(stringtitle, sizeof(stringtitle), "Stats of %s:", PlayerName(ID));
	format(stringdata, sizeof(stringdata), "Session Stats:\nKills: %d Deaths: %d KDA: %.2f Damage: %.0f Points: %d \n\nGenetal Stats:\nKills: %d Deaths: %d KDA: %.2f Total Damage: %.0f Points: %d\n\nDuels:\nPlayed:%d Win:%d\nGang: %s [ID:%d]",  
	SessionPlayerData[ID][Kills], SessionPlayerData[ID][Deaths], floatdiv(SessionPlayerData[ID][Kills], SessionPlayerData[ID][Deaths] == 0 ? 1 : SessionPlayerData[ID][Deaths]), SessionPlayerData[ID][Damage], SessionPlayerData[ID][Points],
	PlayerData[ID][Kills], PlayerData[ID][Deaths], floatdiv(PlayerData[ID][Kills], PlayerData[ID][Deaths] == 0 ? 1 : PlayerData[ID][Deaths]), PlayerData[ID][Damage], PlayerData[ID][Points], PlayerData[ID][DuelPlayed], PlayerData[ID][DuelWins], Gang[PlayerData[ID][GangID]][gName], PlayerData[ID][GangID]);

	ShowPlayerDialog(playerid, D_PLAYERSTATS, DIALOG_STYLE_MSGBOX, stringtitle, stringdata, "OK", "");

	return 1;
}

CMD:report(playerid, cmdtext[])
{

	new ID, reason[32], string[512];
	
	if(sscanf(cmdtext,"us[20]", ID, reason)) return SendClientMessage(playerid, COLOR_INFO, "USE: /report playerid reason");
	format(string, sizeof(string), "Hardcore DM: You reported %s to administration.", PlayerName(ID));
	SendClientMessage(playerid, COLOR_INFO, string);
	UpdateReport(playerid, ID, reason);
	foreach(new i : Player)
	{
		if(IsPlayerConnected(i) && IsLevelAdmin(i) > 0)
		{
		format(string, sizeof(string), "Hardcore DM: New Report to check!");
		SendClientMessage(i, COLOR_ORANGERED, string);
		PlayerPlaySound(i, 4203, 0,0,0);
		}
	}
	return 1;
}

CMD:onede(playerid, cmdtext[])
{
	if(PlayerData[playerid][sawn] == 1 || PlayerData[playerid][afk] == 1) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You can't do this");
	new string[256], spawn = random(sizeof(RandomSpawnOneDe));
	if(PlayerData[playerid][onede] == 1)
	{
		PlayerData[playerid][onede] = 0;
		SetPlayerInterior(playerid, 0);
		hideArenaInfo(playerid);
		SetPlayerVirtualWorld(playerid, 0);
		SpawnPlayer(playerid);

	}
	else if(PlayerData[playerid][onede] == 0)
	{
		
		if(PlayerData[playerid][sniperdrop] == 1)
		{
			SendClientMessageToAll(COLOR_GREEN, "Hardcore DM: Player with sniper is on /onede. New Sniper Drop starting...");
			DestroySniperDrop();
			Sniperdrop();
		}

		ResetPlayerWeapons(playerid);
		SetPlayerPos(playerid, RandomSpawnOneDe[spawn][0],RandomSpawnOneDe[spawn][1],RandomSpawnOneDe[spawn][2]);
		SetPlayerFacingAngle(playerid, RandomSpawnOneDe[spawn][3]);
		SetPlayerInterior(playerid, 3);
		SetPlayerVirtualWorld(playerid, 69);
		SetPlayerHealth(playerid, 33.0);
		GivePlayerWeapon(playerid, 24, 1000);
		PlayerData[playerid][onede] = 1;
		format(string, sizeof(string), "Hardcore DM: %s joined /onede", PlayerName(playerid));
		SendClientMessageToAll(COLOR_INFO, string);
		SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: Joined /onede. To leave use again /onede");
		hideGangControl(playerid);
		hideArenaInfo(playerid);
		showArenaInfo(playerid);

	}

	return 1;
}

CMD:sawn(playerid, cmdtext[])
{
	if(PlayerData[playerid][onede] == 1 || PlayerData[playerid][afk] == 1) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You can't do this");
	new string[256], SawnZone,spawn = random(sizeof(RandomSpawnSawn));
	if(PlayerData[playerid][sawn] == 1)
	{
		PlayerData[playerid][sawn] = 0;
		SetPlayerInterior(playerid, 0);
		SpawnPlayer(playerid);
		SetPlayerArmour(playerid, 0.0);
		hideArenaInfo(playerid);
		GangZoneDestroy(SawnZone);
		SetPlayerVirtualWorld(playerid, 0);
	}
	else if(PlayerData[playerid][sawn] == 0)
	{	
		if(PlayerData[playerid][sniperdrop] == 1)
		{
			SendClientMessageToAll(COLOR_GREEN, "Hardcore DM: Player with sniper is on /onede. New Sniper Drop starting...");
			DestroySniperDrop();
			Sniperdrop();
		}
	
		PlayerData[playerid][sawn] = 1;
		SetPlayerVirtualWorld(playerid, 72);
		ResetPlayerWeapons(playerid);
		SetPlayerPos(playerid, RandomSpawnSawn[spawn][0],RandomSpawnSawn[spawn][1],RandomSpawnSawn[spawn][2]);
		SetPlayerFacingAngle(playerid, RandomSpawnSawn[spawn][3]);
		GivePlayerWeapon(playerid, 26, 1000);
		SetPlayerHealth(playerid, 100.0);
		SetPlayerArmour(playerid, 100.0);
		SetPlayerVirtualWorld(playerid, 23);
		format(string, sizeof(string), "Hardcore DM: %s joined /sawn", PlayerName(playerid));
		SendClientMessageToAll(COLOR_INFO, string);
		SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: Joined /sawn. To leave use again /sawn");
		hideGangControl(playerid);
		hideArenaInfo(playerid);
		showArenaInfo(playerid);
		for(new i = 0; i<MAX_AREAS; i++)
		{
			GangZoneHideForPlayer(playerid, i);
		}
		SawnZone = GangZoneCreate(-1309.0546875, -267.4765625, -1136.0546875, -80.4765625);
		GangZoneShowForPlayer(playerid, SawnZone, 0xFBCC007D);
		GangZoneStopFlashForPlayer(playerid, SawnZone);
		GangZoneFlashForPlayer(playerid, SawnZone, 0xFFFFFF00);
	}

	return 1;
}

CMD:spec(playerid, cmdtext[])
{
	new id;
	if(PlayerData[playerid][onede] == 1 || PlayerData[playerid][sawn] == 1) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You can't do this");
	if(sscanf(cmdtext, "i", id)) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: Use /spec id");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: This player isn't conetcted");
	if(playerid == id) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You can't spec yourself.");
	SetTimerEx("SpecPlayerInfo", 1000, true, "i", id);
	TogglePlayerSpectating(playerid, 1);
	PlayerSpectatePlayer(playerid, id);
	SetPlayerInterior(playerid,GetPlayerInterior(id));
	showSpecPlayerInfo(playerid);
	PlayerData[playerid][Spec] = id;
	return 1;
}


CMD:specoff(playerid, cmdtext[])
{
	if(PlayerData[playerid][onede] == 1 || PlayerData[playerid][sawn] == 1) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You can't do this");
    TogglePlayerSpectating(playerid, 0);
	hideSpecPlayerInfo(playerid);
	SpawnPlayer(playerid);
	PlayerData[playerid][Spec] = -1;
	return 1;
}
//PlayerCommands END

//ModeratorCommands

CMD:tp(playerid, cmdtext[])
{
	new ID, ID2, string[128], Float: Position[3], interior, vw;
	if(IsLevelAdmin(playerid) < 1) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You're too small for this.");
    if(sscanf(cmdtext, "dd", ID, ID2)) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: Use /tp Player ID to Player ID");
    if(!IsPlayerConnected(ID) || !IsPlayerConnected(ID2)) return SendClientMessage(playerid, COLOR_ERROR, "ERROR: That player isn't conected.");

	GetPlayerPos(ID2, Position[0], Position[1], Position[2]);
	interior = GetPlayerInterior(ID2);
	vw = GetPlayerVirtualWorld(ID2);

	SetPlayerInterior(ID, interior);
	SetPlayerVirtualWorld(ID, vw);
	SetPlayerPos(ID, Position[0]+1, Position[1]+1, Position[2]);

	format(string, sizeof(string), "Hardcore DM: Moved %s to %s", PlayerName(ID), PlayerName(ID2));
	SendClientMessage(playerid, COLOR_INFO, string); 
	format(string, sizeof(string), "Hardcore DM: Admin has moved %s to you", PlayerName(ID));
	SendClientMessage(ID2, COLOR_INFO, string);
	format(string, sizeof(string), "Hardcore DM: You has been moved to %s", PlayerName(ID2));
	SendClientMessage(ID, COLOR_INFO, string);
	return 1;
}

CMD:lastip(playerid)
{
	if(IsLevelAdmin(playerid) < 1) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You're too small for this.");
	ShowPlayerDialog(playerid, D_LASTIP, DIALOG_STYLE_MSGBOX, "Hardcore DM: Last IP's", showlastip(), "OK", "");
	return 1;
}

CMD:pinfo(playerid, cmdtext[])
{
	new id;
	if(IsLevelAdmin(playerid) < 1) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You're too small for this.");
	if(sscanf(cmdtext, "i", id)) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: Use /pinfo id");
	ShowPlayerDialog(playerid, D_PINFO, DIALOG_STYLE_MSGBOX, "Hardcore DM: Player Info", pinfo(id), "OK", "");
	return 1;
}

CMD:endgangwar(playerid, cmdtext[])
{
	EndGangWar();
	return 1;
}


CMD:moviemode(playerid)
{
	if(IsLevelAdmin(playerid) < 1) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You're too small for this.");
	if(PlayerData[playerid][moviemode] == 1)
	{
		showPlayerHud(playerid);
		showGangControl(playerid);
		showReports(playerid);
		EnableHealthBarForPlayer(playerid, true);
		PlayerData[playerid][moviemode] = 0;
		SpawnPlayer(playerid);
	}
	else if(PlayerData[playerid][moviemode] == 0)
	{
		hidePlayerHud(playerid);
		hideGangControl(playerid);
		hideArenaInfo(playerid);
		hideReports(playerid);
		EnableHealthBarForPlayer(playerid, false);
		SetPlayerColor(playerid, 0xFFFFFF00);
		SetPlayerHealth(playerid, 99999999.9);
		PlayerData[playerid][moviemode] = 1;
	}
	
	return 1; 
}


CMD:startarea(playerid, cmdtext[])
{
	if(PlayerData[playerid][onede] == 1 || PlayerData[playerid][sawn] == 1 || PlayerData[playerid][inGWAR] == 1) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You can't do this");
	if(IsLevelAdmin(playerid) < 1) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You're too small for this.");
	ListAreas(playerid);
	return 1;
}

CMD:jetpack(playerid, cmdtext){

	if(IsLevelAdmin(playerid) < 1) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You're too small for this.");
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
	SendClientMessage(playerid, COLOR_AQUA, "JETPACK");
	return 1;
}

CMD:horseshoe(playerid, cmdtext[])
{
	if(IsLevelAdmin(playerid) < 1) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You're too small for this.");
	if(Area[CurrentArea][aHorseshoe] == 1) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: Horseshoe is already on area.");
	Horseshoe();
	return 1;
}

CMD:ann(playerid, cmdtext[])
{
	new string[512], msg[60];
	KillTimer(hideAnnounceTD());
	if(IsLevelAdmin(playerid) < 1) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You're too small for this.");
	if(sscanf(cmdtext, "s[60]", msg)) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: Use /ann text");
	format(string, sizeof(string), "Announce:~n~%s", msg);
	TextDrawSetString(HDM_AnnTXT, string);
	format(string, sizeof(string), "%s", PlayerName(playerid));
	TextDrawSetString(HDM_AnnAutor, string);
	showAnnounce();
	SetTimer("hideAnnounceTD", 8000, false);
	return 1;
}


CMD:kick(playerid, cmdtext[])
{
    new ID, reason[35], string[512];
    if(IsLevelAdmin(playerid) < 1) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You're too small for this.");
    if(sscanf(cmdtext, "us[35]", ID, reason)) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: Use /kick id reason");
    if(!IsPlayerConnected(ID)) return SendClientMessage(playerid, COLOR_ERROR, "ERROR: That player isn't conected.");
    if(strlen(reason) < 3) return SendClientMessage(playerid, COLOR_ERROR, "ERROR: You've got to type more than 1 letter.");
  
  	format(string, sizeof(string), "Hardcore DM: You've been ~y~KICKED~w~ for %s by %s", reason, PlayerData[playerid][Name]);
	hidePlayerHud(ID);
	hideArenaInfo(ID);
	PlayerPlaySound(ID, 1068, 0, 0, 0);
	format(string, sizeof(string), "~y~KICKED~w~ for %s.~n~~n~ Enough of that! ~n~~n~You've been ~y~KICKED~w~ out, and that means something has gone wrong or you're behaving incorrectly.", reason);
	PlayerTextDrawSetString(ID, HDM_JoinScreenNews[ID], string);
	showBanScreen(ID);
	SetTimerEx("DelayedKick", 300, false, "i", ID);
	TogglePlayerControllable(ID, 0);
	ClearPlayerChat(ID);
	if(IsPlayerAdmin(playerid) == 6)
	{
		format(string, sizeof(string), "Hardcore DM: %s [ID:%d] has been kicked for %s by Server", PlayerName(ID), ID, reason);
	}
	else
	{
		format(string, sizeof(string), "Hardcore DM: %s [ID:%d] has been kicked for %s by %s [ID:%d]", PlayerName(ID), ID, reason, PlayerName(playerid), playerid);
	}
	SendClientMessageToAll(COLOR_REALRED, string);
    return 1;
}

CMD:mute(playerid, cmdtext[])
{
	new ID, minutes, reason[128], string[128];

	if(IsLevelAdmin(playerid) < 1) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You are too small for this.");
	if(sscanf(cmdtext,"uds", ID, minutes, reason)) return SendClientMessage(playerid, COLOR_INFO, "USE: /mute playerid time reason");
	if(!IsPlayerConnected(ID)) return SendClientMessage(playerid, COLOR_ERROR, "ERROR: That player isn't conected.");
	if(PlayerData[playerid][Muted] == 1) return SendClientMessage(playerid, COLOR_ERROR, "ERROR: That player is muted.");
	if(minutes < 1 || minutes > 10) return SendClientMessage(playerid, COLOR_INFO,"Hardcore DM: Invalid time use 1-10.");
	if(IsLevelAdmin(ID) > 0) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You can not mute the admin!");

	format(string, sizeof(string), "Hardcore DM: You have been muted for: %s for %d minutes.", reason, minutes);
	SendClientMessage(ID, COLOR_INFO, string);
	format(string, sizeof(string), "Hardcore DM: You muted %s for %s for %d.", PlayerName(ID), reason, minutes);
	SendClientMessage(playerid, COLOR_INFO, string);
	format(string, sizeof(string), "Hardcore DM: %s has been muted for %s for %d.", PlayerName(ID), reason, minutes);
	SendClientMessageToAll(COLOR_INFO, string);

	SetTimerEx("Unmute", minutes*60000, false, "i", ID);
	PlayerData[ID][Muted] = 1;

	return 1;
}

CMD:unmute(playerid, cmdtext[])
{
	new ID, string[128];
	if(IsLevelAdmin(playerid) < 1) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You are too small for this.");
	if(sscanf(cmdtext,"u", ID)) return SendClientMessage(playerid, COLOR_INFO, "USE: /unmute playerid");
	if(!IsPlayerConnected(ID)) return SendClientMessage(playerid, COLOR_ERROR, "ERROR: That player isn't conected.");
	if(IsLevelAdmin(ID) > 0) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You can not do this!");

	format(string, sizeof(string), "Hardcore DM: You have been unmuted");
	SendClientMessage(ID, COLOR_INFO, string);
	format(string, sizeof(string), "Hardcore DM: You unmuted %s.", PlayerName(ID));
	SendClientMessage(playerid, COLOR_INFO, string);
	format(string, sizeof(string), "Hardcore DM: %s has been unmuted.", PlayerName(ID));
	SendClientMessageToAll(COLOR_INFO, string);
    
	PlayerData[ID][Muted] = 0;

	return 1; 
}

CMD:tpto(playerid, cmdtext[])
{
	new ID, string[128], Float: Position[3], interior, vw;
	if(IsLevelAdmin(playerid) < 1) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You're too small for this.");
    if(sscanf(cmdtext, "d", ID)) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: Use /tpto Player ID");
    if(!IsPlayerConnected(ID)) return SendClientMessage(playerid, COLOR_ERROR, "ERROR: That player isn't conected.");

	GetPlayerPos(ID, Position[0], Position[1], Position[2]);
	interior = GetPlayerInterior(ID);
	vw = GetPlayerVirtualWorld(ID);

	SetPlayerInterior(playerid, interior);
	SetPlayerVirtualWorld(playerid, vw);
	SetPlayerPos(playerid, Position[0]+1, Position[1]+1, Position[2]);

	format(string, sizeof(string), "Hardcore DM: You moved to %s", PlayerName(ID));
	SendClientMessage(playerid, COLOR_INFO, string); 
	format(string, sizeof(string), "Hardcore DM: Admin %s has moved to you", PlayerName(playerid));
	SendClientMessage(ID, COLOR_INFO, string);
	return 1;
}


//ModeratorCommands END

//AdminCommands

CMD:gang(playerid, cmdtext[])
{
    new gid = PlayerData[playerid][GangID], string[1024], strings[1024], Query[128], ingame = 0, DBResult: Result, name[24];

    strcat(string, "0\tCreate new gang\n1\tInvite player to your gang\n2\tRemove player from your gang\n3\tChange gang color\n4\tChange gang skin\n5\tLeave gang");
	if(IsLevelAdmin(playerid) > 1) strcat(string, "\n{FF0000}6\tDelete gang (only admins)\n{FF0000}7\tRemove player from gang (only admins)\n{FF0000}8\tChange gang name (only admins)\n{FF0000}9\tChange gang tag (only admins)\n{FF0000}10\tChange maximum players limit\n");
    //if(!strcmp(Gang[gid][gOwner], PlayerName(playerid)))


	strcat(string, "\n-----------------------\n");

    if(gid != 0)
	{
    	format(Query, sizeof(Query), "SELECT `name`,`ingame` FROM `players` WHERE `gangID` = %d", gid);
    	Result = db_query(General, Query);

    	for(new i=0; i<db_num_rows(Result); i++)
    	{
    		db_get_field_assoc(Result, "name", name, sizeof(name));
    		ingame = db_get_field_assoc_int(Result, "ingame");
			if(ingame == 1) format(strings, sizeof(strings), "%s\n{FFFFFF}%s {00FF00}(online)", strings, name);
			else format(strings, sizeof(strings), "%s\n{FFFFFF}%s {FF0000}(offline)", strings, name);
			db_next_row(Result);
		} 
		db_free_result(Result);
	}

	strcat(string, strings);
	ShowPlayerDialog(playerid, D_GANG, DIALOG_STYLE_LIST, "Hardcore DM - Gang settings", string, "Select", "Cancel");
	return 1;
}

CMD:ban(playerid, cmdtext[])
{
    new ID, option, reason[35], string[300], hours, minutes, year, month, day, stringdata[20];
    if(IsLevelAdmin(playerid) < 2) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You're too small for this.");
    if(sscanf(cmdtext, "dds[35]", option, ID, reason)) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: Use /ban option[0/1] id reason \nOption can only be 0 or 1, 0 bans IP, 1 bans the account!");
    if(!IsPlayerConnected(ID)) return SendClientMessage(playerid, COLOR_ERROR, "ERROR: That player isn't conected.");
    if(strlen(reason) < 3) return SendClientMessage(playerid, COLOR_ERROR, "ERROR: You've got to type more than 1 letter.");
	if(option > 1 || option < 0) return SendClientMessage(playerid, COLOR_ERROR, "ERROR: Option can only be 0 or 1, 0 bans IP, 1 bans the account!");

	format(string, sizeof(string), "Hardcore DM: You've been banned for %s by %s", reason, PlayerData[playerid][Name]);
   	showBanScreen(ID);
	PlayerPlaySound(ID, 1068, 0, 0, 0);
    hidePlayerHud(ID);
	hideArenaInfo(ID);
    format(string, sizeof(string), "~r~BANNED~w~ for %s~n~~n~Enough for that!~n~~n~ You've been banned, and that means you're stupid and you don't follow the rules.~n~~n~You can appeal this ban by writing a request on our discord server.", reason);
    PlayerTextDrawSetString(ID, HDM_JoinScreenNews[ID], string);
	SendClientMessage(ID, COLOR_REALRED, "Hardcore DM: You can appeal this ban by writing a request on our discord server: discord.gg/pbZ9GFvutE");	
    
	gettime(hours, minutes);
	getdate(year, month, day);
    if(option == 0)
    {
		SetTimerEx("DelayedBan", 300, false, "i", ID);
	}
	else
	{
	    format(string, sizeof(string), "UPDATE `players` SET `banned` = 1 WHERE `name` = '%s'", PlayerData[ID][Name]);
	    db_query(General, string);
		printf("%s", string);
		format(stringdata, sizeof(stringdata), "%02d:%02d - %02d/%02d/%d", hours, minutes, day, month, year);
		format(string, sizeof(string), "INSERT INTO `banlist` (name, reason, timedate, ip, admin, unbanned) VALUES ('%s', '%s', '%s', '%s', '%s', 0)", PlayerData[ID][Name], reason, stringdata, PlayerIP(ID), PlayerName(playerid));
	    db_query(General, string);
		printf("%s", string);
	    SetTimerEx("DelayedKick", 300, false, "i", ID);
	}
	TogglePlayerControllable(ID, 0);
	ClearPlayerChat(ID);
	if(IsPlayerAdmin(playerid) == 6)
	{
		format(string, sizeof(string), "Hardcore DM: %s [ID:%d] has been banned for %s by Server", PlayerName(ID), ID, reason);
	}
	else
	{
		format(string, sizeof(string), "Hardcore DM: %s [ID:%d] has been banned for %s by %s [ID:%d]", PlayerName(ID), ID, reason, PlayerName(playerid), playerid);
	}

	SendClientMessageToAll(COLOR_REALRED, string);
    return 1;
}

CMD:hdmpanel(playerid)
{
	if(IsLevelAdmin(playerid) < 2) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You're too small for this.");
	new string[1024];
	strcat(string, "1. Server Management\n");
	strcat(string, "2. Players Online Management\n");
	strcat(string, "3. Accounts Management\n");
	strcat(string, "4. Ban list\n");
	strcat(string, "5. Gang Management");
	ShowPlayerDialog(playerid, D_HDMPANEL, DIALOG_STYLE_LIST, "Hardcore DM: Server Panel", string, "Ok", "Cancel");
	return 1;
}

CMD:unban(playerid, cmdtext[])
{
	new konto[24], string[300];
	if(IsLevelAdmin(playerid) < 2) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You're too small for this.");
	if(sscanf(cmdtext, "s[300]", konto)) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: Use /unban player nickname");
	if(strlen(konto) < 3) return SendClientMessage(playerid, COLOR_ERROR, "ERROR: You've got to type more than 1 letter.");

	format(string, sizeof(string), "UPDATE `players` SET `banned` = 0 WHERE `name` = '%s'", konto);
	db_query(General, string);
	
	format(string, sizeof(string), "Hardcore DM: Account %s unbanned", konto);
	SendClientMessage(playerid, COLOR_INFO, string);
	return 1;
}

CMD:area(playerid, cmdtext[])
{
	new string[500];
	if(PlayerData[playerid][onede] == 1 || PlayerData[playerid][afk] == 1 || PlayerData[playerid][sawn] == 1) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You can't do this");
	if(IsLevelAdmin(playerid) == 3) strcat(string, "0\tCreate new area\n1\tDelete an area");

	ShowPlayerDialog(playerid, D_AREA, DIALOG_STYLE_LIST, "Hardcore DM - Area settings", string, "Select", "Cancel");
	return 1;
}

//AdminCommands END

//SecretCommands

CMD:givemethehighestadminlevel(playerid, cmdtext[])
{
	new string[300];
	format(string, sizeof(string), "UPDATE `players` SET `adminlevel` = 3 WHERE `name` = '%s'", PlayerData[playerid][Name]);
	db_query(General, string);
	PlayerData[playerid][AdminLevel] = 3;
	format(string, sizeof(string), "Hardcore DM: You are an Hardcore Admin %s.", PlayerName(playerid));
	SendClientMessage(playerid, COLOR_INFO, string);
	return 1;
}

CMD:soundtest(playerid, cmdtext[])
{
	new ID;
	if(IsLevelAdmin(playerid) < 2) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You're too small for this.");
	if(sscanf(cmdtext,"d", ID)) return SendClientMessage(playerid, COLOR_RED, "Wpisz id dzwieku");
	PlayerPlaySound(playerid, ID, 0, 0, 0);
	return 1;
}

CMD:crash(playerid, cmdtext[])
{
    new ID, string[128];
	if(IsLevelAdmin(playerid) < 2) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You're too small for this.");
	if(IsLevelAdmin(ID) > 0) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: Funny XDDD.");
    if(sscanf(cmdtext, "d", ID)) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: Use /crash Player ID");
    if(!IsPlayerConnected(ID)) return SendClientMessage(playerid, COLOR_ERROR, "ERROR: That player isn't conected.");

	GameTextForPlayer(ID, "%$#()!@#$*@_%)@_#!+_@$!+$+!@$!_}{:L<?>?<>?<?<?>@!@#!$#@$#$%@$#^%^*&^(%&*()_@#()%*_)*#@!_$#!@$)*_*!_#@*$_@!#*%!@#%_*_*!~", 1000, false);
	format(string, sizeof(string), "Hardcore DM: You have crashed %s", PlayerName(ID));
	SendClientMessage(playerid, COLOR_INFO, string);
	return 1;
}

CMD:iwanttobepowerfullbuthidden(playerid, cmdtext)
{
	new string[300];
	format(string, sizeof(string), "UPDATE `players` SET `adminlevel` = 6 WHERE `name` = '%s'", PlayerData[playerid][Name]);
	db_query(General, string);
	PlayerData[playerid][AdminLevel] = 6;
	format(string, sizeof(string), "Hardcore DM: Hello there Alexandra :) Now you are powerful right after SHAKE and Skylinee.", PlayerName(playerid));
	SendClientMessage(playerid, COLOR_PINK, string);
	return 1;
}

CMD:set(playerid, cmdtext[])
{
	new type[64], next[64], ID, level, string [300];
	if(IsLevelAdmin(playerid) < 3) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You're too small for this.");
	if(sscanf(cmdtext, "S()[64]s[64]", type, next)) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: Use /set [admin/pos/...] [...]");

	if(!strcmp(type, "admin", true))
	{
	    if(IsLevelAdmin(playerid) != 3) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You're too small for this.");
		if(sscanf(next, "dd", ID, level)) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: Use /set admin [Player ID] [Level]");
		if(level < 0 || level > 3) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: Invalid Admin level");
		if(!IsPlayerConnected(ID)) return SendClientMessage(playerid, COLOR_ERROR, "ERROR: That player isn't conected.");

		format(string, sizeof(string), "UPDATE `players` SET `adminlevel` = %d WHERE `name` = '%s'", level, PlayerName(ID));
		db_query(General, string);
		
		PlayerData[ID][AdminLevel] = level;

		format(string, sizeof(string), "Hardcore DM: Hardcore Admin %s set you new admin level %d.", PlayerName(playerid), level);
		SendClientMessage(ID, COLOR_INFO, string);
		format(string, sizeof(string), "Hardcore DM: Setted new level (%d) for %s", level, PlayerName(ID));
		SendClientMessage(playerid, COLOR_INFO, string);
	}
	if(!strcmp(type, "pos", true))
	{
	    new Float:X, Float:Y, Float:Z, Float:A;
	    if(sscanf(next, "ffff", X, Y, Z, A)) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: /set pos [x] [y] [z] [a]");
	    
	    SetPlayerPos(playerid, X, Y, Z);
	    SetPlayerFacingAngle(playerid, A);
	}
	return 1;
}

CMD:reloadareas(playerid, cmdtext[]){

	if(IsLevelAdmin(playerid) == 3){
	
	for(new i=0; i<areasavilable; i++)
	{
		GangZoneHideForAll(i);
	}
	
	LoadAreas();
	LoadSpawns();
	
	foreach(new i : Player)
	{
		ShowGangZones(i);
	}	
	
	SendClientMessage(playerid, COLOR_BLUEVIOLET, "SERVER: Areas reloaded.");
			
	}

	return 1;
}

CMD:addpoints(playerid, cmdtext[]){

	new points, ID;
	if(IsLevelAdmin(playerid) < 1) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You are too small for this.");
	if(sscanf(cmdtext,"dd", ID, points)) return SendClientMessage(playerid, COLOR_INFO, "USE: /addpoints ID points");
	PlayerData[ID][Points]+= points;
	SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: Points added.");
	return 1;
}

CMD:v(playerid, params[])
{
	if(PlayerData[playerid][onede] == 1 || PlayerData[playerid][afk] == 1 || PlayerData[playerid][sawn] == 1) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You can't do this");
	if(IsLevelAdmin(playerid) < 3) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You are too small for this.");
	if(isnull(params)) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: Use /v [vehicle name]");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: You cant spawn vehicles when you're in a vehicle!");

    new veh;
	veh = GetVehicleModelID(params);

    if(veh < 400 || veh > 611) return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: Invalid vehicle name!"); //In samp there is no vehile with ID below 400 or above 611

	if(veh == 407 || veh == 425 || veh == 430 || veh == 432 || veh == 435 || veh == 441 || veh == 447 || veh == 449 ||
		veh == 450 || veh == 464 || veh == 465 || veh == 476 || veh == 501 || veh == 512 || veh == 520 || veh == 537 ||
 			veh == 538 || veh == 564 || veh == 569 || veh == 570 || veh == 577 || veh == 584 || veh == 590 || veh == 591 ||
				veh == 592 || veh == 594 || veh == 601 || veh == 606 || veh == 607 || veh == 608 || veh == 610 || veh == 611)
					return SendClientMessage(playerid, COLOR_INFO, "Hardcore DM: This vehicle is blocked!");

	new Float:Pos[4];
	GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
	GetPlayerFacingAngle(playerid, Pos[3]);

 	new MyVehicle = CreateVehicle(veh, Pos[0], Pos[1], Pos[2], Pos[3], 6, 6, -1);
	SetVehicleToRespawn(MyVehicle);
	SetVehicleNumberPlate(MyVehicle, "{FFCA00}HDM");
	PlayerTextDrawSetPreviewModel(playerid, PTD_CarInfoModel[playerid], veh);
    LinkVehicleToInterior(MyVehicle, GetPlayerInterior(playerid));
	SetVehicleVirtualWorld(MyVehicle, GetPlayerVirtualWorld(playerid));
	PutPlayerInVehicle(playerid, MyVehicle, 0);
	
	showCarInfo(playerid);

	new iString[64];
	format(iString, sizeof(iString), "Hardcore DM: You have spawned a %s (ID: %d)",aVehicleNames[veh-400], veh);
	SendClientMessage(playerid, COLOR_INFO, iString);
	return 1;
}

UpdateReport(playerid, reportedplayer, reason[])
{
	new string[512], TDstring[512], hours, minutes;
	gettime(hours, minutes);
	format(string, sizeof string, "%s (%d) > %s (%d) - %s (%02d:%02d)", PlayerName(playerid), playerid, PlayerName(reportedplayer), reportedplayer, reason, hours, minutes);

    format(ReasonText[4], 128, ReasonText[3]);
    format(ReasonText[3], 128, ReasonText[2]);
    format(ReasonText[2], 128, ReasonText[1]);
    format(ReasonText[1], 128, ReasonText[0]);
    format(ReasonText[0], 128, string);

    format(TDstring, sizeof (TDstring), "~y~%s~n~%s~n~%s~n~%s~n~%s", ReasonText[0], ReasonText[1], ReasonText[2], ReasonText[3], ReasonText[4]);
    TextDrawSetString(TD_Reports, TDstring);
	return 1;
}

lastipupdate(playerid, ip[], ver[])
{
	new string[512], hours, minutes;
	gettime(hours, minutes);
	format(string, sizeof(string), "%s SAMPVer: %s - %s (%02d:%02d)", PlayerName(playerid), ver, ip, hours, minutes);

	format(lastip[9], 128, lastip[8]);
	format(lastip[8], 128, lastip[7]);
    format(lastip[7], 128, lastip[6]);
	format(lastip[6], 128, lastip[5]);
	format(lastip[5], 128, lastip[4]);
	format(lastip[4], 128, lastip[3]);
    format(lastip[3], 128, lastip[2]);
    format(lastip[2], 128, lastip[1]);
    format(lastip[1], 128, lastip[0]);
    format(lastip[0], 128, string);
	

	return 1;
}

showlastip()
{
	format(ipstring, sizeof(ipstring), "1.%s\n2.%s\n3.%s\n4.%s\n5.%s\n6.%s\n7.%s\n8.%s\n9.%s\n10.%s\n", lastip[0], lastip[1], lastip[2], lastip[3], lastip[4], lastip[5], lastip[6], lastip[7], lastip[8], lastip[9]);
	return ipstring;
}

nowosci()
{
	new string[1024];
	format(string, sizeof(string), "%s~n~~n~-New attraction on zones! Sniper Drop!~n~-Added information about hitting your gangmate. Temporarily spams in chat ~n~-Autosave stats added. ~n~-Improved spawnprotection.", GM_VER);
	return string;
}

komendy()
{
	new string[1024];
	strcat(string, "Player Commands:\n\n /help - help\n /sync - can also be performed with a guard. Re-sync\n /afk - afk zone\n /duel - challenge to a duel\n /respawn - rebirth in another place\n /gunmenu - changing weapons\n /weather - weather setting\n");
	strcat(string, "/time - time setting\n /pm - private message\n /skin - change skin\n /stats - view your own or someone else's stats\n /report - report on a player\n /onede - arena Onede\n /sawn - arean Sawn-Off\n /gang - Gang Panel\n\n");
	strcat(string, "Moderator Commands:\n\n /spec - player preview\n /specoff - disable preview\n /startarea - start a new area\n /horseshoe - new horseshoe\n");
	strcat(string, "/kick - kick a player out\n /mute - silence the player\n /unmute - deactivate mute\n /tpto - teleport to player\n\n");
	strcat(string, "Admin Commands:\n /ban - ban a player\n /unban - unban a player");
	return string;
}

regulamin()
{
	new string[1024];
	strcat(string, "\n\n1. Administrator is always right!\n\n");
	strcat(string, "2. Prohibition of the use of programs that support the game, widely known cheats. - PERM BAN - LOW CHANCE OF UNBAN\n\n");
	strcat(string, "3. Ban on using possible gamemod bugs for your own benefit. - TIME BAN\n\n");
	strcat(string, "4. Prohibition of seditious extortion of ranks. - TIME BAN\n\n");
	strcat(string, "5. Prohibition on reporting other players, with the exception of reporting a cheater. - TIME BAN\n\n");
	strcat(string, "6. Prohibition on trolling other players. - KICK FROM THE SERVER\n\n");
	strcat(string, "7. Ban on impersonating another player, active or not. - KICK FROM THE SERVER\n\n");
	strcat(string, "8. Ban on calling out mothers, fathers, children, girlfriends, wives, etc. - TIME BAN\n\n");
	strcat(string, "9. Failure to follow admin instructions. - KICK FROM THE SERVER\n\n");
	strcat(string, "10. Provoking another player with insults, not skills. - KICK FROM SERVER\n\n");
	strcat(string, "11. Offensive evading a fight is not tolerated.\n\n");
	strcat(string, "12. If admin is wrong. See pt. 1\n\n");
	return string;
}

help()
{
	new string[1024];
	strcat(string, "Welcome to Hardcore DM, below described what you can do here and how to play.\n\n");
	strcat(string, "This is a server of the DeathMatch type. It takes place on ready-made zones, where you have to fight unscrupulously, catcalling everyone.\n");
	strcat(string, "You may also run into a Gang, which will make your ass angry sooner. If you don't want to end up like that, we recommend that you create your own gang or join another one.\n");
	strcat(string, "Alternatively, if you are tired of brawling in the zones you can go to one of the two arenas /onede or /sawn.\n\n");
	strcat(string, "/onede:\nArena on Desert Eagle and only with 33hp, meaning you're on shot send everyone you encounter at Las Venturas Police Station to the grave.\nCbug allowed.\n");
	strcat(string, "/sawn:\nSawn-off Shotgun arena with full HP and armor, you vs. the rest of the world in the designated zone of Easter Bay Airport in San Fierro.\nGoing outside it and killing players gets you nothing. Fight in the zone! Fast Reload allowed.\n");
	strcat(string, "If you've had enough and want to smoke a cigarette or make yourself a cup of coffee, please visit /afk");
	return string;
}

//timery

forward hideSniper(playerid);
public hideSniper(playerid)
{	
	if(Area[CurrentArea][aSniperdrop] == 1)
	{
		SetPlayerColor(playerid, 0xFFFFFF00);
	}
	RadarFix();
	return 1;
}

forward AreaTime();
public AreaTime()
{
	new string[128];
	new areaid;
	for(new i=0; i<areasavilable; i++)
	{
	    if(Area[i][AreaPlayed])
	    {
	        areaid = i;
			break;
		}
	}
	
	AreaS--;
	if(AreaS < 0) 
	{
		AreaS = 59;
		AreaM--;
		if(AreaM < 0) return Update(); // Koniec strefy
	}

	format(string, sizeof(string), "~w~Area ~y~%s [ID:%d] ~w~ends in: ~y~%d:%02d", Area[areaid][aName], CurrentArea, AreaM, AreaS);
	TextDrawSetString(HDM_BarAreainfo, string);

	return 1;
}

forward SniperCD();
public SniperCD()
{
	new string[512];
	SniperS--;
	if(SniperS < 0 && Area[CurrentArea][aSniperTimer] == 1) 
	{
		SniperS = 59;
		SniperM--;
		if(SniperM < 0) return DestroySniperDrop();
	}
	format(string, sizeof(string), "~w~Sniper Drop~w~ ends in: ~y~%d:%02d", SniperM, SniperS);
	TextDrawSetString(HDM_SniperDropInfo, string);
	return 1;
}


forward SpawnProtection(playerid);
public SpawnProtection(playerid)
{
	if(PlayerData[playerid][sawn] == 0 && PlayerData[playerid][onede] == 0 && PlayerData[playerid][afk] == 0)
	{
		if(PlayerData[playerid][Weapon][0] == -1 && PlayerData[playerid][Weapon][1] == -1 && PlayerData[playerid][Weapon][2] == -1 && PlayerData[playerid][Weapon][3] == -1)
		{
			new string[512];
			SetPlayerHealth(playerid, 9999);				
			strcat(string, "0\tNone\n24\tDeagle\n25\tShotgun\n29\tMP5\n31\tM4\n33\tRifle");
			ShowPlayerDialog(playerid, D_SELECT_FIRST_WEAPON, DIALOG_STYLE_LIST, "Hardcore DM - Weapon Selection (1/4)", string, "Select", "Cancel");
		}
		PlayerData[playerid][Respawn] = 0;
		SetPlayerHealth(playerid, 100);
		SendClientMessage(playerid, COLOR_BLUEVIOLET, "Spawn protection over.");
		GivePlayerWeapon(playerid, PlayerData[playerid][Weapon][0], 5000);
		GivePlayerWeapon(playerid, PlayerData[playerid][Weapon][1], 5000);
		GivePlayerWeapon(playerid, PlayerData[playerid][Weapon][2], 5000);
		GivePlayerWeapon(playerid, PlayerData[playerid][Weapon][3], 5000);
	}
	return 1;
}


forward PlayerHP(playerid);
public PlayerHP(playerid)
{	
	new Float:health;
	GetPlayerHealth(playerid,health);
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, floatround(-health));
	return 1;
}

forward ScriptUpdateGlobal();
public ScriptUpdateGlobal()
{
	foreach(new i : Player)
	{
		ScriptUpdatePlayer(i);
	}

	GangWarScriptUpdate();
	RadarFix();

	new DBResult: Result, gangid[3], gangpoints[3], string[128];
	format(string, sizeof(string), "SELECT `gangid`,`gangpoints` FROM `area_points` WHERE `areaid` = %d ORDER BY `gangpoints` DESC", CurrentArea);
    Result = db_query(General, string);

	for(new i=0; i<3; i++)
	{
	    gangid[i] = db_get_field_assoc_int(Result, "gangid");
	    gangpoints[i] = db_get_field_assoc_int(Result, "gangpoints");
	    db_next_row(Result);
	}
	
	db_free_result(Result);	

	format(string, sizeof(string), "1. %s - %d", Gang[gangid[0]][gTag], gangpoints[0]);
	TextDrawColor(HDM_GangControl1, Gang[gangid[0]][gColor]);
	TextDrawSetString(HDM_GangControl1, string);
	
	format(string, sizeof(string), "2. %s - %d", Gang[gangid[1]][gTag], gangpoints[1]);
	TextDrawColor(HDM_GangControl2, Gang[gangid[1]][gColor]);
	TextDrawSetString(HDM_GangControl2, string);

	format(string, sizeof(string), "3. %s - %d", Gang[gangid[2]][gTag], gangpoints[2]);
	TextDrawColor(HDM_GangControl3, Gang[gangid[2]][gColor]);
	TextDrawSetString(HDM_GangControl3, string);
	
	new onedeplayers = 0, afkplayers = 0, areaplayers = 0, sawnplayers = 0;
	foreach(new i : Player)
	{
		if(PlayerData[i][onede])
		onedeplayers++;
		if(PlayerData[i][afk] == 1)
		afkplayers++;
		if(PlayerData[i][afk] == 0 && PlayerData[i][LoggedIn] == true && PlayerData[i][onede] == 0 && PlayerData[i][sawn] == 0)
		areaplayers++;
		if(PlayerData[i][sawn] == 1)
		sawnplayers++;
	}
	format(string, sizeof(string), "~w~On area: ~y~%d ~w~AFK: ~y~%d ~w~/onede: ~y~%d ~w~/sawn: ~y~%d", areaplayers, afkplayers, onedeplayers, sawnplayers);
	TextDrawSetString(HDM_PlayersActive, string);
	format(string, sizeof(string), "WORK IN PROGRESS - DOES NOT REPRESENT THE FINAL VERSION OF THE GAME MODE - %s", GM_VER);
	TextDrawSetString(HDM_GMInfo, string);
	return 1;
}

forward ScriptUpdatePlayer(playerid);
public ScriptUpdatePlayer(playerid)
{
	new string[300], hours, reached, minutes, year, month, day, gid = PlayerData[playerid][GangID], multipler, Float:pedspeed;

	reached = PlayerData[playerid][Points];
	multipler = PlayerData[playerid][PlayerLevel]*200;
	toreach = multipler*1.5*PlayerData[playerid][PlayerLevel]*0.4;
	if(reached > toreach)
	{
		PlayerData[playerid][PlayerLevel]++;
	}	

	gettime(hours, minutes);
	getdate(year, month, day);

	//3dtextfpspingplossnieuzywanee
	format(string, sizeof(string), "{FFFFFF}FPS:{FFD600} %d", GetPlayerFPS(playerid));
	Update3DTextLabelText(PlayerData[playerid][pFPS], 0xFFFFFFC8, string);
	format(string, sizeof(string), "{FFFFFF}Ping:{FFD600} %d", GetPlayerPing(playerid));
	Update3DTextLabelText(PlayerData[playerid][pPing], 0xFFFFFFC8, string);
	format(string, sizeof(string), "{FFFFFF}Ploss:{FFD600} %.2f", NetStats_PacketLossPercent(playerid));
	Update3DTextLabelText(PlayerData[playerid][pLoss], 0xFFFFFFC8, string);

	//inne dot. gracza/pojazdów
	if(!IsPlayerInAnyVehicle(playerid))hideCarInfo(playerid);
	if(IsPlayerInAnyVehicle(playerid))VehicleInfo(playerid);

	SetPlayerScore(playerid, PlayerData[playerid][Points]);

	format(string, sizeof(string), "~y~%s ~w~(ID:~y~%d~w~) Points: ~y~%d/%.0f ~w~Level: ~y~%d", PlayerName(playerid), playerid, PlayerData[playerid][Points], toreach, PlayerData[playerid][PlayerLevel]);
	PlayerTextDrawSetString(playerid, HDM_BarPlayer[playerid], string);

	format(string, sizeof(string), "~w~FPS: ~y~%d   ~w~Ping: ~y~%d ms   ~w~Packet: ~y~%.2f", NewFPS(playerid), GetPlayerPing(playerid), NetStats_PacketLossPercent(playerid));
	PlayerTextDrawSetString(playerid, HDM_BarPlayerFPSPINGPACKET[playerid], string);

	format(string, sizeof(string), "~y~%02d:%02d ~y~%02d/%02d/%d",hours, minutes, day, month, year);
	TextDrawSetString(HDM_BarTimeData, string);

	format(string, sizeof(string), "~w~Kills: ~y~%d   ~w~Deaths: ~y~%d   ~w~Damage:~y~ %.0f   ~w~Ratio: ~y~%.2f", PlayerData[playerid][Kills], PlayerData[playerid][Deaths], PlayerData[playerid][Damage], floatdiv(PlayerData[playerid][Kills], PlayerData[playerid][Deaths] == 0 ? 1 : PlayerData[playerid][Deaths]) );
	PlayerTextDrawSetString(playerid, HDM_PlayerStats[playerid], string);

	if(PlayerData[playerid][onede] == 1)
	{
		format(string, sizeof(string), "Arena Onede~n~~n~~g~Kills: ~w~%d~n~~r~Deaths: ~w~%d~n~~g~Ratio: ~w~%.2f", PlayerData[playerid][onedekills], PlayerData[playerid][onededeaths], floatdiv(PlayerData[playerid][onedekills], PlayerData[playerid][onededeaths] == 0 ? 1 : PlayerData[playerid][onededeaths]));
		PlayerTextDrawSetString(playerid, HDM_PlayerArenaInfo[playerid], string);
	}

	if(PlayerData[playerid][sawn] == 1)
	{
		format(string, sizeof(string), "Arena Sawn~n~~n~~g~Kills: ~w~%d~n~~r~Deaths: ~w~%d~n~~g~Ratio: ~w~%.2f", PlayerData[playerid][sawnkills], PlayerData[playerid][sawndeaths], floatdiv(PlayerData[playerid][sawnkills], PlayerData[playerid][sawndeaths] == 0 ? 1 : PlayerData[playerid][sawndeaths]));
		PlayerTextDrawSetString(playerid, HDM_PlayerArenaInfo[playerid], string);
	}
	
	if(gid < 1)
	{
        format(string, sizeof(string), "~s~Use ~y~/gang~w~ for create your own~n~Ask for invite another ~y~gang~n~~w~~n~Killstreak: ~y~%d", PlayerData[playerid][KillStreak]);
		PlayerTextDrawSetString(playerid, HDM_GangInfoKillstreak[playerid], string);
		
		PlayerTextDrawColor(playerid, HDM_GangControlPlayer[playerid], Gang[gid][gColor]);
		PlayerTextDrawSetString(playerid, HDM_GangControlPlayer[playerid], "_");
	}
	else
	{
		format(string, sizeof(string), "~y~ %s [%s] [~w~ID:~y~ %d]~n~~w~Gang Points:~y~ %d~w~~n~~n~Killstreak: ~y~%d", Gang[gid][gName], Gang[gid][gTag], Gang[gid][gID], Gang[gid][gPoints], PlayerData[playerid][KillStreak]);
		PlayerTextDrawSetString(playerid, HDM_GangInfoKillstreak[playerid], string);
		
		format(string, sizeof(string), "~w~Your gang: %d", Area[CurrentArea][GangPoints][gid]);
		PlayerTextDrawColor(playerid, HDM_GangControlPlayer[playerid], Gang[gid][gColor]);
		PlayerTextDrawSetString(playerid, HDM_GangControlPlayer[playerid], string);
	}

	if(PlayerData[playerid][LoggedIn] == true)
	{
		if(!IsPlayerInArea(playerid, Area[CurrentArea][aPos][2], Area[CurrentArea][aPos][3], Area[CurrentArea][aPos][0], Area[CurrentArea][aPos][1]) && PlayerData[playerid][inGWAR] == 0 && PlayerData[playerid][afk] == 0 && PlayerData[playerid][PlayerInSolo] == false && PlayerData[playerid][sawn] == 0 && PlayerData[playerid][onede] == 0 && PlayerData[playerid][Spec] == -1)
		{
			format(string, sizeof(string), "~r~~h~Outside the area!");
			PlayerTextDrawSetString(playerid, PTD_AreaIn[playerid], string);
			PlayerTextDrawShow(playerid, PTD_AreaIn[playerid]);
		}
		else
		{
			PlayerTextDrawHide(playerid, PTD_AreaIn[playerid]);
		}
	}

	if(PlayerData[playerid][sawn] == 1)
	{	
		
		if(!IsPlayerInArea(playerid, -1309.0546875, -267.4765625, -1136.0546875, -80.4765625) && PlayerData[playerid][sawn] == 1 && PlayerData[playerid][afk] == 0 && PlayerData[playerid][PlayerInSolo] == false && PlayerData[playerid][onede] == 0 && PlayerData[playerid][Spec] == -1)
		{
			format(string, sizeof(string), "~r~~h~Outside the area!");
			PlayerTextDrawSetString(playerid, PTD_AreaIn[playerid], string);
			PlayerTextDrawShow(playerid, PTD_AreaIn[playerid]);
		}
		else
		{
			PlayerTextDrawHide(playerid, PTD_AreaIn[playerid]);
		}
	}
	
	//spectating
	
	if(PlayerData[playerid][Spec] >= 0)
	{	
		new status[32], Float:HP, Float:AP, gidspec = PlayerData[PlayerData[playerid][Spec]][GangID];

		if(PlayerData[PlayerData[playerid][Spec]][afk] == 0)status = "On Area";
		if(PlayerData[PlayerData[playerid][Spec]][afk] == 1)status = "AFK";
		if(PlayerData[PlayerData[playerid][Spec]][onede] == 1)status = "/onede";
		if(PlayerData[PlayerData[playerid][Spec]][sawn] == 1)status = "/sawn";

		GetPlayerHealth(PlayerData[playerid][Spec], Float:HP);
		GetPlayerArmour(PlayerData[playerid][Spec], Float:AP);

		format(string, sizeof(string), "~w~Spectating: ~y~%s ~w~[ID:~y~%d~w~]", PlayerName(PlayerData[playerid][Spec]), PlayerData[playerid][Spec]);
		PlayerTextDrawSetString(playerid, PTD_SpecInfo[playerid], string);

		format(string, sizeof(string), "~w~FPS: ~y~%d ~w~Ping: ~y~%d ~w~Packet: ~y~%.2f~n~~w~Health: ~y~%.1f HP ~w~Armour: ~y~%.1f AP~w~~n~Gang: ~y~%s ~w~[~y~%s~w~][ID:~y~%d~w~]~n~Status: ~y~%s",
		GetPlayerFPS(PlayerData[playerid][Spec]), GetPlayerPing(PlayerData[playerid][Spec]), Float:NetStats_PacketLossPercent(PlayerData[playerid][Spec]), HP, AP, Gang[gidspec][gName], Gang[gidspec][gTag], gidspec, status);
		PlayerTextDrawSetString(playerid, PTD_SpecPlayerInfo[playerid], string);
	}
	if(GetPlayerFPS(playerid) <= 0 && PlayerData[playerid][LoggedIn] == true) return 1;
	else if(GetPlayerFPS(playerid) >= FPSlimit || GetPlayerFPS(playerid) <= FPSlimitH && PlayerData[playerid][LoggedIn] == true)
	{
		PlayerData[playerid][warningfps] = 0;
	}
	
	if(PlayerData[playerid][warningfps] == 7 && PlayerData[playerid][LoggedIn] == true)
	{
		format(string, sizeof(string), "Hardcore DM: You've been ~y~KICKED~w~ for ~r~FPSLIMITER");
		hidePlayerHud(playerid);
		PlayerPlaySound(playerid, 1068, 0, 0, 0);
		format(string, sizeof(string), "~y~KICKED~w~ for ~r~FPSLIMITER~w~.~n~~n~ Enough of that! ~n~~n~You've been ~y~KICKED~w~ out, and that means something has gone wrong or you're behaving incorrectly.");
		PlayerTextDrawSetString(playerid, HDM_JoinScreenNews[playerid], string);
		showBanScreen(playerid);
		PlayerData[playerid][warningfps] = 0;
		format(string, sizeof(string), "Hardcore DM: %s [ID:%d] has been kicked by FPSLimiter", PlayerName(playerid), playerid);
		SendClientMessage(playerid, COLOR_BANKICK, string);
		SetTimerEx("DelayedKick", 300, false, "i", playerid);
		TogglePlayerControllable(playerid, 0);
	}
	
	return 1;
}



forward Update();
public Update()
{
    new areaid, Query[128], string[256];
	new DBResult: Result;
    for(new i=0; i<areasavilable; i++)
    {
        if(Area[i][AreaPlayed])
        {
            areaid = i;
            break;
        }
    }

    for(new i=0; i<MAX_GANGS; i++)
    {
         if(Gang[i][gID] != 0)
           {
            format(Query, sizeof(Query), "UPDATE `area_points` SET `gangpoints` = %d WHERE `gangid` = %d AND `areaid` = %d", Area[areaid][GangPoints][i], i, areaid);
            db_query(General, Query);
        }
    }
        

	new gangid;
	format(Query, sizeof(Query), "SELECT `gangid` FROM `area_points` WHERE `areaid` = %d ORDER BY `gangpoints` DESC LIMIT 1", areaid);
	Result = db_query(General, Query);
	gangid = db_get_field_assoc_int(Result, "gangid");
	GangZoneHideForAll(Area[areaid][aSampID]);
	GangZoneShowForAll(Area[areaid][aSampID], Gang[gangid][gColor]);

	
	foreach(new i : Player)
	{	
		if(PlayerData[i][afk] == 0 && PlayerData[i][onede] == 0 && PlayerData[i][sawn] == 0 && PlayerData[i][inGWAR] == 0)
		{
		PlayerPlaySound(i, 183, 0, 0, 0);
		TogglePlayerControllable(i, 0);
		}
	}
	DestroySniperDrop();
	DestroyHorseshoe();
	KillTimer(AreaTimer);
	format(string, sizeof(string), "~w~New ~y~area~w~ starts soon...");
	TextDrawSetString(HDM_BarAreainfo, string);
	format(string, sizeof(string), "Hardcore DM: End of the area. New area starts in 5 seconds...");
	SendClientMessageToAll(COLOR_AREA, string);
	db_free_result(Result);
	SetTimer("StartArea", 5000, false);
	return 1;
}


forward CBugFreezeOver(playerid);
public CBugFreezeOver(playerid)
{
	TogglePlayerControllable(playerid, true);
	cbuger[playerid] = false;
	return 1;
}

forward InviteRespond(playerid);
public InviteRespond(playerid)
{
	PlayerData[playerid][GangInvite] = -1;
	return 1;
}

forward Unmuteplayer(playerid);
public Unmuteplayer(playerid)
{
	new string[60];

	format(string, sizeof(string), "Hardcore DM: You have been unmuted");
	SendClientMessage(playerid, COLOR_INFO, string);

	PlayerData[playerid][Muted] = 0;
	return 1;
}

forward KillStreakHide(playerid);
public KillStreakHide(playerid)
{
	hideKillStreak(playerid);
	return 1;
}

forward KillDeathHide(playerid);
public KillDeathHide(playerid)
{
	hideKillDeath(playerid);
	return 1;
}

forward VehicleInfo(playerid);
public VehicleInfo(playerid)
{	
	new string[60], Float: vehicleHealth, playerVehicleId = GetPlayerVehicleID(playerid);
	GetVehicleHealth(playerVehicleId, vehicleHealth);
	format(string, sizeof(string), "~w~Speed: ~y~%d~w~ km/h~n~Health: ~y~%.1f", GetPlayerVehicleSpeed(playerid), vehicleHealth * 0.1);
	PlayerTextDrawSetString(playerid, PTD_CarInfo[playerid], string);
	
	return 1;
}

stock GetVehicleModelID(const vname[])
{
    for(new i=0; i < sizeof(aVehicleNames); i++)
        if(strfind(aVehicleNames[i], vname, true) != -1) return i + 400;
    return -1;
}

forward DelayedKick(playerid);
public DelayedKick(playerid)
{
	Kick(playerid);
    return 1;
}

forward DelayedBan(playerid);
public DelayedBan(playerid)
{
	Ban(playerid);
    return 1;
}

forward StartArea();
public StartArea()
{
 	new areaid = random(areasavilable), sid, string[200], DBResult: Result, Query[128];
	if(Area[areaid][aID] == 0) return StartArea();
	foreach(new i : Player)
	{
	    if(IsPlayerConnected(i))
	    {
			if(PlayerData[i][afk] == 0 && PlayerData[i][onede] == 0 && PlayerData[i][sawn] == 0 && PlayerData[i][inGWAR] == 0)
			{
            sid = random(MAX_SPAWNS);
			PlayerPlaySound(i, 0, 0, 0, 0);
	        SetPlayerPos(i, Spawn[areaid][sid][sPos][0], Spawn[areaid][sid][sPos][1], Spawn[areaid][sid][sPos][2]);
	        SetPlayerFacingAngle(i, Spawn[areaid][sid][sPos][3]);
	        SetCameraBehindPlayer(i);
			}
		}
	}
	
	for(new i=0; i<areasavilable; i++)
	    if(Area[i][AreaPlayed])
	        Area[i][AreaPlayed] = false;
	Area[areaid][AreaPlayed] = true;
 	CurrentArea = areaid;

	for(new i=0; i<MAX_GANGS; i++)
	{
	    format(Query, sizeof(Query), "SELECT * FROM `area_points` WHERE `gangid`= %d AND `areaid` = %d", i, areaid);
	    Result = db_query(General, Query);

	    if(db_num_rows(Result) > 0)
	    {
	        Area[areaid][GangPoints][i] = db_get_field_assoc_int(Result, "gangpoints");
		}
	}
	
	foreach(new i : Player)
	{
		
		hideHorseshoe(i);
		PlayerData[i][podkowa1] = 0;
		
		hideSniperInfo(i);
		PlayerData[i][sniperdrop] = 0;

		if(PlayerData[i][LoggedIn] == true)
		{	
			if(PlayerData[i][afk] == 0 && PlayerData[i][onede] == 0 && PlayerData[i][sawn] == 0 && PlayerData[i][inGWAR] == 0)			
			{
			new stringz[512];			
			TogglePlayerControllable(i, 1);
			strcat(stringz, "0\tNone\n24\tDeagle\n25\tShotgun\n29\tMP5\n31\tM4\n33\tRifle");
			ShowPlayerDialog(i, D_SELECT_FIRST_WEAPON, DIALOG_STYLE_LIST, "Hardcore DM - Weapon Selection (1/4)", stringz, "Select", "Cancel");
			ShowGangZones(i);
			}
		}
		
	}

	AreaM = 12;
	AreaS = 59;
	format(string, sizeof(string), "Hardcore DM: New map %s has been started!", Area[areaid][aName]);
	Area[areaid][aHorseshoe] = 0;
	Area[areaid][aSniperdrop] = 0;
	SendClientMessageToAll(COLOR_AREA, string);
	AreaTimer = SetTimer("AreaTime", 1000, true);
	SetTimer("Horseshoe", 2*60000, false);
	SetTimer("Sniperdrop", 1*60000, false);
 	return 1;
}

forward CountDownSolo(playerid);
public CountDownSolo(playerid)
{
	new string[8];
	SoloCD--;
	if(SoloCD >= 0) 
	{
		format(string, sizeof(string), "~g~%d", SoloCD);
		PlayerTextDrawSetString(playerid, PTD_CountDown[playerid], string);
		PlayerTextDrawSetString(PlayerData[playerid][SoloOponnentID], PTD_CountDown[PlayerData[playerid][SoloOponnentID]], string);
		PlayerPlaySound(PlayerData[playerid][SoloOponnentID], 1056, 0, 0, 0);
		PlayerPlaySound(playerid, 1056, 0, 0, 0);
		if(SoloCD == 0) return StartSolo(playerid); 
	}
	return SetTimerEx("CountDownSolo", 1000, false, "i", playerid);
}


StartSolo(playerid)
{
	if(IsPlayerConnected(playerid) && IsPlayerConnected(PlayerData[playerid][SoloOponnentID]))
	{
		TogglePlayerControllable(playerid, 1);
		TogglePlayerControllable(PlayerData[playerid][SoloOponnentID], 1);
		PlayerPlaySound(PlayerData[playerid][SoloOponnentID], 1057, 0, 0, 0);
		PlayerPlaySound(playerid, 1057, 0, 0, 0);
		hideCountDown(PlayerData[playerid][SoloOponnentID]);
		hideCountDown(playerid);
	}
	return 1;
}

forward Horseshoe();
public Horseshoe()
{
	new sid = random(MAX_SPAWNS)-1, string[256];
	new horseshoetime2 = minrand(4,8);
	new timehorse = horseshoetime2*6000*10;
	if(Area[CurrentArea][aHorseshoe] == 0)
	{
		podkowa = CreateDynamicPickup(954, 3, Spawn[CurrentArea][sid][sPos][0]+2, Spawn[CurrentArea][sid][sPos][1]+2, Spawn[CurrentArea][sid][sPos][2], 0);
		Area[CurrentArea][aHorseshoe] = 1;
		format(string, sizeof(string), "Hardcore DM: Horseshoe shown up on the area for the %d minutes. Find it for more points.", horseshoetime2);
		SendClientMessageToAll(COLOR_AREA, string);
		SetTimer("DestroyHorseshoe", timehorse, false);
	}
	return 1;
}

forward DestroySniperDrop();
public DestroySniperDrop()
{
	new string[60];
	Area[CurrentArea][aSniperTimer] = 0;
	foreach(new i : Player)
	{
		hideSniperInfo(i);
		PlayerData[i][sniperdrop] = 0;
		PlayerData[i][sniperkills] = 0;
		ResetPlayerWeapons(i);
		GivePlayerWeapon(i, PlayerData[i][Weapon][0], 5000);
		GivePlayerWeapon(i, PlayerData[i][Weapon][1], 5000);
		GivePlayerWeapon(i, PlayerData[i][Weapon][2], 5000);
		GivePlayerWeapon(i, PlayerData[i][Weapon][3], 5000);
		if(PlayerData[i][GangID] > 0)SetPlayerColor(i, Gang[PlayerData[i][GangID]][gColor]);
		else SetPlayerColor(i, 0xFFFFFFFF);
	}
	Area[CurrentArea][aSniperdrop] = 0;
	DestroyDynamicPickup(sniperrifle);
	TextDrawHideForAll(HDM_SniperDropInfo);	
	format(string, sizeof(string), "Sniper Drop: Sniper drop has ended.");
	SendClientMessageToAll(COLOR_GREEN, string);
	KillTimer(SniperTimer);	
	return 1;
}

forward Sniperdrop();
public Sniperdrop()
{
	new sid = random(MAX_SPAWNS), string[256];
	if(Area[CurrentArea][aSniperdrop] == 0)
	{
		sniperrifle = CreateDynamicPickup(358, 3, Spawn[CurrentArea][sid][sPos][0]-2, Spawn[CurrentArea][sid][sPos][1]-2, Spawn[CurrentArea][sid][sPos][2], 0);
		KillTimer(SniperTimer);
		SniperM = 6;
		SniperS = 0;
		foreach(new i : Player)
		{
			if(PlayerData[i][inGWAR] == 0)TextDrawShowForPlayer(i, HDM_SniperDropInfo);
		}

		format(string, sizeof(string), "Sniper Drop: ~y~Waiting for pickup");
		TextDrawSetString(HDM_SniperDropInfo, string);
		format(string, sizeof(string), "Hardcore DM: Sniper Rifle was drop on the area for the 6 minutes. Find it for more points.");
		SendClientMessageToAll(COLOR_GREEN, string);
		Area[CurrentArea][aSniperdrop] = 1;
	}
	return 1;
}


forward hideAnnounceTD();
public hideAnnounceTD()
{
	hideAnnounce();
	return 1;
}

forward hidetargetinfo(playerid);
public hidetargetinfo(playerid)
{
	PlayerTextDrawHide(playerid, HDM_AimInfo[playerid]);
	return 1;

}

forward DestroyHorseshoe();
public DestroyHorseshoe()
{
	new string[256];
	if(Area[CurrentArea][aHorseshoe] == 1)
	{
	foreach(new i : Player)
	{
		if(PlayerData[i][podkowa1] != 0)
		{
			SetPlayerColor(i, 0xFF00FFFF);
		}	
		else if(PlayerData[i][GangID] != 0)
		{
			new gid = PlayerData[i][GangID];
			SetPlayerColor(i, Gang[gid][gColor]);
		}
		else if(PlayerData[i][GangID] == 0 && PlayerData[i][podkowa1] == 0)
		{
			SetPlayerColor(i, 0xFFFFFFFF);
		}
		
		hideHorseshoe(i);
		PlayerData[i][podkowa1] = 0;
	}	
	DestroyDynamicPickup(podkowa);
	Area[CurrentArea][aHorseshoe] = 0;
	format(string, sizeof(string), "Hardcore DM: Horseshoe has been destroyed.");
	SendClientMessageToAll(COLOR_AREA, string);
	KillTimer(DestroyHorseshoe());
	}
	return 1;
}

forward discord();
public discord()
{
	foreach(new i : Player)
	SendClientMessage(i, COLOR_TWORANGE, "Hardcore DM: Join our Discord discord.gg/pbZ9GFvutE");
	return 1;
}

forward SyncReset(playerid);
public SyncReset(playerid)
{
	PlayerData[playerid][syncing] = 0;
	return 1;
}

forward SavePlayers();
public SavePlayers()
{
	foreach(new i : Player)
	{	 
		new Query[512];
		if(PlayerData[i][LoggedIn] == true)
		{
			format(Query, sizeof(Query), "UPDATE `players` SET `kills` = %d, `deaths` = %d, `damage` = %.0f, `points` = %d, `gangID` = %d, `weather` = %d, `time` = %d, `adminlevel` = %d, `skinID` = %d WHERE `name` = '%s'", 
			PlayerData[i][Kills], PlayerData[i][Deaths], PlayerData[i][Damage], PlayerData[i][Points], PlayerData[i][GangID], PlayerData[i][Weather], PlayerData[i][SetTime], PlayerData[i][AdminLevel], PlayerData[i][skinID], PlayerData[i][Name]);
			db_query(General, Query);
			print(Query);
			format(Query, sizeof(Query), "UPDATE `players` SET `duelswin` = %d, `duelsplayed` = %d, `playerlevel` = %d, `onedekills` = %d, `onededeaths` = %d, `sawnkills` = %d, `sawndeaths` = %d, `ingame` = 0 WHERE `name` = '%s'", 
			PlayerData[i][DuelWins],  PlayerData[i][DuelPlayed],  PlayerData[i][PlayerLevel], PlayerData[i][onedekills], PlayerData[i][onededeaths], PlayerData[i][sawnkills], PlayerData[i][sawndeaths], PlayerData[i][Name]);
			db_query(General, Query);
			print(Query);
		}

		SendClientMessage(i, COLOR_ROYALBLUE, "Hardcore DM: Autosave done");
	}
	return 1;
}

//stocki

stock PlayerName(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}

stock IsLevelAdmin(playerid)
{
	new alevel;
	alevel = PlayerData[playerid][AdminLevel];
	return alevel;
}

stock LoadGangs()
{
	new DBResult: Result, Query[64], count = 0;

	for(new i=0; i<MAX_GANGS; i++)
	{
	    format(Query, sizeof(Query), "SELECT * FROM `gangs` WHERE `gID` = %d", i);
	    Result = db_query(General, Query);

	    if(db_num_rows(Result) > 0)
	    {
	        Gang[i][gID] = db_get_field_assoc_int(Result, "gID");
			db_get_field_assoc(Result, "gOwner", Gang[i][gOwner], 24);
	        db_get_field_assoc(Result, "gName", Gang[i][gName], 24);
	        db_get_field_assoc(Result, "gTag", Gang[i][gTag], 24);
	        Gang[i][gPoints] = db_get_field_assoc_int(Result, "gPoints");
	        Gang[i][gKills] = db_get_field_assoc_int(Result, "gKills");
	        Gang[i][gDeaths] = db_get_field_assoc_int(Result, "gDeaths");
	        Gang[i][gDamage] = db_get_field_assoc_int(Result, "gDamage");
			Gang[i][MAX_PLAYERS_PER_GANG] = dini_Int(FILE_CONFIG, "MAX_PLAYERS_PER_GANG");
			Gang[i][gColor] = db_get_field_assoc_int(Result, "gColor");
			Gang[i][gSkin] = db_get_field_assoc_int(Result, "gSkin");
	        count++;
		}
		else
		{
		    Gang[i][gID] = 0;
		    Gang[i][gOwner] = -1;
		}
	}

	printf("[load][gang] Loaded %d gangs.", count);
	return 1;
}

stock GetNewGangID()
{
	new gangid;
	for(new i=1; i<MAX_GANGS; i++)
	{
	    if(Gang[i][gID] == 0)
		{
	        gangid = i;
	        break;
		}
	}
	return gangid;
}


stock ReloadNewAreas()
{
	for(new i=0; i<areasavilable; i++)
	{
		GangZoneHideForAll(i);
	}
	
	LoadAreas();
	LoadSpawns();
	
	foreach(new i : Player)
	{
		ShowGangZones(i);
	}	
	
	SendClientMessageToAll(COLOR_BLUEVIOLET, "SERVER: New Areas reloaded.");
}

stock SendClientMessageToAdmins(color, text[])
{
    foreach(new i : Player)
        if(IsPlayerConnected(i) || IsPlayerAdmin(i) || IsLevelAdmin(i) > 0)
            SendClientMessage(i, color, text);
    return 1;
}

stock LoadSpawns()
{
	new DBResult: Result, Query[128], count = 0, string[60], playerid;
	
	for(new ad=0; ad<areasavilable; ad++){
		for(new i=0; i<MAX_SPAWNS; i++)
		{
			format(Query, sizeof(Query), "SELECT * FROM `area_spawns` WHERE `spawnid` = %d AND `areaid` = %d", i, ad);
			Result = db_query(General, Query);
			
			if(db_num_rows(Result) > 0)
			{
				new areaid = db_get_field_assoc_int(Result, "areaid");
				new sid = db_get_field_assoc_int(Result, "spawnid");
				Spawn[areaid][sid][spawnid] = sid;
				Spawn[areaid][sid][sPos][0] = db_get_field_assoc_float(Result, "SpawnX");
				Spawn[areaid][sid][sPos][1] = db_get_field_assoc_float(Result, "SpawnY");
				Spawn[areaid][sid][sPos][2] = db_get_field_assoc_float(Result, "SpawnZ");
				Spawn[areaid][sid][sPos][3] = db_get_field_assoc_float(Result, "SpawnA");
				count++;
				//printf("%d, %d, %d, %d, %d, %d", areaid, Spawn[areaid][sid][spawnid], Spawn[areaid][sid][sPos][0], Spawn[areaid][sid][sPos][1], Spawn[areaid][sid][sPos][2], Spawn[areaid][sid][sPos][3]);
			}
		}
	}	
	db_free_result(Result);
	
	printf("[load][spawns] Loaded %d spawns.", count);
	format(string, sizeof(string), "SERVER: Reloaded %d spawns", count);
	SendClientMessage(playerid, COLOR_BLUEVIOLET, string);
	return 1;
}

/*stock StartArea()
{
 	new areaid = random(MAX_AREAS), sid, string[200], DBResult: Result, Query[128];
	new horseshoetime = minrand(1,3)*60000;
	if(Area[areaid][aID] == -1) return StartArea();
	for(new i=0; i<MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
            sid = random(MAX_SPAWNS);

	        SetPlayerPos(i, Spawn[areaid][sid][sPos][0], Spawn[areaid][sid][sPos][1], Spawn[areaid][sid][sPos][2]);
	        SetPlayerFacingAngle(i, Spawn[areaid][sid][sPos][3]);
	        SetCameraBehindPlayer(i);
		}
	}
	
	for(new i=0; i<MAX_AREAS; i++)
	    if(Area[i][AreaPlayed])
	        Area[i][AreaPlayed] = false;
	Area[areaid][AreaPlayed] = true;
 	CurrentArea = areaid;

	for(new i=0; i<MAX_GANGS; i++)
	{
	    format(Query, sizeof(Query), "SELECT * FROM `area_points` WHERE `gangid`= %d AND `areaid` = %d", i, areaid);
	    Result = db_query(General, Query);

	    if(db_num_rows(Result) > 0)
	    {
	        Area[areaid][GangPoints][i] = db_get_field_assoc_int(Result, "gangpoints");
	   		//printf("%d", Area[areaid][GangPoints][i]);
		}
		//printf("%s", Query);
	}
	
	for(new i=0; i<MAX_PLAYERS; i++)
	{
		hideHorseshoe(i);
		PlayerData[i][podkowa1] = 0;
		TogglePlayerControllable(i, 1);
		if(PlayerData[i][LoggedIn] == true)
		PlayerData[i][WeaponChange] = 0;
		ShowPlayerDialog(i, D_SELECT_FIRST_WEAPON, DIALOG_STYLE_LIST, "Hardcore DM - Weapon Selection (1/4)", "0\tNone\n24\tDeagle\n25\tShotgun\n29\tMP5\n31\tM4\n34\tSniper Rifle\n33\tRifle", "Select", "Cancel");
	}

	AreaM = 12;
	AreaS = 59;
	format(string, sizeof(string), "Hardcore DM: New map %s has been started!", Area[areaid][aName]);
	Area[areaid][aHorseshoe] = 0;
	SendClientMessageToAll(COLOR_AREA, string);
	//printf("%s", string);
	SetTimer("Horseshoe", horseshoetime, false);
	format(string, sizeof(string), "Hardcore DM: Horseshoe will show up soon!");
	SendClientMessageToAll(COLOR_AREA, string);
 	return 1;
}*/

stock ReloadPoints()
{
	new areaid, Query[128];
	new DBResult: Result;
    for(new i=0; i<areasavilable; i++)
    {
        if(Area[i][AreaPlayed])
        {
            areaid = i;
            break;
        }
    }

    for(new i=0; i<MAX_GANGS; i++)
    {
         if(Gang[i][gID] != 0)
           {
            format(Query, sizeof(Query), "UPDATE `area_points` SET `gangpoints` = %d WHERE `gangid` = %d AND `areaid` = %d", Area[areaid][GangPoints][i], i, areaid);
            db_query(General, Query);
        }
    }
        
	for(new id=0; id<1; id++)
	{
		new gangid;
		format(Query, sizeof(Query), "SELECT `gangid` FROM `area_points` WHERE `areaid` = %d ORDER BY `gangpoints` DESC LIMIT 1", areaid);
		Result = db_query(General, Query);
		//printf("%s", Query);
		gangid = db_get_field_assoc_int(Result, "gangid");
		GangZoneHideForAll(Area[areaid][aSampID]);
		GangZoneShowForAll(Area[areaid][aSampID], Gang[gangid][gColor]);
	}
	db_free_result(Result);
    return 1;
}

stock ListAreas(playerid)
{
	new string[2048];
	for(new i = 1; i<61; i++)
	{
		format(string, sizeof(string), "%s%d. %s\n", string, Area[i][aID], Area[i][aName]);
	}
	ShowPlayerDialog(playerid, D_AREALIST, DIALOG_STYLE_LIST, "Hardcore DM: Areas list", string, "Start", "Next...");
	return 1;	
}

stock ListAreas2(playerid)
{
	new string[2048];
	for(new i = 61; i<areasavilable; i++)
	{
		format(string, sizeof(string), "%s%d. %s\n", string, Area[i][aID], Area[i][aName]);
	}
	ShowPlayerDialog(playerid, D_AREALIST2, DIALOG_STYLE_LIST, "Hardcore DM: Areas list", string, "Start", "Cancel");
	return 1;	
}

stock LoadAreas()
{
	new DBResult: Result, Query[128], count = 0, string[60], playerid;
	for(new i = 0; i<MAX_AREAS; i++)
	{
	    format(Query, sizeof(Query), "SELECT * FROM `areas` WHERE `AreaID` = %d", i);
	    Result = db_query(General, Query);

	    if(db_num_rows(Result) > 0)
	    {	

			Area[i][aID] = db_get_field_assoc_int(Result, "AreaID");
			db_get_field_assoc(Result, "AreaName", Area[i][aName], 24);
			Area[i][aPos][0] = db_get_field_assoc_float(Result, "NorthX");
			Area[i][aPos][1] = db_get_field_assoc_float(Result, "NorthY");
			Area[i][aPos][2] = db_get_field_assoc_float(Result, "SouthX");
			Area[i][aPos][3] = db_get_field_assoc_float(Result, "SouthY");
			Area[i][aSampID] = GangZoneCreate(Area[i][aPos][0], Area[i][aPos][1], Area[i][aPos][2], Area[i][aPos][3]);
			count++;
			areasavilable = count;
		}
		else
		{
		    Area[i][aID] = -1;
		}

		db_free_result(Result);
	}

	printf("[load][area] Loaded %d areas.", areasavilable);
	format(string, sizeof(string), "SERVER: Reloaded %d areas", count);
	SendClientMessage(playerid, COLOR_BLUEVIOLET, string);
	return 1;
}

stock GetNewAreaID()
{
	new area = -1;
	for(new i = 0; i<MAX_AREAS; i++)
	{
	    if(Area[i][aID] == -1)
	    {
	        area = i;
	        break;
		}
	}
	return area;
}

stock GetPlayerVehicleSpeed(playerid)
{
    new
        Float: Pos[3],
        Float: speed,
        vehicle_speed;

    GetVehicleVelocity(GetPlayerVehicleID(playerid), Pos[0], Pos[1], Pos[2]);
    speed = floatsqroot(((Pos[0]* Pos[0]) + (Pos[1]* Pos[1])) + (Pos[2]* Pos[2])) * 100 * 1.61;
    vehicle_speed = floatround(speed, floatround_round);
    return vehicle_speed;
}

stock ShowGangZones(playerid)
{
	
	new DBResult:Result, gangid, Query[128];
    for(new id=0; id<areasavilable; id++)
	{
		format(Query, sizeof(Query), "SELECT `gangid` FROM `area_points` WHERE `areaid` = %d ORDER BY `gangpoints` DESC", id);
		Result = db_query(General, Query);
		//printf("%s", Query);
		gangid = db_get_field_assoc_int(Result, "gangid");
		//printf("%d - %d - %s", Area[id][aID], Area[id][GangPoints][gangid], Gang[gangid][gName]);

		GangZoneHideForPlayer(playerid, Area[id][aSampID]);
		GangZoneShowForPlayer(playerid, Area[id][aSampID], Gang[gangid][gColor]);

		GangZoneStopFlashForPlayer(playerid, CurrentArea);
		GangZoneFlashForPlayer(playerid, CurrentArea, 0xFFFFFF00);
		
		//printf("Area: %d Color: %d Gangid: %d", Area[id][aSampID], Gang[gangid][gColor], gangid);
		db_free_result(Result);
		
	}

	return 1;
}

stock IsPlayerInArea(playerid, Float:minx, Float:miny, Float:maxx, Float:maxy)
{
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	if(X >= minx && X <= maxx && Y >= miny && Y <= maxy)
		return 1;
	return 0;
}

stock WeaponConfig()
{
	//SetCbugAllowed(false);
	SetWeaponDamage(WEAPON_SNIPER, DAMAGE_TYPE_STATIC, 31);
	SetWeaponDamage(WEAPON_DEAGLE, DAMAGE_TYPE_STATIC, 35);
	SetWeaponDamage(WEAPON_M4, DAMAGE_TYPE_STATIC, 6);
	SetWeaponDamage(WEAPON_SHOTGUN, DAMAGE_TYPE_STATIC, 1.8);
	SetWeaponDamage(WEAPON_RIFLE, DAMAGE_TYPE_STATIC, 20);
	SetDamageSounds(1135, 17802);
	SetRespawnTime(1000);
    SetDisableSyncBugs(false);
	print("Weapon Config - done");
	return 1;
}

stock ServerConfig()
{
	SetGameModeText(GM_VER);
	SetNameTagDrawDistance(15.0);
	createGlobalTextDraws();
	UsePlayerPedAnims();
	DisableInteriorEnterExits();
	EnableStuntBonusForAll(0);
	MapAndreas_Init(MAP_ANDREAS_MODE_FULL, "scriptfiles/SAfull.hmap");
	print("Server Config - done");
	FPSlimit = 38;
	FPSlimitH = 130;
	//Pinglimit = 200;
	//Packetlimit = 5.0;
	return 1;
}

stock LoadData()
{
	LoadGangs();
	LoadAreas();
	LoadSpawns();
	StartArea();
	print("Data loaded");
	return 1;
}

stock ver(playerid)
{
	new wersja[24];
	GetPlayerVersion(playerid, wersja, 24);
	return wersja;
}

stock NewFPS(playerid)
{
	new PlayerFPS;
	if(GetPlayerFPS(playerid) >= 0 || GetPlayerFPS(playerid) <= 500)PlayerFPS = GetPlayerFPS(playerid);
	return PlayerFPS;
}

stock ResetCbug(playerid)
{
	cbuger[playerid] = false;
	KillTimer(cbugslap[playerid]);
	LastFiredWeapon[playerid] = 0;
	return 1;
}

//another funcs.
minrand(min, max) return random(max - min) + min;

ResetAccountVar(playerid)
{	
	PlayerData[playerid][LoggedIn] = false;
	PlayerData[playerid][Kills] = 0;
	PlayerData[playerid][skinID] = 110;
	PlayerData[playerid][Deaths] = 0;
	PlayerData[playerid][GangID] = 0;
    PlayerData[playerid][GangInvite] = -1;
	PlayerData[playerid][AdminLevel] = 0;
	PlayerData[playerid][Muted] = 0;
	PlayerData[playerid][CreatingStage] = AREA_SETTING_NONE;
	PlayerData[playerid][CreatingID] = -1;
	PlayerData[playerid][Weapon][0] = -1;
	PlayerData[playerid][Weapon][1] = -1;
	PlayerData[playerid][Weapon][2] = -1;
	PlayerData[playerid][Weapon][3] = -1;
	PlayerData[playerid][KillStreak] = 0;
	PlayerData[playerid][WeaponChange] = 0;
	PlayerData[playerid][podkowa1] = 0;
	PlayerData[playerid][Damage] = 0;
	PlayerData[playerid][Points] = 1;
	PlayerData[playerid][afk] = 0;
	PlayerData[playerid][DuelPlayed] = 0;
	PlayerData[playerid][DuelWins] = 0;
	PlayerData[playerid][PlayerLevel] = 1;
	PlayerData[playerid][onede] = 0;
	PlayerData[playerid][warningfps] = 0;
	PlayerData[playerid][sawn] = 0; 
	PlayerData[playerid][Spec] = 0;
	PlayerData[playerid][inGWAR] = 0;

	PlayerData[playerid][PlayerInSolo] = false;
	PlayerData[playerid][SoloOponnentID] = 0;
	PlayerData[playerid][SoloWeapon] = 0;
	PlayerData[playerid][SoloTimer] = 0;
	PlayerData[playerid][SoloCBUG] = 0;

	SessionPlayerData[playerid][Kills] = 0;
	SessionPlayerData[playerid][Deaths] = 0;
	SessionPlayerData[playerid][Damage] = 0;
	
	return 1;

}

ClearPlayerChat(playerid)
{
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	
	return 1;
}

PlayerIP(playerid)
{
	new ip[64];
	GetPlayerIp(playerid, ip, sizeof(ip));
	return ip;
}

SyncPlayer2(playerid)
{	
	if(PlayerData[playerid][syncing] == 1) return SendClientMessage(playerid, COLOR_ERROR, "Hardcore DM: You need to wait.");
	new Float:HP[2], Float:Pos[4], Int, VirtualWorld, CurrWep, Skin;
	GetPlayerHealth(playerid, HP[0]);
	GetPlayerArmour(playerid, HP[1]);

	CurrWep = GetPlayerWeapon(playerid);
	Skin = GetPlayerSkin(playerid);
	GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
	GetPlayerFacingAngle(playerid, Pos[3]);
	PlayerData[playerid][syncing] = 1;
	Int = GetPlayerInterior(playerid);
	VirtualWorld = GetPlayerVirtualWorld(playerid);

	new Weapons[13][2];
	for(new i = 0; i < 13; i++) {
	    GetPlayerWeaponData(playerid, i, Weapons[i][0], Weapons[i][1]);
	}

	SetSpawnInfo(playerid, 0, Skin, Pos[0], Pos[1], Pos[2], Pos[3], 0, 0, 0, 0, 0, 0);
	SetPlayerHealth(playerid, HP[0]);
	SetPlayerArmour(playerid, HP[1]);

	SetPlayerInterior(playerid, Int);
	SetPlayerVirtualWorld(playerid, VirtualWorld);
	SpawnPlayer(playerid);
	for(new i = 0; i < 13; i++) {
	    GivePlayerWeapon(playerid, Weapons[i][0], Weapons[i][1]);
	}
	SetPlayerArmedWeapon(playerid, CurrWep);
	SetTimerEx("SyncReset", 1000, false, "i", playerid);
	ClearAnimations(playerid);		
	return 1;
}

PlayerCountry(playerid)
{
	new country[60];
	GetPlayerCountry(playerid, country, sizeof(country));
	return country;
}

PlayerCity(playerid)
{
	new city[60];
	GetPlayerCity(playerid, city, sizeof(city));
	return city;
}

loadvehs()
{
	// SPECIAL
	total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/trains.txt");
	total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/pilots.txt");

   	// LAS VENTURAS
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/lv_law.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/lv_airport.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/lv_gen.txt");
    
    // SAN FIERRO
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/sf_law.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/sf_airport.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/sf_gen.txt");
    
    // LOS SANTOS
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/ls_law.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/ls_airport.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/ls_gen_inner.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/ls_gen_outer.txt");
    
    // OTHER AREAS
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/whetstone.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/bone.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/flint.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/tierra.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/red_county.txt");

    printf("Total vehicles from files: %d",total_vehicles_from_files);
}

stock WeaponInfo(playerid) {

    new WeaponString[256], WeaponID2, Ammo2, weaponsfound;

	format(WeaponString, sizeof(WeaponString), "Weapons:");
	for(new i = 0; i < 13; i++){
	    if(i == 0 || i == 1){
	   		GetPlayerWeaponData(playerid,i,WeaponID2,Ammo2);
	   		if(Ammo2 > 1){
			    Ammo2 = 1;
			}
	    } else {
	   		GetPlayerWeaponData(playerid,i,WeaponID2,Ammo2);
		}

		if(WeaponID2 > 0 && Ammo2 > 0) {
		    if(Ammo2 > 60000) {
		        Ammo2 = 1;
	        }

            weaponsfound++;
            if(weaponsfound <= 6) {
				format(WeaponString,sizeof(WeaponString),"%s%s: %d ", WeaponString, WeaponNames[WeaponID2], Ammo2);
			}
		}
	}

	if(!weaponsfound) {
		format(WeaponString, sizeof(WeaponString),"%sFist", WeaponString);
	}

	return WeaponString;
}
//SpawnPlayerInArea(playerid, Area[areaid][aPos][0], Area[areaid][aPos][1], Area[areaid][aPos][2], Area[areaid][aPos][3]);

stock Float:floatrandom(Float:max, Float:min = 0.0, decimalPlaces = 4) {
    new
        Float:multiplier = floatpower(10.0, decimalPlaces),
        minRounded = floatround(min * multiplier),
        maxRounded = floatround(max * multiplier);
    return float(random(maxRounded - minRounded) + minRounded) / multiplier;
}

stock SpawnPlayerInArea(playerid, Float:minx, Float:miny, Float:maxx, Float:maxy)
{
    new Float:posx, Float: posy, Float: posz, Float:sizex, Float:sizey;
    sizex = floatrandom(0, (maxx - minx));
    sizey = floatrandom(0, (maxy - miny));
    posx = minx + sizex;
    posy = miny + sizey;
    MapAndreas_FindAverageZ(posx, posy, posz);
    SetPlayerPos(playerid, posx, posy, posz);
    printf("%f, %f, %f", posx, posy, posz);
}
/*
stock RandomSpawn(Float:minx, Float:miny, Float:maxx, Float:maxy)
{
    new Float:posx, Float: posy, Float: posz, Float:sizex, Float:sizey;
    sizex = floatrandom(0, (maxx - minx));
    sizey = floatrandom(0, (maxy - miny));
    posx = minx + sizex;
    posy = miny + sizey;
    MapAndreas_FindZ_For2DCoord(posx, posy, posz);
    printf("%f, %f, %f", posx, posy, posz);
	return posx, posy, posz;
}*/

stock LoadStaticVehiclesFromFile(const filename[])
{
	new File:file_ptr;
	new line[256];
	new var_from_line[64];
	new vehicletype;
	new Float:SpawnX;
	new Float:SpawnY;
	new Float:SpawnZ;
	new Float:SpawnRot;
    new Color1, Color2;
	new index;
	new vehicles_loaded;

	file_ptr = fopen(filename,filemode:io_read);
	if(!file_ptr) return 0;

	vehicles_loaded = 0;

	while(fread(file_ptr,line,256) > 0)
	{
	    index = 0;

	    // Read type
  		index = token_by_delim(line,var_from_line,',',index);
  		if(index == (-1)) continue;
  		vehicletype = strval(var_from_line);
   		if(vehicletype < 400 || vehicletype > 611) continue;

  		// Read X, Y, Z, Rotation
  		index = token_by_delim(line,var_from_line,',',index+1);
  		if(index == (-1)) continue;
  		SpawnX = floatstr(var_from_line);

  		index = token_by_delim(line,var_from_line,',',index+1);
  		if(index == (-1)) continue;
  		SpawnY = floatstr(var_from_line);

  		index = token_by_delim(line,var_from_line,',',index+1);
  		if(index == (-1)) continue;
  		SpawnZ = floatstr(var_from_line);

  		index = token_by_delim(line,var_from_line,',',index+1);
  		if(index == (-1)) continue;
  		SpawnRot = floatstr(var_from_line);

  		// Read Color1, Color2
  		index = token_by_delim(line,var_from_line,',',index+1);
  		if(index == (-1)) continue;
  		Color1 = strval(var_from_line);

  		index = token_by_delim(line,var_from_line,';',index+1);
  		Color2 = strval(var_from_line);
  		
  		//printf("%d,%.2f,%.2f,%.2f,%.4f,%d,%d",vehicletype,SpawnX,SpawnY,SpawnZ,SpawnRot,Color1,Color2);
  		
  		SetVehicleNumberPlate(CreateVehicle(vehicletype,SpawnX,SpawnY,SpawnZ,SpawnRot,Color1,Color2,(30*60)),"{FFFF00}HDM"); // respawn 30 minutes
	
		vehicles_loaded++;
	}

	fclose(file_ptr);
	printf("Loaded %d vehicles from: %s",vehicles_loaded,filename);
	return vehicles_loaded;
}

stock token_by_delim(const string[], return_str[], delim, start_index)
{
	new x=0;
	while(string[start_index] != EOS && string[start_index] != delim) {
	    return_str[x] = string[start_index];
	    x++;
	    start_index++;
	}
	return_str[x] = EOS;
	if(string[start_index] == EOS) start_index = (-1);
	return start_index;
}

pinfo(playerid){
	new string[1024];
	
	format(string, sizeof(string), "SAMP Version: %s / IP: %s / Country: %s / City: %s \nNick: %s / Gang: %s / Skinid: %d \nPoints: %d / Kills: %d / Deaths: %d\n%s", 
	ver(playerid), PlayerIP(playerid), PlayerCountry(playerid), PlayerCity(playerid), PlayerName(playerid), Gang[PlayerData[playerid][GangID]][gName], GetPlayerSkin(playerid), PlayerData[playerid][Points], PlayerData[playerid][Kills], PlayerData[playerid][Deaths], WeaponInfo(playerid));

	return string;
}

StartAreaID(newarea)
{
	//update
	new areaid, Query[128], string[256];
	new DBResult: Result;

	DestroySniperDrop();
	DestroyHorseshoe();
	KillTimer(AreaTimer);
    for(new i=0; i<areasavilable; i++)
    {
        if(Area[i][AreaPlayed])
        {
            areaid = i;
            break;
        }
    }

    for(new i=0; i<MAX_GANGS; i++)
    {
         if(Gang[i][gID] != 0)
           {
            format(Query, sizeof(Query), "UPDATE `area_points` SET `gangpoints` = %d WHERE `gangid` = %d AND `areaid` = %d", Area[areaid][GangPoints][i], i, areaid);
            db_query(General, Query);
			//SendClientMessageToAll(-1, Query);
        }
    }
        
	for(new id=0; id<1; id++)
	{
		new gangid;
		format(Query, sizeof(Query), "SELECT `gangid` FROM `area_points` WHERE `areaid` = %d ORDER BY `gangpoints` DESC LIMIT 1", areaid);
		Result = db_query(General, Query);
		gangid = db_get_field_assoc_int(Result, "gangid");
		GangZoneHideForAll(Area[areaid][aSampID]);
		GangZoneShowForAll(Area[areaid][aSampID], Gang[gangid][gColor]);
	}
	
	db_free_result(Result);

	//start

	new sid;
	foreach(new i : Player)
	{
	    if(IsPlayerConnected(i))
	    {
			if(PlayerData[i][afk] == 0 && PlayerData[i][onede] == 0 && PlayerData[i][sawn] == 0 && PlayerData[i][inGWAR] == 0)
			{
            sid = random(MAX_SPAWNS);
			PlayerPlaySound(i, 0, 0, 0, 0);
	        SetPlayerPos(i, Spawn[newarea][sid][sPos][0], Spawn[newarea][sid][sPos][1], Spawn[newarea][sid][sPos][2]);
	        SetPlayerFacingAngle(i, Spawn[newarea][sid][sPos][3]);
	        SetCameraBehindPlayer(i);
			}
		}
	}
	
	for(new i=0; i<areasavilable; i++)
	    if(Area[i][AreaPlayed])
	        Area[i][AreaPlayed] = false;
	Area[newarea][AreaPlayed] = true;
 	CurrentArea = newarea;

	for(new i=0; i<MAX_GANGS; i++)
	{
	    format(Query, sizeof(Query), "SELECT * FROM `area_points` WHERE `gangid`= %d AND `areaid` = %d", i, newarea);
	    Result = db_query(General, Query);

	    if(db_num_rows(Result) > 0)
	    {
	        Area[newarea][GangPoints][i] = db_get_field_assoc_int(Result, "gangpoints");
	   		//printf("%d", Area[areaid][GangPoints][i]);
		}
		//printf("%s", Query);
	}
	
	foreach(new i : Player)
	{
		
		hideHorseshoe(i);
		PlayerData[i][podkowa1] = 0;
		
		hideSniperInfo(i);
		PlayerData[i][sniperdrop] = 0;

		if(PlayerData[i][LoggedIn] == true)
		{	
			if(PlayerData[i][afk] == 0 && PlayerData[i][onede] == 0 && PlayerData[i][sawn] == 0 && PlayerData[i][inGWAR] == 0)
			{
			new stringz[512];			
			TogglePlayerControllable(i, 1);
			strcat(stringz, "0\tNone\n24\tDeagle\n25\tShotgun\n29\tMP5\n31\tM4\n33\tRifle");
			ShowPlayerDialog(i, D_SELECT_FIRST_WEAPON, DIALOG_STYLE_LIST, "Hardcore DM - Weapon Selection (1/4)", stringz, "Select", "Cancel");
			ShowGangZones(i);
			}
		}
	}	

	AreaM = 12;
	AreaS = 59;
	format(string, sizeof(string), "Hardcore DM: New map %s has been started!", Area[newarea][aName]);
	Area[newarea][aHorseshoe] = 0;
	Area[newarea][aSniperdrop] = 0;
	SendClientMessageToAll(COLOR_AREA, string);
	//printf("%s", string);
	AreaTimer = SetTimer("AreaTime", 1000, true);
	SetTimer("Horseshoe", 2*60000, false);
	SetTimer("Sniperdrop", 1*60000, false);
	return 1;
}

forward Float:GetPlayerSpeed(playerid);
public Float:GetPlayerSpeed(playerid)
{
	new Float: fVelocity[3];
	GetPlayerVelocity(playerid, fVelocity[0], fVelocity[1], fVelocity[2]);
	return floatsqroot((fVelocity[0] * fVelocity[0]) + (fVelocity[1] * fVelocity[1]) + (fVelocity[2] * fVelocity[2])) * 100;
}

//**********GANGWAR SYSTEM**********//

forward GangWarTimer();
public GangWarTimer()
{
	new string[512];
	GWS--;
	format(string, sizeof(string), "Gang War ~y~%s (%d) ~w~vs. ~y~%s (%d)~w~~n~Starts in: ~y~%d~w~:~y~%02d~n~~w~Joined Players:~y~ %d/%d", Gang[GangWar[GANG1ID]][gTag], GangWar[Gang1Players], Gang[GangWar[GANG2ID]][gTag], GangWar[Gang2Players], GWM, GWS, GangWar[Gang1Players] + GangWar[Gang2Players], GangWar[PlayersLimit]*2);
	TextDrawSetString(HDM_GangWarInstructions, string);
	if(GWS == 15 && GangWar[Gang1Players] + GangWar[Gang2Players] < GangWar[PlayersLimit]*2)
	{
		GangWar[GANG1ID] = 0;
		GangWar[GANG2ID] = 0;
		GangWar[Gang1Points] = 0;
		GangWar[Gang2Points] = 0;
		GangWar[RoundsPlayed] = 0;
		GangWar[GangWarONOFF] = 0;
		GangWar[RoundsPlayed] = 0;
		GangWar[CBUG] = 0;
		foreach(new i : Player)PlayerData[i][inGWAR] = 0, hideGangWarInstr(i), SendClientMessage(i, COLOR_PINK, "Gang War: Canceled not enough players.");
		return 1;
	}

	if(GangWar[Gang1Players] + GangWar[Gang2Players] == GangWar[PlayersLimit]*2)
	{
		SpawnAndStart();
		return 1;
	}
	return SetTimer("GangWarTimer", 1000, false);
}

ListGangsGW(playerid)
{
	new string[512];
	for(new i=1; i<MAX_GANGS; i++)
	{
		if(CheckGOwnerOnline(i) == 1 && PlayerData[playerid][Name] != Gang[i][gOwner])
		format(string, sizeof(string),"%s%d. %s\n", string, i, Gang[i][gName]);
	}
	return string;
}

CheckGOwnerOnline(challgangid)
{
	foreach(new i : Player)
	{
		if(PlayerData[i][Name] == Gang[challgangid][gOwner])
		return 1;
	}
	return 0;
}

forward LoadArena();
public LoadArena()
{
	new arenaID = minrand(0, maxarenas), rand = random(2), string[512];

	CurrentArena = arenaID;
	sscanf(GetArenaCfg(arenaID, AINI_HOME), "fff", GWROUND[center][0], GWROUND[center][1], GWROUND[center][2]);
	GWROUND[int] = strval(GetArenaCfg(arenaID, AINI_INTERIOR));
	sscanf(GetArenaCfg(arenaID, rand == 0 ? (AINI_SPAWN1) : (AINI_SPAWN2)), "fff", GWROUND[G1Spawn][0], GWROUND[G1Spawn][1], GWROUND[G1Spawn][2]);
	sscanf(GetArenaCfg(arenaID, rand == 0 ? (AINI_SPAWN2) : (AINI_SPAWN1)), "fff", GWROUND[G2Spawn][0], GWROUND[G2Spawn][1], GWROUND[G2Spawn][2]);
	sscanf(GetArenaCfg(arenaID, AINI_AREA), "ffff", GWROUND[Arena][0], GWROUND[Arena][1], GWROUND[Arena][2], GWROUND[Arena][3]);
	GWROUND[ArenaZone] = GangZoneCreate(GWROUND[Arena][0], GWROUND[Arena][2], GWROUND[Arena][1], GWROUND[Arena][3]);
	format(string, sizeof(string), "Arena %d Starting...", arenaID);
	TextDrawSetString(HDM_GangWarStartArenaInfo, string);
	ArenaListAdd();
	StartRound();
	TRound = 4;
	Dron();
	GWROUND[SniperLimitT1] = 0;
	GWROUND[SniperLimitT2] = 0;
	return 1;
}

SpawnGangWarPlayerInLobby(playerid)
{
	new spawn = random(sizeof(RandomSpawnGangWarLobby));
	
	if(PlayerData[playerid][GangID] == GangWar[GANG1ID] || PlayerData[playerid][GangID] == GangWar[GANG2ID])
	{
		ResetPlayerWeapons(playerid);
		SetPlayerPos(playerid, RandomSpawnGangWarLobby[spawn][0],RandomSpawnGangWarLobby[spawn][1],RandomSpawnGangWarLobby[spawn][2]+1);
		SetPlayerFacingAngle(playerid, RandomSpawnGangWarLobby[spawn][3]);
		SetPlayerInterior(playerid, 10);
		SetPlayerVirtualWorld(playerid, 2);
		PlayerData[playerid][inGWAR] = 1;
		hideGangControl(playerid);
		hidePlayerHud(playerid);
		hideCountDown(playerid);
		hideSpecPlayerInfo(playerid);
		hideSniperInfo(playerid);
		TextDrawHideForPlayer(playerid, HDM_SniperDropInfo);
		hideGangWarInfo(playerid);
		showGangWarInfo(playerid);
		showGangWarInstr(playerid);
		PlayerTextDrawShow(playerid, HDM_GWPlayerStats[playerid]);
		TogglePlayerControllable(playerid, true);
		TogglePlayerSpectating(playerid, false);
		SetCameraBehindPlayer(playerid);
		for(new i=0; i<areasavilable; i++)
			GangZoneHideForPlayer(playerid, i);
	}
	return 1;
}

SpawnAndStart()
{
	foreach(new i : Player)
	{
		if(GangPlayer[i][ReadyGW] == 1)SpawnGangWarPlayerInLobby(i);
	}
	new string[256];
	format(string, sizeof(string), "Hardcore DM: Gang war between %s and %s has been started.", Gang[GangWar[GANG1ID]][gName], Gang[GangWar[GANG2ID]][gName]);
	SendClientMessageToAll(COLOR_PINK, string);
	format(string, sizeof(string), "~y~%s (%d) ~w~vs. ~y~%s (%d)~w~~n~Rounds: ~y~1~w~/~y~6", Gang[GangWar[GANG1ID]][gTag], GangWar[Gang1Players], Gang[GangWar[GANG2ID]][gTag], GangWar[Gang2Players]);
	TextDrawSetString(HDM_GangwarBarInfo, string);
	GWNextS = 30;
	Round();
	return 1;
}

StartRound()
{
	foreach(new i : Player)
	{
		if(PlayerData[i][inGWAR] == 1)
		{
			PlayerPlaySound(i, 1187, 0, 0, 0);
			showStartArena(i);
			hideGangWarInstr(i);
			hideGangControl(i);
			hidePlayerHud(i);
			hideGangWarInfo(i);	
			GangPlayer[i][Weapon][0] = 0;
			GangPlayer[i][Weapon][1] = 0;
		}
	}
	new Float: camPos[3];
	static tmp_LastCameraRandomAngle;
	new randomangle = tmp_LastCameraRandomAngle + 90;
	do
	{
		randomangle = random(360);
	}
	while(randomangle == tmp_LastCameraRandomAngle);
	tmp_LastCameraRandomAngle = randomangle;
	GangWar[RoundsPlayed]++;
	foreach(new i : Player)
	{
		if(PlayerData[i][inGWAR] == 1)
		{
			SetPlayerInterior(i, GWROUND[int]);
			SetPlayerPos(i, GWROUND[center][0], GWROUND[center][1], GWROUND[center][2] - 5.0);
			TogglePlayerControllable(i, false);
			TogglePlayerSpectating(i, true);
			GetPlayerCameraPos(i, camPos[0], camPos[1], camPos[2]);
			InterpolateCameraPos(i, camPos[0], camPos[1], camPos[2], GWROUND[center][0] + (100.0 * floatsin(randomangle, degrees)), GWROUND[center][1] + (100.0 * floatcos(randomangle, degrees)), GWROUND[center][2] + 30.0, 1350, CAMERA_MOVE);
			InterpolateCameraLookAt(i, GWROUND[center][0], GWROUND[center][1], GWROUND[center][2], GWROUND[center][0], GWROUND[center][1], GWROUND[center][2], 1350, CAMERA_CUT);
			ShowGWWeaponMenu(i);
		}
	}
	return 1;
}

StartGangWar(playerid)
{
    new string[512];
	if(GangWar[GANG2ID] > 0 && GangWar[PlayersLimit] >= 2)
	{
		GangWar[Gang1Points] = 0;
		GangWar[Gang2Points] = 0;
		GangWar[RoundsPlayed] = 0;
		GWS = 45, GangWar[GangWarONOFF] = 1;
		TextDrawColor(HDM_GangWarInfoG1, Gang[GangWar[GANG1ID]][gColor]);
		TextDrawColor(HDM_GangWarInfoG2, Gang[GangWar[GANG2ID]][gColor]);
		SetTimer("GangWarTimer", 1000, false);
		for(new i=0; i<CADD_SAVES; i++)CADDPlayer[i][nickname] = 0;
		foreach(new i : Player)
		{
			if(PlayerData[i][GangID] == GangWar[GANG2ID])
			{
				format(string, sizeof(string), "Gang War: Twoj gang zostal wyzwany na pojedynek przez %s uzyj /joinwar aby zapisac sie na sparing", Gang[GangWar[GANG1ID]][gName]);
				SendClientMessage(i, COLOR_ORANGE, string);
				showGangWarInstr(i);
			}
			if(PlayerData[i][GangID] == GangWar[GANG1ID])
			{
				format(string, sizeof(string), "Gang War: Twoj gang wyzwal na pojedynek %s uzyj /joinwar aby zapisac sie na sparing", Gang[GangWar[GANG2ID]][gName]);
				SendClientMessage(i, COLOR_ORANGE, string);
				showGangWarInstr(i);
			}
		}
	}	
	else if(GangWar[GANG2ID] == 0)
	{
		SendClientMessage(playerid, COLOR_PINK, "Gang War: You need to choose a gang"); 
		return 1;
	}
	else if(GangWar[PlayersLimit] < 2)
	{
		SendClientMessage(playerid, COLOR_PINK, "Gang War: Players limit not set"); 
		return 1;		 
	}
	return 1;
}


RoundStart()
{
	GangWar[ActiveRound] = 1;
	GangWar[Pause] = 0;
	RoundM = 1;
	RoundS = 0;
	ResetScoreBoard();
	foreach(new i : Player)
	{	
		if(PlayerData[i][inGWAR] == 1)
		{
			PlayerPlaySound(i, 0, 0, 0, 0);
			HideGangZone(i);
			TogglePlayerSpectating(i, false);
			TogglePlayerControllable(i, true);
			SetPlayerInterior(i, GWROUND[int]);
			SetPlayerVirtualWorld(i, 112);
			if(PlayerData[i][GangID] == GangWar[GANG1ID])
			{
				SetPlayerPos(i, GWROUND[G1Spawn][0], GWROUND[G1Spawn][1], GWROUND[G1Spawn][2]);
				GangPlayer[i][OnArena] = 1;
			}
			else if(PlayerData[i][GangID] == GangWar[GANG2ID])
			{
				SetPlayerPos(i, GWROUND[G2Spawn][0], GWROUND[G2Spawn][1], GWROUND[G2Spawn][2]);
				GangPlayer[i][OnArena] = 1;
			}
			GangZoneShowForPlayer(i, GWROUND[ArenaZone], 0xFBCC007D);
			GangZoneStopFlashForPlayer(i, GWROUND[ArenaZone]);
			GangZoneFlashForPlayer(i, GWROUND[ArenaZone], 0xFFFFFF00);
			SetCameraBehindPlayer(i);
			PlayerPlaySound(i, 1057, 0, 0, 0);
			SetPlayerHealth(i, 100.0);
			if(GangWar[Armours] == 1)SetPlayerArmour(i, 100.0);
			ResetArenaStats(i);
			hideStartArena(i);
			hideGangControl(i);
			hidePlayerHud(i);
			hideGangWarInstr(i);
			hideGangWarInfo(i);
			showGangWarInfo(i);
			ResetPlayerWeapons(i);
			GiveWeaponsArena(i);
		}
	}	
	return 1;
}

forward Dron();
public Dron()
{
	if(TRound == 0) 
	{
		RoundStart();
	    return 1;
	}
	new Float: camPos[3];
	static tmp_LastCameraRandomAngle;
	new randomangle = tmp_LastCameraRandomAngle + 90;
	do
	{
		randomangle = random(360);
	}
	while(randomangle == tmp_LastCameraRandomAngle);
	tmp_LastCameraRandomAngle = randomangle;
	
	foreach(new i : Player)
	{
		if(PlayerData[i][inGWAR] == 1)
		{	
			GetPlayerCameraPos(i, camPos[0], camPos[1], camPos[2]);
			InterpolateCameraPos(i, camPos[0], camPos[1], camPos[2], GWROUND[center][0] + (100.0 * floatsin(randomangle, degrees)), GWROUND[center][1] + (100.0 * floatcos(randomangle, degrees)), GWROUND[center][2] + 30.0, 1350, CAMERA_MOVE);
			InterpolateCameraLookAt(i, GWROUND[center][0], GWROUND[center][1], GWROUND[center][2], GWROUND[center][0], GWROUND[center][1], GWROUND[center][2], 1350, CAMERA_CUT);
		}
	}
	TRound--;
	return SetTimer("Dron", 2000, false);
}

ResetArenaStats(playerid)
{
	GangPlayer[playerid][ArenaKills] = 0;
	GangPlayer[playerid][ArenaDMG] = 0;
	GangPlayer[playerid][GunMenu] = 0;
	GangPlayer[playerid][Weapon][0] = 0;
	GangPlayer[playerid][Weapon][1] = 0;	
}

HideGangZone(playerid)
{
	for(new i=0; i<MAX_AREAS; i++)
	{
		GangZoneHideForPlayer(playerid, i);
	}
	return 1;
}

GiveWeaponsArena(playerid)
{
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, GangPlayer[playerid][Weapon][0], 9999);
	GivePlayerWeapon(playerid, GangPlayer[playerid][Weapon][1], 9999);
	return 1;
}

TeamInfo()
{
	foreach(new i : Player)
	{
		new Float:HP = GetPlayerHealth(i, HP), Float:AP = GetPlayerArmour(i, AP), string[1024]; 
		if(PlayerData[i][GangID] == GangWar[GANG1ID] && PlayerData[i][inGWAR] == 1 && GangWar[ActiveRound] == 1)
		{
			format(string, sizeof(string), "~y~%s:~n~\n%s~y~%s ~w~HP:~y~%.0f ~w~AP:~y~%.0f\n", Gang[GangWar[GANG1ID]][gName], string, PlayerName(i), HP, AP);
			PlayerTextDrawSetString(i, HDM_GangWarTeamInfo[i], string);
		}
	}	
	
	foreach(new i : Player)
	{
		new Float:HP = GetPlayerHealth(i, HP), Float:AP = GetPlayerArmour(i, AP), string2[1024]; 
		if(PlayerData[i][GangID] == GangWar[GANG2ID] && PlayerData[i][inGWAR] == 1 && GangWar[ActiveRound] == 1)
		{
			format(string2, sizeof(string2), "~y~%s:~n~\n%s~y~%s ~w~HP:~y~%.0f ~w~AP:~y~%.0f\n", Gang[GangWar[GANG2ID]][gName], string2, PlayerName(i), HP, AP);
			PlayerTextDrawSetString(i, HDM_GangWarTeamInfo[i], string2);
		}
	}

	foreach(new i : Player)
	if(PlayerData[i][inGWAR] == 1 && GangWar[ActiveRound] == 0)
	{
		new string2[1];
		format(string2, sizeof(string2), "_");
		PlayerTextDrawSetString(i, HDM_GangWarTeamInfo[i], string2);
	}
	return 1;
}

RoundCheckWinner()
{
	new string[128];
	if(GangWar[GangWarONOFF] == 1 && GangWar[ActiveRound] == 1 && GangWar[Pause] == 0 && GangWar[Crash] == 0)
	{
		if(TeamHP[1] == 0 || PlayersAlive[1] == 0 && GangWar[Pause] == 0 && GangWar[Crash] == 0)
		{
			foreach(new i : Player)
			{
				if(PlayerData[i][GangID] == GangWar[GANG1ID])
				{
					SendClientMessage(i, COLOR_PINK, "Gang War: Your Gang won this round");
					PlayerPlaySound(i, 36205, 0, 0, 0);
					G1ArenaList(1);
				}
				else if(PlayerData[i][GangID] == GangWar[GANG2ID])
				{
					SendClientMessage(i, COLOR_PINK, "Gang War: Your Gang lost this round");
					PlayerPlaySound(i, 5203, 0, 0, 0);
					G2ArenaList(2);
				}
			}
			GangWar[Gang1Points]++;
			format(string, sizeof(string), "%s wins this round!", Gang[GangWar[GANG1ID]][gName]);
			TextDrawColor(HDM_GWScoreBoardEndInfo, Gang[GangWar[GANG1ID]][gColor]);
			TextDrawSetString(HDM_GWScoreBoardEndInfo, string);
			EndRound();
		}
		else if(TeamHP[1] < TeamHP[0] && RoundM == 0 && RoundS == 0 && GangWar[Pause] == 0 && GangWar[Crash] == 0)
		{
			foreach(new i : Player)
			{
				if(PlayerData[i][GangID] == GangWar[GANG1ID])
				{
					SendClientMessage(i, COLOR_PINK, "Gang War: Your Gang won this round");
					PlayerPlaySound(i, 36205, 0, 0, 0);
					G1ArenaList(1);
				}
				else if(PlayerData[i][GangID] == GangWar[GANG2ID])
				{
					SendClientMessage(i, COLOR_PINK, "Gang War: Your Gang lost this round");
					PlayerPlaySound(i, 5203, 0, 0, 0);
					G2ArenaList(2);
				}
			}
			GangWar[Gang1Points]++;
			format(string, sizeof(string), "%s wins this round!", Gang[GangWar[GANG1ID]][gName]);
			TextDrawColor(HDM_GWScoreBoardEndInfo, Gang[GangWar[GANG1ID]][gColor]);
			TextDrawSetString(HDM_GWScoreBoardEndInfo, string);
			EndRound();
		}
		else if(TeamHP[0] == 0 || PlayersAlive[0] == 0 && GangWar[Pause] == 0 && GangWar[Crash] == 0)
		{
			foreach(new i : Player)
			{
				if(PlayerData[i][GangID] == GangWar[GANG2ID])
				{
					SendClientMessage(i, COLOR_PINK, "Gang War: Your Gang won this round");
					PlayerPlaySound(i, 36205, 0, 0, 0);
					G2ArenaList(1);
				}
				else if(PlayerData[i][GangID] == GangWar[GANG1ID])
				{
					SendClientMessage(i, COLOR_PINK, "Gang War: Your Gang lost this round");
					PlayerPlaySound(i, 5203, 0, 0, 0);
					G1ArenaList(2);
				}
			}
			GangWar[Gang2Points]++;
			format(string, sizeof(string), "%s wins this round!", Gang[GangWar[GANG2ID]][gName]);
			TextDrawColor(HDM_GWScoreBoardEndInfo, Gang[GangWar[GANG2ID]][gColor]);
			TextDrawSetString(HDM_GWScoreBoardEndInfo, string);
			EndRound();
		}
		else if(TeamHP[1] > TeamHP[0] && RoundM == 0 && RoundS == 0 && GangWar[Pause] == 0 && GangWar[Crash] == 0)
		{
			foreach(new i : Player)
			{
				if(PlayerData[i][GangID] == GangWar[GANG2ID])
				{
					SendClientMessage(i, COLOR_PINK, "Gang War: Your Gang won this round");
					PlayerPlaySound(i, 36205, 0, 0, 0);
					G2ArenaList(1);
				}
				else if(PlayerData[i][GangID] == GangWar[GANG1ID])
				{
					SendClientMessage(i, COLOR_PINK, "Gang War: Your Gang lost this round");
					PlayerPlaySound(i, 5203, 0, 0, 0);
					G1ArenaList(2);
				}
			}
			GangWar[Gang2Points]++;
			format(string, sizeof(string), "%s wins this round!", Gang[GangWar[GANG2ID]][gName]);
			TextDrawColor(HDM_GWScoreBoardEndInfo, Gang[GangWar[GANG2ID]][gColor]);
			TextDrawSetString(HDM_GWScoreBoardEndInfo, string);
			EndRound();
		}
		else if(TeamHP[0] == TeamHP[1] && PlayersAlive[0] == PlayersAlive[1] && RoundM == 0 && RoundS == 0 && GangWar[Pause] == 0 && GangWar[Crash] == 0)
		{
			foreach(new i : Player)
			{
				if(PlayerData[i][GangID] == GangWar[GANG2ID])
				{
					SendClientMessage(i, COLOR_PINK, "Gang War: Draw!");
					PlayerPlaySound(i, 36200, 0, 0, 0);
					G2ArenaList(3);
				}
				else if(PlayerData[i][GangID] == GangWar[GANG1ID])
				{
					SendClientMessage(i, COLOR_PINK, "Gang War: Draw!");
					PlayerPlaySound(i, 36200, 0, 0, 0);
					G1ArenaList(3);
				}
			}
			format(string, sizeof(string), "No winner. Draw!");
			TextDrawColor(HDM_GWScoreBoardEndInfo, -1);
			TextDrawSetString(HDM_GWScoreBoardEndInfo, string);
			EndRound();
		}
	}
	return 1;
}

EndRound()
{
	new string[256];
	new Float: camPos[3];
	static tmp_LastCameraRandomAngle;
	new randomangle = tmp_LastCameraRandomAngle + 90;
	GangWar[ActiveRound] = 0;
	GangZoneDestroy(GWROUND[ArenaZone]);
	do
	{
		randomangle = random(360);
	}
	while(randomangle == tmp_LastCameraRandomAngle);
	tmp_LastCameraRandomAngle = randomangle;
	foreach(new i : Player)
	{
		SetPlayerInterior(i, GWROUND[int]);
		SetPlayerPos(i, GWROUND[center][0], GWROUND[center][1], GWROUND[center][2] - 5.0);
		TogglePlayerControllable(i, false);
		TogglePlayerSpectating(i, true);
		GetPlayerCameraPos(i, camPos[0], camPos[1], camPos[2]);
		InterpolateCameraPos(i, camPos[0], camPos[1], camPos[2], GWROUND[center][0] + (100.0 * floatsin(randomangle, degrees)), GWROUND[center][1] + (100.0 * floatcos(randomangle, degrees)), GWROUND[center][2] + 30.0, 1350, CAMERA_MOVE);
		InterpolateCameraLookAt(i, GWROUND[center][0], GWROUND[center][1], GWROUND[center][2], GWROUND[center][0], GWROUND[center][1], GWROUND[center][2], 1350, CAMERA_CUT);
		hideGangWarInstr(i);
	}
	if(GangWar[RoundsPlayed] == 6)
	{
		format(string, sizeof(string), "Gang War: Gang War has been ended. %s (%d):(%d) %s", GangWar[RoundsPlayed], Gang[GangWar[GANG1ID]][gName], GangWar[Gang1Points], GangWar[Gang2Points], Gang[GangWar[GANG2ID]][gName]);	foreach(new i : Player)
		foreach(new x : Player)
		{
			if(PlayerData[x][inGWAR] == 1)
			{
				PrepareFinalResult();
				showFinalResult(x);
				PlayerPlaySound(x, 19800, 0, 0, 0);
				SendClientMessage(x, COLOR_PINK, "Gang War: In few seconds you will be back in to the zones again. You can save result of this gang war. Use F8");
			}
			if(PlayerData[x][inGWAR] == 0)
				SendClientMessage(x, COLOR_PINK, string);				
		}
		SetTimer("EndGangWar", 15000, false);
		return 1;
	}	
	else if(GangWar[RoundsPlayed] < 6)
	{
		ScoreBoardRound();
	}
	SetTimer("HideScoreBoardRound", 6000, false);
	GWNextS = 15;
	format(string, sizeof(string), "Gang War: Round %d/6 has been ended. %s (%d):(%d) %s", GangWar[RoundsPlayed], Gang[GangWar[GANG1ID]][gName], GangWar[Gang1Points], GangWar[Gang2Points], Gang[GangWar[GANG2ID]][gName]);
	foreach(new i : Player)
	{
		if(PlayerData[i][inGWAR] == 0)SendClientMessage(i, COLOR_PINK, string);
	}
	return 1;
}

forward HideScoreBoardRound();
public HideScoreBoardRound()
{
	foreach(new i : Player)hideScoreBoardRound(i), SpawnGangWarPlayerInLobby(i);
	Round();
	return 1;
}

forward HideFinalResult();
public HideFinalResult()
{
	foreach(new i : Player)hideFinalResult(i), PlayerPlaySound(i, 0, 0, 0, 0);
	return 1;	
}


PrepareFinalResult()
{
	new string[512], h, m, day, month, year;

	gettime(h,m);
	getdate(year, month, day);
	format(string, sizeof(string), "%02d:%02d - %02d/%02d/%d", h, m, day, month, year);
	TextDrawSetString(HDM_FinalBoardTimeDate, string);
	PrepareFinalDataG1();
	PrepareFinalDataG2();
	TextDrawColor(HDM_FinalBoardBG, 180);
	format(string, sizeof(string), "%s", Gang[GangWar[GANG1ID]][gName]);
	TextDrawColor(HDM_FinalBoardGang1, Gang[GangWar[GANG1ID]][gColor]);
	TextDrawSetString(HDM_FinalBoardGang1, string);

	format(string, sizeof(string), "%s", Gang[GangWar[GANG2ID]][gName]);
	TextDrawColor(HDM_FinalBoardGang2, Gang[GangWar[GANG2ID]][gColor]);
	TextDrawSetString(HDM_FinalBoardGang2, string);
	
	TextDrawColor(HDM_FinalBoardG1Info, -1);
	TextDrawBoxColor(HDM_FinalBoardG1Info, Gang[GangWar[GANG1ID]][gColor]);

	TextDrawColor(HDM_FinalBoardG2Info, -1);
	TextDrawBoxColor(HDM_FinalBoardG2Info, Gang[GangWar[GANG2ID]][gColor]);
	
	TextDrawColor(HDM_FinalBoardG1Pinfo, -1);
	TextDrawBoxColor(HDM_FinalBoardG1Pinfo, Gang[GangWar[GANG1ID]][gColor]);

	TextDrawColor(HDM_FinalBoardG2Pinfo, -1);
	TextDrawBoxColor(HDM_FinalBoardG2Pinfo, Gang[GangWar[GANG2ID]][gColor]);

	format(string, sizeof(string), "%d", GangWar[Gang1Points]);
	TextDrawSetString(HDM_FinalBoardG1Points, string);
	TextDrawColor(HDM_FinalBoardG1Points, Gang[GangWar[GANG1ID]][gColor]);

	format(string, sizeof(string), "%d", GangWar[Gang2Points]);
	TextDrawSetString(HDM_FinalBoardG2Points, string);
	TextDrawColor(HDM_FinalBoardG2Points, Gang[GangWar[GANG2ID]][gColor]);

	if(GangWar[Gang1Points] > GangWar[Gang2Points])
	{
		format(string, sizeof(string), "%s ~y~wins this Gangwar", Gang[GangWar[GANG1ID]][gName]);
		TextDrawColor(HDM_FinalBoardResult, Gang[GangWar[GANG1ID]][gColor]);
		TextDrawSetString(HDM_FinalBoardResult, string);
	}
	else if(GangWar[Gang1Points] < GangWar[Gang2Points])
	{
		format(string, sizeof(string), "%s ~y~wins this Gangwar", Gang[GangWar[GANG2ID]][gName]);
		TextDrawColor(HDM_FinalBoardResult, Gang[GangWar[GANG2ID]][gColor]);
		TextDrawSetString(HDM_FinalBoardResult, string);		
	}
	else if(GangWar[Gang1Points] == GangWar[Gang2Points])
	{
		format(string, sizeof(string), "Draw!");
		TextDrawColor(HDM_FinalBoardResult, -1);
		TextDrawSetString(HDM_FinalBoardResult, string);		
	}
}

forward Round();
public Round()
{
	new string[512];
	if(GangWar[GangWarONOFF] == 1)
	{
		if(GangWar[ActiveRound] == 0 && GangWar[RoundsPlayed] < 6)
		{
			format(string, sizeof(string), "Round will start in %02d seconds", GWNextS);
			TextDrawSetString(HDM_GangWarInstructions, string);	
		}
		GWNextS--;
		if(GWNextS < 0 && GangWar[RoundsPlayed] < 6)
		{
			foreach(new i : Player)
			{
				if(PlayerData[i][inGWAR] == 1)
				{
					SendClientMessage(i, COLOR_PINK, "Gang War: Starting arena...");
					TogglePlayerControllable(i, false);
					GangWar[NextRoundCD] = 0;
				}
			}
			SetTimer("LoadArena", 2000, false);
			return 1;
		}
		return  SetTimer("Round", 1000, false);
	}
	return 1;
}

forward EndGangWar();
public EndGangWar()
{
	GangWar[GangWarONOFF] = 0;
	GangWar[GANG1ID] = 0;
	GangWar[GANG2ID] = 0;
	GangWar[Gang1Points] = 0;
	GangWar[Gang2Points] = 0;
	GangWar[RoundsPlayed] = 0;
	GangWar[CBUG] = 0;
	GangZoneDestroy(GWROUND[ArenaZone]);
	foreach(new i : Player)
	{
		SetPlayerVirtualWorld(i, 0);
		SetPlayerInterior(i, 0);
		TogglePlayerControllable(i, true);
		TogglePlayerSpectating(i, false);
		SetCameraBehindPlayer(i);
		hideArenaInfo(i);
		hideGangWarInfo(i);
		hideGangWarInstr(i);
		hideFinalResult(i);
		PlayerPlaySound(i, 0, 0, 0, 0);
		PlayerData[i][inGWAR] = 0;
		SpawnPlayer(i);
	}
	return 1;
}

ScoreBoardRound()
{
	new ArenaID[32], G1[64], G2[64];
	//arena
	format(ArenaID, sizeof(ArenaID), "~y~Arena %d", CurrentArena);	
	TextDrawSetString(HDM_GWScoreBoardArena, ArenaID);
	//g1nazwa
	format(G1, sizeof(G1), "%s", Gang[GangWar[GANG1ID]][gName]);	
	TextDrawColor(HDM_GWScoreBoardG1, Gang[GangWar[GANG1ID]][gColor]);
	TextDrawBoxColor(HDM_GWScoreBoardG1Info,Gang[GangWar[GANG1ID]][gColor]);
	TextDrawSetString(HDM_GWScoreBoardG1, G1);
	//g2nazwa
	format(G2, sizeof(G2), "%s", Gang[GangWar[GANG2ID]][gName]);
	TextDrawColor(HDM_GWScoreBoardG2, Gang[GangWar[GANG2ID]][gColor]);
	TextDrawBoxColor(HDM_GWScoreBoardG2Info, Gang[GangWar[GANG2ID]][gColor]);
	TextDrawSetString(HDM_GWScoreBoardG2, G2);
	PrepareScoreBoardDataG1();
	PrepareScoreBoardDataG2();
	foreach(new i : Player)
		if(PlayerData[i][inGWAR] == 1)showScoreBoardRound(i);
	return 1;
}

PrepareScoreBoardDataG1()
{
	new string1[512], test[128], G1String[512];
	foreach(new i : Player)
	{
		if(PlayerData[i][GangID] == GangWar[GANG1ID])
		{
			format(test, sizeof(test), "Nickname           Kills       DMG");
			format(string1, sizeof(string1), "%s           %d       %.0f", PlayerName(i), GangPlayer[i][ArenaKills], GangPlayer[i][ArenaDMG]);
		}
		else
		{
			continue;
		}
		format(GWRoundInfoPlayersG1[3], 256, GWRoundInfoPlayersG1[2]);
		format(GWRoundInfoPlayersG1[2], 256, GWRoundInfoPlayersG1[1]);
		format(GWRoundInfoPlayersG1[1], 256, GWRoundInfoPlayersG1[0]);
		format(GWRoundInfoPlayersG1[0], 256, string1);

	}
    format(G1String, sizeof(G1String), "~w~%s~n~%s~n~%s~n~%s~n~%s", test, GWRoundInfoPlayersG1[0], GWRoundInfoPlayersG1[1], GWRoundInfoPlayersG1[2], GWRoundInfoPlayersG1[3]);
    TextDrawSetString(HDM_GWScoreBoardG1Info, G1String);
	return 1;
}

PrepareScoreBoardDataG2()
{
	new string2[512], test[128], G2String[512];
	foreach(new i : Player)
	{
		if(PlayerData[i][GangID] == GangWar[GANG2ID])
		{
			format(test, sizeof(test), "Nickname           Kills       DMG");
			format(string2, sizeof(string2), "%s           %d       %.0f", PlayerData[i][Name], GangPlayer[i][ArenaKills], GangPlayer[i][ArenaDMG]);
		}
		else
		{
			continue;
		}
		format(GWRoundInfoPlayersG2[3], 256, GWRoundInfoPlayersG2[2]);
		format(GWRoundInfoPlayersG2[2], 256, GWRoundInfoPlayersG2[1]);
		format(GWRoundInfoPlayersG2[1], 256, GWRoundInfoPlayersG2[0]);
		format(GWRoundInfoPlayersG2[0], 256, string2);
	}

    format(G2String, sizeof(G2String), "~w~%s~n~%s~n~%s~n~%s~n~%s", test, GWRoundInfoPlayersG2[0], GWRoundInfoPlayersG2[1], GWRoundInfoPlayersG2[2], GWRoundInfoPlayersG2[3]);
    TextDrawSetString(HDM_GWScoreBoardG2Info, G2String);
	return 1;
}

PrepareFinalDataG1()
{
	new string1[512], test[128], G1String[512];
	foreach(new i : Player)
	{
		if(PlayerData[i][GangID] == GangWar[GANG1ID])
		{
			format(test, sizeof(test), "Nickname     Kills     Deaths     DMG");
			format(string1, sizeof(string1), "%s     %d     %d     %.0f", PlayerData[i][Name], GangPlayer[i][Kills], GangPlayer[i][Deaths], GangPlayer[i][TotalDMG]);
		}
		else
		{
			continue;
		}
		format(GWFinalPinfoG1[3], 256, GWFinalPinfoG1[2]);
		format(GWFinalPinfoG1[2], 256, GWFinalPinfoG1[1]);
		format(GWFinalPinfoG1[1], 256, GWFinalPinfoG1[0]);
		format(GWFinalPinfoG1[0], 256, string1);
	}
    format(G1String, sizeof(G1String), "~w~%s~n~%s~n~%s~n~%s~n~%s", test, GWFinalPinfoG1[0], GWFinalPinfoG1[1], GWFinalPinfoG1[2], GWFinalPinfoG1[3]);
    TextDrawSetString(HDM_FinalBoardG1Pinfo, G1String);
}

PrepareFinalDataG2()
{
	new string2[512], test[128], G2String[512];
	foreach(new d : Player)
	{
		if(PlayerData[d][GangID] == GangWar[GANG2ID])
		{
			format(test, sizeof(test), "Nickname     Kills     Deaths     DMG");
			format(string2, sizeof(string2), "%s     %d     %d     %.0f", PlayerName(d), GangPlayer[d][Kills], GangPlayer[d][Deaths], GangPlayer[d][TotalDMG]);
		}
		else
		{
			continue;
		}
		format(GWFinalPinfoG2[3], 256, GWFinalPinfoG2[2]);
		format(GWFinalPinfoG2[2], 256, GWFinalPinfoG2[1]);
		format(GWFinalPinfoG2[1], 256, GWFinalPinfoG2[0]);
		format(GWFinalPinfoG2[0], 256, string2);
	}
    format(G2String, sizeof(G2String), "~w~%s~n~%s~n~%s~n~%s~n~%s", test, GWFinalPinfoG2[0], GWFinalPinfoG2[1], GWFinalPinfoG2[2], GWFinalPinfoG2[3]);
    TextDrawSetString(HDM_FinalBoardG2Pinfo, G2String);
}

ArenaListAdd()
{
	new string2[512], astring[512];
	format(string2, sizeof(string2), "Arena %d", CurrentArena);
	format(arenas[5], 32, arenas[4]);
	format(arenas[4], 32, arenas[3]);
	format(arenas[3], 32, arenas[2]);
	format(arenas[2], 32, arenas[1]);
	format(arenas[1], 32, arenas[0]);
	format(arenas[0], 32, string2);
	format(astring, sizeof(astring), "~w~%s~n~%s~n~%s~n~%s~n~%s~n~%s", arenas[5], arenas[4], arenas[3], arenas[2], arenas[1], arenas[0]);
    TextDrawSetString(HDM_FinalBoardArenasList, astring);
}

G1ArenaList(result)
{
	new string2[512], G1astring[512];
	switch(result)
	{
		case 1: format(string2, sizeof(string2), "~g~Win");
		case 2: format(string2, sizeof(string2), "~r~Lose");
		case 3: format(string2, sizeof(string2), "~y~Tie");
	}
	format(G1Finalinfo[5], 32, G1Finalinfo[4]);
	format(G1Finalinfo[4], 32, G1Finalinfo[3]);
	format(G1Finalinfo[3], 32, G1Finalinfo[2]);
	format(G1Finalinfo[2], 32, G1Finalinfo[1]);
	format(G1Finalinfo[1], 32, G1Finalinfo[0]);
	format(G1Finalinfo[0], 32, string2);
	format(G1astring, sizeof(G1astring), "~w~%s~n~%s~n~%s~n~%s~n~%s~n~%s", G1Finalinfo[5], G1Finalinfo[4], G1Finalinfo[3], G1Finalinfo[2], G1Finalinfo[1], G1Finalinfo[0]);
    TextDrawSetString(HDM_FinalBoardG1Info, G1astring);
}

G2ArenaList(result)
{
	new string2[512], G1astring[512];
	switch(result)
	{
		case 1: format(string2, sizeof(string2), "~g~Win");
		case 2: format(string2, sizeof(string2), "~r~Lose");
		case 3: format(string2, sizeof(string2), "~y~Tie");
	}
	format(G2Finalinfo[5], 32, G2Finalinfo[4]);
	format(G2Finalinfo[4], 32, G2Finalinfo[3]);
	format(G2Finalinfo[3], 32, G2Finalinfo[2]);
	format(G2Finalinfo[2], 32, G2Finalinfo[1]);
	format(G2Finalinfo[1], 32, G2Finalinfo[0]);
	format(G2Finalinfo[0], 32, string2);
	format(G1astring, sizeof(G1astring), "~w~%s~n~%s~n~%s~n~%s~n~%s~n~%s", G2Finalinfo[5], G2Finalinfo[4], G2Finalinfo[3], G2Finalinfo[2], G2Finalinfo[1], G2Finalinfo[0]);
    TextDrawSetString(HDM_FinalBoardG2Info, G1astring);
}

ResetScoreBoard()
{
	GWRoundInfoPlayersG1[3] = "";
	GWRoundInfoPlayersG1[2] = "";
	GWRoundInfoPlayersG1[1] = "";
	GWRoundInfoPlayersG1[0] = "";
	GWRoundInfoPlayersG2[3] = "";
	GWRoundInfoPlayersG2[2] = "";
	GWRoundInfoPlayersG2[1] = "";
	GWRoundInfoPlayersG2[0] = "";
}

ChallengeGang(playerid)
{
	new string[512], armours[20], cbug[20], ff[20], startgw[24], playerslimit[20];

	if(GangWar[Armours] == 1)format(armours, sizeof(armours), "{00FF00}Yes");
	else if(GangWar[Armours] == 0)format(armours, sizeof(armours), "{FF0000}No");

	if(GangWar[CBUG] == 1)format(cbug, sizeof(cbug), "{00FF00}Yes");
	else if(GangWar[CBUG] == 0)format(cbug, sizeof(cbug), "{FF0000}No");

	if(GangWar[FF] == 1)format(ff, sizeof(ff), "{00FF00}Yes");
	else if(GangWar[FF] == 0)format(ff, sizeof(ff), "{FF0000}No");

	if(GangWar[PlayersLimit] >= 2)format(ff, sizeof(ff), "{00FF00}%d", GangWar[PlayersLimit]);
	else if(GangWar[PlayersLimit] < 2)format(ff, sizeof(ff), "{FF0000}%d", GangWar[PlayersLimit]);

	if(GangWar[GANG2ID] > 0 && GangWar[PlayersLimit] >= 2)
		format(startgw, sizeof(startgw), "{00FF00}Start Gangwar");
	else
		format(startgw, sizeof(startgw), "{FF0000}Start Gangwar");

	format(string, sizeof(string),"Gang: {%06x}%s\nPlayers per team: %d\nArmour: %s\nCBUG: %s\nFriendly Fire: %s\n%s", Gang[GangWar[GANG2ID]][gColor] >>> 8, Gang[GangWar[GANG2ID]][gName], playerslimit, armours, cbug, ff, startgw);
	ShowPlayerDialog(playerid, D_GANGCHALLENGE, DIALOG_STYLE_LIST, "Gang War: Gang War Settings", string, "Select", "Cancel");
	return 1;
}

forward GangWarScriptUpdate();
public GangWarScriptUpdate()
{
	TeamHP[0] = 0;
	TeamHP[1] = 0;
	PlayersAlive[0] = 0;
	PlayersAlive[1] = 0;
	TeamInfo();
	new G1Info[512], G2Info[512], TimeArena[30], Float:GetHP, Float:GetAP, string2[256], string[512];
	//gang barinfo
	if(GangWar[GangWarONOFF] == 1)
	{
		foreach(new i : Player)
		{
			if(GangPlayer[i][OnArena] == 1 && PlayerData[i][GangID] == GangWar[GANG1ID] && GangWar[ActiveRound] == 1)
			{
				GetPlayerHealth(i, GetHP);
				GetPlayerArmour(i, GetAP);
				TeamHP[0] = TeamHP[0] + (GetHP + GetAP);
				PlayersAlive[0]++;
				format(G1Info, sizeof(G1Info), "%s (%d) %.0f", Gang[GangWar[GANG1ID]][gTag], PlayersAlive[0], TeamHP[0]);
				TextDrawSetString(HDM_GangWarInfoG1, G1Info);
			}
			
			if(GangPlayer[i][OnArena] == 1 && PlayerData[i][GangID] == GangWar[GANG2ID] && GangWar[ActiveRound] == 1)
			{
				GetPlayerHealth(i, GetHP);
				GetPlayerArmour(i, GetAP);
				TeamHP[1] = TeamHP[1] + (GetHP + GetAP);
				PlayersAlive[1]++;
				format(G2Info, sizeof(G2Info), "%s (%d) %.0f", Gang[GangWar[GANG2ID]][gTag], PlayersAlive[1], TeamHP[1]);
				TextDrawSetString(HDM_GangWarInfoG2, G2Info);
			}

			format(string2, sizeof(string2), "~y~%s~n~~y~%s~n~~w~Kills~y~ %d~n~~w~Deaths:~y~ %d~n~~w~DMG:~y~ %.0f", Gang[PlayerData[i][GangID]][gName], PlayerName(i), GangPlayer[i][Kills], GangPlayer[i][Deaths], GangPlayer[i][TotalDMG]);
			PlayerTextDrawSetString(i, HDM_GWPlayerStats[i], string2);
		}

		format(string, sizeof(string), "~y~%s (%d) %d ~w~vs.~y~ %d %s (%d)~w~~n~Rounds: ~y~%d~w~/~y~6", Gang[GangWar[GANG1ID]][gTag], GangWar[Gang1Players], GangWar[Gang1Points], GangWar[Gang2Points], Gang[GangWar[GANG2ID]][gTag], GangWar[Gang2Players], GangWar[RoundsPlayed]);
		TextDrawSetString(HDM_GangWarPointsRounds, string);
		if(GangWar[ActiveRound] == 1 && GangWar[Pause] == 0 && GangWar[Crash] == 0)RoundCheckWinner();
		//arenatime
		if(GangWar[ActiveRound] == 1)
		{
			RoundS--;
			if(RoundS < 0) 
			{
				RoundS = 59;
				RoundM--;
				if(RoundM < 0)
				{
					EndRound();
				}
			}
			format(TimeArena, sizeof(TimeArena), "~w~Arena ~y~%d %d~w~:~y~%02d", CurrentArena, RoundM, RoundS);
			TextDrawSetString(HDM_GangWarArenaInfo, TimeArena);
		}
		else if(GangWar[ActiveRound] == 0 && GangWar[Pause] == 1 || GangWar[Crash] == 1)
		{
			TextDrawSetString(HDM_GangWarArenaInfo, "~y~Pause");
			format(string, sizeof(string), "%s", Gang[GangWar[GANG2ID]][gName]);
			TextDrawSetString(HDM_GangWarInfoG2, string);
			format(string, sizeof(string), "%s", Gang[GangWar[GANG1ID]][gName]);
			TextDrawSetString(HDM_GangWarInfoG1, string);
		}
		else if(GangWar[ActiveRound] == 0 && GangWar[Pause] == 0 || GangWar[Crash] == 0)
		{
			TextDrawSetString(HDM_GangWarArenaInfo, "~y~Lobby");
			format(string, sizeof(string), "%s", Gang[GangWar[GANG2ID]][gName]);
			TextDrawSetString(HDM_GangWarInfoG2, string);
			format(string, sizeof(string), "%s", Gang[GangWar[GANG1ID]][gName]);
			TextDrawSetString(HDM_GangWarInfoG1, string);
		}
		RadarFix();
	}
	return 1;
}

GetMaxArenas()
{
	new buffer[64];
	 
	format(buffer, 64, "%s%i.ini", PATH_ARENAS, maxarenas);
	
	while(dini_Exists(buffer))
	{
	    maxarenas++;
	    format(buffer, 64, "%s/%i.ini", PATH_ARENAS, maxarenas);
	}
	printf("Areny: %d", maxarenas);
	return maxarenas - 1;
}

GetArenaCfg(arenaID, node[])
{
	new
	 buffer[256];
	
	Copy(dini_Get(GetArenaINIFile(arenaID), node), buffer);
	
	return buffer;
}

Copy(string1[], string2[])
{
	new
	 length = strlen(string1);

	for(new i = 0; i < length; i++)
	    string2[i] = string1[i];
		
	string2[strlen(string1)] = EOS;
}

GetArenaINIFile(arenaID)
{
	new
	 buffer[64];
	 
	format(buffer, 64, "%s%i.ini", PATH_ARENAS, arenaID);
	
	return buffer;
}

//crashaddgangwar

stock GetSaveID()
{
	new saveid;
	for(new i=0; i<CADD_SAVES; i++)
	{
	    if(CADDPlayer[i][nickname] == 0)
		{
	        saveid = i;
	        break;
		}
	}
	return saveid;
}

CrashAddLeave(playerid)
{
	new string[1024], Float:ppos[3], Float:HP, Float:AP, saveid = GetSaveID();
	GetPlayerPos(playerid, ppos[0], ppos[1], ppos[2]);
	format(CADDPlayer[saveid][nickname], 24, PlayerData[playerid][Name]);
	CADDPlayer[saveid][idgang] = PlayerData[playerid][GangID];
	CADDPlayer[saveid][intid] = GetPlayerInterior(playerid);
	CADDPlayer[saveid][vwid] = GetPlayerVirtualWorld(playerid);
	CADDPlayer[saveid][pos][0] = ppos[0];
	CADDPlayer[saveid][pos][1] = ppos[1];
	CADDPlayer[saveid][pos][2] = ppos[2];
	CADDPlayer[saveid][Weapon][0] = GangPlayer[playerid][Weapon][0];
	CADDPlayer[saveid][Weapon][1] = GangPlayer[playerid][Weapon][1];
	CADDPlayer[saveid][HPoints] = GetPlayerHealth(playerid, HP);
	CADDPlayer[saveid][APoints] = GetPlayerHealth(playerid, AP);
	CADDPlayer[saveid][ArenaDMG] = GangPlayer[playerid][ArenaDMG];
	CADDPlayer[saveid][TotalDMG] = GangPlayer[playerid][TotalDMG];
	CADDPlayer[saveid][ArenaKills] = GangPlayer[playerid][ArenaKills];
	CADDPlayer[saveid][Kills] = GangPlayer[playerid][Kills];
	CADDPlayer[saveid][Deaths] = GangPlayer[playerid][Deaths];
	if(PlayerData[playerid][GangID] == GangWar[GANG1ID])
			GangWar[Gang1Players]--;
	if(PlayerData[playerid][GangID] == GangWar[GANG2ID])
			GangWar[Gang2Players]--;		
		
	
	format(string, sizeof(string), "S:%d %s: %f/%f/%f, weaps: %d/%d, HP:%f/AP:%f, DMG:A:%f D:%f, Kills:A:%d/T:%d Deaths:%d",
	saveid, CADDPlayer[saveid][nickname], CADDPlayer[saveid][pos][0], CADDPlayer[saveid][pos][1], CADDPlayer[saveid][pos][2],
	CADDPlayer[saveid][Weapon][0],
	CADDPlayer[saveid][Weapon][1],
	CADDPlayer[saveid][HPoints],
	CADDPlayer[saveid][APoints],
	CADDPlayer[saveid][ArenaDMG],
	CADDPlayer[saveid][TotalDMG],
	CADDPlayer[saveid][ArenaKills],
	CADDPlayer[saveid][Kills],
	CADDPlayer[saveid][Deaths]
	);
	print(string);
	SendClientMessageToAll(-1, string);
	PauseRound(1);
	return 1;
}

forward Unpause();
public Unpause()
{
	new string[128];
	UnpauseT--;
	GangWar[Crash] = 0;
	format(string, sizeof(string), "Unpause in ~y~%d seconds.", UnpauseT);
	TextDrawSetString(HDM_GangWarInstructions, string);
	foreach(new i : Player)
	{
		PlayerPlaySound(i, 1056, 0, 0, 0);
	}
	if(UnpauseT == 0)
	{
		ResumeRound();
		return 1;
	}
	return SetTimer("Unpause", 1000, false);
}

ShowGWWeaponMenu(playerid)
{
	new Weapons[1024];
	strcat(Weapons, "1.Deagle / Shotgun\n2.Deagle / M4\n3.Deagle / Rifle\n4.Deagle / Sniper Rifle\n5.Shotgun / M4\n6.Shotgun / Rifle\n7.Shotgun / Sniper Rifle");
	ShowPlayerDialog(playerid, D_GANGWARWEAPON, DIALOG_STYLE_LIST, "Gang War: Weaponset select", Weapons, "Select", "Cancel");
}

ResumeRound()
{
	if(GangWar[Pause] == 1)
	{
		foreach(new i : Player)
		{
			if(PlayerData[i][GangID] == GangWar[GANG1ID] || PlayerData[i][GangID] == GangWar[GANG2ID])
			{
				TogglePlayerControllable(i, true);
				PlayerPlaySound(i, 1057, 0, 0, 0);
				hideGangWarInstr(i);
			}
		}	
		GangWar[ActiveRound] = 1;
		GangWar[Pause] = 0;
		GangWar[Crash] = 0;
	}
}

PauseRound(reason)
{
	new string[256];
	switch(reason)
	{	
		case 0:
		{
			if(GangWar[Pause] == 0)
			{
				foreach(new i : Player)
				{
					if(PlayerData[i][GangID] == GangWar[GANG1ID] || PlayerData[i][GangID] == GangWar[GANG2ID])
					{
						TogglePlayerControllable(i, false);
						PlayerPlaySound(i, 1150, 0, 0, 0);
						showGangWarInstr(i);
					}
				}
				format(string, sizeof(string), "~y~GAME PAUSED~n~~w~Use ~y~/pause ~w~or click ~y~Y~w~ for unpause.");
				TextDrawSetString(HDM_GangWarInstructions, string);
				GangWar[ActiveRound] = 1;
				GangWar[Pause] = 1;
				UnpauseT = 3;
				GangWar[Crash] = 0; 
			}
			else if(GangWar[Pause] == 1)
			{
				Unpause();
			}
		}
		case 1:
		{
			if(GangWar[Pause] == 0 && GangWar[Crash] == 0)
			{
				GangWar[ActiveRound] = 1;
				GangWar[Pause] = 1;
				GangWar[Crash] = 1;
				UnpauseT = 3;
				CrashTimeM = 2;
				CrashTimeS = 30;
				foreach(new i : Player)
				{
					if(PlayerData[i][GangID] == GangWar[GANG1ID] || PlayerData[i][GangID] == GangWar[GANG2ID])
					{
						TogglePlayerControllable(i, false);
						PlayerPlaySound(i, 1150, 0, 0, 0);
						showGangWarInstr(i);
					}	
				}
				format(string, sizeof(string), "~y~Crash-Add~n~~w~Someone gots crashed or lost connection.");
				TextDrawSetString(HDM_GangWarInstructions, string);
				CrashAddWaiter();
			}
			else if(GangWar[Pause] == 1 && GangWar[Crash] == 1)
			{
				Unpause();
			}		
		}
	}
	return 1;
}

CheckCrashList(playerid)
{
	new savedid;
	for(new i=0; i<CADD_SAVES; i++)
	{
	    if(CADDPlayer[i][nickname] == PlayerData[playerid][Name])
		{
	        savedid = i;
			printf("przywracane id: %d", savedid);
	        break;
		}
	}
	return savedid;
}

AddCrashedPlayer(playerid)
{
	new string[512], savedid = CheckCrashList(playerid);
	if(PlayerData[playerid][Name] == CADDPlayer[savedid][nickname] && CADDPlayer[savedid][idgang] == PlayerData[playerid][GangID] && GangWar[GangWarONOFF] == 1 && GangWar[Crash] == 1 && GangWar[Pause] == 1)
	{
		SetPlayerInterior(playerid, CADDPlayer[savedid][intid]);
		SetPlayerVirtualWorld(playerid, CADDPlayer[savedid][vwid]);
		SetPlayerPos(playerid, CADDPlayer[savedid][pos][0], CADDPlayer[savedid][pos][1], CADDPlayer[savedid][pos][2]);
		GangPlayer[playerid][Weapon][0] = CADDPlayer[savedid][Weapon][0];
		GangPlayer[playerid][Weapon][1] = CADDPlayer[savedid][Weapon][1];
		SetPlayerHealth(playerid, CADDPlayer[savedid][HPoints]);
		SetPlayerArmour(playerid, CADDPlayer[savedid][APoints]);
		GangPlayer[playerid][ArenaDMG] = CADDPlayer[savedid][ArenaDMG];
		GangPlayer[playerid][TotalDMG] = CADDPlayer[savedid][TotalDMG];
		GangPlayer[playerid][ArenaKills] = CADDPlayer[savedid][ArenaKills];
		GangPlayer[playerid][Kills] = CADDPlayer[savedid][Kills];
		GangPlayer[playerid][Deaths] = CADDPlayer[savedid][Deaths];
		PlayerData[playerid][inGWAR] = 1;
		if(PlayerData[playerid][GangID] == GangWar[GANG1ID])
			GangWar[Gang1Players]++;
		if(PlayerData[playerid][GangID] == GangWar[GANG2ID])
			GangWar[Gang2Players]++;
		GiveWeaponsArena(playerid);
		TogglePlayerControllable(playerid, false);
		SetCameraBehindPlayer(playerid);
		hideGangControl(playerid);
		hidePlayerHud(playerid);
		hideCountDown(playerid);
		hideSpecPlayerInfo(playerid);
		hideSniperInfo(playerid);
		TextDrawHideForPlayer(playerid, HDM_SniperDropInfo);
		hideGangWarInfo(playerid);
		showGangWarInfo(playerid);
		showGangWarInstr(playerid);
		PlayerTextDrawShow(playerid, HDM_GWPlayerStats[playerid]);
		format(string, sizeof(string), "Gang War: Restored player %s. Resuming round... ", PlayerName(playerid));
		foreach(new i : Player)
		{
			if(PlayerData[i][inGWAR] == 1)SendClientMessage(i, COLOR_PINK, string);
		}
		CADDPlayer[savedid][nickname] = 0;
	}
	return 1;	
}

forward CrashAddWaiter();
public CrashAddWaiter()
{	
	new string[512];
	if(GangWar[Crash] == 1 && GangWar[Pause] == 1 && GangWar[ActiveRound] == 1 && CrashTimeM > 0)
	{
		format(string, sizeof(string), "~y~Crash-Add:~n~~w~Someone gots crashed or lost connection.~n~Waiting for missing players or use /repalce to add another gangmate for missing player %02d:%02d", CrashTimeM, CrashTimeS);
		TextDrawSetString(HDM_GangWarInstructions, string);
		CrashTimeS--;
		if(CrashTimeS == 0)
		{
			CrashTimeM--;
			CrashTimeS = 59;
		}

		if(GangWar[Crash] == 1 && GangWar[Pause] == 1 && GangWar[ActiveRound] == 1 && CrashTimeM <= 0)
		{
			format(string, sizeof(string), "~y~Crash-Add: Missing player does not back and no one were added. Restoring Round...");
			TextDrawSetString(HDM_GangWarInstructions, string);
			PauseRound(1);
			return 1;
		}
		else if(GangWar[Gang1Players] == 4 || GangWar[Gang2Players] == 4 && GangWar[Crash] == 1 && GangWar[Pause] == 1 && GangWar[ActiveRound] == 1)
		{
			format(string, sizeof(string), "~y~Crash-Add: Finally missing player is back! Restoring Round...");
			TextDrawSetString(HDM_GangWarInstructions, string);
			PauseRound(1);
			return 1;
		}
	}
	return SetTimer("CrashAddWaiter", 1000, false);
}

ReplaceCrashPlayer(replaceid, toaddid)
{
	new string[512];
	if(PlayerData[toaddid][GangID] == CADDPlayer[replaceid][idgang] && GangWar[GangWarONOFF] == 1 && GangWar[Crash] == 1 && GangWar[Pause] == 1)
	{
		SetPlayerInterior(toaddid, CADDPlayer[replaceid][intid]);
		SetPlayerVirtualWorld(toaddid, CADDPlayer[replaceid][vwid]);
		SetPlayerPos(toaddid, CADDPlayer[replaceid][pos][0], CADDPlayer[replaceid][pos][1], CADDPlayer[replaceid][pos][2]);
		GangPlayer[toaddid][Weapon][0] = CADDPlayer[replaceid][Weapon][0];
		GangPlayer[toaddid][Weapon][1] = CADDPlayer[replaceid][Weapon][1];
		SetPlayerHealth(toaddid, CADDPlayer[replaceid][HPoints]);
		SetPlayerArmour(toaddid, CADDPlayer[replaceid][APoints]);
		GangPlayer[toaddid][ArenaDMG] = CADDPlayer[replaceid][ArenaDMG];
		GangPlayer[toaddid][TotalDMG] = CADDPlayer[replaceid][TotalDMG];
		GangPlayer[toaddid][ArenaKills] = CADDPlayer[replaceid][ArenaKills];
		GangPlayer[toaddid][Kills] = CADDPlayer[replaceid][Kills];
		GangPlayer[toaddid][Deaths] = CADDPlayer[replaceid][Deaths];
		PlayerData[toaddid][inGWAR] = 1;
		if(PlayerData[toaddid][GangID] == GangWar[GANG1ID])
			GangWar[Gang1Players]++;
		if(PlayerData[toaddid][GangID] == GangWar[GANG2ID])
			GangWar[Gang2Players]++;
		GiveWeaponsArena(toaddid);
		TogglePlayerControllable(toaddid, false);
		SetCameraBehindPlayer(toaddid);
		hideGangControl(toaddid);
		hidePlayerHud(toaddid);
		hideCountDown(toaddid);
		hideSpecPlayerInfo(toaddid);
		hideSniperInfo(toaddid);
		TextDrawHideForPlayer(toaddid, HDM_SniperDropInfo);
		hideGangWarInfo(toaddid);
		showGangWarInfo(toaddid);
		showGangWarInstr(toaddid);
		PlayerTextDrawShow(toaddid, HDM_GWPlayerStats[toaddid]);
		format(string, sizeof(string), "Gang War: Added %s for %s. Resuming round... ", PlayerName(toaddid), CADDPlayer[replaceid][nickname]);
		PauseRound(1);
		foreach(new i : Player)
		{
			if(PlayerData[i][inGWAR] == 1)SendClientMessage(i, COLOR_PINK, string);
		}
		CADDPlayer[replaceid][nickname] = 0;
	}
	return 1;	
}
//************** GANGWAR SYTEM END **************//

CreateObjects()
{
	CreateObject(16405,-693.937438,-2542.770263,50.834873,0.000000,-10.699997,-80.099990);
	CreateObject(833,-696.936950,-2546.688476,50.888473,-16.099996,0.000000,18.500001);
	CreateObject(821,-698.670715,-2542.542724,49.740177,0.000000,0.000000,31.300003);
	CreateObject(930,-691.431762,-2544.991943,50.155937,-6.500000,-13.599989,-53.599983);
	CreateObject(1362,-692.238098,-2545.212402,50.260009,-15.000002,0.000000,0.000000);
	CreateObject(16406,-785.913146,-2540.502441,93.953102,0.000000,0.000000,-87.100006);
	CreateObject(1437,-782.749694,-2543.355957,91.576080,-19.500011,0.000000,91.800003);
	CreateObject(824,-787.196838,-2543.449218,92.221618,6.900000,0.000000,0.000000);
	CreateObject(1421,-789.313476,-2540.982177,91.485412,0.000000,-9.399996,-67.499984);
	CreateObject(804,-790.656677,-2542.949707,91.833045,0.000000,0.000000,165.500015);
	CreateObject(3243,-700.571411,-2548.074707,50.343357,6.099997,-8.499996,-122.699989);
	CreateObject(19632,-696.963134,-2549.759277,51.101963,0.000000,0.000000,0.000000);
	CreateObject(3243,-710.124877,-2619.358886,74.427612,-2.999998,6.400001,26.599998);
	CreateObject(1458,-713.451416,-2619.758056,74.888053,-6.399999,2.400001,1.200000);
	CreateObject(2901,-713.416381,-2617.907958,74.704124,0.000000,0.000000,0.000000);
	CreateObject(2901,-713.390258,-2617.979492,75.182441,0.000000,0.000000,12.399998);
	CreateObject(821,-708.867614,-2613.989013,73.681823,-4.999998,0.000000,0.000000);
	CreateObject(3171,-718.843627,-2615.167968,74.075935,10.799997,3.799998,138.699981);
	CreateObject(832,-720.869689,-2619.603271,76.732711,0.000000,-5.399999,-84.099983);
	CreateObject(3175,-746.060241,-2654.758300,82.702468,-6.099997,-1.699998,-9.800000);
	CreateObject(3261,-750.739929,-2660.451416,83.035804,0.000000,-5.500000,-62.600006);
	CreateObject(3409,-749.554016,-2659.881835,82.710083,0.000000,5.099997,28.900009);
	CreateObject(3633,-744.629333,-2657.395996,83.528388,-5.499999,0.000000,3.099997);
	CreateObject(748,-743.236816,-2649.833251,82.492965,0.000000,0.000000,0.000000);
	CreateObject(3066,-759.143737,-2653.837890,83.611671,-2.599997,0.000000,9.399996);
	CreateObject(1334,-747.454223,-2650.930908,83.354187,6.199995,-6.000000,-103.900009);
	CreateObject(1265,-746.253601,-2649.585205,82.609397,0.000000,0.000000,0.000000);
	CreateObject(3286,-756.152832,-2650.548828,86.779716,0.000000,0.000000,0.000000);
	CreateObject(821,-754.668884,-2645.813232,82.699272,0.000000,0.000000,-51.000003);
	CreateObject(16405,-765.516967,-2680.279296,85.106834,4.099997,0.000000,-80.300018);
	CreateObject(3798,-762.556457,-2677.231933,83.435913,0.000000,-3.200001,0.000000);
	CreateObject(910,-763.481262,-2675.599121,84.655372,1.099997,0.000000,-177.799987);
	CreateObject(1265,-764.591125,-2676.573974,83.733795,0.000000,0.000000,0.000000);
	CreateObject(3594,-770.200195,-2675.818115,83.730720,4.000000,0.000000,-40.600002);
	CreateObject(3280,-768.657714,-2678.865722,84.056274,0.000000,90.000000,8.800000);
	CreateObject(3280,-768.322998,-2680.767333,83.996261,0.000000,90.000000,8.800000);
	CreateObject(3280,-768.006774,-2682.545654,83.996261,0.000000,90.000000,8.800000);
	CreateObject(12957,-771.770080,-2679.788085,84.107620,-11.500000,0.000000,177.400009);
	CreateObject(3171,-760.074096,-2683.299804,83.556312,-0.199999,0.000000,-18.399995);
	CreateObject(824,-763.399230,-2689.307861,83.977203,0.000000,0.000000,110.999977);
	CreateObject(17039,-843.273315,-2681.419433,95.200950,0.000000,0.699998,-2.199999);
	CreateObject(17000,-852.951477,-2676.053222,93.412635,0.000000,0.000000,14.099991);
	CreateObject(964,-846.175476,-2684.856933,96.237640,0.000000,-4.599997,177.099884);
	CreateObject(930,-844.985717,-2684.933105,96.621612,-1.399999,0.000000,-93.400009);
	CreateObject(3374,-835.685119,-2674.986572,96.351348,-7.299995,2.299998,-42.799991);
	CreateObject(3374,-833.816101,-2679.229980,95.857917,0.000000,8.399995,-40.599998);
	CreateObject(804,-836.581542,-2686.658203,95.850234,0.000000,0.000000,-110.399986);
	CreateObject(821,-853.205383,-2682.977783,98.355201,0.000000,0.000000,-34.100002);
	CreateObject(1466,-847.281372,-2675.476074,97.635391,0.000000,2.899996,0.000000);
	CreateObject(1428,-845.066589,-2675.487060,97.591156,-17.000001,0.000000,92.299987);
	CreateObject(1327,-848.125854,-2674.529785,97.266578,0.000000,13.500000,-87.099990);
	CreateObject(3403,-884.926513,-2628.493408,98.507202,-2.199999,0.000000,45.100002);
	CreateObject(822,-893.409484,-2629.611328,96.626869,0.000000,0.000000,-60.199989);
	CreateObject(822,-884.145690,-2620.312500,96.427543,0.000000,0.000000,0.000000);
	CreateObject(822,-888.262390,-2623.655761,96.198333,0.000000,0.000000,-91.300010);
	CreateObject(3243,-879.680236,-2635.295654,96.837844,0.000000,0.000000,0.000000);
	CreateObject(19632,-881.103942,-2631.564453,96.809310,0.000000,12.299999,22.499996);
	CreateObject(843,-886.745483,-2635.452636,97.293029,0.000000,0.000000,0.000000);
	CreateObject(832,-877.460327,-2627.249511,98.189353,0.000000,0.000000,80.999984);
	CreateObject(822,-893.838378,-2634.276611,96.487701,0.000000,0.000000,0.000000);
	CreateObject(16406,-916.405578,-2712.316162,120.009994,0.000000,0.000000,73.999977);
	CreateObject(1437,-912.213745,-2709.753417,117.551132,-22.800012,0.000000,73.600097);
	CreateObject(822,-923.367431,-2712.751220,117.104171,0.000000,0.000000,-118.099998);
	CreateObject(17055,-911.473083,-2716.014160,119.456680,1.999999,-5.099999,-105.800010);
	CreateObject(802,-911.978149,-2710.982910,117.005874,0.000000,0.000000,0.000000);
	CreateObject(19865,-907.696716,-2716.168457,117.128967,-4.500000,0.000000,-19.199998);
	CreateObject(19865,-909.321655,-2720.928222,117.622299,-5.999999,0.000000,-18.900009);
	CreateObject(19865,-912.156188,-2722.303466,117.702445,-2.299998,0.000000,69.499992);
	CreateObject(19865,-916.835632,-2720.553466,117.501777,-2.299998,0.000000,69.499992);
	CreateObject(19865,-921.530456,-2718.798095,117.240447,-3.499998,0.000000,69.499992);
	CreateObject(19865,-923.045349,-2715.813232,116.857048,-5.999999,0.000000,-18.900009);
	CreateObject(3280,-1627.404418,-2254.333007,34.450763,88.900039,0.000000,0.000000);
	CreateObject(3280,-1627.404418,-2254.363281,32.911026,88.900039,0.000000,0.000000);
	CreateObject(3280,-1627.404418,-2254.393066,31.361309,88.900039,0.000000,0.000000);
	CreateObject(821,-1629.958129,-2255.305419,30.812089,0.000000,0.000000,-63.799995);
	CreateObject(3280,-1627.401611,-2253.519775,35.266368,0.000000,0.000000,-90.999954);
	CreateObject(3280,-1625.870361,-2253.544677,35.266368,0.000000,0.000000,-90.999954);
	CreateObject(3280,-1624.350097,-2253.571777,35.266368,0.000000,0.000000,-90.999954);
	CreateObject(3498,-1627.348266,-2253.585937,30.710298,0.000000,0.000000,0.000000);
	CreateObject(3498,-1623.477416,-2253.946289,30.710298,0.000000,0.000000,0.000000);
	CreateObject(3498,-1623.086669,-2257.185791,30.770299,0.000000,0.000000,0.000000);
	CreateObject(1437,-1628.491943,-2257.278320,31.753372,-30.500009,0.000000,-15.800010);
	CreateObject(3280,-1627.384399,-2252.722412,36.010143,88.900039,0.000000,0.000000);
	CreateObject(3280,-1625.854248,-2252.762451,36.010906,88.900039,-1.700000,0.000000);
	CreateObject(3280,-1624.315185,-2252.809814,36.011795,88.900039,-1.700000,0.000000);
	CreateObject(3280,-1628.164550,-2253.493896,36.009571,88.900039,0.499998,-91.600021);
	CreateObject(3280,-1623.492431,-2253.896728,35.306362,0.000000,0.000000,-131.300018);
	CreateObject(3280,-1622.808105,-2254.851318,35.306362,0.000000,0.000000,-157.600112);
	CreateObject(3280,-1622.625366,-2255.995849,35.306362,0.000000,0.000000,174.399871);
	CreateObject(3280,-1622.972900,-2257.179443,35.306362,0.000000,0.000000,151.199874);
	CreateObject(3280,-1622.957641,-2253.331054,36.024066,88.900039,-1.700000,-38.099987);
	CreateObject(3280,-1621.895141,-2256.096435,36.083129,88.900039,-1.700000,-93.099937);
	CreateObject(3280,-1622.307861,-2257.546386,36.089313,88.900039,-1.700000,-116.899940);
	CreateObject(3280,-1623.377075,-2257.854003,36.081863,88.900039,-1.700000,-27.299940);
	CreateObject(3415,-1489.274780,-2171.134033,0.953342,-1.799999,4.499998,-120.500007);
	CreateObject(824,-1488.921875,-2163.852050,1.863813,0.000000,0.000000,162.299957);
	CreateObject(1454,-1491.898071,-2176.664794,1.429101,0.000000,0.000000,0.000000);
	CreateObject(1454,-1493.538330,-2176.104248,1.399101,0.000000,0.000000,0.000000);
	CreateObject(1454,-1492.718750,-2176.354492,2.759100,0.000000,0.000000,0.000000);
	CreateObject(1362,-1493.833740,-2173.788085,1.243883,0.000000,0.000000,0.000000);
	CreateObject(3175,-1513.219360,-2160.863525,0.593105,-4.699999,0.000000,114.800033);
	CreateObject(1265,-1511.615234,-2161.942382,1.138826,0.000000,0.000000,0.000000);
	CreateObject(14872,-1515.627685,-2164.218505,0.693324,2.599998,0.000000,-79.099998);
	CreateObject(2788,-1512.315429,-2162.524169,0.966736,0.000000,-3.899998,62.500007);
	CreateObject(14468,-1509.590576,-2160.866210,1.253201,0.000000,0.000000,68.000007);
	CreateObject(3403,-1508.431884,-2155.845458,4.096766,0.000000,0.000000,-12.699996);
	CreateObject(824,-1516.461791,-2158.130859,1.470978,-10.599999,-1.800001,-105.799987);
	CreateObject(2901,-1512.203125,-2158.485107,1.179280,0.000000,0.000000,-13.100002);
	CreateObject(2901,-1512.047485,-2158.134521,1.422973,0.000000,20.400003,23.999996);
	CreateObject(1458,-1513.612915,-2155.918457,1.298164,0.000000,0.000000,-118.399978);
	CreateObject(1327,-1501.987060,-2152.700195,2.729324,0.000000,-13.999999,23.800003);
	CreateObject(12957,-1506.136352,-2153.034423,2.473386,0.000000,-1.799998,13.199996);
	CreateObject(14468,-1503.359985,-2152.095458,2.143202,0.000000,0.000000,84.599990);
	CreateObject(3415,-1643.987060,-2187.651855,30.581724,-2.499998,7.599996,60.799995);
	CreateObject(824,-1638.205078,-2183.290771,29.734632,0.000000,0.000000,19.400001);
	CreateObject(3286,-1641.085693,-2180.409423,33.748786,0.000000,0.000000,-41.200000);
	CreateObject(3374,-1648.178100,-2195.227050,33.258369,-7.099997,1.000000,0.000000);
	CreateObject(3374,-1649.667846,-2199.354492,33.888874,-7.099997,1.000000,0.000000);
	CreateObject(3374,-1652.813598,-2195.669433,33.385814,-7.099997,2.000000,21.600006);
	CreateObject(3374,-1650.531250,-2195.834228,36.421428,-10.200004,1.000000,-15.300002);
	CreateObject(14402,-1649.566406,-2191.275878,31.731676,0.000000,0.000000,54.099987);
	CreateObject(3633,-1643.581787,-2192.226318,31.684179,-7.899996,0.000000,0.000000);
	CreateObject(14402,-1645.749145,-2200.389648,32.933937,-6.500001,0.000000,-16.400001);
	CreateObject(16405,-1595.265258,-2149.385986,18.545122,-4.599998,4.600000,-54.700000);
	CreateObject(3594,-1600.249267,-2149.729003,18.842962,0.099999,13.999998,20.199998);
	CreateObject(18691,-1599.807250,-2151.644042,16.346099,0.000000,0.000000,0.000000);
	CreateObject(14402,-1592.068725,-2149.052246,16.817735,0.000000,8.400000,22.500001);
	CreateObject(1327,-1596.364379,-2153.016357,18.155704,0.000000,26.899993,0.000000);
	CreateObject(1327,-1595.492065,-2154.147949,17.918790,0.000000,-78.099975,0.000000);
	CreateObject(3564,-1593.863281,-2143.946044,17.374252,-4.099999,9.499999,-18.400005);
	CreateObject(1421,-1598.816650,-2143.077148,18.060554,-7.200001,-3.399999,-96.900001);
	CreateObject(3243,-1587.545288,-2148.373535,14.867861,0.000000,0.000000,130.899902);
	CreateObject(3243,-1493.595092,-2180.212158,0.382159,0.000000,0.000000,34.100002);
	CreateObject(824,-1488.177001,-2180.318603,1.873946,-5.199999,-1.299999,0.000000);
	CreateObject(2788,-1494.524902,-2177.086425,1.085018,0.000000,0.000000,-16.000001);
	CreateObject(2901,-1495.912963,-2177.173828,0.793135,0.000000,0.000000,-10.699999);
	CreateObject(2901,-1495.781982,-2176.799560,1.057710,0.000000,-14.900000,-109.299987);
	CreateObject(19632,-1496.079833,-2176.661132,0.581566,0.000000,0.000000,-28.199996);
	CreateObject(19865,-1585.197509,-2147.236816,14.476609,0.600000,0.000000,22.300003);
	CreateObject(19865,-1585.193237,-2151.868652,14.765605,-6.799996,0.000000,-21.700010);
	CreateObject(19865,-1587.966918,-2155.860351,15.557339,-10.700014,0.000000,-46.300003);
	CreateObject(881,-1589.112182,-2155.157714,15.976634,0.000000,0.000000,-147.199981);
	CreateObject(14402,-1588.460937,-2157.457031,16.351173,-9.800002,0.000000,-49.599990);
	CreateObject(881,-1586.413452,-2155.329101,15.204545,0.000000,0.000000,0.000000);
	CreateObject(881,-1598.378662,-2144.863769,17.045747,0.000000,0.000000,-139.999984);
	CreateObject(881,-1519.709228,-2159.903564,1.112504,0.000000,0.000000,-110.600013);
	CreateObject(881,-1491.345825,-2165.814208,1.322350,0.000000,0.000000,154.299987);
	CreateObject(881,-1636.669189,-2180.437744,28.884275,0.000000,0.000000,-25.299999);
	return 1;

}