## About:
A light-weight AHK overlay with UI and QoL features for Path of Exile 1 and 2, emphasizing ease-of-use, minimalist design, low hotkey requirements, and seamless integration into the game-client. **`This project is not affiliated with or endorsed by Grinding Gear Games (GGG) in any way`**. Formerly Lailloken UI.  
<br>

## Download & Setup
| [![img](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/_autohotkey.png)](https://www.autohotkey.com/) | [![img](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/_guide.png)](https://github.com/Lailloken/Lailloken-UI/wiki) | [![img](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/_download.png)](https://github.com/Lailloken/Exile-UI/archive/refs/heads/main.zip) | [![img](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/_releases.png)](https://github.com/Lailloken/Lailloken-UI/releases) |
|---|---|---|---|

## Contributions
| [![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/_issues.png)](https://github.com/Lailloken/Lailloken-UI/issues/new) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/_code.png) | [![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/_translations.png)](https://github.com/Lailloken/Lailloken-UI/issues/326) |
|---|---|---|
<br>

## Context: What is this project?
<details><summary>show</summary>

- this is a fun-project (by a self-taught hobby-coder) that contains various UI/QoL features

  - I implement ideas that I think are fun/interesting to work on and figure out (even if they're not necessarily useful to everyone, or even myself)

  - since some features are user-requested and I don't use every single one myself, some aspects are heavily reliant on user-feedback (use the banners above to contribute)
 
  - my own ideas are always centered around SSF, but I'm open to trade-league-related ideas (if they're interesting enough and not too complex)
 
  - I generally avoid features that are "OP" or abusable because I don't think they're good for the game, regardless of how much QoL they would provide

- I view this as a personal toolkit rather than a product, so certain aspects may seem rough around the edges (or simply unconventional) when compared to other PoE-related projects
</details>
<br>

## Transparency Notice / Things you should know
<details><summary>show</summary>

- **things this tool does**

  - reads the game's client.txt log-file for certain statistics/events: current character level, area & transitions, NPC dialogues, etc.
 
  - sends key-presses to copy item-info, or activate chat-commands and in-game searches
 
  - checks screen-content for context-sensitivity to adapt the tool's behavior: it searches for open UIs (e.g. inventory, stash), `but it never reads/checks game-related values or bars`
 
  - reads on-screen text `on key-press` to summarize the information and display it in customizable tooltips
 
- **FAQ: has GGG approved this / can I be banned?**

  - to my knowledge, GGG has never approved any (local) 3rd-party tool
 
  - I can't make any claims about whether you'll get banned or not. All I can say is that I strictly follow [GGG's guidelines](https://www.pathofexile.com/developer/docs/index#policy): creators can be banned for distributing tools that violate the ToS, so it's in my best interest to follow them
 
  - (weak) anecdotal evidence: I have not been banned, nor have I heard of anyone else being banned
</details>
<br>

## Main Features
**`click the links to open the feature's wiki-page`**
<br>

### [Clone-frames](https://github.com/Lailloken/Lailloken-UI/wiki/Clone-frames): "interface-customization" by cloning & projecting screen areas  
| | example: rage meter | example: cooldowns / charges | example: flask status |
|---|---|---|---|
| PoE1 | ![img](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/cloneframes_001.jpg) | ![img](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/cloneframes_002.jpg) | ![img](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/cloneframes_003.jpg) |
| PoE2 | ![img](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/cloneframes_101.jpg) | ![img](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/cloneframes_102.jpg) | ![img](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/cloneframes_103.jpg) |
<br>

### [Item-info](https://github.com/Lailloken/Lailloken-UI/wiki/Item-info): compact & customizable tooltip to determine loot quality at a glance  
| | example: rare | example: unique| example: anointed |
|---|---|---|---|
| PoE1 | ![img](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/iteminfo_001.png) | ![img](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/iteminfo_002.png) | ![img](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/iteminfo_003.png) |
| PoE2 | ![img](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/iteminfo_101.png) | ![img](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/iteminfo_102.png) | |
<br>

### [Act-Tracker](https://github.com/Lailloken/Lailloken-UI/wiki/Act%E2%80%90Tracker): campaign-related QoL features  
| | \*automated campaign-guide overlay | quick-access PoB skilltree overlays | quick-access PoB gem setups |
|---|---|---|---|
| PoE1 | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/leveltracker_001.png) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/leveltracker_002.jpg) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/leveltracker_003.jpg) |
| PoE2 | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/leveltracker_101.png) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/leveltracker_102.jpg) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/leveltracker_103.jpg) |
<br>

### [Act-Decoder](https://github.com/Lailloken/Exile-UI/wiki/Act%E2%80%90Decoder): campaign layout overlay  
| | layout selection<br>based on indicators | advanced layouts | simple fallback |
|---|---|---|---|
| PoE1 | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/actdecoder_001.jpg) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/actdecoder_002.jpg) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/actdecoder_003.jpg) |
| PoE2 | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/actdecoder_101.jpg) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/actdecoder_102.jpg) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/actdecoder_103.jpg) |
<br>

