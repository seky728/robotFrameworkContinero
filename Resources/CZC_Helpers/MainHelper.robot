*** Settings ***
Library  SeleniumLibrary
Library  String
Library  Collections


*** Variables ***
${price01Product}  0
${price02Product}  0



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
# Vhodné by bylo samozřejmě toto nahradit polem, nebo nějakym listem co by bralo jako vstupní argument počet produktů a nebyly na pevno dány takto 3
    Sleep  1s
    ${price01Product} =  Get Text  css:#tiles > div:nth-child(1) .price .price-vatin
    ${price02Product} =  Get Text  css:#tiles > div:nth-child(3) .price .price-vatin
    ${price03Product} =  Get Text  css:#tiles > div:nth-child(5) .price .price-vatin
    Log To Console  ${Price01Product}
    Log To Console  ${Price02Product}
    Log To Console  ${Price03Product}
    ${Price01Product} =  Split String  ${Price01Product}  Kč
    ${Price02Product} =  Split String  ${Price02Product}  Kč
    ${Price03Product} =  Split String  ${Price03Product}  Kč


    ${Price01Product} =  Get From List  ${Price01Product}  0
    ${Price02Product} =  Get From List  ${Price02Product}  0
    ${Price03Product} =  Get From List  ${Price03Product}  0

    ${Price01Product} =  Convert To Integer  ${Price01Product}
    ${Price02Product} =  Convert To Integer  ${Price02Product}
    ${Price03Product} =  Convert To Integer  ${Price03Product}

    Log To Console  ${Price01Product}
    Log To Console  ${Price02Product}
    Log To Console  ${Price03Product}

    Should Be True  ${Price01Product} > ${Price02Product} > ${Price03Product}


User Save Price Of 1st Product
#zde také by bylo vhodné nahradit metodou, která by jako vstupní argument přijala z kolikátého produktu chci částku načíst
    ${price01Product} =  Get Text  css:#tiles > div:nth-child(1) .price .price-vatin
    ${Price01Product} =  Split String  ${Price01Product}  Kč
    ${Price01Product} =  Get From List  ${Price01Product}  0
    ${Price01Product} =  Convert To Integer  ${Price01Product}
    Set Global Variable  ${price01Product}   ${price01Product}


User Save Price Of 2nd Product
    ${price02Product} =  Get Text  css:#tiles > div:nth-child(3) .price .price-vatin
    ${Price02Product} =  Split String  ${Price02Product}  Kč
    ${Price02Product} =  Get From List  ${Price02Product}  0
    ${Price02Product} =  Convert To Integer  ${Price02Product}
    Set Global Variable  ${price02Product}   ${price02Product}





Add First Product Into Cart
#tady také, nahradit metodou se vstupním argumentem pro nth-child
    Scroll Element Into View  css:#tiles > div:nth-child(1) button
    Click Button  css:#tiles > div:nth-child(1) button




Add Second Product Into Cart
    Click Button  css:#tiles > div:nth-child(3) button



Check Price In Cart
    Log To Console  Hello Now i will check price in cart
    Wait Until Element Is Visible  id:basket-preview
    Sleep  3s
    ${cartPrice} =  Get Text  css:#basket-preview > a span.price-vatin > span
    ${cartPrice} =  Split String  ${cartPrice}  Kč
    ${cartPrice} =  Get From List  ${cartPrice}  0
    ${cartPrice} =  Convert To Integer  ${cartPrice}
    ${countCurrentProducts} =  Evaluate  ${price01Product} + ${price02Product}
    Log To Console  ${countCurrentProducts}
    Should Be True  ${cartPrice} == ${countCurrentProducts}


Continue In Shopping
    Click Button  css:.buy-mode__container .btn.close


Continue Into Order
    Sleep  2s
    Click Element  css:.buy-mode__container .btn-purchase


User Is In Cart
    Element Should Contain  css:#basket-visibility-container h1  Váš nákupní košík
