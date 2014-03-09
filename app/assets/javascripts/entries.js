function addEntries(categoryNames) {
  
  var total = new Number(0);
  var entryAmount;

  for (var i = 0; i < categoryNames.length; i++) {
    var categoryName = categoryNames[i];
    categoryName = "entry_" + categoryName;
    entryAmount = document.getElementById(categoryName).value;
    if (isNaN(entryAmount)) {
      alert("\"" + entryAmount + "\" is not a valid number entry!");
      document.getElementById(categoryName).value = "";
      break;
    } else if (entryAmount.indexOf(".") != -1 && (entryAmount.length - entryAmount.indexOf(".") > 3 )) {
      alert("Entry cannot be more than two decimal places!");
      document.getElementById(categoryName).value = "";
      break;
    } else {
      entryAmount = new Number(entryAmount);
      total += entryAmount;
    }
  }
    
  total = total.toFixed(2); 
  document.getElementById("entry_total").innerHTML = total;
}