var tangle = new Tangle(document.getElementById("distanceCalculator"), {
  initialize: function () {
    this.kilometres = 5;
  },
  update: function () {
    this.miles = this.kilometres * 0.621371192;
  }
});
