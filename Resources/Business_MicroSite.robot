*** Settings ***
Documentation     Keyword for using in Microsite IL Business Process application (Android) automation testing
Library           String
Library           Process
Library           AppiumLibrary
Library           OperatingSystem
Library           Collections
Library           ../Libraries/OpenPyxlLibrary.py
Library           ../Libraries/KillExcel.py
Resource          Static_MicrositeIL.robot
Resource          Locators_MicrositeIL.robot
Resource          Resource_Environment.robot
Resource          Resource_MicrositeIL.robot

*** Keywords ***
Customer Data Input
    [Documentation]    Accessing to Member Data either manual fill-in or automatically via SandBox process
    ${Is_Executed} =        Run Keyword And Return Status    Should Be Equal As Strings   ${Executed}            ${STATIC_FLAG_YES}    ignore_case=True
    ${Is_Mode_SandBox} =    Run Keyword And Return Status    Should Be Equal As Strings   ${IS_Fill_SandBox}     ${STATIC_FLAG_YES}    ignore_case=True
    ${Is_Mode_FillIn} =     Run Keyword And Return Status    Should Be Equal As Strings   ${IS_Fill_Customer}    ${STATIC_FLAG_YES}    ignore_case=True
    ${Is_Mode_FillIn}       Set Variable If    ${Is_Mode_SandBox}    ${False}    ${Is_Mode_FillIn}

    Run Keyword If   ${Is_Executed} and ${Is_Mode_SandBox}    Connect to Easy SandBox    ${SandBox_PIN}
    Run Keyword If   ${Is_Executed} and ${Is_Mode_FillIn}     Registry Customer Information

Get Month Data Pattern
    [Arguments]    ${Detect_Lang}=${AppLanguage}   ${Request_FullText}=${True}
    [Documentation]   Retrieve Month name depending on language and full text
    ${MonthText}    Set Variable If
    ...     '${Detect_Lang}' == '${STATIC_LANG_ENG}' and ${Request_FullText} == ${True}         ${STATIC_MONTHNAME_FULL_LANG_ENG}
    ...     '${Detect_Lang}' == '${STATIC_LANG_TH}' and ${Request_FullText} == ${True}          ${STATIC_MONTHNAME_FULL_LANG_TH}
    ...     '${Detect_Lang}' == '${STATIC_LANG_ENG}' and ${Request_FullText} == ${False}        ${STATIC_MONTHNAME_SHORT_LANG_ENG}
    ...     '${Detect_Lang}' == '${STATIC_LANG_TH}' and ${Request_FullText} == ${False}         ${STATIC_MONTHNAME_SHORT_LANG_TH}
    ...     ${EMPTY}
    [Return]   ${MonthText}

Retrieval Month Name Pattern
    [Arguments]    ${Detect_Lang}=${AppLanguage}   ${Request_FullText}=${True}   ${MonthValue}=${0}
    [Documentation]   Retrieve Month name depending on language and full text
    ${MonthText} =    Get Month Data Pattern   ${Detect_Lang}   ${Request_FullText}
    ${MsgLen}         Get Length               ${MonthText}
    Run Keyword If    ${MsgLen} < 1            [Return]   ${EMPTY}

    ${MonthList}      Split String             ${MonthText}     |
    ${MonthValue} =   Convert To Integer       ${MonthValue}
    ${myIndex} =      Evaluate                 ${MonthValue} - 1
    ${MonthName} =    Set Variable If   ${MonthValue} > ${0}    ${MonthList[${myIndex}]}     ${EMPTY}
    [Return]    ${MonthName}

Get Month Index From Pattern
    [Arguments]    ${MonthName}    ${Detect_Lang}=${AppLanguage}   ${Request_FullText}=${True}
    [Documentation]   Retrieve Month name depending on language and full text
    ${MonthIndex}     Set Variable   ${-1}
    ${MonthText} =    Get Month Data Pattern   ${Detect_Lang}   ${Request_FullText}
    ${MonthList}      Split String    ${MonthText}   |
    ${ListCount}      Get Length   ${MonthList}
    : FOR    ${iLoop}    IN RANGE    1    ${ListCount} + 1
    \    ${FieldValue}   Set Variable    ${MonthList[${iLoop}]}
    \    ${MsgLen}       Get Length      ${FieldValue}
    \    Exit For Loop If   ${MsgLen} < 1
    \    ${FieldValue}    Strip String    ${FieldValue}
    \    ${Is_Matched}    Run Keyword And Return Status   Should Be Equal As Strings   ${FieldValue}   ${MonthName}    ignore_case=True
    \   ${MonthIndex}     Set Variable If    ${Is_Matched}   ${iLoop}    ${MonthIndex}
    \    Exit For Loop If   ${Is_Matched}
    [Return]    ${MonthIndex}

Select Customer Sexual Type
    [Arguments]    ${SexType}   ${Timeout}=${MAX_TIME_WAITING}
    [Documentation]    Select Customer sex
    ${Text_Info} =    Replace String     ${SexType}                   ${STATIC_SEX_PREFIX_TH}    ${EMPTY}
    ${Locator} =      Replace String     ${RadioSex1_Home_Locator}    ${STATIC_TEXT_REPLACE}     ${Text_Info}
    ${MsgLen}         Get Length         ${Locator}
    ${MaxTimesOn}     Set Variable If    ${MsgLen} > 0    3    0
    : FOR    ${iLoop}    IN RANGE    1    ${MaxTimesOn}
    \    Wait And Click on Locator    ${Locator}     ${Timeout}
    \    ${Status}    Get Element Attribute        ${Locator}    selected
    \    Exit For Loop If    '${Status}' == 'True'
    \    Take Capture Screen File
    Take Capture Screen File

Select Card Type
    [Arguments]    ${CardType}    ${ScreenArea_Locator}=${ScreenArea_Home_Locator}    ${Timeout}=${MAX_TIME_WAITING}
    [Documentation]    Select Card Category type from pop up
    Send Enter Key Code From Keyboard
    ${Locator}    Set Variable If
    ...    '${CardType}' == '${STATIC_CARDTYPE_PID_ENG}'           ${RadioCardType_PID_Home_Locator}
    ...    '${CardType}' == '${STATIC_CARDTYPE_PASSPORT_ENG}'      ${RadioCardType_Passport_Home_Locator}
    ...    '${CardType}' == '${STATIC_CARDTYPE_OTHER_ENG}'         ${RadioCardType_Other_Home_Locator}
    ...    '${CardType}' == '${STATIC_CARDTYPE_PID_TH}'            ${RadioCardType_PID_Home_Locator}
    ...    '${CardType}' == '${STATIC_CARDTYPE_PASSPORT_TH}'       ${RadioCardType_Passport_Home_Locator}
    ...    '${CardType}' == '${STATIC_CARDTYPE_OTHER_TH}'          ${RadioCardType_Other_Home_Locator}
    ...    ${EMPTY}
    ${myLen}    Get Length    ${Locator}
    Run Keyword If   ${myLen} > 0    Wait And Click on Locator    ${Locator}     ${Timeout}

