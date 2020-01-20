*** Settings ***
Documentation     Keyword for using in Microsite IL application (Android) automation testing
Library           String
Library           Process
Library           AppiumLibrary
Library           OperatingSystem
Library           Collections
Library           robot.libraries.DateTime
Resource          Resource_Environment.robot
Resource          Static_MicrositeIL.robot
Resource          Locators_MicrositeIL.robot
Library           ../Libraries/OpenPyxlLibrary.py
Library           ../Libraries/KillExcel.py

*** Keywords ***
Default Setup
    [Documentation]    Load Data Configuration from Excel
    Log   Test Excel File ...${TESTDATA_EXCEL_NAME}....Sheet [ ${SHEET_CONFIG} ]
    Read Excel Data Configure By Column Key Value    ${TESTDATA_EXCEL_NAME}   ${SHEET_CONFIG}
    Launch And Initial on Websit

Solution Tear Up
    [Documentation]    Load Data Member from Excel
    Create Fields Name Collection List
    Load Data From Test Data Sheet And Filter By Test Scenario ID    ${TESTDATA_EXCEL_NAME}    ${SHEET_CUSTOMER}       ${TEST_NAME}
    Load Data From Test Data Sheet And Filter By Test Scenario ID    ${TESTDATA_EXCEL_NAME}    ${SHEET_CALCPAYMENT}    ${TEST_NAME}
    Navigate to URL Website    Url_Locator=${InputURL_Browser_Locator}    WebsiteName=${APPLICATION_NAME}

Solution Tear Down
    [Documentation]    Logout from Solution Website
    Set Global Variable   ${gRepeatURL}    ${1}
    Clean Fields Value from List Collection
    Run Keyword If   ${gReqTearDownAction} == ${True}   Logout From Website

Read Excel Data Configure By Column Key Value
    [Arguments]        ${ExcelFileName}=${TESTDATA_EXCEL_NAME}    ${SheetName}=${SHEET_CONFIG}
    ...   ${RowsStartFrom}=${2}  ${ColIndex_Key}=1    ${ColIndex_Value}=2
    [Documentation]    Read Excel configuration data by using Key/Value
    ${ExcelFileName}    Set Variable   ${EXECDIR}${/}TestData${/}${ExcelFileName}

    open_excel      ${ExcelFileName}
    ${RowsCount}    Get_Row_Count       ${SheetName}
    ${ColsCount}    Get_Column_Count    ${SheetName}
    Log  Fetch Excel File [ ${ExcelFileName} ]\n${SPACE*8}Sheet [ ${SheetName} ]\n${SPACE*3}Total Rows [ ${RowsCount} ]\n Total Columns [ ${ColsCount} ]

    : FOR    ${RowsIndex}    IN RANGE    ${RowsStartFrom}    ${RowsCount} + 1
    \    ${Field_Key}    Read_Cell_Data_By_Coordinates    ${SheetName}    ${RowsIndex}    ${ColIndex_Key}
    \    ${Field_Val}    Read_Cell_Data_By_Coordinates    ${SheetName}    ${RowsIndex}    ${ColIndex_Value}
    \    ${Field_Key}    Strip String    ${Field_Key}
    \    ${Field_Val}    Strip String    ${Field_Val}
    \    Log    [${Field_Key}] \ \ [${Field_Val}]
    \    Set Suite Variable    ${Field_Key}    ${Field_Val}
    Log  Fetch Excel Data Sheet End

