; Script generated by the HM NIS Edit Script Wizard.

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "NAEV"
!define PRODUCT_VERSION "0.4.2"
!define PRODUCT_PUBLISHER "NAEV Inc."
!define PRODUCT_WEB_SITE "http://naev.googlecode.com/"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\naev.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "..\logos\logo.ico"
!define MUI_UNICON "..\logos\logo.ico"

; Language Selection Dialog Settings
!define MUI_LANGDLL_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_LANGDLL_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "NSIS:Language"

RequestExecutionLevel user

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!insertmacro MUI_PAGE_LICENSE "legal\gpl-3.0.txt"
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!define MUI_FINISHPAGE_RUN "$INSTDIR\naev.exe"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "Spanish"

; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "naev-${PRODUCT_VERSION}-win32.exe"
InstallDir "$PROGRAMFILES\NAEV"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show

Function .onInit
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

Section "Principal" SEC01
  SetOutPath "$INSTDIR"
  SetOverwrite try
  File "bin\*.dll"
  File "bin\naev.exe"
  CreateDirectory "$SMPROGRAMS\NAEV"
  CreateShortCut "$SMPROGRAMS\NAEV\NAEV.lnk" "$INSTDIR\naev.exe"
  CreateShortCut "$DESKTOP\NAEV.lnk" "$INSTDIR\naev.exe"
  MessageBox MB_YESNO  "Want to download ndata? if unsure click yes." IDNO install_ok
  NSISdl::download "http://naev.googlecode.com/files/ndata-${PRODUCT_VERSION}" "ndata"
  Pop $R0
  StrCmp $R0 "success" install_ok
  MessageBox MB_OK|MB_ICONSTOP "Error while downloading ndata. Try downloading manually from naev.googlecode.com."
  install_ok:
SectionEnd

Section -AdditionalIcons
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\NAEV\Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
  CreateShortCut "$SMPROGRAMS\NAEV\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\naev.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\naev.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd


Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "Uninstall of $(^Name) was successfull"
FunctionEnd

Function un.onInit
!insertmacro MUI_UNGETLANGUAGE
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to uninstall $(^Name) and all its components?" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  MessageBox MB_YESNO  "Do you also want remove your saved games and configuration files? If you're planning to install another version of ${PRODUCT_NAME} later, click no." IDNO skipconf
  RMDir /r "$APPDATA\naev"
  skipconf:
  Delete "$INSTDIR\${PRODUCT_NAME}.url"
  Delete "$INSTDIR\naev.exe"
  Delete "$INSTDIR\*.dll"
  Delete "$INSTDIR\ndata"

  Delete "$SMPROGRAMS\NAEV\*.lnk"

  RMDir "$SMPROGRAMS\NAEV"
  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd