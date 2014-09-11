# Tournament Code Generator

1. Setup automated match reporting, e.g. if you are running a tournament.
2. Pass around the tournament code to let people to join a lobby without having to have the lobby owner/host invite, because there is currently no option to give invite to other people in the lobby.

## Query String
|Name|Type|Description|
|---|:-:|---|
|index|`bool`|Append a numerical index to extra codes generated via `codes`.
|rhash|`bool`|Append a randomized hash to extra codes generated via `codes`.
|rpass|`bool`|Use a pseudo-random password (unique to each tournament code).
|codes|`int`|The number of additional tournament codes to generate.
|map|`int`|The specified map, corresponding to its position in the dropdown.
|mode|`int`|The specified mode, corresponding to its position in the dropdown.
|spec|`int`|The spectator format, corresponding to its position in the dropdown.
|lobby|`string`|The lobby name. Defaults to `Custom Lobby` plus a hash.
|pass|`string`|The lobby password.  Defaults to an empty string (no password).

Where relevant, all integer values start at `1` (i.e. are 1-indexed arrays).