Select Calendar Date Assignment
    [Arguments]    ${Calendar_Date}    ${ByLangName}=${STATIC_LANG_ENG}   ${Calendar_Locator}=${TextCalendar_Day_Home_Locator}
    ...   ${Timeout}=${MAX_TIME_WAITING}
    [Documentation]    Set date on calendar from format dd/mm/yyyy

    Wait And Click on Locator    ${BoxCust_BOD_Home_Locator}     ${Timeout}

    ${myListDate}    Split String    ${Calendar_Date}    ${gSTATIC_SYM_SLASH}
    ${DateField}     Strip String    ${myListDate[0]}
    ${MonthField}    Strip String    ${myListDate[1]}
    ${YearField}     Strip String    ${myListDate[2]}
    ${MsgLen}        Get Length      ${DateField}

    Wait Until Element Is Visible       ${ButtonCalendarYear_Home_Locator}
    ${YearText}             Get Text    ${ButtonCalendarYear_Home_Locator}
    ${NeedToClickYear} =    Run Keyword And Return Status    Should Not Be Equal    ${YearField}   '${YearText}'
    Run Keyword If    ${NeedToClickYear}    Select Year On Calendar    ${YearField}

    ${DateField} =       Convert Date Data Pattern   ${Calendar_Date}       ${ByLangName}
    ${NodeItemName} =    Replace String              ${Calendar_Locator}    ${STATIC_TEXT_REPLACE}    ${DateField}

    Select Month On Calendar     ${MonthField}    Calendar_Locator=${NodeItemName}    Detect_Lang=${AppLanguage}
    Wait And Click on Locator    ${NodeItemName}
    Take Capture Screen File
    Wait And Click on Locator    ${ButtonCalendarOK_Home_Locator}    ${Timeout}

Close Info Bar Icon
    [Arguments]    ${Timeout}=${1}
    [Documentation]    Close the Info Bar Icon when it displays
    ${IsVisibled}    Run Keyword And Return Status    Wait Until Element Is Visible    ${ButtonInfoBarClose_Home_Locator}    ${Timeout}
    Run Keyword If    ${IsVisibled}    Click Element    ${ButtonInfoBarClose_Home_Locator}

Select Month On Calendar
    [Arguments]    ${Month_Value}    ${Calendar_Locator}   ${Detect_Lang}=${STATIC_LANG_ENG}   ${Timeout}=${MAX_TIME_WAITING}
    [Documentation]    Choose and scroll Month value from calendar
    ${Is_Visible_Month}   Set Variable   ${False}

    Wait Until Element Is Visible    ${TextHeaderMonth_Calendar_Home_Locator}   ${Timeout}   Month pattern is not show within time [${Timeout}]

    ${MonthName_Para}   Retrieval Month Name Pattern    Detect_Lang=${Detect_Lang}   Request_FullText=${False}    MonthValue=${Month_Value}
    ${TextMonthView}    Get Text        ${TextHeaderMonth_Calendar_Home_Locator}
    ${myListDate}       Split String    ${TextMonthView}    ${SPACE}
    ${ArrayLen}         Get Length      ${myListDate}
    ${MonthName_Text}   Strip String    ${myListDate[${ArrayLen} - 1]}
    ${Month_Index}=     Get Month Index From Pattern   MonthName=${MonthName_Text}    Detect_Lang=${Detect_Lang}   Request_FullText=${False}

    ${Month_Value}      Convert To Integer    ${Month_Value}
    ${Moving_Total}     Evaluate    ${Month_Index} - ${Month_Value}
    ${Moving_Locator}   Set Variable If
    ...   ${Moving_Total} > 0    ${ButtonMonthPrev_Calendar_Home_Locator}
    ...   ${Moving_Total} < 0    ${ButtonMonthNext_Calendar_Home_Locator}
    ...   ${Moving_Total} == 0   ${gNotInCondition}
    ${CalcStep}         Set Variable If   ${Moving_Total} < 0    ${-1}    ${1}
    ${Moving_Total}     Evaluate  ${Moving_Total} * ${CalcStep}

    : FOR    ${RowsIndex}    IN RANGE    1     ${Moving_Total} + 3
    \   ${Is_Visible_Month}    Run Keyword And Return Status    Element Should Be Visible    ${Calendar_Locator}
    \   Exit For Loop If   ${Is_Visible_Month}
    \   Click Element      ${Moving_Locator}
    \   Sleep   0.1
    Take Capture Screen File
    Run Keyword If   ${Is_Visible_Month} == ${False}   Fail   Not found Month name [${MonthName_Para}]

Select Year On Calendar
    [Arguments]    ${Year_Value}    ${Timeout}=${3}     ${MaxTimeMovingText}=${20}
    [Documentation]    Choose and scroll Year value from calendar

    ${Is_Visible_Year}    Set Variable    ${False}
    ${Year_Value_Org}     Set Variable    ${Year_Value}
    Wait And Click on Locator     ${ButtonCalendarYear_Home_Locator}

    ${Top_Value}        Get Text              ${TextYearTop_Calendar_Home_Locator}
#    ${Low_Value}        Get Text              ${TextYearLow_Calendar_Home_Locator}
    ${Is_MoveTextUp}    Set Variable If   ${Year_Value} > ${Top_Value}    ${True}    ${False}

    : FOR    ${RowsIndex}    IN RANGE    1     ${MaxTimeMovingText} + 1
    \   ${Is_Visible_Year}    Run Keyword And Return Status    Wait Until Page Contains     ${Year_Value}   1
    \   Exit For Loop If   ${Is_Visible_Year}
    \   ${Top_Value}    Get Text    ${TextYearTop_Calendar_Home_Locator}
    \   Log   Top Current Year [${Top_Value}] Compare With Year Input [${Year_Value}] MoveTextUp [${Is_MoveTextUp}]
    \   Swipe Screen Locator    ${ScreenAreaYear_Calendar_Home_Locator}    ${Is_MoveTextUp}

    Take Capture Screen File
    ${Button_Locator}     Set Variable If    ${Is_Visible_Year}    ${ButtonCalendarOK_Home_Locator}    ${ButtonCalendarCancel_Home_Locator}
    ${YearLocator}        Replace String     ${TextCalendarYear_Home_Locator}    ${STATIC_TEXT_REPLACE}    ${Year_Value_Org}
    ${OnActionOK}         Run Keyword If     ${Is_Visible_Year}    Run Keyword And Return Status    Wait And Click on Locator   ${YearLocator}
    ${Is_Visible_Year}    Run Keyword And Return Status    Wait Until Locator Is Not Visible    ${YearLocator}   2

Find And Proceed the Next Action from Home Screen
    [Arguments]    ${NextButton_Locator}=${ButtonNext_Home_Locator}    ${ScreenArea_Locator}=${ScreenAreaYear_Calendar_Home_Locator}
    ...    ${MaxTimeMovingText}=${20}    ${InnerLoopWaitingTime}=${1}
    [Documentation]    Scroll down to find and click on the Next button from home screen
    ${Is_Visible}      Set Variable    ${False}
    ${MovingTextUp}    Set Variable    ${True}
    : FOR    ${RowsIndex}    IN RANGE    1     ${MaxTimeMovingText} + 1
    \   ${Is_Visible}    Run Keyword And Return Status    Wait Until Locator Is Not Visible    ${NextButton_Locator}   ${InnerLoopWaitingTime}
    \   Exit For Loop If   ${Is_Visible}
    \   Swipe Screen Locator    ${ScreenAreaYear_Calendar_Home_Locator}    ${MovingTextUp}
    Take Capture Screen File
    Run Keyword If    ${Is_Visible} == ${False}    Fail   Cannot find the Locator [${NextButton_Locator}]

Convert Date Data Pattern
    [Arguments]    ${Calendar_Date}    ${ByLangName}=${STATIC_LANG_ENG}    ${ReqConvertToBC}=${False}
    [Documentation]    Set date on calendar from format dd/mm/yyyy
    ${Min_BC_Range}    Set Variable   ${2300}

    ${myListDate}    Split String    ${Calendar_Date}    ${gSTATIC_SYM_SLASH}
    ${DateField}     Strip String    ${myListDate[0]}
    ${MonthField}    Strip String    ${myListDate[1]}
    ${YearField}     Strip String    ${myListDate[2]}
    ${MsgLen}        Get Length      ${DateField}

    ${DateField}     Set Variable If    ${MsgLen} < 2    ${0}${DateField}    ${DateField}
    ${BC_Total}      Set Variable If    ${YearField} > ${Min_BC_Range}    ${0}    ${gYear_BC}
    ${YearField}     Run Keyword If     ${ReqConvertToBC} == ${True}    Evaluate     ${YearField} + ${BC_Total}
    ...    ELSE   Set Variable   ${YearField}

    ${MonthName} =    Retrieval Month Name Pattern   Detect_Lang=${ByLangName}   MonthValue=${MonthField}
    ${DatePattern}    Set Variable      ${DateField}${SPACE}${MonthName}${SPACE}${YearField}
    [Return]  ${DatePattern}

Verify Thai PID Number
    [Arguments]    ${PID_No}
    [Documentation]    Verify Thai ID Card number or Not
    ${Max_PID_Len}      Set Variable    ${13}
    ${Len_Position}     Set Variable    ${14}
    ${Block_Factor}     Set Variable    ${11}
    ${Len_TermCheck}    Set Variable    ${10}
    ${SumTotal}         Set Variable    ${0}
    ${MsgLen}           Get Length      ${PID_No}

    ${NotThaiPID}    Run Keyword And Return Status    Should Not Be Equal    ${MsgLen}    ${Max_PID_Len}
    Run Keyword If   ${NotThaiPID}   [Return]    ${EMPTY}

    ${CheckSum}        Get Substring    ${PID_No}    12
    : FOR    ${iPositIdx}    IN RANGE    0     12
    \    ${Next_Idx}         Evaluate         ${iPositIdx} + 1
    \    ${Field_Value} =    Get Substring    ${PID_No}    ${iPositIdx}    ${Next_Idx}
    \    ${Result} =         Evaluate         ${Field_Value} * (${Len_Position} - ${Next_Idx})
    \    ${SumTotal} =       Evaluate         ${SumTotal} + ${Result}

    ${Result} =      Evaluate    (${Block_Factor} - ${SumTotal} % ${Block_Factor}) % ${Len_TermCheck}
    Log  Sum Total [${SumTotal}] Check-Sum [${CheckSum}] Result [${Result}]

    ${Is_Matched}    Run Keyword And Return Status    Should Be Equal As Strings    ${CheckSum}    ${Result}
    [Return]    ${Is_Matched}

Wait for Application Company Logo Display
    [Arguments]    ${Timeout}=${MAX_TIME_APPL}
    [Documentation]    Wait for Company Logo Display
    ${myLocator} =    Replace String    ${Image_WithCaption_General_Locator}    ${STATIC_TEXT_REPLACE}    ${STATIC_COMPANY_NAME_EN}
    ${Is_Opened}      Run Keyword And Return Status    Wait Until Element Is Visible    ${myLocator}    ${Timeout}

    Run Keyword If   ${Is_Opened}   Take Capture Screen File
    Run Keyword If   ${Is_Opened}  Close Info Bar Icon
    Run Keyword If   ${Is_Opened} == ${False}   Fail  Application not available to operate

Connect to Easy SandBox
    [Arguments]    ${PinNumber}    ${Timeout}=${MAX_TIME_WAITING}
    [Documentation]    Connect to the Easy Sandbox

    ${Is_Visbled}    Run Keyword And Return Status    Wait Until Element Is Visible    ${ButtonSandBox_Home_Locator}    ${Timeout}
    Run Keyword If    ${Is_Visbled}    Fail   Cannot find the Sand Box Locator [${ButtonSandBox_Home_Locator}]

    Take Capture Screen File
    ${SandBox_Text}    Get Text    ${CaptionSandBox_Home_Locator}
    Wait And Click on Locator      ${ButtonSandBox_Home_Locator}    ${Timeout}

    Verify Title Header Display via Contains Text feature    ${STATIC_HEADER_SANDBOX_TH}    ${STATIC_HEADER_SANDBOX_ENG}   ScreenNameMsg='SandBox Title'
    ${MsgLen}    Get Length    ${PinNumber}
    : FOR    ${iPositIdx}    IN RANGE    1     ${MsgLen}
    \    ${Next_Idx}         Evaluate          ${iPositIdx} + 1
    \    ${Field_Value}      Get Substring     ${PinNumber}    ${iPositIdx}    ${Next_Idx}
    \    ${Pin_Locator}      Replace String    ${TextView_WithCaption_General_Locator}    ${STATIC_TEXT_REPLACE}    ${Field_Value}
    \    Click Element       ${Pin_Locator}
    Take Capture Screen File
    # Language
    ${Axis_Y}    Set Variable If    ${AppLanguage} == ${STATIC_LANG_TH}    ${63}    ${230}
    ${Axis_X}    Set Variable       ${350}
    Click Element At Coordinates   ${Axis_X}    ${Axis_Y}
    Take Capture Screen File

    # Box Connection
    ${Axis_Y}    Set Variable      ${460}
    Click Element At Coordinates   ${Axis_X}    ${Axis_Y}
    Take Capture Screen File

Specify Total Sum-Insured Amount
    [Arguments]    ${Total_SumInsured}=${0}   ${MaxTimeLooping}=20
    ...   ${Total_FloatingPoint}=${2}    ${Timeout}=${MAX_TIME_WAITING}
    [Documentation]    To Specify the Sum-Insured Amount should be matched
    ${Is_Matched}          Set Variable          ${False}
    ${Total_MinAmount}     Get Text              ${TextMinTotalSum_SumInsured_Locator}
    ${Total_MinAmount}     Replace String        ${Total_MinAmount}     ${gSTATIC_SYM_COMMA}    ${EMPTY}
    ${Total_MinAmount}     Convert To Number     ${Total_MinAmount}     ${Total_FloatingPoint}

    ${Total_SumInsured}    Convert To String     ${Total_SumInsured}
    ${Total_SumInsured}    Replace String        ${Total_SumInsured}    ${gSTATIC_SYM_COMMA}    ${EMPTY}
    ${Total_SumInsured}    Convert To Number     ${Total_SumInsured}    ${Total_FloatingPoint}

    Take Capture Screen File
    Run Keyword If    ${Total_SumInsured} < ${Total_MinAmount}    Fail   Cannot specify Sum-Insured Amount less than minimum valute [${Total_MinAmount}]

    : FOR    ${iPositIdx}    IN RANGE   1     ${MaxTimeLooping} + 1
    \    ${Current_Amount}    Get Text             ${TextTotalSumInsured_SumInsured_Locator}
    \    ${Current_Amount}    Replace String       ${Current_Amount}    ${gSTATIC_SYM_COMMA}    ${EMPTY}
    \    ${Is_Matched}        Run Keyword And Return Status    Should Be Equal As Numbers    ${Current_Amount}    ${Total_SumInsured}   precision=${Total_FloatingPoint}
    \    Exit For Loop If    ${Is_Matched}
    \    Wait And Click on Locator    ${ButtonNext_SumInsured_Locator}    1
    Take Capture Screen File
    Run Keyword If    ${Is_Matched} == ${False}    Fail   Cannot specify Sum-Insured Amount [${Total_SumInsured}]
    ${Total_PaidAmount}        Get Text    ${TextTotalPaid_SumInsured_Locator}
    ${Total_CoveragePeriod}    Get Text    ${TextTotalCoveragePeriod_SumInsured_Locator}
    ${Total_PaidPeriod}        Get Text    ${TextTotalPaidPeriod_SumInsured_Locator}
    ${Total_SumAmount}         Get Text    ${TextSumAmount_SumInsured_Locator}
    ${Total_ReturnAmount}      Get Text    ${TextReturnAmount_SumInsured_Locator}
    ${Total_ReturnAmountAll}   Get Text    ${TextReturnAmountAll_SumInsured_Locator}

