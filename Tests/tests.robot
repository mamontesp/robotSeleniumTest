*** Settings ***
Documentation	 This is robot test for ebay platform
Library  SeleniumLibrary
Library  OperatingSystem
Library  Collections
Library  String
  
*** Variables ***
${MESSAGE}  Hello, world!
${BROWSER}  Firefox
${URL}  https://www.ebay.com/
${test}  COP $23 540.90
${test2}
${number}  
${number2}=  ${12}
${totalPrice}

*** Test Cases ***
Verify regex
	[Documentation]
	${test2}=  Evaluate  '${test}'.replace(' ','')
	Log To Console  ${test2}
	${price}=  Get Regexp Matches  ${test2}  \\d+.\\d+
	${number}=  Convert To Number  ${price}[0]  2
	${totalPrice}=  Evaluate  ${number} + ${number2}
	Log To Console  ${totalPrice}
	  
Look for shoes in ebay
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
  ${count}=  Get Element Count  //div[@class='s-item__detail s-item__detail--primary']//span[@class='s-item__price']
  Log  ${count}
  ${pricesList}=  Create List
  :FOR  ${i}  IN RANGE  1  ${count}
  \  Exit For Loop If  ${i} == 6
  \  ${text}=  Get Text  xpath=(//span[@class='s-item__price'])[${i}]
  \  ${price}=  Get Regexp Matches  ${text}  \\d+.\\d+
  \  ${number}=  Convert To Number  ${price}[0]  2
  \  Append To List  ${pricesList}  ${number}
  Log List  ${pricesList}
  
	Close Browser
