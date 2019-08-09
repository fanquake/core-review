# AppleScript

[AppleScript](https://developer.apple.com/library/archive/documentation/AppleScript/Conceptual/AppleScriptLangGuide/introduction/ASLR_intro.html#//apple_ref/doc/uid/TP40000983) is a simple scripting language developed by Apple that can be used to automate tasks on macOS.

You can read about automating the UI using AppleScript [here](https://developer.apple.com/library/archive/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/AutomatetheUserInterface.html#//apple_ref/doc/uid/TP40016239-CH69-SW1).

### Repetitively load and unload wallets

This [script](load_unload_wallets.applescript) continuously loads and unloads 2 wallets using the GUI.

It can be used to produce a [scheduler crash](https://github.com/bitcoin/bitcoin/issues/16307) in Bitcoin Core.

```applescript
tell application "System Events" to tell process "Bitcoin Core"	
	repeat
		click menu item "Close Wallet..." of menu "File" of menu bar 1
		click button "Yes" of group 1 of window 1
		delay 0.2
		click menu item "Close Wallet..." of menu "File" of menu bar 1
		click button "Yes" of group 1 of window 1
		delay 0.2
		click menu item "[default wallet]" of menu "Open Wallet" of menu item "Open Wallet" of menu "File" of menu bar 1
		delay 0.2
		click menu item "test" of menu "Open Wallet" of menu item "Open Wallet" of menu "File" of menu bar 1
		delay 0.2
	end repeat
end tell
```
