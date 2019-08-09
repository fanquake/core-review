tell application "System Events" to tell process "Bitcoin Core"
	-- sane window location and size
	set position of window 1 to {0, 20}
	set size of window 1 to {500, 500}
	set frontmost to true
	
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
