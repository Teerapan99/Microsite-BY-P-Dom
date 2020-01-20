*** Settings ***
Library           AppiumLibrary
Resource          ../Resources/Resource_Environment.robot
Resource          ../Resources/Resource_MicrositeIL.robot
Resource          ../Resources/Business_Microsite.robot

Suite Setup       Default Setup
Test Setup        Solution Tear Up
Test Teardown     Solution Tear Down


*** Test Cases ***
MicrositeIL_TC_001_1
    [Documentation]    Fill in customer data
    [Tags]   Test1
    Navigate to URL Website
    Process Customer Data Input And Verify Premium Calcuation with Payment

MicrositeIL_TC_001_2
    [Documentation]    Fill in customer data
    [Tags]   Test1
    Process Customer Data Input And Verify Premium Calcuation with Payment
