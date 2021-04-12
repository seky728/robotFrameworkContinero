*** Settings ***
Documentation  Main Scenario for search category Notebook and insert first two most expesives products
Resource  ../../Resources/CZC_Helpers/MainHelper.robot

Suite Teardown  Close Browser

*** Variables ***



*** Test Cases ***
Verify Main Scenario For CZC Eshop
    [Documentation]  This is verified Main Scenario for CZC
    [Tags]  Functional

    Start TestCase
    See Navigation Tab
    User Move Mouse Over Main Category
    User See Megadropdown Menu
    Click On Category Notebooky
    User See Page With Notebooks
    Scroll Page To List Main Menu
    Select Category Most Expensive From List Main Menu
    Check If Sorting Is Ok
    User Save Price Of 1st Product
    Add First Product Into Cart
    Check Price In Cart
    Continue In Shopping
    User See Page With Notebooks
    User Save Price Of 2nd Product
    Add Second Product Into Cart
    Check Price In Cart
    Continue Into Order
    User Is In Cart
    Check Price In Cart