#    Focus On Locator By Scrolling Up Screen    ${Locator}    ${ScreenArea_Home_Locator}
     ${OK_Locator} =    Get Locator on Language    ${STATIC_OK_TH}    ${STATIC_OK_ENG}    ${ButtonContains_WithCaption_General_Locator}
    Focus On Locator By Scrolling Up Screen    ${OK_Locator}    ${ScreenArea_Home_Locator}
    Take Capture Screen File

    ${Title_Info}      Set Variable If   '${AppLanguage}' == '${STATIC_LANG_TH}'      ${STATIC_TAX_REDUCTION_TH}    ${STATIC_TAX_REDUCTION_ENG}
    ${Locator} =       Replace String     ${Text_WithCaption_General_Locator}         ${STATIC_TEXT_REPLACE}        ${Title_Info}
    ${Is_Visibled}     Run Keyword And Return Status      Wait Until Element Is Visible    ${Locator}               ${Timeout}
    ${Total_TaxBase}   Run Keyword If   ${Is_Visibled}    Get Text   ${TextTaxBase_SumInsured_Locator}             ELSE    ${0}
    ${Total_Reduct}    Run Keyword If   ${Is_Visibled}    Get Text   ${TextToalTaxReduction_SumInsured_Locator}    ELSE    ${0}

    Verify And Click on the Continued Button   'Specify Total Sum-Insured Amount'

Add Number Value with Comma And Floating Points
    [Arguments]    ${Amount_Value}    ${Total_FloatingPoint}=2
    [Documentation]    To convert and add the comma into number string
    ${Field_Value}    Convert To String    ${Amount_Value}
    ${Field_Value}    Replace String       ${Field_Value}    ${gSTATIC_SYM_COMMA}    ${EMPTY}
    ${Field_Value}    Convert To Number    ${Field_Value}    ${Total_FloatingPoint}
    ${Value}          Format String        {:,}              ${Field_Value}
    ${arrayData}      Split String         ${Value}    ${gSTATIC_SYM_POINT}
    ${Info}           Set Variable         ${SPACE * ${Total_FloatingPoint}}
    ${Info}           Replace String       ${Info}    ${SPACE}    0
    ${Info}           Get Substring        ${arrayData[1]}${Info}   0   ${Total_FloatingPoint}
    ${Value}          Set Variable         ${arrayData[0]}${gSTATIC_SYM_POINT}${Info}
    [Return]   ${Value}

Specify the Paid Amount Plan
    [Arguments]    ${TotalPaidAmount}=${0}    ${Timeout}=${MAX_TIME_WAITING}
    [Documentation]    To Specify the Paid Amount Plan
    ${CallerName}    Set Variable    "Specify the Paid Amount Plan"
    ${Is_Matched}    Set Variable    ${False}

#    Focus On Locator By Scrolling Up Screen
    Verify Title Header Display via Contains Text feature    ${STATIC_PLAN_PAIDMODE_TH}    ${STATIC_PLAN_PAIDMODE_ENG}   ScreenNameMsg='Policy Channel'

#    Verify And Click on the Continued Button   Caller_Name=${CallerName}
    ${TotalPaidAmount} =       Add Number Value with Comma And Floating Points   ${TotalPaidAmount}    ${gMaxFloatingPoint}
    ${PlanAmount_Locator} =    Replace String    ${TextContains_WithCaption_General_Locator}   ${STATIC_TEXT_REPLACE}    ${TotalPaidAmount}
    ${MsgLen} =                Get Length        ${TotalPaidAmount}

    ${Is_Visibled}    Run Keyword And Return Status    Page Should Contain Element   ${PlanAmount_Locator}
    Run Keyword If   ${Is_Visibled}    Wait And Click on Locator    ${PlanAmount_Locator}
    Take Capture Screen File
    Run Keyword If   ${Is_Visibled} == ${False}    Fail  Cannot find the Paid Amount Plan [${PlanAmount_Locator}]

    # Apply Now
    Verify And Click on the Continued Button   Caller_Name=${CallerName}   Caption_TH=${STATIC_APPLYNOW_TH}    Caption_ENG=${STATIC_APPLYNOW_ENG}
#    Click on Button And Re-Waiting Until Locator Visible    ${Next_Locator}   "Cannot go to other part because the Continued button is detected"

Verify Applicant Information
    [Arguments]    ${Policy_Channel_By}=${EMPTY}    ${WorkingPlaceName}=${Policy_WorkingPlace_Name}    ${Timeout}=${MAX_TIME_WAITING}
    [Documentation]    Verify all information input from Customer Insurance
    ${MaxTimeMovingText}    Set Variable    2
    Verify Title Header Display via Contains Text feature    ${STATIC_HEADER_CUSTOMER_TH}    ${STATIC_HEADER_CUSTOMER_ENG}   ScreenNameMsg='Applicant'

    ${TitleName_Insured}     Get Text    ${TitleName_Insured_Locator}
    ${FullName_Insured}      Get Text    ${FullName_Insured_Locator}
    ${BOD_Insured}           Get Text    ${BOD_Insured_Locator}
    ${Aged_Insured}          Get Text    ${Aged_Insured_Locator}
    ${PID_Insured}           Get Text    ${PID_Insured_Locator}
    ${MobileNo_Insured}      Get Text    ${MobileNo_Insured_Locator}

    # Address Header
    ${Address_Locator} =    Get Locator on Language    ${STATIC_ADDRESS_OFFICE_CUSTOMER_TH}    ${STATIC_ADDRESS_OFFICE_CUSTOMER_ENG}    ${TextContains_WithCaption_General_Locator}
    Focus On Locator By Scrolling Up Screen    ${Address_Locator}    ScreenArea_Locator=${ScreenArea_Insured_Locator}
    Take Capture Screen File

    # Channel Header
    ${Channel_Locator} =    Get Locator on Language    ${STATIC_POLICY_CHANNEL_CUSTOMER_TH}    ${STATIC_POLICY_CHANNEL_CUSTOMER_ENG}    ${TextContains_WithCaption_General_Locator}
    Focus On Locator By Scrolling Up Screen            ${Channel_Locator}                      ScreenArea_Locator=${ScreenArea_Insured_Locator}
    Take Capture Screen File

    ${Is_Visibled_Channel}    Set Variable    ${False}
    ${Is_MoveTextUp}          Set Variable    ${True}

    : FOR    ${RowsIndex}    IN RANGE    1     ${MaxTimeMovingText} + 1
    \   Swipe Screen Locator    ${ScreenArea_Insured_Locator}    ${Is_MoveTextUp}
    \   Take Capture Screen File
    ${Is_Visibled} =    Run Keyword And Return Status    Wait Until Element Is Visible    ${Channel_Locator}    2
    Run Keyword If   ${Is_Visibled} == ${False}    Fail  Cannot focus on the Channel Locator [${Channel_Locator}]

#    ${Is_Visibled} =         Run Keyword And Return Status    Wait Until Element Is Visible    ${WorkingPlace_Insured_Locator}    ${Timeout}
#    Run Keyword If    ${Is_Visibled}       Wait And Click on Locator    ${Address_Locator}
    Hide Keyboard
    Take Capture Screen File
    Wait Until Element Is Visible    ${WorkingPlace_Insured_Locator}    ${Timeout}    The Working place is not displayed on locator [${WorkingPlace_Insured_Locator}]
    Verify and Input Data            ${WorkingPlace_Insured_Locator}    ${WorkingPlaceName}
    Hide Keyboard

    ${Title_Info}      Set Variable If
    ...   '${AppLanguage}' == '${STATIC_LANG_TH}' and '${Policy_Channel_By}' == '${STATIC_CHANNEL_VIA_EMAIL}'     ${STATIC_CHANNEL_EMAIL_TH}
    ...   '${AppLanguage}' == '${STATIC_LANG_ENG}' and '${Policy_Channel_By}' == '${STATIC_CHANNEL_VIA_EMAIL}'    ${STATIC_CHANNEL_EMAIL_ENG}
    ...   '${AppLanguage}' == '${STATIC_LANG_TH}' and '${Policy_Channel_By}' == '${STATIC_CHANNEL_VIA_POST}'      ${STATIC_CHANNEL_POST_TH}
    ...   '${AppLanguage}' == '${STATIC_LANG_ENG}' and '${Policy_Channel_By}' == '${STATIC_CHANNEL_VIA_POST}'     ${STATIC_CHANNEL_POST_ENG}
    ...   ${EMPTY}
    ${MsgLen} =             Get Length        ${Title_Info}
    ${Channel_Locator} =    Replace String    ${TextContains_WithCaption_General_Locator}    ${STATIC_TEXT_REPLACE}    ${Title_Info}
    ${Is_Visibled}          Run Keyword And Return Status    Page Should Contain Element     ${Channel_Locator}
    Run Keyword If   ${Is_Visibled} and ${MsgLen} > 0    Wait And Click on Locator    ${Channel_Locator}
    Take Capture Screen File

#    Verify And Click on the Continued Button   'Verify Applicant Information'
    ${Next_Locator} =    Get Locator on Language    ${STATIC_CONTINUED_TH}    ${STATIC_CONTINUED_ENG}    ${ButtonContains_WithCaption_General_Locator}
    Click on Button And Re-Waiting Until Locator Visible    ${Next_Locator}   "Cannot go to other part because the Continued button is detected"

Add Beneficiency For Applicant Information
    [Arguments]    ${Total_Bene}=${0}    ${Timeout}=${MAX_TIME_WAITING}
    [Documentation]    Add beneficiency information

    Verify Title Header Display via Contains Text feature    ${STATIC_HEDADER_BENE_TH}    ${STATIC_HEDADER_BENE_ENG}   ScreenNameMsg='Adding Beneficiary'

    ${Title_Info}      Set Variable If   '${AppLanguage}' == '${STATIC_LANG_TH}'     ${STATIC_CAPTION_ADD_BENE_TH}   ${STATIC_CAPTION_ADD_BENE_TH}
    ${Add_Locator} =   Replace String     ${Button_WithCaption_General_Locator}      ${STATIC_TEXT_REPLACE}    ${Title_Info}

    : FOR    ${iPositIdx}    IN RANGE    1    ${Total_Bene} + 1
    \    ${Bene_Rel}      Set Variable     ${PREFIX_BENE_RELATION}${iPositIdx}
    \    ${Bene_Ratio}    Set Variable     ${PREFIX_BENE_RATIO}${iPositIdx}
    \    ${Bene_Name}     Set Variable     ${PREFIX_BENE_NAME}${iPositIdx}
    \    ${MsgLen}        Get Length       ${Bene_Rel}
    \    Exit For Loop If    ${MsgLen} < 1
    \    Log   Bene Rel [${${Bene_Rel}}] Bene Ratio [${${Bene_Ratio}}] Bene Name [${${Bene_Name}}]
    \    ${Is_Enabled}    Run Keyword And Return Status    Element Should Be Enabled    ${Add_Locator}
    \    Run Keyword If    ${iPositIdx} > 1 and ${Is_Enabled}    Wait And Click on Locator    ${Add_Locator}
    \    Wait And Click on Locator    ${BoxRelation_Bene_Locator}
    \    ${Rel_Locator}    Replace String     ${CheckBox_WithCaption_General_Locator}    ${STATIC_TEXT_REPLACE}    ${${Bene_Rel}}
    \    Wait And Click on Locator    ${Rel_Locator}    1
    \    Verify and Input Data        ${Ratio_Bene_Locator}       ${${Bene_Ratio}}
    \    Verify and Input Data        ${FullName_Bene_Locator}    ${${Bene_Name}}

    Verify And Click on the Continued Button   'Add Beneficiency For Applicant Information'

    # Confirm Pop-up Window
   Verify And Click on the Continued Button   Caller_Name='Add Beneficiency For Applicant Information'
   ...   Caption_TH=${STATIC_CONFIRM_TH}    Caption_ENG=${STATIC_CONFIRM_ENG}    MustBeVisibled=${False}

Verify Text Contains Page With Multiple Collections
    [Arguments]    ${Total_Count}    ${Prefix_Text_Name}    ${Timeout}=${MAX_TIME_WAITING}
    [Documentation]    Verify collection title text on page depending on the total checking
    ${Is_Found}        Set Variable     ${False}
    ${Total_Count} =   Run Keyword If   ${Total_Count} > 0    Evaluate  ${Total_Count} + 1    ELSE   Set Variable   ${0}
    Log  Prefix Text Name [${Prefix_Text_Name}]
    : FOR    ${iPositIdx}    IN RANGE    1    ${Total_Count}
    \    ${Field_Name}   Set Variable     ${Prefix_Text_Name}${iPositIdx}
    \    ${Field_Value}  Set Variable     ${${Field_Name}}
    \    ${MsgLen}        Get Length      ${Field_Value}
    \    Log   ${Field_Name} [${Field_Value}]
    \    Exit For Loop If    ${MsgLen} < 1
    \    ${Locator}     Replace String    ${TextContains_WithCaption_General_Locator}    ${STATIC_TEXT_REPLACE}    ${Field_Value}
    \    ${Is_Found}    Run Keyword And Return Status    Page Should Contain Element     ${Locator}
    \    Exit For Loop If    ${Is_Found} == ${False}
    Take Capture Screen File
    Run Keyword If   ${Is_Found} == ${False}   Fail  The Caption ["${Field_Value}"] is not contained in Page

Get Locator on Language
    [Arguments]    ${Caption_TH}=${STATIC_CONTINUED_TH}    ${Caption_ENG}=${STATIC_CONTINUED_ENG}
    ...   ${Locator_WithCaption}=${ButtonContains_WithCaption_General_Locator}
    [Documentation]    Assigne Locator by classifying Caption on Element for each Language
    ${Title_Info}      Set Variable If   '${AppLanguage}' == '${STATIC_LANG_TH}'        ${Caption_TH}    ${Caption_ENG}
    ${Locator} =       Replace String     ${Locator_WithCaption}    ${STATIC_TEXT_REPLACE}    ${Title_Info}
    [Return]   ${Locator}

Verify And Click on the Continued Button
    [Arguments]    ${Caller_Name}=${EMPTY}    ${Timeout}=${MAX_TIME_WAITING}
    ...    ${Caption_TH}=${STATIC_CONTINUED_TH}    ${Caption_ENG}=${STATIC_CONTINUED_ENG}   ${MustBeVisibled}=${True}    ${ReqClicking}=${True}
    ...    ${Locator_WithCaption}=${ButtonContains_WithCaption_General_Locator}
    [Documentation]    Verify the continue caption on button and then click on

    ${EnforceToVisible} =    Run Keyword And Return Status    Should Be Equal As Strings    ${MustBeVisibled}   ${True}    ignore_case=True
    ${NeedToClick} =         Run Keyword And Return Status    Should Be Equal As Strings    ${ReqClicking}      ${True}    ignore_case=True
    ${Locator} =             Get Locator on Language    ${Caption_TH}    ${Caption_ENG}    ${Locator_WithCaption}
    ${Is_Visibled} =         Run Keyword And Return Status    Wait Until Element Is Visible    ${Locator}               ${Timeout}
    Take Capture Screen File
    Run Keyword If    ${Is_Visibled} == ${False} and ${EnforceToVisible}    Fail   Cannot find the Continue button locator [${Locator}] ${Caller_Name}

    ${Is_Enabled}    Run Keyword And Return Status    Element Should Be Enabled    ${Locator}
    Run Keyword If    ${Is_Visibled} == ${False} and ${EnforceToVisible}          Fail   Detect to Visible on Continue button locator [${Locator}] for ${Caller_Name}
    Run Keyword If    ${Is_Visibled} == ${False} and ${Is_Enabled} == ${False}    Fail   Detect to Disable on Continue button locator [${Locator}] for ${Caller_Name}
    Run Keyword If    ${EnforceToVisible} and ${NeedToClick} and ${Is_Enabled}    Wait And Click on Locator    ${Locator}    1