### [Stash-Ninja](https://github.com/Lailloken/Lailloken-UI/wiki/Stash%E2%80%90Ninja): poe.ninja/bulk-exchange price-overlay & sale management
| customizable price-tags and profiles | conversion rates & optional price history | (bulk-)sale management & bulk-exchange listings |
|---|---|---|
| ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/stashninja_001.jpg) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/stashninja_002.jpg) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/stashninja_003.jpg) |
<br>

### \*[Map-Tracker](https://github.com/Lailloken/Lailloken-UI/wiki/Map%E2%80%90Tracker): collect, save, view, and export mapping-related data for statistical analysis
| | in-game log viewer |
|---|---|
| PoE1 | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/maptracker_001.png) |
| PoE2 | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/maptracker_101.png) |
<br>

### Overhauled [map-info panel](https://github.com/Lailloken/Lailloken-UI/wiki/Map-info-panel): streamlined & customizable map-mod tooltip and panel
| | tooltip for rolling maps | re-check mods on demand in maps | search/pin mods for quick access when switching builds |
|---|---|---|---|
| PoE1 | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/mapinfo_001.png) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/mapinfo_002.png) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/mapinfo_003.png) |
| PoE2 | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/mapinfo_101.png) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/mapinfo_102.png) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/mapinfo_103.png) |
<br>

### [Sanctum/Sekhema Planner](https://github.com/Lailloken/Lailloken-UI/wiki/Sanctum-and-Sekhema-Planner): floor scanner & interactive planner/analysis overlay
| | potential reach for every room | available pathing to "desired" rooms | how to avoid bad rooms & which rooms will be blocked off |
|---|---|---|---|
| PoE1 | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/sanctum_001.jpg) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/sanctum_002.jpg) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/sanctum_003.jpg) |
| PoE2 | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/sanctum_101.jpg) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/sanctum_102.jpg) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/sanctum_103.jpg) |
<br>

### [Enchant Finder](https://github.com/Lailloken/Exile-UI/wiki/Enchant-Finder): quick-access enchant calculator for blight oils and distilled emotions
| | streamlined import of materials | flexible searching/filtering via regex or keywords |
|---|---|---|
| PoE1 | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/anoints_001.jpg) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/anoints_002.jpg) |
| PoE2 | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/anoints_101.jpg) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/anoints_102.jpg) |
<br>

### [Recombination Simulator](https://github.com/Lailloken/Lailloken-UI/wiki/Recombination-Simulator): in-game overlay that simulates outcomes in a few clicks
| example 1: single mod transfer | example 2: runic + zeffre + archmage's wand |
|---|---|
| ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/recombination_001.png) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/recombination_002.png)
<br>

### [Context-menu](https://github.com/Lailloken/Lailloken-UI/wiki/Minor-Features) for items: single-hotkey access to features and popular 3rd-party websites  
| PoE1 | ![img](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/contextmenu_001.jpg) | ![img](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/contextmenu_002.jpg) | ![img](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/contextmenu_003.jpg) |
|---|---|---|---|
| PoE2 | ![img](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/contextmenu_101.jpg) | ![img](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/contextmenu_102.jpg) | |
<br>

### [Statlas](https://github.com/Lailloken/Exile-UI/wiki/Statlas): quick-access atlas overlay for map layouts, bosses, and statistics
**`Path of Exile 2 ONLY`**
| ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/statlas_001.png) |
|---|
<br>

### [Search-strings](https://github.com/Lailloken/Lailloken-UI/wiki/Search-strings): customizable, single-hotkey menu for every individual in-game search  
| | built-in: beast-crafting | example: Gwennen | example: vendor |
|---|---|---|---|
| PoE1 | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/searchstrings_001.jpg) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/searchstrings_002.jpg) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/searchstrings_003.jpg) |
| PoE2 | | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/searchstrings_102.jpg) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/searchstrings_103.jpg) |
<br>

### [Vaal Street](https://github.com/Lailloken/Exile-UI/wiki/Vaal-Street): currency exchange ratio-calculator, QoL, trade logging, and balance tracking
| | optional trade logging | ratio-calculator | optional balance tracking |
|---|---|---|---|
| PoE1 | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/vaalstreet_001.jpg) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/vaalstreet_002.jpg) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/vaalstreet_003.jpg) |
| PoE2 | ✔️ | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/vaalstreet_102.jpg) | ✔️ |
<br>

### Several minor [QoL features](https://github.com/Lailloken/Lailloken-UI/wiki/Minor-Features):  
| essence tooltip to check the next tier's stats | orb of horizons tooltips | countdown & stopwatch |
|---|---|---|
| ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/qol_001.png) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/qol_002.png) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/qol_003.png) |
||| **Path of Exile 2 compatible** |

