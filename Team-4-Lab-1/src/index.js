// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Strict_mode
// Strict mode makes it easier to write "secure" JavaScript.

"use strict";

// color
var red = "red";
var green = "green";
var purple = "purple";
var colorArray = [red, green, purple];

// shape
var oval = "oval";
var rhombus = "rhombus";
var tilde = "tilde";
var shapeArray = [oval, rhombus, tilde];

// shade
var dashed = "dashed";
var empty = "empty";
var filled = "filled";
var shadeArray = [dashed, empty, filled];

// quality
var one = "1";
var two = "2";
var three = "3";
var qualityArray = [one, two, three];

// scores
var computerPlayerScore = 0;
var playerScore = 0;

var user = "user";
var computer = "computer";
var currentPlayer = "user"; // It can be user and computer.

// timer
var defaultTime = 20;
var currentTime = defaultTime;
var timer;

// level of difficutly
var levelOfDifficutly;

// deck array.
var deckArray = []; //
//var selectedArray = [];
var tableArray = []; // current cards on Borad. 12

var dialogOpened = true;

// Card Object
function Card(color, shape, shade, quality) {
  this.color = color;
  this.shape = shape;
  this.shade = shade;
  this.quality = quality;
  this.position = "";
  this.checked = false;

  this.filePath = function () {
    var filePath = "src/assets/card_images/" + this.color + "_" + this.shape + "_" + this.shade + "_" + this.quality + ".PNG";
    return filePath;
  }
}

//function main() {
//console.log("Entering main");
//document.getElementById("game").innerHTML = "Executing main()";
//}
//main();

function displayDialog() {
  //var mainPage = document.getElementById("mainPageId");
  // freeze the main page.
  //mainPage.style.backgroundColor = "#000";
  //mainPage.style.position = "fixed";
  //mainPage.style.display = "none";

  // display the dialog
  var dialogPage = document.getElementById("dialogId");
  //dialogPage.style.display = "block";
  dialogOpened = true;
  window.clearInterval(timer);
  dialogPage.showModal();
  //playerScore = 0;
  //document.getElementById("playerScoreId").innerHTML = playerScore;
}

function initDeck() {
  // get the value of difficulty
  var isSelected = false;
  var radio = document.getElementsByName("difficultyName");
  for (var i = 0; i < radio.length; i++) {
    if (radio[i].checked) {
      levelOfDifficutly = radio[i].value;
      isSelected = true;
    }
  }

  deckArray.length = 0;
  currentPlayer = user;
  computerPlayerScore = 0;
  playerScore = 0;
  document.getElementById("computerScoreId").innerHTML = computerPlayerScore;
  document.getElementById("playerScoreId").innerHTML = playerScore;

  if (isSelected) {
    // close the dialog
    var dialogPage = document.getElementById("dialogId");
    dialogPage.close();

    var displayLevel = document.getElementById("displayLevelId");
    displayLevel.innerHTML = levelOfDifficutly;

    // pick up a random color to initilze deckArray.
    var colorSize = colorArray.length;
    var colorIndex = Math.floor(Math.random() * colorSize);
    var color = colorArray[colorIndex];

    // initialize the Card and deck array.
    if (levelOfDifficutly == "easy") {

      for (var shapeIndex = 0; shapeIndex < shapeArray.length; shapeIndex++) {
        for (var shadeIndex = 0; shadeIndex < shadeArray.length; shadeIndex++) {
          for (var qualityIndex = 0; qualityIndex < qualityArray.length; qualityIndex++) {
            var card = new Card(color, shapeArray[shapeIndex], shadeArray[shadeIndex], qualityArray[qualityIndex]);

            // set card into deckArray.
            var index = getIndexOfDeckArray(27);
            deckArray[index] = card;
          }
        }
      }

    } else if (levelOfDifficutly == "hard") {

      for (var colorIndex = 0; colorIndex < colorArray.length; colorIndex++) {
        for (var shapeIndex = 0; shapeIndex < shapeArray.length; shapeIndex++) {
          for (var shadeIndex = 0; shadeIndex < shadeArray.length; shadeIndex++) {
            for (var qualityIndex = 0; qualityIndex < qualityArray.length; qualityIndex++) {
              var card = new Card(colorArray[colorIndex], shapeArray[shapeIndex], shadeArray[shadeIndex], qualityArray[qualityIndex]);

              // set card into deckArray.
              var index = getIndexOfDeckArray(81);
              deckArray[index] = card;
            }
          }
        }
      }

    }
    dialogOpened = false;

    initBoardTable();

    startTimer();
  }
}