Load Data From Test Data Sheet And Filter By Test Scenario ID
    [Arguments]        ${ExcelFileName}    ${SheetName}    ${TestScenarioID}=${TEST_NAME}
    ...   ${RowsStartFrom}=${2}    ${ColIndex_Value}=1
    [Documentation]    Read Excel configuration data by using Key/Value

    ${ExcelFileName}            Set Variable    ${EXECDIR}${/}TestData${/}${ExcelFileName}
    ${RowIndex_Header}          Set Variable    ${1}
    ${ColsIndex_Field_Start}    Set Variable    ${2}
    ${MsgLen}                   Set Variable    ${0}
    ${Is_Found_TC}              Set Variable    ${False}
    ${TestScenarioID}           Strip String    ${TestScenarioID}

    open_excel      ${ExcelFileName}
    ${RowsCount}    Get_Row_Count       ${SheetName}
    ${ColsCount}    Get_Column_Count    ${SheetName}
    ${ColsCount}    Run Keyword If      ${ColsCount} > 0    Evaluate     ${ColsCount} + 1  ELSE   Set Variable   ${ColsCount}

    Log  Fetch Excel File [ ${ExcelFileName} ]\n${SPACE*8}Sheet [ ${SheetName} ]\n${SPACE*3}Total Rows [ ${rowsCount} ]\n Total Columns [ ${colsCount} ]
    : FOR    ${RowsIndex}    IN RANGE    ${RowsStartFrom}    ${RowsCount} + 1
    \    ${Field_Key}      Read_Cell_Data_By_Coordinates    ${SheetName}    ${RowIndex_Header}    ${ColIndex_Key}
    \    ${Field_Val}      Read_Cell_Data_By_Coordinates    ${SheetName}    ${RowsIndex}          ${ColIndex_Value}
    \    ${Field_Key}      Strip String    ${Field_Key}
    \    ${Field_Val}      Strip String    ${Field_Val}
    \    Log    [${Field_Key}] \ \ [${Field_Val}]
    \    ${MsgLen}         Get Length    ${Field_Val}
    \    Exit For Loop If    ${MsgLen} < 1
    \    ${Is_Found_TC}    Run Keyword And Return Status    Should Be Equal As Strings    '${Field_Val}'    '${TestScenarioID}'
    \    Set Test Variable    ${Field_Key}    ${Field_Val}
    \    Run Keyword If      ${Is_Found_TC}    Add Field Name Into List Collection        ${Field_Key}
    \    Run Keyword If      ${Is_Found_TC}    Fetches Data Column Member From Sheet      ${SheetName}    ${RowsIndex}    ${ColsCount}    ${RowIndex_Header}    ${ColsIndex_Field_Start}
    \    Exit For Loop If    ${Is_Found_TC}

Create Fields Name Collection List
    [Documentation]    Create global Fields Collection List
    ${gFieldsNameCollect} =    Create List
    Set Global Variable    ${gFieldsNameCollect}     ${gFieldsNameCollect}

Add Field Name Into List Collection
    [Arguments]    ${Field_Name}
    [Documentation]    Add data field name into collection

    ${Is_Existed}    Run Keyword And Return Status    List Should Contain Value    ${gFieldsNameCollect}    ${Field_Name}
    Run Keyword If   ${Is_Existed} == ${False}    Append To List    ${gFieldsNameCollect}    ${Field_Name}

Clean Fields Value from List Collection
    [Documentation]    Clear all data field from List collection
    : FOR    ${Field_Name}    IN    @{gFieldsNameCollect}
    \    ${Detect_Name}    Set Variable    ${Field_Name}
    \    Log    Test Variable Before ${Field_Name}
    \    Set Test Variable    ${Field_Name}    ${EMPTY}
    \    Log    Test Variable After ${Detect_Name} [${Field_Name}]

Verify Key Name Existing in Data Dictionary
    [Arguments]    ${KeyName}    ${Dict_Name}=${gFieldsNameCollect}
    [Documentation]    Make sure that the Dictionary key name already existed in Dictionary object

    ${Is_Presented}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${Dict_Name}    ${KeyName}
	[Return]    ${Is_Presented}

Fetches Data Column Member From Sheet
    [Arguments]        ${SheetName}    ${RowsIndex}    ${ColsCount}    ${RowsIndex_Key}=${1}    ${ColsIndex_Start}=${2}
    [Documentation]    Read and Map data fields from Excel Value
    : FOR    ${Cols_Index}    IN RANGE    ${ColsIndex_Start}    ${ColsCount}
    \    ${Field_Key}      read_cell_data_by_coordinates    ${SheetName}    ${RowsIndex_Key}    ${Cols_Index}
    \    ${Field_Value}    read_cell_data_by_coordinates    ${SheetName}    ${RowsIndex}        ${Cols_Index}
    \    Log    ${Field_Key} \ \ ${Field_Value}
    \    Add Field Name Into List Collection     ${Field_Key}
    \    Set Global Variable    ${Field_Key}     ${Field_Value}

