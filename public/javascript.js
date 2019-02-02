function playCard(card) {
  var data = {card: card};
  fetch('/game', {
    method: 'POST',
    body: JSON.stringify(data),
    headers: {
      "Content-Type": "application/json"
    }
  });
  window.location.reload();
  // bottom();
}

function playCrazyCard(card) {
  var data = {card: card};
  fetch('/crazy_game', {
    method: 'POST',
    body: JSON.stringify(data),
    headers: {
      "Content-Type": "application/json"
    }
  });
  window.location.reload();
  // bottom();
}


function playersUno(name) {
  alert(`${name} said 'Uno'`);
}

function drawACrazyCard() {
  var data = {card: "Draw"};
  fetch('/crazy_game', {
    method: 'POST',
    body: JSON.stringify(data),
    headers: {
      "Content-Type": "application/json"
    }
  });
  window.location.reload();
}

function drawACard() {
  var data = {card: "Draw"};
  fetch('/game', {
    method: 'POST',
    body: JSON.stringify(data),
    headers: {
      "Content-Type": "application/json"
    }
  });
  window.location.reload();
}

function flip() {
  document.getElementById("flip-box-inner").className = "flip-box-inner flip";
  // document.getElementById("myDIV").className = "mystyle"
  window.setTimeout(partB,1000);
}
function bottom() {
  document.getElementById("theCard").className = "card slide-bottom";
  // document.getElementById("myDIV").className = "mystyle"
  window.setTimeout(partC,1000);
}
function partB() {
  document.getElementById("flip-box-inner").className = "flip-box-inner flip slide-right";
  window.setTimeout(partC,1000);
}

function partC() {
  window.location.reload();
}
