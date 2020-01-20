*** Settings ***
Documentation     Locators for using in Microsite IL application (Android) automation testing
Resource          Static_MicrositeIL.robot

*** Variables ***
########################################################
# General Variable Declaration
########################################################
${Button_WithCaption_General_Locator}                  xpath=//android.widget.Button[@text='${STATIC_TEXT_REPLACE}']
${Image_WithCaption_General_Locator}                   xpath=//android.widget.Image[@text='${STATIC_TEXT_REPLACE}']
${Text_WithCaption_General_Locator}                    xpath=//android.view.View[@text='${STATIC_TEXT_REPLACE}']
${TextContains_WithCaption_General_Locator}            xpath=//android.view.View[contains(@text,'${STATIC_TEXT_REPLACE}')]
${CheckBox_WithCaption_General_Locator}                xpath=//android.widget.CheckedTextView[@text='${STATIC_TEXT_REPLACE}']
${ButtonContains_WithCaption_General_Locator}          xpath=//android.widget.Button[contains(@text,'${STATIC_TEXT_REPLACE}')]
${TextView_WithCaption_General_Locator}                xpath=//android.widget.TextView[@text='${STATIC_TEXT_REPLACE}']

########################################################
# Customer Data Registration
########################################################

########################################################
#  Chrome Browser Startup
########################################################
${ButtonAccept_Chrome_Locator}                         id=com.android.chrome:id/terms_accept
${ButtonNext_Chrome_Locator}                           id=com.android.chrome:id/next_button
${ButtonCont_Chrome_Locator}                           id=com.android.chrome:id/positive_button
${ButtonNoThks_Chrome_Locator}                         id=com.android.chrome:id/negative_button
${BoxSearch_Chrome_Locator}                            id=com.android.chrome:id/search_box_text
${InputURL_Browser_Locator}                            id=com.android.chrome:id/url_bar
${ButtonLogout_Home_Locator}                           id=com.android.chrome:id/logout_button   #Dome: Wait to check

########################################################
#  Application Variable Declaration
########################################################
${CaptionSandBox_Home_Locator}                         xpath=//*[@resource-id='easy-sandbox']    #id=easy-sandbox
${ButtonSandBox_Home_Locator}                          xpath=//*[@resource-id='easy-sandbox']    #id=easy-sandbox

${ChkboxForStandalone_Home_Locator}                    xpath=//android.widget.CheckBox[@resource-id='cbWebOnly']
${RadioLangTh_Home_Locator}                            xpath=//android.view.View[6]/android.view.View/android.view.View[3]
${RadioLangEng_Home_Locator}                           xpath=//android.view.View[7]/android.view.View/android.view.View[1]
${ScreenArea_Home_Locator}                             xpath=//*[@resource-id='root']
${TextTitleName_Home_Locator}                          xpath=//android.view.View//*[@resource-id='ddlTitle']
${TextCust_FName_Home_Locator}                         xpath=//android.view.View//*[@resource-id='txtFirstName']
${TextCust_LName_Home_Locator}                         xpath=//android.view.View//*[@resource-id='txtLastName']
${BoxCust_BOD_Home_Locator}                            xpath=//android.view.View//*[@resource-id='txtBirthDate']

${ButtonMonthPrev_Calendar_Home_Locator}               xpath=//*[@resource-id='android:id/prev']
${ButtonMonthNext_Calendar_Home_Locator}               xpath=//*[@resource-id='android:id/next']
${TextHeaderMonth_Calendar_Home_Locator}               xpath=//*[@resource-id='android:id/date_picker_header_date']  #Fri, Dec 21
${TextCalendarView_Calendar_Home_Locator}              xpath=//*[@resource-id='android:id/month_view']
${TextCalendar_Day_Home_Locator}                       xpath=//android.view.View[@content-desc='${STATIC_TEXT_REPLACE}']   #'01 July 2019'

${ButtonCalendarYear_Home_Locator}                     xpath=//android.widget.LinearLayout/android.widget.TextView[1]    #id=android:id/date_picker_header_year
${TextCalendarYear_Home_Locator}                       xpath=//android.widget.TextView[@resource-id='android:id/text1' and @text='${STATIC_TEXT_REPLACE}']
${TextYearTop_Calendar_Home_Locator}                   xpath=//android.widget.ListView/android.widget.TextView[1]
${TextYearLow_Calendar_Home_Locator}                   xpath=//android.widget.ListView/android.widget.TextView[7]
${ScreenAreaYear_Calendar_Home_Locator}                xpath=//android.widget.FrameLayout//*[@resource-id='android:id/datePicker']


