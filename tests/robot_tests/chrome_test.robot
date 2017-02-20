*** Settings ***
Library  Selenium2Library
Suite Teardown  Close all browsers

*** Test Cases ***
Chrome opens a page
  Open browser  http://fanmiles.com  chrome