Verify Title Header Display via Contains Text feature
    [Arguments]    ${For_Title_Header_TH}    ${For_Title_Header_ENG}    ${Timeout}=${MAX_TIME_APPL}
    ...    ${Auto_Capscreen}=${True}    ${IgnoredWhenFail}=${False}    ${ScreenNameMsg}=${EMPTY}
    [Documentation]    Verify the Title Header must be displayed with the Contains text feature supporting
    ${Title_Info}      Set Variable If   '${AppLanguage}' == '${STATIC_LANG_TH}'         ${For_Title_Header_TH}    ${For_Title_Header_ENG}
    ${Locator} =       Replace String     ${TextContains_WithCaption_General_Locator}    ${STATIC_TEXT_REPLACE}    ${Title_Info}
    ${Is_Visibled}     Run Keyword And Return Status    Wait Until Element Is Visible    ${Locator}                ${Timeout}
    Run Keyword If    '${Auto_Capscreen}' == '${True}'    Take Capture Screen File
    Run Keyword If    ${Is_Visibled} == ${False} and ${IgnoredWhenFail} == ${False}    Fail   Cannot see the ${ScreenNameMsg} Information Title Header locator [${Locator}]

Refund Amount on Policy Contract
    [Arguments]    ${SavedToCompany}=${STATIC_FLAG_YES}    ${RefundToBankAccNo}=${EMPTY}    ${Timeout}=${MAX_TIME_WAITING}
    [Documentation]    Refund Policy amount on contract duration
    ${Is_Matched}       Set Variable    ${False}

    Verify Title Header Display via Contains Text feature    ${STATIC_HEDADER_BENE_TH}    ${STATIC_HEDADER_BENE_ENG}   ScreenNameMsg='Beneficiary'

    ${Title_Info}      Set Variable If   '${AppLanguage}' == '${STATIC_LANG_TH}'         ${STATIC_HEDADER_BENE_TH}    ${STATIC_HEDADER_BENE_ENG}
    ${Locator} =       Replace String     ${TextContains_WithCaption_General_Locator}    ${STATIC_TEXT_REPLACE}       ${Title_Info}
    ${Is_Visibled}     Run Keyword And Return Status    Wait Until Element Is Visible    ${Locator}                   ${Timeout}
    Take Capture Screen File
    Run Keyword If    ${Is_Visibled} == ${False}    Fail   Cannot see the Beneficiary Information Title Header locator [${Locator}]

    ${SavingStatus_Locator}   Set Variable If   '${SavedToCompany}' == '${STATIC_FLAG_YES}'    ${RadioSavingInPolicyYes_Refund_Locator}    ${RadioSavingInPolicyNo_Refund_Locator}
    Wait And Click on Locator    ${SavingStatus_Locator}

    Focus On Locator By Scrolling Up Screen    TotalScrolling=2
    ${MsgLen}              Get Length         ${RefundToBankAccNo}
    ${Max_Times_Next}      Set Variable If    ${MsgLen} > 0    ${4}    ${0}
    ${BankAcc_Locator} =   Replace String     ${ViewBankAcc_Refund_Locator}      ${STATIC_TEXT_REPLACE}    ${RefundToBankAccNo}
    : FOR    ${iPositIdx}    IN RANGE    1    ${Max_Times_Next} + 1
    \    ${Is_Matched}    Run Keyword And Return Status    Wait Until Element Is Visible    ${BankAcc_Locator}    1
    \    Exit For Loop If    ${Is_Matched}
    \    ${NodeIdx}           Convert To String    ${iPositIdx}
    \    ${Button_Locator}    Replace String       ${ButtonContains_WithCaption_General_Locator}   ${STATIC_TEXT_REPLACE}    ${NodeIdx}
    \    Wait And Click on Locator    ${Button_Locator}
    \    Sleep    1
    Take Capture Screen File
    Verify And Click on the Continued Button   'Refund Amount on Policy Contract'

Verify Tax rights and FATCA Status
    [Arguments]    ${Is_RequiredOnExcludingTax}=${STATIC_FLAG_YES}    ${Is_AcceptedAll}=${STATIC_FLAG_YES}    ${Timeout}=${MAX_TIME_WAITING}
    [Documentation]    Verify Tax Rights and FATCA Status information

    Verify Title Header Display via Contains Text feature    ${STATIC_HEADER_FATCA_TH}    ${STATIC_HEADER_FATCA_ENG}   ScreenNameMsg='TAX Rights and FATCA Status'

    ${Excluding_Locator}    Set Variable If    '${Is_RequiredOnExcludingTax}' == '${STATIC_FLAG_YES}'    ${ExcludingVatYes_FATCA_Locator}    ${ExcludingVatNo_FATCA_Locator}
    Wait And Click on Locator    ${Excluding_Locator}

    Focus On Locator By Scrolling Up Screen    TotalScrolling=2

    ${Accepting_Locator}    Set Variable If    '${Is_AcceptedAll}' == '${STATIC_FLAG_YES}'    ${AcceptingYes_FATCA_Locator}    ${AcceptingNo_FATCA_Locator}
    Wait And Click on Locator    ${Accepting_Locator}
    Take Capture Screen File

    Verify And Click on the Continued Button   'Verify Tax rights and FATCA Status'

Confirm on Applicant Policy Information
    [Arguments]    ${Timeout}=${MAX_TIME_WAITING}
    [Documentation]    Confirm Applicant Policy Information
    ${CallerName}      Set Variable   "Confirm on Applicant Policy Information"

    Verify Title Header Display via Contains Text feature    ${STATIC_HEADER_CONFIRM_TH}    ${STATIC_HEADER_CONFIRM_ENG}   ScreenNameMsg='Confirm Applicant Policy'
    ${TextTotalPaidAmount}    Get Text    ${TextTotalPaidAmount_Confirm_Locator}
    ${TextPaidTerm}           Get Text    ${TextPaidTerm_Confirm_Locator}
    ${TextInsuredName}        Get Text    ${TextInsuredName_Confirm_Locator}
    ${TextInsuredMobile}      Get Text    ${TextInsuredMobile_Confirm_Locator}
    ${TextInsuredEmail}       Get Text    ${TextInsuredEmail_Confirm_Locator}
    ${TextInsuredSending}     Get Text    ${TextInsuredSending_Confirm_Locator}

    Focus On Locator By Scrolling Up Screen    TotalScrolling=2
    Take Capture Screen File

    Wait And Click on Locator    ${CheckedBoxConfirm_Confirm_Locator}

    Verify And Click on the Continued Button   Caller_Name=${CallerName}
    ...   Caption_TH=${STATIC_OK_TH}    Caption_ENG=${STATIC_OK_ENG}    MustBeVisibled=${False}

    Verify And Click on the Continued Button   Caller_Name=${CallerName}
    ...   Caption_TH=${STATIC_CONFIRM_TH}    Caption_ENG=${STATIC_CONFIRM_ENG}    MustBeVisibled=${False}

Paid on Insurance Claim Number
    [Documentation]    Paid an Insurance Claim Number via SCB Easy payment process
    ${CallerName}    Set Variable    "Paid on Insurance Claim Number"
    Verify Title Header Display via Contains Text feature    ${STATIC_CONTENT_CONFIRM_TH}    ${STATIC_CONTENT_CONFIRM_ENG}   ScreenNameMsg='Insurance Claim Number'
    ${ClaimNo}    Get Text    ${CaptionPolicyNo_Confirm_Locator}
    Log   Detect to Insurance Claim Number paid [${ClaimNo}]

    Verify And Click on the Continued Button   Caller_Name=${CallerName}
    ...   Caption_TH=${STATIC_PAYMENT_VIA_SCBEASY_TH}    Caption_ENG=${STATIC_PAYMENT_VIA_SCBEASY_ENG}    MustBeVisibled=${False}

Send Tab Key Code From Keyboard
    [Documentation]    Send key ENTER code on keyboard
    Press Keycode    ${KEYCODE_TAB}