${InfoBarIcon_Home_Locator}                            xpath=//*[@resource-id='com.android.chrome:id/infobar_icon']
${ButtonInfoBarClose_Home_Locator}                     xpath=//*[@resource-id='com.android.chrome:id/infobar_close_button']

${ButtonCalendarOK_Home_Locator}                       id=android:id/button1
${ButtonCalendarCancel_Home_Locator}                   id=android:id/button2
${ButtonCalendarClear_Home_Locator}                    id=android:id/button3
${TextPID_Home_Locator}                                xpath=//android.view.View//*[@resource-id='txtCitizenId']
${BoxCardType_Home_Locator}                            xpath=//android.widget.Spinner[@resource-id='ddlCardType']   #id=ddlCardType
${RadioCardType_PID_Home_Locator}                      xpath=//android.widget.CheckedTextView[1]
${RadioCardType_Passport_Home_Locator}                 xpath=//android.widget.CheckedTextView[2]
${RadioCardType_Other_Home_Locator}                    xpath=//android.widget.CheckedTextView[3]

${RadioSex1_Home_Locator}                              xpath=//android.view.View/android.view.View[@text='${STATIC_TEXT_REPLACE}']

${TextCust_Email_Home_Locator}                         xpath=//android.view.View//*[@resource-id='txtEmail']   #id=txtEmail
${TextCust_MobileNo_Home_Locator}                      xpath=//android.view.View//*[@resource-id='txtMobile']   #id=txtMobile
${TextCust_AddressNo_Home_Locator}                     xpath=//android.view.View//*[@resource-id='txtAddressNo']   #id=txtAddressNo
${TextCust_AddressMoo_Home_Locator}                    xpath=//android.view.View//*[@resource-id='txtAddressMoo']   #id=txtAddressMoo
${TextCust_AddressBuilding_Home_Locator}               xpath=//android.view.View//*[@resource-id='txtAddressVillageName']   #id=txtAddressVillageName
${TextCust_AddressSoi_Home_Locator}                    xpath=//android.view.View//*[@resource-id='txtAddressSoi']   #id=txtAddressSoi
${TextCust_AddressRoad_Home_Locator}                   xpath=//android.view.View//*[@resource-id='txtAddressStreet']   #id=txtAddressStreet
${TextCust_HomeSubDistrict_Home_Locator}               xpath=//android.view.View//*[@resource-id='txtAddressSubDistrict']   #id=txtAddressSubDistrict
${TextCust_HomeDistrict_Home_Locator}                  xpath=//android.view.View//*[@resource-id='txtAddressDistrict']   #id=txtAddressDistrict
${TextCust_HomeProvince_Home_Locator}                  xpath=//android.view.View//*[@resource-id='txtAddressProvinceCode']   #id=txtAddressProvinceCode
${TextCust_HomePostcode_Home_Locator}                  xpath=//android.view.View//*[@resource-id='txtAddressPostalCode']   #id=txtAddressPostalCode
${TextCust_BankName_Home_Locator}                      xpath=//android.view.View//*[@resource-id='txtBankAccount']   #id=txtBankAccount
${TextCust_BankAccNo_Home_Locator}                     xpath=//android.view.View//*[@resource-id='txtAccountNumber']   #id=txtAccountNumber
${BoxCust_BankBranch_Home_Locator}                     xpath=//android.view.View[2]/android.view.View[*]/android.view.View
${TextCust_BankBranch_Home_Locator}                    xpath=//android.widget.EditText[@resource-id='branchName']
${ButtonNext_Home_Locator}                             xpath=//android.widget.Button

