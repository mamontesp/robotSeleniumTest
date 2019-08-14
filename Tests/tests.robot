*** Settings ***
Documentation	 This is robot test for ebay platform
Library  SeleniumLibrary
Library  OperatingSystem

*** Variables ***
${MESSAGE}  Hello, world!

*** Test Cases ***
Look for shoes in ebay
  [Documentation]  This is some basic info about test
	[Tags]   Smoke
	Log  ${MESSAGE}
	Open Browser  https://www.ebay.com/  firefox
	Close Browser

