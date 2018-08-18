# gtav-portblock

## About this program
This tool uses *Windows Firewall* to set up port blocking and whitelisting so you can have a fun experience playing GTA V: Online alone or with your friends. You must enable it first if you want to use this tool.

This tool is not compatible if you are using a third-party firewall such as ZoneAlarm or Comodo.

This tool is useful if you want to play features such as CEO missions and Biker businesses that can otherwise only be played if you are in a Public session but wish to keep out griefers and/or modders whose sole intention are to ruin your game experience.

This is a tool written for convenience:
1. You do not need account registration with a third-party website.
2. You do not need to bother with the tedious configuration of Windows Firewall rules.

This tool does not touch any files related to the game:
1. Instead it manipulates your computer's connection to the network so you cannot connect to other players' sessions.
2. When you cannot connect to any network (same as if you have a terrible internet connection), the game places you into a public session by yourself.
3. Unless Rockstar Games decides to change their terms of service, there is no reason for your account to be flagged and banned as a result of using this tool.

## How to use
### How to play alone
1. Go to GTA V: Online.
2. After entering a public session, select "1) Start solo public session".
3. Wait for a few moments for players to leave the session. Find a new session if not.
4. ???
5. Profit!

### How to play with friends
1. Ensure your friends' IP are put in a text file called "whitelist.txt" in the same directory where this program is run. They can find their IP address through any third-party services such as www.canihazip.com or even simply googling "what is my ip".
2. Follow steps in "Play alone".
3. Select "1) Stop solo public session" and then "2) Start whitelist session"
4. Invite your friends into your session via Steam overlay or Rockstar Social Club.
5. ???
6. Profit!

### How to remove firewall rules
1. Select "Stop whitelist session" or "Stop solo public session".

Closed the program without selecting that first? The next time you run this they will be deleted automatically.