| in-client notepad & sticky-notes | quick-access overlay and tracker for casual lab-runs | map-event notifications |
|---|---|---|
| ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/qol_004.png) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/qol_005.jpg) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/qol_006.png) |
| **Path of Exile 2 compatible** |||
<br>

### [Seed-explorer](https://github.com/Lailloken/Lailloken-UI/wiki/Seed-explorer): in-client UI to quickly test a legion jewel in every socket
| full view | skilltree & socket-selection | jewel/socket info, transformation results |
|---|---|---|
| ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/seedexplorer_001.jpg) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/seedexplorer_003.jpg) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/seedexplorer_002.png) |
<br>

### [Cheat-sheet Overlay Toolkit](https://github.com/Lailloken/Lailloken-UI/wiki/Cheat-sheet-Overlay-Toolkit): create customizable, context-sensitive overlays
**`Path of Exile 2 compatible`**  
| image overlay | app "overlay" | custom/advanced overlay |
|---|---|---|
| ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/cheatsheets_001.jpg) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/cheatsheets_002.jpg) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/cheatsheets_003.jpg) |
<br>

### [TLDR-Tooltips](https://github.com/Lailloken/Lailloken-UI/wiki/TLDR%E2%80%90Tooltips): customizable tooltips that summarize & highlight on-screen information
| eldritch altars | vaal side areas |
|---|---|
| ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/tldr_001.jpg) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/tldr_002.jpg) |
<br>

### [Betrayal-info](https://github.com/Lailloken/Lailloken-UI/wiki/Betrayal-Info): streamlined & customizable info-sheet (with optional image recognition)  
| simple mode: member-list & custom highlighting | img-recognition: on-hover reward list + board tracking |
|---|---|
| ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/betrayal_001.jpg) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/betrayal_002.jpg) |
<br>

### \*Support for [community translations](https://github.com/Lailloken/Lailloken-UI/discussions/categories/translations-localization):
| item-info tooltip in German | item-info tooltip in Japanese | map-info panel in German |
|---|---|---|
| ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/translations_001.jpg) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/translations_002.jpg) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/translations_003.jpg) |
<br>
<br>

### Acknowledgements
- `item-info` uses a custom version of [Path of Building's](https://github.com/PathOfBuildingCommunity/PathOfBuilding) datamined resources

- several features use data provided by poedb

- `act-tracker` has a default guide and PoB-import features that were originally derived from [exile-leveling](https://github.com/HeartofPhos/exile-leveling)

- `stash-ninja` uses price-data provided by [poe.ninja](https://poe.ninja/), and bulk-exchange support was implemented with [BocikPG](https://github.com/BocikPG)'s help

- `seed-explorer` uses a custom version of the timeless-jewel databases provided via [TimelessJewelData](https://github.com/KeshHere/TimelessJewelData)

- [GDI+ Library for AutoHotkey](https://github.com/marius-sucan/AHK-GDIp-Library-Compilation), [GDI+ ImageSearch](https://github.com/MasterFocus/AutoHotkey/blob/master/Functions/Gdip_ImageSearch/Gdip_ImageSearch.ahk), [OCR with UWP API](https://www.autohotkey.com/boards/viewtopic.php?t=72674) enable advanced screen/image-related features

- [AutoHotkey-JSON](https://github.com/cocobelgica/AutoHotkey-JSON) enables processing JSON databases

- [base64 decode for AutoHotkey](https://github.com/jNizM/AHK_Scripts/blob/master/src/encoding_decoding/base64.ahk) enables decoding PoB-exports

- [zlib wrapper for AutoHotkey](https://www.autohotkey.com/board/topic/63343-zlib/) enables decompressing and processing PoB-exports
<br>

### (Temporarily-)retired / Legacy Features:
| [Archnemesis Recipe Helper/Scanner](https://github.com/Lailloken/Lailloken-UI/wiki/%5BArchive%5D-Retired-Features#archnemesis-recipe-scanner) | [Delve-helper](https://github.com/Lailloken/Lailloken-UI/wiki/%5BArchive%5D-Retired-Features#delve-helper): in-game UI to help you find secret passages |
|---|---|
| ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/legacy_001.jpg) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/legacy_002.jpg) |

| [Necropolis Lantern Highlighting](https://github.com/Lailloken/Lailloken-UI/wiki/Necropolis) | \*[Overlayke: Kalandra Planner/Preview Overlay](https://github.com/Lailloken/Lailloken-UI/wiki/%5BArchive%5D-Retired-Features#overlayke-lake-of-kalandra-plannerpreview-overlay) | [Sanctum-room tooltip overlays](https://github.com/Lailloken/Lailloken-UI/releases/tag/v1.29.4-hotfix2) |
|---|---|---|
| ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/necropolis_003.jpg) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/legacy_004.jpg) | ![image](https://raw.githubusercontent.com/Lailloken/Lailloken-UI/main/img/readme/legacy_005.jpg) |