########################################################
# Premium Rate Calcuation And Sum-Insured Section
########################################################
${ScreenArea_Premium_Locator}                          xpath=//*[@resource-id='productDetail']
${ButtonSex_Premium_Locator}                           xpath=//android.widget.Button[@text='${STATIC_TEXT_REPLACE}']
${TextDOB_Premium_Locator}                             xpath=//android.view.View[4]/android.view.View[2]
#${ButtonCalcTH_Premium_Locator}                        xpath=//android.widget.Button[@text='คำนวณเบี้ย']
#${ButtonCalcENG_Premium_Locator}                       xpath=//android.widget.Button[@text='คำนวณเบี้ย']
#${ButtonCalcLang_Premium_Locator}                      xpath=//android.widget.Button[@text='${STATIC_TEXT_REPLACE}']
${TextCoverage_Premium_Locator}                        xpath=//android.view.View[@text='${STATIC_TEXT_REPLACE}']
${CheckBoxAcceptCondition_Premium_Locator}             xpath=//android.widget.CheckBox
${ButtonAccept_Premium_Locator}                        xpath=//android.widget.Button[@text='${STATIC_TEXT_REPLACE}']

${TitleHeadSumInsured_SumInsured_Locator}              xpath=//android.widget.Button[@text='${STATIC_TEXT_REPLACE}']
${TextTotalSumInsured_SumInsured_Locator}              xpath=//android.widget.EditText[@resource-id='uiSI']
${TextMinTotalSum_SumInsured_Locator}                  xpath=//android.view.View[3]/android.view.View[4]
${ButtonPrev_SumInsured_Locator}                       xpath=//android.view.View[2]/android.view.View[1]/android.widget.Image[@resource-id='uiSI']
${ButtonNext_SumInsured_Locator}                       xpath=//android.view.View[2]/android.view.View[2]/android.widget.Image[@resource-id='uiSI']
${TextTotalPaid_SumInsured_Locator}                    xpath=//android.view.View[2]/android.view.View[3]/android.view.View
${TextTotalCoveragePeriod_SumInsured_Locator}          xpath=//android.view.View[2]/android.view.View[5]/android.view.View[2]
${TextTotalPaidPeriod_SumInsured_Locator}              xpath=//android.view.View[2]/android.view.View[6]/android.view.View[2]
${TextSumAmount_SumInsured_Locator}                    xpath=//android.view.View[2]/android.view.View[7]/android.view.View[2]
${TextReturnAmount_SumInsured_Locator}                 xpath=//android.view.View[2]/android.view.View[8]/android.view.View[2]
${TextReturnAmountAll_SumInsured_Locator}              xpath=//android.view.View[2]/android.view.View[9]/android.view.View[2]
#${TitleTaxReduction_SumInsured_Locator}                xpath=//android.widget.FrameLayout[1]/android.webkit.WebView/android.view.View/android.view.View[2]/android.view.View[1]
#${TitleTaxReduction_SumInsured_Locator}                xpath=//android.view.View[@text='${STATIC_TEXT_REPLACE}']
${TextTaxBase_SumInsured_Locator}                      xpath=//android.view.View[2]/android.view.View[2]/android.view.View[1]
${TextToalTaxReduction_SumInsured_Locator}             xpath=//android.view.View[2]/android.view.View[2]/android.view.View[2]

########################################################
#  Applicant Information
########################################################
${ScreenArea_Insured_Locator}                          xpath=//*[@resource-id='android:id/content']
#${TitleName_Insured_Locator}                           xpath=//android.view.View[2]/android.view.View[2]/android.view.View[3]
${TitleName_Insured_Locator}                           xpath=//android.view.View[2]/android.view.View[3]/android.view.View/android.view.View
${FullName_Insured_Locator}                            xpath=//android.view.View[2]/android.view.View[2]/android.view.View[5]
${BOD_Insured_Locator}                                 xpath=//android.view.View[2]/android.view.View[2]/android.view.View[6]/android.view.View[2]
${Aged_Insured_Locator}                                xpath=//android.view.View[2]/android.view.View[2]/android.view.View[7]/android.view.View[2]
${PID_Insured_Locator}                                 xpath=//android.view.View[2]/android.view.View[2]/android.view.View[9]
${MobileNo_Insured_Locator}                            xpath=//android.view.View//*[@resource-id='InsuredMobileNo']
${Email_Insured_Locator}                               xpath=//android.view.View//*[@resource-id='InsuredEmail']
#${WorkingPlace_Insured_Locator}                        xpath=//android.view.View[1]/android.widget.EditText
${WorkingPlace_Insured_Locator}                        xpath=//android.view.View//*[@resource-id='InsuredEmail']
${Income_Insured_Locator}                               xpath=//*[@resource-id='income']

