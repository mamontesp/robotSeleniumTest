*** Settings ***
Documentation	 This is robot test for ebay platform
Library  SeleniumLibrary
Library  OperatingSystem
Library  Collections
  
*** Variables ***
${MESSAGE}  Hello, world!
${BROWSER}  Firefox
${URL}  https://www.ebay.com/

*** Test Cases ***
Look for shoes in ebay
  [Documentation]  This is some basic info about test
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
  \  Append To List  ${pricesList}  ${text}
  Log List  ${pricesList}
	Close Browser
