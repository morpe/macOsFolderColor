-- Percorso assoluto a fileicon (modifica se diverso)
set fileiconPath to "/opt/homebrew/bin/fileicon"

-- Verifica se fileicon è installato
try
	do shell script "test -x " & quoted form of fileiconPath
on error
	display dialog "❌ 'fileicon' non è installato o il percorso è errato." & return & return & "Puoi installarlo con:" & return & "brew install fileicon" buttons {"OK"} default button "OK"
	return
end try

-- Ottieni la selezione nel Finder
tell application "Finder"
	set sel to selection
end tell

-- Filtra solo le cartelle (usando class, non kind!)
set folderList to {}
repeat with i in sel
	tell application "Finder"
		if class of i is folder then
			copy (POSIX path of (i as alias)) to end of folderList
		end if
	end tell
end repeat

-- Se nessuna cartella è stata selezionata
if (count of folderList) = 0 then
	display dialog "❌ Nessuna cartella selezionata." buttons {"OK"} default button "OK"
	return
end if

-- Menu colori
set iconFolder to "/Users/Shared/Colored Folders/"
set colorList to {"black", "blue", "green", "grey", "orange", "purple", "red", "yellow", "Ripristina"}

-- Scegli colore
set chosenColor to choose from list colorList with prompt "Scegli un colore per le cartelle selezionate, oppure 'Ripristina' per tornare all'originale:"
if chosenColor is false then return
set chosenColor to item 1 of chosenColor

-- Applica l’icona a ogni cartella
repeat with folderPath in folderList
	if chosenColor is "Ripristina" then
		do shell script "SetFile -a C " & quoted form of folderPath
	else
		set iconPath to iconFolder & chosenColor & ".icns"
		do shell script fileiconPath & " set " & quoted form of folderPath & " " & quoted form of iconPath
	end if
end repeat

-- Conferma
display dialog "✅ Icona aggiornata per " & (count of folderList) & " cartella/e." buttons {"OK"} default button "OK"
