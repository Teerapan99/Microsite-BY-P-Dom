*** Settings ***
Documentation     Main Configuration for Microsite IL Application (Android)

*** Variables ***
${TESTDATA_EXCEL_NAME}         MicrositeIL_TestDataSheet.xlsx
${APPLICATION_NAME}            ${EMPTY}
${MAX_TIME_APPL}               ${EMPTY}
${MAX_TIME_WAITING}            ${EMPTY}
${gReqTearDownAction}          ${False}
${gReqLogout}                  ${False}
${gRepeatURL}                  ${0}
${RefreshURLSite}              www.google.com
${RefreshURLBeShown}           google
${ColIndex_Key}                ${1}
${ColIndex_Value}              ${2}
${RowsStartFrom}               ${2}
${gYear_BC}                    ${543}
${gMaxFloatingPoint}           ${2}
${NO_TIME_OUT}                 ${0}
${gSTATIC_FILTER_BY}           ,
${gSTATIC_SYM_COMMA}           ,
${gSTATIC_SYM_SLASH}           /
${gSTATIC_SYM_POINT}           .
${gNotInCondition}             No Action
${gFieldsNameCollect}
${SHEET_CONFIG}                Config
${SHEET_CUSTOMER}              Customer
${SHEET_CALCPAYMENT}           CalcPremiumAndPayment

${PREFIX_CALC_PREM_TOPIC}      Calc_Prem_Topic_
${PREFIX_CALC_PREM_COVER}      Calc_Prem_Cover_
${PREFIX_CALC_PREM_COND}       Calc_Prem_Cond_
${PREFIX_BENE_RELATION}        Bene_Rel_
${PREFIX_BENE_RATIO}           Bene_Ratio_
${PREFIX_BENE_NAME}            Bene_FullName_

${KEYCODE_TAB}                 61
${KEYCODE_ENTER}               66