Send Key Code From Keyboard
    [Arguments]    ${KeyCode}    ${TotalTimesPress}=${1}
    [Documentation]    Send key code on keyboard

    : FOR    ${iLoop}    IN RANGE    1    ${TotalTimesPress} + 1
    \    Press Keycode    ${KeyCode}
    \    Sleep   1

Send Enter Key Code From Keyboard
    [Documentation]    Send key ENTER code on keyboard
    Press Keycode    ${KEYCODE_ENTER}

Click on Button And Re-Waiting Until Locator Visible
    [Arguments]    ${Button_Locator}     ${DisplayMsgFail}=${EMPTY}    ${MaxTimeForInvisibled}=10    ${Timeout}=${MAX_TIME_WAITING}
    [Documentation]    Click the button and will be waited until already visible or timeout
    ${Not_Visibled} =    Run Keyword And Return Status    Wait Until Locator Is Not Visible    ${Button_Locator}   ${MaxTimeForInvisibled}
    ${Still_Visibled}    Run Keyword And Return Status    Wait Until Element Is Visible        ${Button_Locator}    1
    Run Keyword If    ${Still_Visibled}    Wait And Click on Locator    ${Button_Locator}
    ${Not_Visibled} =    Run Keyword And Return Status    Wait Until Locator Is Not Visible    ${Button_Locator}   ${Timeout}
    Run Keyword If    ${Not_Visibled} == ${False}    Take Capture Screen File
    Run Keyword If    ${Not_Visibled} == ${False}    Fail   ${DisplayMsgFail}

Select Your Sum-Insured Amount
    [Arguments]    ${Total_SumInsured}=${Total_SumInsured}    ${Timeout}=${MAX_TIME_WAITING}    ${ScreenWaitTime}=${MAX_TIME_APPL}
    [Documentation]    Verify Premium Information Screen before actual Premium on Policy

#    # Verify Total Sum-Insured Amount
#    ${Locator} =      Get Locator on Language   ${STATIC_HEADTITLE_SUMINSURED_TH}   ${STATIC_HEADTITLE_SUMINSURED_ENG}   ${TitleHeadSumInsured_SumInsured_Locator}
#    ${Is_Visibled}    Run Keyword And Return Status    Wait Until Element Is Visible    ${Locator}    ${ScreenWaitTime}
#    Take Capture Screen File
#    Run Keyword If    ${Is_Visibled} == ${False}    Fail   Cannot find an Sum-Insured Amount screen locator [${Locator}]

    Verify Title Header Display via Contains Text feature    ${STATIC_HEADTITLE_SUMINSURED_TH}    ${STATIC_HEADTITLE_SUMINSURED_ENG}   ScreenNameMsg='Select Your Sum-Insured'
    Specify Total Sum-Insured Amount                         ${Total_SumInsured}

Convert Total Field To Value
    [Arguments]    ${Field_Value}
    [Documentation]    Convert data field to exist value
    ${Field_Value}     Set Variable         ${0}${Field_Value}
    ${Field_Value}     Replace String       ${Field_Value}    None    0
    ${Field_Value}     Convert To Integer   ${Field_Value}
    [Return]    ${Field_Value}

########################################
###########  Business Module ###########
########################################
Registry Customer Information
    [Arguments]    ${Timeout}=${MAX_TIME_WAITING}
    [Documentation]    Registry customer data from Excel value configurations

    Wait for Application Company Logo Display

    ${Is_Checked_PID} =    Run Keyword And Return Status    Should Be Equal As Strings    ${Is_Verified_PID}   ${STATIC_FLAG_YES}    ignore_case=True
    ${Is_PID}=   Run Keyword If    ${Is_Checked_PID}    Verify Thai PID Number   ${PID}
    ...   ELSE    ${False}
    Run Keyword If    ${Is_Checked_PID} and ${Is_PID} == ${False}    Fail   Invalid Thai PID number [${PID}]
    Run Keyword If    ${Is_Checked_PID} and ${Is_PID}    Log   Valid Thai PID number [${PID}]
    Run Keyword If   '${ForStandalone}' == '${STATIC_FLAG_YES}'    Wait And Click on Locator    ${ChkboxForStandalone_Home_Locator}    ${Timeout}

    ${Locator}    Set Variable If    '${AppLanguage}' == '${STATIC_LANG_ENG}'    ${RadioLangEng_Home_Locator}    ${RadioLangTh_Home_Locator}
    Run Keyword If   '${AppLanguage}' == '${STATIC_LANG_ENG}'       Wait And Click on Locator    ${RadioLangEng_Home_Locator}           ${Timeout}

    Verify and Input Data   ${TextTitleName_Home_Locator}     ${TitleName}
    Verify and Input Data   ${TextCust_FName_Home_Locator}    ${Customer_FName}
    Verify and Input Data   ${TextCust_LName_Home_Locator}    ${Customer_LName}

    ${HasData} =    Run Keyword And Return Status    Should Not Be Equal    ${DOB}   ${EMPTY}
    Run Keyword If    ${HasData}    Select Calendar Date Assignment   ${DOB}   ${AppLanguage}   ${TextCalendar_Day_Home_Locator}

    Verify and Input Data   ${TextPID_Home_Locator}   ${PID}

    Click Element   ${TextPID_Home_Locator}
    Hide Keyboard
    Send Tab Key Code From Keyboard
    Run Keyword If   '${Identity_Card_Type}' != '${EMPTY}'    Select Card Type     ${Identity_Card_Type}

#    Send Tab Key Code From Keyboard
    Click Element   ${TextCust_Email_Home_Locator}
    Hide Keyboard
    Run Keyword If   '${Sex}' != '${EMPTY}'    Select Customer Sexual Type     ${Sex}
    Verify and Input Data   ${TextCust_Email_Home_Locator}              ${Email}     ReqSwiped=${False}
    Verify and Input Data   ${TextCust_MobileNo_Home_Locator}           ${Mobile_Phone}

    Take Capture Screen File
    Focus On Locator By Scrolling Up Screen    ${TextCust_HomePostcode_Home_Locator}

    # Address
    Verify and Input Data   ${TextCust_AddressNo_Home_Locator}          ${Address_No}
    Verify and Input Data   ${TextCust_AddressMoo_Home_Locator}         ${Address_Moo}
    Verify and Input Data   ${TextCust_AddressBuilding_Home_Locator}    ${Building}

#    Take Capture Screen File
#    Focus On Locator By Scrolling Up Screen    ${BoxCust_BankBranch_Home_Locator}    DelayWaitingTimes=${0.5}    SwipInterval=${1000}
    Wait And Click on Locator   ${TextCust_AddressBuilding_Home_Locator}
    Verify and Input Data   ${TextCust_AddressSoi_Home_Locator}         ${Soi}
    Verify and Input Data   ${TextCust_AddressRoad_Home_Locator}        ${Road}
    Hide Keyboard
    Verify and Input Data   ${TextCust_HomeSubDistrict_Home_Locator}    ${SubDistrict}
    Verify and Input Data   ${TextCust_HomeDistrict_Home_Locator}       ${District}
    Verify and Input Data   ${TextCust_HomeProvince_Home_Locator}       ${Province}
    Verify and Input Data   ${TextCust_HomePostcode_Home_Locator}       ${Postcode}

    # Banking
    Take Capture Screen File
    Focus On Locator By Scrolling Up Screen    ${TextCust_BankName_Home_Locator}
    Wait And Click on Locator   ${TextCust_BankName_Home_Locator}
    Verify and Input Data        ${TextCust_BankName_Home_Locator}      ${Bank_Name}
    Wait And Click on Locator    ${TextCust_BankName_Home_Locator}      ${Timeout}

    Verify and Input Data        ${TextCust_BankAccNo_Home_Locator}     ${BankAccount}