function getRandomInt(max) {
  return Math.floor(Math.random() * max);
}

function initBoardTable() {
  var index = 0;
  for (var row = 0; row < 3; row++) {
    for (var column = 0; column < 4; column++) {
      var cardPosition = document.getElementById(row + "" + column + "Id");

      cardPosition.style.backgroundColor = "white";
      // remove card from deckArray into tableArray.
      var card = deckArray[deckArray.length - 1];
      deckArray.length = deckArray.length - 1;

      // set position and checked in the tableArray.
      card.position = row + "" + column;
      card.checked = false;
      tableArray[index] = card;
      index++;

      var content = "<br />";
      var content = content + "<input type=\"checkbox\" id=\"" + row + "" + column + "CheckboxId\" name=\"checkboxCardName\" value=\"" + card.color + "," + card.shape + "," + card.shade + "," + card.quality + "\" onchange=\"selectCard(" + row + ", " + column + ")\" style=\"display: none;\">";
      content = content + "<label for=\"" + row + "" + column + "CheckboxId\">";
      content = content + "<img id=\"" + row + "" + column + "ImageId\" src=\"" + card.filePath() + "\">";
      content = content + "</label>";
      content = content + "<br />";

      cardPosition.innerHTML = content;

    }
  }
}

function resetTable() {
  for (var i = 0; i < deckArray.length; i++) {
    var tempCard = deckArray[i];
    tableArray[tableArray.length] = tempCard;
  }
  deckArray.length = 0;

  var size = tableArray.length;
  for (var i = 0; i < tableArray.length; i++) {
    var card = tableArray[i];

    card.position = "";
    card.checked = false;
    var index = getIndexOfDeckArray(size);
    deckArray[index] = card;
  }
  tableArray.length = 0;

  initBoardTable();
}

function selectCard(row, column) {
  var isChecked = false;
  var checkbox = document.getElementById(row + "" + column + "CheckboxId");
  if (checkbox.checked) {
    document.getElementById(row + "" + column + "Id").style.backgroundColor = "green";
    isChecked = true;
  } else {
    document.getElementById(row + "" + column + "Id").style.backgroundColor = "white";
  }

  // update card status on tableArray.
  var currentPosistion = row + "" + column;
  for (var i = 0; i < tableArray.length; i++) {
    var card = tableArray[i];
    if (card.position == currentPosistion) {
      card.checked = isChecked;
    }
  }

  checkForSet();
}

function checkForSet() {
  //var card = document.getElementById(row + "" + column + "CheckboxId").value;
  //alert(card + " is clicked");
  var selectedCardsArray = [];
  var checkboxArray = document.getElementsByName("checkboxCardName");
  for (var index = 0; index < checkboxArray.length; index++) {
    var checkbox = checkboxArray[index];
    if (checkbox.checked) {
      var checkboxId = checkbox.id;
      var position = checkboxId.slice(0, 2);
      var value = checkbox.value;
      var tokens = value.split(",");
      var color = tokens[0];
      var shape = tokens[1];
      var shade = tokens[2];
      var quality = tokens[3];

      var card = new Card(color, shape, shade, quality);
      card.position = position;
      selectedCardsArray[selectedCardsArray.length] = card;
      //alert("color = " + color + ", shape = " + shape + ", shade = " + shade + ", quality = " + quality);
    }
  }


  if (selectedCardsArray.length == 3) {
    var isSet = compareCards(selectedCardsArray[0], selectedCardsArray[1], selectedCardsArray[2]);
    if (isSet) {
      alert("It is a set, " + currentPlayer + " get 1 point!");
      updateScore(true);

      replaceCardFromDeckToTable(selectedCardsArray);

    } else {
      alert("It is not a set! You lose 1 point.");
      updateScore(false);
      // reset.
      resetAllCheckboxAndBackground();
    }

    // switch to another player.
    switchPlayers();
  }

}

/**
 * reset all the checkbox status to unchecked and set the background color to white.
 */
