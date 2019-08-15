*** Settings ***
Documentation	 This is robot test for ebay platform
Library  SeleniumLibrary
Library  OperatingSystem
Library  Collections
Library  String
  
*** Variables ***
${MESSAGE}  Hello, world!
${MESSAGE_SORT_LIST}  Sorting List!
${BROWSER}  Firefox
${URL}  https://www.ebay.com/
${test}  COP $23 980.9
${test2}
${number}  
${shippingPriceNumber}  
${number2}=  ${12}
${totalPrice}

*** Keywords ***
Prices from String
  [Arguments]  ${stringPrice}=0 
	${numPrices}=  Convert To Number  ${stringPrice}  2
  [return]  ${numPrices}
  
Regex Length Match
	[Arguments]  ${text}
	${filteredText}=  Get Regexp Matches  ${text}  \\d+.\\d+
	${length}=  Get Length  ${filteredText}
	${match}=  Set Variable If  ${length}==0  ${0}  ${length}>0  ${filteredText}[0]
  [return]  ${match}

Verify Order
	[Arguments]  ${item1}  ${item2}
	${order}=  Set Variable If  ${item1}<=${item2}  ${1}  ${item1}>${item2}  ${0}
	[return]  ${order}

Ordered Products from Dictionary
  [Arguments]  ${dictionary}
  ${sorted}=  Get Dictionary Keys  ${dictionary}
  Log  ${sorted}
  [return]  ${sorted}
  
Ordered Products by Price from Dictionary
  [Arguments]  ${dictionary}
  ${prices}=  Get Dictionary Values  ${dictionary}
  Sort List  ${prices}
  ${orderedProductsByPrice}=  Create List
  :FOR  ${i}  IN RANGE  0  5
  \  ${product}=  Get Product by Price  ${dictionary}  ${prices}[${i}]
  \  Append To List  ${orderedProductsByPrice}  ${product}
  Log List  ${orderedProductsByPrice}
  [return]  ${orderedProductsByPrice}

Get Product by Price
	[Arguments]  ${dictionary}  ${price}
	${copyDictionary}=  Copy Dictionary  ${dictionary}
	Log Dictionary  ${copyDictionary}
	${products}=  Get Dictionary Keys  ${copyDictionary}
	Log List  ${products}
	:FOR  ${i}  IN RANGE  0  5
  \  ${val}=  Pop From Dictionary  ${copyDictionary}  ${products}[${i}]
	\  Return From Keyword If  ${val}==${price}  ${products}[${i}]
	
	
*** Test Cases ***
Verify regex
	[Documentation]
	${test2}=  Evaluate  '${test}'.replace(' ','')
	Log To Console  ${test2}
  ${price}=  Regex Length Match  ${test2}  
	${number}=  Prices from String  ${price}
	${totalPrice}=  Evaluate  ${number} + ${number2}
	Log To Console  ${totalPrice}
   
Look for shoes by prices
  [Documentation]  List 5 first low prices shoes
	[Tags]   Smoke
	Log  ${MESSAGE}
	Open Browser  ${URL}  ${BROWSER}
	Input Text  id=gh-ac  Shoes
	Press Key  id=gh-ac  \\13
  Wait Until Page Contains Element  xpath=//li[@name='Brand']//a[contains(@href, 'PUMA')]
	Click Link  xpath=//li[@name='Brand']//a[contains(@href, 'PUMA')]
  Wait Until Page Contains Element  xpath=//div[@id='w3-w3' and @class='size-component']//a[@class='size-component__square'][5]
	Click Link  xpath=//div[@id='w3-w3' and @class='size-component']//a[@class='size-component__square'][5]
	${results}  Get Text  xpath=//div[@class='srp-controls__row-cells']//div[@class='srp-controls__control srp-controls__count']//h1 
	Log  ${results}
  Click Button  xpath=//div[@class='srp-controls__sort srp-controls__control']//div[@id='w7']//button
  Wait Until Page Contains Element  xpath= /html/body/div[3]/div[5]/div[1]/div/div[1]/div[3]/div[1]/div/div/div/ul/li[4]/a[1]
  Click Link  xpath= /html/body/div[3]/div[5]/div[1]/div/div[1]/div[3]/div[1]/div/div/div/ul/li[4]/a[1]
  Sleep  2s
  ${count}=  Get Element Count  //div[@class='s-item__details clearfix']
  Log  ${count}
  ${pricesList}=  Create List
  ${productsList}=  Create List
  Comment  Create a Dictionary Object
  ${productsDictionary}=  Create Dictionary

  :FOR  ${i}  IN RANGE  1  ${count}
  \  Exit For Loop If  ${i} == 6
  \  ${product}=  Get Text  xpath=(//h3[@class='s-item__title'])[${i}]
  \  ${mainPrice}=  Get Text  xpath=(//div[@class='s-item__details clearfix']//span[@class='s-item__price'])[${i}]
  \  ${shippingPrice}=  Get Text  xpath=(//div[@class='s-item__details clearfix']//span[@class='s-item__shipping s-item__logisticsCost'])[${i}]

  \  ${mainPrice}=  Regex Length Match  ${mainPrice}
  \  ${shippingPrice}=  Regex Length Match  ${shippingPrice}

  \  ${mainPriceNumber}=  Prices from String  ${mainPrice}
  \  ${shippingPriceNumber}=  Prices from String  ${shippingPrice} 
  
  \  ${totalPrice}=  Evaluate  ${mainPriceNumber} + ${shippingPriceNumber}

  \  Set To Dictionary  ${productsDictionary}   ${product}  ${totalPrice}
  \  Append To List  ${pricesList}  ${totalPrice}
	\  Append To List  ${productsList}  ${product}
  :FOR  ${i}  IN RANGE  0  4
  \  ${order}=  Verify Order  ${pricesList}[${i}]  ${pricesList}[${i+1}]
	\  Should Be Equal As Integers  ${order}  ${1} 
	:FOR  ${i}  IN RANGE  0  5
	\  Comment  Printing 5 products and prices
  \  Log To Console   ${productsList}[${i}]
  \  Log To Console   ${pricesList}[${i}]
  Log List  ${pricesList}
  Log Dictionary  ${productsDictionary}
	Close Browser
	Log To Console  ${MESSAGE_SORT_LIST}
  Comment  Sorting Products List
	Sort List  ${productsList}
	Log List  ${productsList}
	Comment  Sorting Prices List
	Sort List  ${productsList}
	Log List  ${productsList}
	Ordered Products from Dictionary  ${productsDictionary}
  Ordered Products by Price from Dictionary  ${productsDictionary}