Go To Previous On Times
    [Arguments]    ${Total_Back}=${1}    ${ReqToCap}=True
    [Documentation]    Go back the Previous page
    : FOR    ${INDEX}    IN RANGE    1    ${Total_Back}
    \    Go Back
    \    Sleep    ${MAX_DELAY_GOBACK_OPTION}
    \    Run Keyword If    "${ReqToCap}" == "True"    Take Capture Screen File

Get Android Screen Size
    [Documentation]    Get an Android Screen size
    ${h} =    Get Window Height
    ${h} =    Convert To Integer    ${h}
    Set Global Variable    ${Height}    ${h}
    ${w} =    Get Window Width
    ${w} =    Convert To Integer    ${w}
    Set Global Variable    ${Width}    ${w}

Launch Mobile Application On
    [Documentation]    Execute the Application launching command
    Log  Url [${REMOTEURL}]\n${SPACE*1}Platform Name [${PLATFORMNAME}]\n${SPACE*5}Platform Version [${PLATFORMVERSION}]\n${SPACE*5}Device Name [${DEVICENAME}]\n${SPACE*5}UDID [${UDID}]\n${SPACE*3}noReset[${NO_RESET}]\n${SPACE*3}appPackage[${APP_PACKAGE}]\n${SPACE*3}appActivity[${APP_ACTIVITY}]\n${SPACE*3}browser[${BROWSER_NAME}]\n${SPACE*5}APP ${APPLICATION_NAME}

    Start Process   appium -p 4732  shell=true     alias=test
    Process Should Be Running   handle=test     error_message=Process is not running
    ${prcid}    Get Process ID      handle=test
    Log   Detect Proess Id [${prcid}]

    Open Application    ${REMOTEURL}
    ...   platformName=${PLATFORMNAME}
    ...   platformVersion=${PLATFORMVERSION}
    ...   deviceName=${DEVICENAME}
    ...   udid=${UDID}
    ...   noReset=${NO_RESET}
    ...   appPackage=${APP_PACKAGE}
    ...   appActivity=${APP_ACTIVITY}
    ...   browser=${BROWSER_NAME}
    ...   automationName=UiAutomator2
    Sleep   ${MAX_DELAY_LAUNCH_APP}
    Take Capture Screen File    Mobile Luanch Application - {index}.png

Verify Location Not Existing
    [Arguments]    ${LocationObject}    ${TotalTimeout}=10    ${ReqToCap}=True
    [Documentation]    To make sure that the Location not existing
    Wait Until Page Does Not Contain Element    ${LocationObject}    timeout=${TotalTimeout}
    Run Keyword If    "${ReqToCap}" == "True"    Take Capture Screen File

Launch And Initial on Websit
    [Arguments]    ${WebsiteName}=${APPLICATION_NAME}    ${DelayForAppl}=${MAX_TIME_APPL}     ${DelayElement}=${MAX_TIME_WAITING}
    [Documentation]    Initial website before accessing to URL

    Launch Mobile Application On
    ${IsAcceptStatus}    Run Keyword And Return Status    Wait Until Element Is Visible    ${ButtonAccept_Chrome_Locator}    ${DelayForAppl}

    Verify Chrome Accessing Login Section And Clicking On    ${ButtonAccept_Chrome_Locator}    ${IsAcceptStatus}    ${DelayElement}
    Verify Chrome Accessing Login Section And Clicking On    ${ButtonNext_Chrome_Locator}      ${IsAcceptStatus}    ${DelayElement}
    Verify Chrome Accessing Login Section And Clicking On    ${ButtonNoThks_Chrome_Locator}    ${IsAcceptStatus}    ${DelayElement}
    Verify Chrome Accessing Login Section And Clicking On    ${BoxSearch_Chrome_Locator}       ${IsAcceptStatus}    ${DelayElement}

Navigate to URL Website
    [Arguments]    ${Url_Locator}=${InputURL_Browser_Locator}    ${WebsiteName}=${APPLICATION_NAME}
    [Documentation]    Access onto Website on url name

    ${Is_Repeated}    Run Keyword And Return Status    Should Be Equal    ${gRepeatURL}    ${1}
    Run Keyword If    ${Is_Repeated}   Click Element          ${Url_Locator}
    Run Keyword If    ${Is_Repeated}   Wait And Input Data    ${Url_Locator}    ${RefreshURLSite}