function resetAllCheckboxAndBackground() {
  // unselect all the cards.
  var checkboxArray = document.getElementsByName("checkboxCardName");
  for (var index = 0; index < checkboxArray.length; index++) {
    var checkbox = checkboxArray[index];
    checkbox.checked = false;
  }

  // reset every card in the tableArray checked = false;
  for (var i = 0; i < tableArray.length; i++) {
    var card = tableArray[i];
    card.checked = false;

    // reset the background color.
    var position = card.position;
    document.getElementById(position + "Id").style.backgroundColor = "white";
  }
}

function getIndexOfDeckArray(size) {
  var index;
  do {
    index = Math.floor(Math.random() * size);
    var tempCard = deckArray[index];

    //console.log("index = " + index);

  } while (typeof (tempCard) !== "undefined");

  return index;
}

function updateScore(isIncreasement) {

  if (currentPlayer == user) {
    // update userScore. increase points or lose points.
    if (isIncreasement) {
      playerScore++;
    } else {
      if (playerScore > 0) {
        playerScore--;
      }
    }

    document.getElementById("playerScoreId").innerHTML = playerScore;
  } else {
    // update computerPlayerScore. computer increase points or lose points.
    if (isIncreasement) {
      computerPlayerScore++;
    } else {
      if (computerPlayerScore > 0) {
        computerPlayerScore--;
      }
    }
    document.getElementById("computerScoreId").innerHTML = computerPlayerScore;
  }

}

function replaceCardFromDeckToTable(selectedCardsArray) {

  // remove all selected card from tableArray.
  for (var i = 0; i < selectedCardsArray.length; i++) {
    var selectedCard = selectedCardsArray[i];

    for (var j = 0; j < tableArray.length; j++) {
      var tempCard = tableArray[j];
      if (tempCard.color == selectedCard.color && tempCard.shape == selectedCard.shape && tempCard.shade == selectedCard.shade && tempCard.quality == selectedCard.quality) {
        tableArray.splice(j, 1);
      }
    }
  }

  // since a set with 3 cards has been removed from tableArray, tableArray.length is still 12 means there are 3 additional cards have been introduced.
  // once a set has been found, the play resumes again with 12 cards and shuffle the table.
  // the new <tr></tr> and <td></td> should be removed.
  if (tableArray.length == 12) {
    var index = 0;
    for (var row = 0; row < 3; row++) {
      for (var column = 0; column < 4; column++) {
        var position = row + "" + column;
        var cardPosition = document.getElementById(row + "" + column + "Id");

        cardPosition.style.backgroundColor = "white";

        var card = tableArray[index];
        card.position = position;
        card.checked = false;
        index++;

        var checkbox = document.getElementById(position + "CheckboxId");
        checkbox.checked = false;
        checkbox.value = card.color + "," + card.shape + "," + card.shade + "," + card.quality;

        var image = document.getElementById(position + "ImageId");
        image.src = card.filePath();
      }
    }

    // remove additional new <tr></tr> and <td></td>
    /*
    var mainTable = document.getElementById("mainTableId");
    var numberOfRow = mainTable.rows.length;
    for(var i=3; i<numberOfRow; i++){
      mainTable.deleteRow(i);
    }
    */
    document.getElementById("mainTableId").deleteRow(3);

  } else {
    // get new cards from deckArray and set them into tableArray.
    if (deckArray.length >= 3) {
      for (var i = 0; i < selectedCardsArray.length; i++) {
        var selectedCard = selectedCardsArray[i];
        var position = selectedCard.position;

        var card = deckArray[deckArray.length - 1];
        deckArray.length = deckArray.length - 1;

        var cardPosition = document.getElementById(position + "Id");

        cardPosition.style.backgroundColor = "white";

        // set position and checked in the tableArray.
        tableArray[tableArray.length] = card;
        card.position = position;
        card.checked = false;

        var checkbox = document.getElementById(position + "CheckboxId");
        checkbox.checked = false;
        checkbox.value = card.color + "," + card.shape + "," + card.shade + "," + card.quality;

        var image = document.getElementById(position + "ImageId");
        image.src = card.filePath();
      }
    } else {
      for (var i = 0; i < selectedCardsArray.length; i++) {
        var selectedCard = selectedCardsArray[i];
        var position = selectedCard.position;

        var cardPosition = document.getElementById(position + "Id");
        cardPosition.style.backgroundColor = "white";
        cardPosition.innerHTML = "";
      }
    }
  }
}