#    Wait And Click on Locator    ${BoxCust_BankBranch_Home_Locator}     ${Timeout}
    Verify and Input Data        ${TextCust_BankBranch_Home_Locator}    ${Bank_Branch}    ReqClickBeforeInput=${False}
    Hide Keyboard

    Take Capture Screen File
    Verify And Click on the Continued Button   'Registry Customer Information'
    Hide Keyboard

    Take Capture Screen File
    ${Next_Locator} =    Get Locator on Language   ${STATIC_CONTINUED_TH}    ${STATIC_CONTINUED_ENG}    ${ButtonContains_WithCaption_General_Locator}
    Click on Button And Re-Waiting Until Locator Visible    ${Next_Locator}   "Cannot go to other part because the Continued button is detected"

Verify to Calculate Premium Process
    [Arguments]    ${Timeout}=${MAX_TIME_WAITING}
    [Documentation]    Verify to the Premium Calculation process

    ${CallerName}     Set Variable   "Verify to Calculate Premium Process"
    ${Locator} =      Replace String    ${ButtonSex_Premium_Locator}    ${STATIC_TEXT_REPLACE}    ${Sex}
    ${Is_Visibled}    Run Keyword And Return Status    Wait Until Element Is Visible    ${Locator}    ${MAX_TIME_APPL}
    
    Take Capture Screen File
    Run Keyword If    ${Is_Visibled} == ${False}    Fail   Cannot find locator [${Locator}] within time [${MAX_TIME_APPL}]

    ${ByLangName} =    Set Variable If    '${Convert_BOD_Thai}' == '${STATIC_FLAG_YES}'    ${STATIC_LANG_TH}    ${STATIC_LANG_ENG}
    ${BOD_Text}    Convert Date Data Pattern    Calendar_Date=${DOB}   ByLangName=${ByLangName}    ReqConvertToBC=${True}
    ${Title_BOD}   Get Text        ${TextDOB_Premium_Locator}
    ${Title_BOD}   Strip String    ${Title_BOD}
    Should Be Equal As Strings    '${Title_BOD}'    '${BOD_Text}'
    Close Info Bar Icon

    # Main Topic
    ${Total_CalcPrem_Topic}    Convert Total Field To Value    ${Total_CalcPrem_Topic}
    ${Need_Verified}    Set Variable If   ${Total_CalcPrem_Topic} > 0    ${True}    ${False}
    Run Keyword If    ${Need_Verified}    Verify Text Contains Page With Multiple Collections    ${Total_CalcPrem_Topic}    ${PREFIX_CALC_PREM_TOPIC}
    Take Capture Screen File

    # Coverage Section
    ${Coverage_Locator} =       Get Locator on Language         ${STATIC_COVERAGE_CALC_TH}    ${STATIC_COVERAGE_CALC_ENG}    ${TextContains_WithCaption_General_Locator}
    ${Total_Calc_Prem_Cover}    Convert Total Field To Value    ${Total_Calc_Prem_Cover}
    ${Need_Verified}    Set Variable If   ${Total_Calc_Prem_Cover} > 0    ${True}    ${False}
    Focus On Locator By Scrolling Up Screen                ${Coverage_Locator}        ${ScreenArea_Premium_Locator}
    Run Keyword If    ${Need_Verified}    Wait Until Element Is Visible                          ${Coverage_Locator}        ${MAX_TIME_WAITING}
    Run Keyword If    ${Need_Verified}    Wait And Click on Locator                              ${Coverage_Locator}
    Run Keyword If    ${Need_Verified}    Verify Text Contains Page With Multiple Collections    ${Total_Calc_Prem_Cover}   ${PREFIX_CALC_PREM_COVER}

    # For only case
    ${OK_Locator} =    Get Locator on Language    ${STATIC_OK_TH}    ${STATIC_OK_TH}    ${ButtonContains_WithCaption_General_Locator}
    Focus On Locator By Scrolling Up Screen       ${OK_Locator}      ${ScreenArea_Premium_Locator}

    # Condition Insurance
    Take Capture Screen File
    ${Condition_Locator} =      Get Locator on Language         ${STATIC_CONDITION_CALC_TH}      ${STATIC_CONDITION_CALC_ENG}    ${TextContains_WithCaption_General_Locator}
    ${Total_Calc_Prem_Cond}     Convert Total Field To Value    ${Total_Calc_Prem_Cond}
    ${Need_Verified}    Set Variable If   ${Total_Calc_Prem_Cond} > 0    ${True}    ${False}
    Focus On Locator By Scrolling Up Screen                ${Condition_Locator}       ${ScreenArea_Premium_Locator}
    Run Keyword If    ${Need_Verified}    Wait Until Element Is Visible                          ${Condition_Locator}       ${MAX_TIME_WAITING}
    Run Keyword If    ${Need_Verified}    Wait And Click on Locator                              ${Condition_Locator}
    Run Keyword If    ${Need_Verified}    Verify Text Contains Page With Multiple Collections    ${Total_Calc_Prem_Cond}    ${PREFIX_CALC_PREM_COND}
    Take Capture Screen File

    ${Calc_Prem_Locator}    Get Locator on Language          ${STATIC_PREMIUM_CALC_TH}    ${STATIC_PREMIUM_CALC_ENG}    ${ButtonContains_WithCaption_General_Locator}
    Focus On Locator By Scrolling Up Screen                  ${Calc_Prem_Locator}         ${ScreenArea_Premium_Locator}
    Click on Button And Re-Waiting Until Locator Visible     ${Calc_Prem_Locator}   "Cannot go to other part because the Calculation Premium button is detected"
    Take Capture Screen File

Verify Rules And Condition Agreement Via Website
    [Arguments]    ${Timeout}=${MAX_TIME_WAITING}    ${ScreenWaitTime}=${MAX_TIME_APPL}
    [Documentation]    Verify Rule and their conditions Agreements Acceptance through this website
    Verify Title Header Display via Contains Text feature    ${STATIC_HEADER_CONDITION_TH}         ${STATIC_HEADER_CONDITION_ENG}   ScreenNameMsg='Rule And Conditions'   Timeout=${ScreenWaitTime}

    ${OK_Locator} =    Get Locator on Language    ${STATIC_OK_TH}    ${STATIC_OK_ENG}    ${ButtonContains_WithCaption_General_Locator}
    Focus On Locator By Scrolling Up Screen       ${OK_Locator}      ${ScreenArea_Premium_Locator}

    # Click the Calc Premium for the Checked-Box Agreement screen displayed
    Wait And Click on Locator                     ${CheckBoxAcceptCondition_Premium_Locator}
    Wait Until Element Should Be Enabled          ${OK_Locator}     ${Timeout}
    Take Capture Screen File
    Wait And Click on Locator                     ${OK_Locator}     ${Timeout}

Verify Policy for Premium Calculation and Payment Process
    [Arguments]    ${RequestToCheckNextButton}=${True}    ${Timeout}=${MAX_TIME_WAITING}    ${ScreenWaitTime}=${MAX_TIME_APPL}
    [Documentation]    Verify Premium Information Screen before actual Premium on Policy
    ${CallerName}    Set Variable   "Verify Policy for Premium Calculation and Payment Process"

    Run Keyword If    ${RequestToCheckNextButton}    Find And Proceed the Next Action from Home Screen
    Verify to Calculate Premium Process
    Verify Rules And Condition Agreement Via Website
    Select Your Sum-Insured Amount             ${Total_SumInsured}
    Specify the Paid Amount Plan               ${Plan_Paid_Type}
    Verify Applicant Information               ${Policy_Channel_Via}    ${Policy_WorkingPlace_Name}
    Refund Amount on Policy Contract           ${Is_SavedTo_Policy}     ${Refund_To_BankAccNo}
    Verify Tax rights and FATCA Status         ${Is_ExcludingTAX}       ${Is_Accepted_Condition}
    Confirm on Applicant Policy Information
    Paid on Insurance Claim Number


#######################
# MAIN TEMPLATE PROCESS
#######################
Process Customer Data Input And Verify Premium Calcuation with Payment
    Customer Data Input
    Verify Policy for Premium Calculation and Payment Process