#    Run Keyword If    ${Is_Repeated}   Click Element          ${Url_Locator}
    Run Keyword If    ${Is_Repeated}   Solution Press Enter Key
    ${Is_Visibled}    Run Keyword If    ${Is_Repeated}    Run Keyword And Return Status    Wait Until Element Is Visible     ${RefreshURLBeShown}    ${5}
    Click Element          ${Url_Locator}
    Wait And Input Data    ${Url_Locator}    ${WebsiteName}
#    Click Element          ${Url_Locator}
    Solution Press Enter Key

Verify Chrome Accessing Login Section And Clicking On
    [Arguments]     ${Locator}    ${bEnforceStatusChecking}=${True}    ${Timeout}=3
    [Documentation]    Verify Chrom Accessing to Login and clicking on
    ${IsActived}    Run Keyword If    ${bEnforceStatusChecking}     Run Keyword And Return Status    Wait Until Element Is Visible    ${Locator}    ${Timeout}
    Run Keyword If    ${IsActived}    Click Element    ${Locator}

Login To Website
    [Arguments]     ${Timeout}=${MAX_TIME_WAITING}
    [Documentation]    Log in to Solution Website
    ${IsButtonSignInFound}    Run Keyword And Return Status    Wait Until Element Is Visible    ${ButtonDirect_SignIn_Locator}    1
    Run Keyword If    ${IsButtonSignInFound}    Access into the Profile Menu of Settings part
    Clear Text             ${LoginName_SignIn_Locator}
    Wait And Input Data    ${LoginName_SignIn_Locator}   ${LoginByUser}
    Clear Text             ${LoginPwd_SignIn_Locator}
    Wait And Input Data    ${LoginPwd_SignIn_Locator}    ${Password}
    Click Element At Coordinates   ${555}   ${345}
    Take Capture Screen File
    Access Or Register via Channel

Validate Member Login
    [Arguments]     ${CheckByUserName}=${UserName}    ${Timeout}=${MAX_TIME_WAITING}
    [Documentation]    Log in to Solution Website
    Wait Until Page Contains    ${UserName}    ${Timeout}
    Take Capture Screen File

Logout From Website
    [Arguments]     ${Timeout}=${MAX_TIME_WAITING}    ${MaxTimeNotDisplayData}=${2}
    [Documentation]    Logout from Solution Website
    Run Keyword If    ${gReqLogout}    Wait And Click on Locator   ${ButtonLogout_Home_Locator}    ${Timeout}
    Run Keyword If    ${gReqLogout}    Wait Until Page Does Not Contain    ${UserName}    ${MaxTimeNotDisplayData}

Wait And Input Data
    [Arguments]    ${Locator}    ${Text}    ${timeout}=${MAX_TIME_WAITING}
    [Documentation]    Waits for the Element given in the locator and then input the text in the locator

    Wait Until Page Contains Element    ${Locator}    ${timeout}    "TextBox is not seen in the given time"
    Input Text    ${Locator}    ${Text}
    Log    Inputted ${Text} at ${Locator}

Wait And Click on Locator
    [Arguments]    ${Locator}    ${Timeout}=${MAX_TIME_WAITING}
    [Documentation]    Waits for the Element given in the locator and then clicks the element
    Wait Until Page Contains Element    ${Locator}    ${Timeout}    "Element is not seen in the given time"
    Click Element    ${Locator}
    Log    Clicked element at ${Locator}

Wait And Click on Text Caption
    [Arguments]    ${CaptionInfo}    ${Timeout}=${MAX_TIME_WAITING}
    [Documentation]    Waits for the Text given and then clicks on
    ${Is_Visibled}    Set Variable    ${False}
    Log    Clicked Text At [${CaptionInfo}]
    : FOR    ${iLoop}    IN RANGE    1    ${Timeout} + 1
    \   ${Is_Visibled}    Run Keyword And Return Status    Page Should Contain Text   ${CaptionInfo}
    \    Exit For Loop If   ${Is_Visibled}
    \    Sleep    ${1}
    Run Keyword If    ${Is_Visibled}    Click Text    ${CaptionInfo}
    ...    ELSE    "Text [${CaptionInfo}] is not seen in the given time [${Timeout}]"

