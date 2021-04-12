*** Settings ***
Library  SeleniumLibrary
Library  String
Library  Collections


*** Variables ***
@{prices}



*** Keywords ***
Start TestCase
    Open Browser  https://www.czc.cz/  chrome
    Maximize Browser Window

See Navigation Tab
    Element Should Be Visible  css:header .main-menu-wrapper

User Move Mouse Over Main Category
    Mouse Over  css:.main-menu > div:nth-child(2)

User See Megadropdown Menu
    Element Should Be Visible  css:.main-menu > div:nth-child(2) .main-menu__submenu

Click On Category Notebooky
    Click Link  Notebooky

User See Page With Notebooks
    Element Should Contain  css:.entry-header  Notebooky


Scroll Page To List Main Menu
    Scroll Element Into View  css:#tiles > div:nth-child(1) .price .price-vatin

Select Category Most Expensive From List Main Menu
    Click Link  Nejdražší

Check If Sorting Is Ok
    [Arguments]  ${numOfProducts}
    ${products} =  Create List
    Sleep  1s
    FOR  ${num}  IN  ${numOfProducts}
        ${price} =  Get Price Of N Position Product  ${num}

        Append To List  ${products}  ${price}

    END

    ${sortedList} =  Evaluate  sorted(${products}, key = int, reverse=True)

    Lists Should Be Equal  ${products}  ${sortedList}


User Save Price Of N Product
    [Arguments]  ${nProduct}
    ${price} =  Get Price Of N Position Product  ${nProduct}
    Append To List  ${prices}  ${price}


Get Price Of N Position Product
    [Arguments]  ${nProduct}
    IF  ${nProduct} > 1
        ${nProduct} =  Evaluate  ${nProduct} + 1
    END
    ${price} =  Get Text  css:#tiles > div:nth-child(${nProduct}) .price .price-vatin
    ${price} =  Split String  ${price}  Kč
    ${price} =  Get From List  ${price}  0
    ${price} =  Convert To Integer  ${price}
    [Return]  ${price}



Add Product Into Cart
    [Arguments]  ${nProduct}
    IF  ${nProduct} > 1
        ${nProduct} =  Evaluate  ${nProduct} + 1
    END

    Scroll Element Into View  css:#tiles > div:nth-child(${nProduct}) button
    Click Button  css:#tiles > div:nth-child(${nProduct}) button


Check Price In Cart
    Log To Console  Hello Now i will check price in cart
    Wait Until Element Is Visible  id:basket-preview
    Sleep  3s
    ${cartPrice} =  Get Text  css:#basket-preview > a span.price-vatin > span
    ${cartPrice} =  Split String  ${cartPrice}  Kč
    ${cartPrice} =  Get From List  ${cartPrice}  0
    ${cartPrice} =  Convert To Integer  ${cartPrice}

    Log To Console  this is prices: ${prices}
    ${countSavedPrices} =  Sum List Values  ${prices}
    Log To Console  ${countSavedPrices}
    Should Be True  ${cartPrice} == ${countSavedPrices}


Continue In Shopping
    Click Button  css:.buy-mode__container .btn.close


Continue Into Order
    Sleep  2s
    Click Element  css:.buy-mode__container .btn-purchase


User Is In Cart
    Element Should Contain  css:#basket-visibility-container h1  Váš nákupní košík

Sum List Values
    [arguments]   ${list}
    ${listLength} =  Get Length  ${list}
    ${value} =  Set Variable  0
    IF  ${listLength} <= 1
        ${value} =  Get From List  ${list}  0
    ELSE

        FOR  ${num}  IN RANGE  ${listLength}
            ${listValue} =  Get From List  ${list}  ${num}
            ${value} =  Evaluate  ${value} + ${listValue}
        END

    END

    [Return]  ${value}