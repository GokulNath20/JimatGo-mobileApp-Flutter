//All page
var titleFontSize = 0.0;
var labelHintFontSize = 0.0;
var errorFontSize = 0.0;
var contentFontSize = 0.0;
var textFieldVerticalContainer = 0.0;
var switchButtonScale = 0.0;
//Login page
var loginPageIconSize = 0.0;
//Register page
var registerPageIconSize = 0.0;
//Reset page
var resetButtonWidth = 0.0;
var resetButtonHeight = 0.0;
var resetPageIconSize = 0.0;

// Content/Title Font size & TextFieldContainer size based on screen resolution
void responsive(screenWidth) {
  if (screenWidth <= 410) {
    contentFontSize = 12.0;
    titleFontSize = 31.0;
    labelHintFontSize = 12.0;
    errorFontSize = 10.0;
    textFieldVerticalContainer = 0.0;
    switchButtonScale = 0.8;
    loginPageIconSize = 18.0;
    registerPageIconSize = 18.0;
    resetPageIconSize = 120.0;
    resetButtonWidth = screenWidth / 2.5;
    resetButtonHeight = screenWidth * 0.08;
  } else if (screenWidth > 410 && screenWidth <= 700) {
    contentFontSize = 17.0;
    titleFontSize = 37.0;
    labelHintFontSize = 16.0;
    errorFontSize = 14.0;
    textFieldVerticalContainer = 0.0;
    switchButtonScale = 1.0;
    loginPageIconSize = 24.0;
    registerPageIconSize = 24.0;
    resetPageIconSize = 170;
    resetButtonWidth = screenWidth / 2.5;
    resetButtonHeight = screenWidth * 0.09;
  } else {
    contentFontSize = 22.0;
    titleFontSize = 43.0;
    labelHintFontSize = 21.0;
    errorFontSize = 18.0;
    textFieldVerticalContainer = 8.0;
    switchButtonScale = 1.3;
    loginPageIconSize = 29.0;
    registerPageIconSize = 29.0;
    resetPageIconSize = 220;
    resetButtonWidth = screenWidth / 3.3;
    resetButtonHeight = screenWidth * 0.07;
  }
}