Solution Press Enter Key
    [Documentation]    Press Enter Key to confirm
    Press Keycode    66    # KEYCODE_ENTER

Take Capture Screen File
    [Arguments]        ${sImageFileName}=${EMPTY}    ${Is_DefaultFile}=${False}    ${DelayTimeBeforeCapture}=1
    [Documentation]    Capture screen by classing on Test Scenario ID
#    ${MsgLen}    Get Length    ${sImageFileName}
#    ${sImageFileName}    Set Variable If    ${MsgLen} > 3  ${sImageFileName}
#    ...   ${MsgLen} == 0 and ${Is_DefaultFile} == ${False}    ${TEST_NAME}-{index}.png
#    Run Keyword If   ${Is_DefaultFile} == ${True}    Capture Page Screenshot
#    ...   ELSE    Capture Page Screenshot   filename=${sImageFileName}
    Sleep   ${DelayTimeBeforeCapture}
    Capture Page Screenshot

Wait Until Element Should Be Enabled
    [Arguments]        ${Locator}     ${Timeout}=${MAX_TIME_WAITING}
    [Documentation]    Capture screen by classing on Test Scenario ID

    : FOR    ${iLoop}    IN RANGE    1    ${Timeout}
    \    ${IsEnabled}    Run Keyword And Return Status    Element Should Be Enabled    ${Locator}
    \    Run Keyword If    ${IsEnabled}    Exit For Loop
    \    Sleep    1
    Element Should Be Enabled    ${Locator}

Click Locator on Collection
    [Arguments]    ${ItemListInfo}    ${Locator}    ${FindMsg}=${STATIC_TXT_REPLACEITEM}
    ...   ${Timeout}=5    ${FilterBySymbol}=${gSTATIC_FILTER_BY}   ${TimeOut_NextItem}=1
    [Documentation]    Verify Locator from Collection string and clicking on when is visibled and enabled
    ${iTimes}       Set Variable    ${0}
    ${DelayTime}    Set Variable    ${Timeout}
    @{myListMsg}    Split String    ${ItemListInfo}    ${FilterBySymbol}
    : FOR    ${ItemInfo}    IN    @{myListMsg}
    \    Log    Get Tag Item name....[${ItemInfo}]
    \    ${ItemInfo} =        Strip String      ${ItemInfo}
    \    ${MsgLen} =          Get Length        ${ItemInfo}
    \    Exit For Loop If    ${MsgLen} < 1
    \    ${iTimes} =          Evaluate    ${iTimes} + 1
    \    ${DelayTime}         Set Variable If    ${iTimes} == 1    ${Timeout}    ${TimeOut_NextItem}
    \    ${myElement} =       Replace String     ${Locator}    ${FindMsg}    ${ItemInfo}
    \    ${IsVisibled} =      Run Keyword And Return Status    Wait Until Element Is Visible           ${myElement}    ${DelayTime}
    \    ${IsEnbled} =        Run Keyword And Return Status    Wait Until Element Should Be Enabled    ${myElement}    ${DelayTime}
    \    Run Keyword If      ${IsVisibled} and ${IsEnbled}     Click Element                           ${myElement}
    \    Exit For Loop If    ${IsVisibled} and ${IsEnbled}

Verify and Input Data
    [Arguments]    ${Input_Locator}    ${Data}     ${ReqClearFirst}=${True}   ${ScreenArea_Locator}=${ScreenArea_Home_Locator}
    ...   ${ReqSwiped}=${True}    ${ReqClickBeforeInput}=${True}
    [Documentation]    Input data whenever this field not empty
    ${MsgLen}    Get Length    ${Data}
    Run Keyword If   ${MsgLen} > 0 and '${ReqSwiped}' == 'True'   Focus On Locator By Scrolling Up Screen    ${Input_Locator}
    Run Keyword If   ${MsgLen} > 0 and '${ReqClickBeforeInput}' == 'True'    Click Element                   ${Input_Locator}
    Run Keyword If   ${MsgLen} > 0     Hide Keyboard
    Run Keyword If   ${MsgLen} > 0    Clear Field And ReInput Data    ${Input_Locator}    ${Data}   ${ReqClearFirst}

