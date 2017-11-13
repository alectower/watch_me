repeat
  set fileName to ""
  set logLine to ""

  tell application "System Events"
    set applicationName to name of first process where frontmost is true

    if applicationName = "Google Chrome" then
      tell application "Google Chrome"
        set visibleMode to mode of window 1
        if visibleMode is equal to "normal"
          set firstTabUrl to URL of first tab of front window
          set siteUrl to URL of active tab of front window
          set siteTitle to title of active tab of front window
          set logLine to "time='" & (current date) & "' app='Google Chrome'" & " url='" & siteUrl & "'" & " title='" & siteTitle & "'"
        end if
      end tell
    else if applicationName = "iTerm2" then
      tell application "iTerm"
        set tabName to name of current window
        set tabContent to the contents of the current session of the current window
        set fileNameLine to paragraph ((length of paragraphs of tabContent) - 2) of tabContent
        set text item delimiters of AppleScript to {"         "}
        if (length of text items of fileNameLine is not equal to 1)
          set firstString to first text item of fileNameLine
          set text item delimiters of AppleScript to {"/"}
          set filePath to text items of firstString
          set text item delimiters of AppleScript to {"."}
          if length of text items of filePath is greater than 0
            set fileNameParts to text items of last text item of filePath
            if (length of fileNameParts is equal to 2)
              set fileParts to text items of last item of filePath
              set digits to "0123456789"
              set noNumbers to true
              repeat with i from 1 to number of items in firstString
                if item i in firstString is in digits
                  set noNumbers to false
                  exit repeat
                end if
              end repeat
              if noNumbers and (length of text items of fileParts is equal to 2) and (first character of firstString is not in digits)
                set fileName to firstString
              end if
            end if
          end if
        else
          set fileName to paragraph (length of paragraphs of tabContent) of tabContent
          if fileName starts with " " or fileName is equal to ""
            set fileName to "N/A"
          end if
        end if
      end tell

      set logLine to "time='" & (current date) & "' app='iTerm2'" & " tab='" & tabName & "'" & " file='" & fileName & "'"
    end if

    if logLine is not equal to "" then
      do shell script "sfk udpsend localhost 4001 \"" & logLine & "\""
    end if
  end tell

  delay 1
end repeat
