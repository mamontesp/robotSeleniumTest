*** Settings ***
Documentation	 This is robot test for ebay platform
Library  SeleniumLibrary
Library  OperatingSystem

*** Variables ***
  ${BROWSER}  firefox
  
*** Test Cases ***
User is able to go to platform URL
  [Documentation]  This is some basic info about test
	[Tags]   Smoke
	Open Browser  http://www.amazon.com  firefox
	Close Browser