Clear Field And ReInput Data
    [Arguments]    ${Input_Locator}    ${Data}     ${ReqClearFirst}=${True}
    [Documentation]    Clear data field and re-input info

    Run Keyword If    ${ReqClearFirst} == ${True}    Clear Text    ${Input_Locator}
    Wait And Input Data    ${Input_Locator}    ${Data}

Wait Until Locator Is Not Visible
    [Arguments]    ${Locator}   ${TimeOut}=5
    [Documentation]    Wait locator invisible within period of time
    ${Is_InVisible}    Set Variable    ${False}

    : FOR    ${LoopIndex}    IN RANGE    1     ${TimeOut} + 1
    \   ${Is_InVisible}    Run Keyword And Return Status    Element Should Be Visible    ${Locator}
    \   Exit For Loop If   '${Is_InVisible}' == 'False'
    \   Sleep   1
    ${Visible_Status}    Set Variable If    ${Is_InVisible}   ${False}    ${True}
    [Return]   ${Visible_Status}

Swipe Screen Locator
    [Arguments]    ${Screen_Locator}   ${Is_MoveTextToUp}=${True}    ${DelayTime}=${0.2}
    [Documentation]    Swipe Screen Up/Down on locator area
#    ${StepOnStart_Y}    Set Variable If    '${Is_MoveTextToUp}' == 'True'    ${0.7}   ${0.3}
#    ${StepOnEnd_Y}      Set Variable If    '${Is_MoveTextToUp}' == 'True'    ${0.3}   ${0.7}
    ${StepOnStart_Y}    Set Variable If    '${Is_MoveTextToUp}' == 'True'    ${0.8}   ${0.4}
    ${StepOnEnd_Y}      Set Variable If    '${Is_MoveTextToUp}' == 'True'    ${0.4}   ${0.8}

    ${Locator_Size} =        Get Element Size        ${Screen_Locator}
    ${Locator_location} =    Get Element Location    ${Screen_Locator}
    ${Start_X}=              Evaluate                ${Locator_location['x']} + (${Locator_Size['width']} * 0.5)
    ${Start_Y}=              Evaluate                ${Locator_location['y']} + (${Locator_Size['height']} * ${StepOnStart_Y})
    ${End_X}=                Evaluate                ${Locator_location['x']} + (${Locator_Size['width']} * 0.5)
    ${End_Y}=                Evaluate                ${Locator_location['y']} + (${Locator_Size['height']} * ${StepOnEnd_Y})
    Swipe          ${Start_X}    ${Start_Y}    ${End_X}    ${End_Y}    500
    Sleep          ${DelayTime}

Focus On Locator By Scrolling Up Screen
    [Arguments]    ${Locator}    ${ScreenArea_Locator}=${ScreenArea_Home_Locator}
    ...    ${TotalScrolling}=${5}    ${DelayWaitingTimes}=${1}    ${SwipInterval}=${600}
    [Documentation]    Scroll or Swipe screen up/down when element locator is not displayed or focused
    : FOR    ${LoopIndex}    IN RANGE    1     ${TotalScrolling} + 1
    \   ${Is_Visibled}          Run Keyword And Return Status    Element Should Be Visible    ${Locator}
    \   Exit For Loop If    ${Is_Visibled}
    \   ${Element_Size}=        Get Element Size        ${ScreenArea_Locator}
    \   ${Element_Location}=    Get Element Location    ${ScreenArea_Locator}
    \   ${Start_X}=             Evaluate                ${Element_Location['x']} + (${Element_Size['width']} * 0.4)  #0.5
    \   ${Start_Y}=             Evaluate                ${Element_Location['y']} + (${Element_Size['height']} * 0.2)  #0.7
    \   ${End_X}=               Evaluate                ${Element_Location['x']} + (${Element_Size['width']} * 0.4)   #0.5
    \   ${End_Y}=               Evaluate                ${Element_Location['y']} + (${Element_Size['height']} * 0.1)  #0.3
    \   Swipe    ${Start_X}   ${Start_Y}   ${End_X}   ${End_Y}   ${SwipInterval}
    \   Sleep   ${DelayWaitingTimes}
    Close Info Bar Icon
