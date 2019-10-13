# MissingTradeSkillsList
Addon For World Of Warcraft Classic v1.13  
Shows the missing recipes/skills for a tradeskill and where to get them  
Addon only works **all** languages now! (MTSL Options menu still only shown in English only)  

Please donate if you want to support this addon!

### Author
Thumbkin (Retail: EU-Burning Steppes, Classic: EU-Pyrewood Village)

### Screenshots
MTSL - Vertical split (Change using options menu)
![alt text](https://media.forgecdn.net/attachments/265/613/mtsl_main.png "Missing TradeSkills List - Vertical Split")
MTSL - Horizontal split (Change using options menu)
![alt text](https://media.forgecdn.net/attachments/265/614/mtsl_main_horizontal.png "Missing TradeSkills List - Horizontal Split")
Account explorer (/mtsl acc or /mtsl account)
![alt text](https://media.forgecdn.net/attachments/265/616/mtsl_account.png "Missing TradeSkills List - Account explorer")
Database explorer (/mtsl db or /mtsl database)
![alt text](https://media.forgecdn.net/attachments/265/615/mtsl_database.png "Missing TradeSkills List - Database explorer")
Options menu (/mtsl or /mtsl config or /mtsl options)
![alt text](https://media.forgecdn.net/attachments/265/541/mtsl_options.png "Missing TradeSkills List - Options menu")

### Missing / Work in Progress
  * Add lines to tooltips for recipes to show if chars who know the skill can learn it or not (skip learned ones though)
  * Translations for the special actions for certain skills  

### Known Bugs
1: Not all trainer skills have the correct minimum skill required or price  
3: Reputation required not yet shown for items
5: World drops currently left out when filtering on specific zone for drops (mob range check not yet in place)

### Fixed Issues
2: When a skill has multiple sources, the secondary source is not always shown correctly  
4: Drop down for filtering on zone does not fill correct for Eastern Kingdoms  

### Latest version 
v1.13.19&nbsp;&nbsp;&nbsp;&nbsp;Account Explorer uses different code to show learned skills (**resave all players/professions**)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Colored skill level in Account Explorer to show status  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Green : learned  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Orange : can be learned  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Red : can not be learned  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Changes to options menu:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Added UI split-orientation option for all 3 main windows (will reset current saved scale!)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Redesigned scaling to drop downs for compacter/better view  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Fixed some wrong translations  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Account explorer & options menu window is now movable/draggable  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Refactored UI code making all 3 main windows appear/use same code   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Split up datafile with continents & zones  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Moved "Kalimdor" up in filterlist before "The Eastern Kingdoms"  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Numerous code fixing for smaller filesize addon & faster running  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Sort players by name/realm in Account Explorer & Database explorer view    
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Filters players by realm in Account Explorer & Database explorer view  

[Full Version History](VERSION_HISTORY.md)