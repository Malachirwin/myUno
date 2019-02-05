function playCard(card, client_number) {
  var data = {card: card, client_number: client_number};
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

function playersUno(name) {
  alert(`${name} said 'Uno'`);
}

function drawACard(client_number) {
  var data = {card: "Draw", client_number: client_number};
  fetch('/game', {
    method: 'POST',
    body: JSON.stringify(data),
    headers: {
      "Content-Type": "application/json"
    }
  });
  window.location.reload();
}