function addAdditionalCardsToTable() {
  // append a new <tr></tr> node into table
  var mainTable = document.getElementById("mainTableId");
  var trNode = document.createElement("tr");

  // row and column based on current number of <tr></tr> nodes.
  var row = mainTable.rows.length;

  for (var column = 0; column < 3; column++) {

    var tdNode = document.createElement("td");
    tdNode.id = row + "" + column + "Id";

    //var cardPosition = document.getElementById(row + "" + column + "Id");

    //cardPosition.style.backgroundColor = "white";
    // remove card from deckArray into tableArray.
    var card = deckArray[deckArray.length - 1];
    deckArray.length = deckArray.length - 1;

    // set position and checked in the tableArray.
    card.position = row + "" + column;
    card.checked = false;
    tableArray[tableArray.length] = card;

    var content = "<br />";
    content = content + "<input type=\"checkbox\" id=\"" + row + "" + column + "CheckboxId\" name=\"checkboxCardName\" value=\"" + card.color + "," + card.shape + "," + card.shade + "," + card.quality + "\" onchange=\"selectCard(" + row + ", " + column + ")\" style=\"display: none;\">";
    content = content + "<label for=\"" + row + "" + column + "CheckboxId\">";
    content = content + "<img id=\"" + row + "" + column + "ImageId\" src=\"" + card.filePath() + "\">";
    content = content + "</label>";
    content = content + "<br />";

    tdNode.innerHTML = content;

    trNode.appendChild(tdNode);
  }

  mainTable.appendChild(trNode);
}

/**
 * If there is a set on current table, pop up a dialog ("There is still a set") to user.
 * If there is no set can be found on current table, introduce 3 additional cards from deck.
 * If there is no set can be found on current table, determine the winner based on socres.
 */
function addCardsOrDecideWinner() {
  var isExistSet = generateHint(false);
  if (isExistSet) {
    alert("There is still at least one set on current table.");
  } else {
    if (deckArray.length >= 3) {
      // no set can be found on current table and introduce 3 additional cards.
      alert("3 additional cards introduced");

      addAdditionalCardsToTable();

    } else {
      // no set can be found on current table then determine the winner.
      //alert("determine the winner!");
      endGame();
    }
  }
}

function generateHint(isHightlight) {
  // check current cards on board for a set
  // highlight the cards that would make the set
  // if no hint available pop up message that says none available
  var index = 0;
  var card1;
  var card2;
  var card3;
  var isSet = false;
  for (var i = 0; i < tableArray.length; i++) {
    for (var j = i + 1; j < tableArray.length; j++) {
      for (var k = j + 1; k < tableArray.length; k++) {

        card1 = tableArray[i];
        card2 = tableArray[j];
        card3 = tableArray[k];

        isSet = compareCards(card1, card2, card3);

        if (isSet) {
          // isHightlight == true, isHightlight the background.
          if (isHightlight) {
            // a set has been found. hightlight them and return true.
            document.getElementById(card3.position + "Id").style.backgroundColor = "blue";
          }

          return true;
        }

      }
    }
  }

  // there is no set can be found. return false.
  return false;
}

function compareCards(card1, card2, card3) {
  var sd = compareAttribute(card1.shade, card2.shade, card3.shade);
  var c = compareAttribute(card1.color, card2.color, card3.color);
  var q = compareAttribute(card1.quality, card2.quality, card3.quality);
  var sp = compareAttribute(card1.shape, card2.shape, card3.shape);

  if (sd && c && q && sp) {
    return true;
  } else {
    return false;
  }
}

function compareAttribute(attribute0, attribute1, attribute2) {
  var same = true;
  var diff = true;
  var setIndicator = false;
  if (attribute0 == attribute1) {
    diff = false;
  }
  else {
    same = false;
  }
  if (attribute1 == attribute2) {
    diff = false;
  }
  else {
    same = false;
  }
  if (attribute0 == attribute2) {
    diff = false;
  }
  else {
    same = false;
  }
  setIndicator = same || diff;

  return setIndicator;
}

/**
 * Create a timer.
 */
