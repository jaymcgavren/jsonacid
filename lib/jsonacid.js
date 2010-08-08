//Copyright (c) 2010 Jay McGavren.
//
//Permission is hereby granted, free of charge, to any person obtaining
//a copy of this software and associated documentation files (the
//"Software"), to deal in the Software without restriction, including
//without limitation the rights to use, copy, modify, merge, publish,
//distribute, sublicense, and/or sell copies of the Software, and to
//permit persons to whom the Software is furnished to do so, subject to
//the following conditions:
//
//The above copyright notice and this permission notice shall be
//included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


//The parent class for all other Factories.
//Should not normally be instantiated directly.
//Takes a hash with these keys and defaults:
//  source_factories : []
function Factory() {

  var options = arguments[0] == null ? {} : arguments[0];
  
  //An array of factories to be queried by get_unit and have their return values averaged.
  this.sourceFactories = options['source_factories'] || [];
  
  //Calls getUnit(key) on each source factory and averages results.
  this.getUnit = function (key) {
    if (this.sourceFactories.length == 0) return 0.0;
    var sum = 0.0;
    for (var i = 0; i < this.sourceFactories.length; i++) {
      sum += this.sourceFactories[i].getUnit(key);
    }
    return sum / this.sourceFactories.length;
  }

  //Calls getUnit() with key to get value between 0.0 and 1.0, then converts that value to be between given minimum and maximum.
  //The following argument combinations are acceptable:
  //get(key): Uses maximum of 1.0, minimum of 0.0
  //get(key, max): Uses specified maximum, minimum of 0.0 (or maximum - 1.0 if maximum is <= 0.0)
  //get(key, min, max): Uses specified minimum and maximum.
  this.get = function (key) {
    if (arguments.length == 3) {min = arguments[1]; max = arguments[2];}
    else if (arguments.length == 2) {max = arguments[1]; min = max > 0.0 ? 0.0 : max - 1.0;}
    else if (arguments.length == 1) {min = 0.0; max = 1.0;}
    return (this.getUnit(key) * (max - min)) + min;
  }
  
  //Returns true if this.getUnit(key) returns greater than 0.5.
  this.boolean = function (key) {
    return this.getUnit(key) >= 0.5;
  }
  
  //Calls this.getUnit with key to get value between 0.0 and 1.0, then converts that value to an index within the given list of choices.
  //Choices can be an array or an argument list of arbitrary size.
  this.choose = function (key) {
    if (arguments[1] instanceof Array) {choices = arguments[1];}
    else {
      choices = [];
      for (var i = 1; i <= arguments.length - 1; i++) {choices.push(arguments[i]);}
    }
    var index = Math.floor(this.getUnit(key) * choices.length);
    if (index > choices.length - 1) {index = choices.length - 1;}
    return choices[index];
  }
  
}


function FlashFactory() {
  
  var options = arguments[0] || {};
  
  //The number of times to return a value before switching.
  this.interval = options['interval'] || 3;
  this.counters = {};
  this.values = {};
  
  // def initialize(options = {})
    // super  //TODO
  
  //If key is over threshold, flip to other value and reset counter.
  this.getUnit = function (key) {
    if (this.counters[key] == null) this.counters[key] = 0;
    if (this.values[key] == null) this.values[key] = 1.0;
    if (this.counters[key] >= this.interval) {
      this.values[key] = (this.values[key] == 1.0 ? 0.0 : 1.0);
      this.counters[key] = 0;
    }
    this.counters[key] += 1;
    return this.values[key];
  }

}
FlashFactory.prototype = new Factory();