#${TitleName_Insured_Locator}                           xpath=//android.view.View[2]/android.view.View[3]
#${FullName_Insured_Locator}                            xpath=//android.view.View[2]/android.view.View[2]/android.view.View[5]
#${BOD_Insured_Locator}                                 xpath=//android.view.View[2]/android.view.View[2]/android.view.View[6]/android.view.View[2]
#${Aged_Insured_Locator}                                xpath=//android.view.View[2]/android.view.View[2]/android.view.View[7]/android.view.View[2]
#${PID_Insured_Locator}                                 xpath=//android.view.View//*[@resource-id='InsuredCitizenNo']
#${MobileNo_Insured_Locator}                            xpath=//android.view.View//*[@resource-id='InsuredMobileNo']
#${Email_Insured_Locator}                               xpath=//android.view.View//*[@resource-id='InsuredEmail']
##${WorkingPlace_Insured_Locator}                        xpath=//android.view.View//*[@resource-id='InsuredEmail']
#${WorkingPlace_Insured_Locator}                        xpath=//android.view.View/android.view.View[2]/android.view.View[1]/android.widget.EditText



########################################################
# Beneficiency Information
########################################################
${BoxRelation_Bene_Locator}                            xpath=//android.view.View//*[@resource-id='RelationShipId']
${Ratio_Bene_Locator}                                  xpath=//android.widget.EditText[@resource-id='Percent']
${FullName_Bene_Locator}                               xpath=//android.widget.EditText[@resource-id='BeneficiaryFullName']

########################################################
# Refund Policy Amount
########################################################
${RadioSavingInPolicyYes_Refund_Locator}               xpath=//android.view.View[1]/android.view.View[2]/android.view.View[2]/android.view.View/android.view.View[1]
${RadioSavingInPolicyNo_Refund_Locator}                xpath=//android.view.View[1]/android.view.View[2]/android.view.View[3]/android.view.View/android.view.View[1]
${ViewBankAcc_Refund_Locator}                          xpath=//android.view.View[1][@text='${STATIC_TEXT_REPLACE}']

########################################################
# Tax rights and FATCA Status Information
########################################################
${ExcludingVatYes_FATCA_Locator}                       xpath=//android.view.View[3]/android.view.View[1]/android.view.View/android.view.View[1]
${ExcludingVatNo_FATCA_Locator}                        xpath=//android.view.View[3]/android.view.View[1]/android.view.View/android.view.View[2]
${AcceptingYes_FATCA_Locator}                          xpath=//android.view.View[3]/android.view.View[3]/android.view.View/android.view.View[1]
${AcceptingNo_FATCA_Locator}                           xpath=//android.view.View[3]/android.view.View[4]/android.view.View/android.view.View[1]

########################################################
# Policy Confirmation Data
########################################################
${TextTotalPaidAmount_Confirm_Locator}                 xpath=//android.view.View/android.view.View[4]/android.view.View[4]/android.view.View
${TextPaidTerm_Confirm_Locator}                        xpath=//android.view.View/android.view.View[4]/android.view.View[5]/android.view.View
${TextInsuredName_Confirm_Locator}                     xpath=//android.view.View[5]/android.view.View[2]/android.view.View[2]/android.view.View
${TextInsuredMobile_Confirm_Locator}                   xpath=//android.view.View[5]/android.view.View[2]/android.view.View[4]/android.view.View
${TextInsuredEmail_Confirm_Locator}                    xpath=//android.view.View[5]/android.view.View[2]/android.view.View[6]/android.view.View
${TextInsuredSending_Confirm_Locator}                  xpath=//android.view.View[5]/android.view.View[2]/android.view.View[8]/android.view.View
${CheckedBoxConfirm_Confirm_Locator}                   xpath=//android.widget.FrameLayout[2]/android.webkit.WebView/android.view.View/android.view.View[6]/android.view.View
${CaptionPolicyNo_Confirm_Locator}                     xpath=//android.view.View[7]/android.view.View[1]/android.view.View/android.view.View/android.view.View[2]