function startTimer() {
  currentTime = defaultTime;

  // display arrow and timer based on current player.
  if (currentPlayer == user) {
    // update arrow.
    document.getElementById(user + "ImageId").style.display = "block";
    document.getElementById(computer + "ImageId").style.display = "none";

    // update timer.
    document.getElementById(user + "TimeId").innerHTML = currentTime;
    document.getElementById(computer + "TimeId").innerHTML = "";
  } else {
    // update arrow.
    document.getElementById(user + "ImageId").style.display = "none";
    document.getElementById(computer + "ImageId").style.display = "block";

    // update timer.
    document.getElementById(user + "TimeId").innerHTML = "";
    document.getElementById(computer + "TimeId").innerHTML = currentTime;
  }

  timer = window.setInterval(countdownTimer, 1000);
}

function countdownTimer() {

  currentTime = currentTime - 1;

  // display timer based on current player.
  if (currentPlayer == user) {
    document.getElementById(user + "TimeId").innerHTML = currentTime;
    document.getElementById(computer + "TimeId").innerHTML = "";
  } else {
    document.getElementById(user + "TimeId").innerHTML = "";
    document.getElementById(computer + "TimeId").innerHTML = currentTime;
  }
  //document.getElementById("timeId").innerHTML = currentTime;

  if (currentTime <= 0) {
    switchPlayers();
  }
}

/**
 * If current player is user, it will switch to computer.
 * If current player is computer, it will switch to player.
 * 
 * when it is a computer turn, it will disable all the cards.
 */
function switchPlayers() {
  // reset timer.
  window.clearInterval(timer);
  // reset checkbox and backgroun.
  resetAllCheckboxAndBackground();
  if(dialogOpened == false) {
    if (currentPlayer == user) {
      currentPlayer = computer;
      alert("Computers turn!");
      // computer turn, disabled all the cards.
      var checkboxArray = document.getElementsByName("checkboxCardName");
      for (var i = 0; i < checkboxArray.length; i++) {
        checkboxArray[i].disabled = true;
      }

      // delay some seconds to let computer find a set.
      var delayTime = Math.floor(Math.random() * 10);
      window.setTimeout(aiPlayer, delayTime * 1000);

    } else {
      currentPlayer = user;
      alert("Players turn!");

      var checkboxArray = document.getElementsByName("checkboxCardName");
      for (var i = 0; i < checkboxArray.length; i++) {
        checkboxArray[i].disabled = false;
      }

    }

    startTimer();
  }
}

/**
 * generate a random number,
 * if the number is even, computer will find a set.
 * if the number is odd, computer will not find a set.
 * 
 * after that, it will switch to player turn.
 * 
 * @returns 
 */
function aiPlayer() {

  var tempNumber = Math.floor(Math.random() * 10);

  // try to find a set.
  var tempArray = [];
  if(dialogOpened == false) {
    for (var i = 0; i < tableArray.length; i++) {
      for (var j = i + 1; j < tableArray.length; j++) {
        for (var k = j + 1; k < tableArray.length; k++) {

          var card1 = tableArray[i];
          var card2 = tableArray[j];
          var card3 = tableArray[k];

          var isSet = compareCards(card1, card2, card3);
          if (isSet) {
            tempArray[0] = card1;
            tempArray[1] = card2;
            tempArray[2] = card3;
          }

        }
      }
    }

    if (tempNumber % 2 == 0 && tempArray.length > 0) {
      // it will find a set.
      for (var i = 0; i < tempArray.length; i++) {
        var tempCard = tempArray[i];
        var position = tempCard.position;
        document.getElementById(position + "Id").style.backgroundColor = "green";
        document.getElementById(position + "CheckboxId").checked = true;
      }

      var delayTime = Math.floor(Math.random() * 5);
      window.setTimeout(checkForSet, delayTime * 1000);

    } else {
      // it will not find a set.
      alert("Computer did not find a set! It will switch to your turn soon!");
      updateScore(false);
      var delayTime = Math.floor(Math.random() * 5);
      window.setTimeout(switchPlayers, delayTime * 1000);
    }
  }
}


function endGame() {
  var isContinue = false;
  if (playerScore > computerPlayerScore) {
    isContinue = confirm("Congratulations, you won the game! Would you like to restart the game?");
  } else if (playerScore < computerPlayerScore) {
    isContinue = confirm("Unfortunately, Computer won the game! Would you like to restart the game?");
  } else {
    isContinue = confirm("Wow, it seems draw! Would you like to restart the game?");
  }

  if (isContinue) {
    displayDialog();
  }

}
