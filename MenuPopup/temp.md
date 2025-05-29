I need to enhance the menuPopup.ahk script to:

1) Build primary and sub-menus from the array loaded from the menus.csv
2) Enable the MenuHandler function to handle the actions appropriately

- The first column being the primary menu text
- The second column is the sub-menu text
- The third column being the action type
  - The action type values I would like:
    - Clipboard  (Push a string into the clipboard)
    - SendInput  (Send Input so the text would evaluate {Tab} and {Enter})
    - SendRaw    (Send Raw so the text would NOT evaluate {Tab} and {Enter})
    - Code       (Run AHK code in the filename path in the 4th column)
- The fourth column would contain the information needed for the action.



g33kdude json 

